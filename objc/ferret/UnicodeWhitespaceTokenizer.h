//
//  UnicodeWhitespaceTokenizer.h
//  ferret
//
//  Created by Sergey Martynov on 24.08.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <unicode/utext.h>
#import <unicode/ustring.h>
#import "FerretInternals.h"

typedef struct UnicodeWhitespaceTokenizer
{
    FrtCachedTokenStream super;
    UText *u_text;
} UnicodeWhitespaceTokenizer;


static FrtTokenStream *unicode_ws_clone_i(FrtTokenStream *orig_ts)
{
    UnicodeWhitespaceTokenizer *orig_utk = (UnicodeWhitespaceTokenizer*)orig_ts;
    UText *utext = NULL;
    if (orig_utk->u_text) {
        UErrorCode status = U_ZERO_ERROR;
        utext = utext_clone(NULL, orig_utk->u_text, false, true, &status);
        if (U_ZERO_ERROR != status)
            return NULL;
        utext_setNativeIndex(utext, utext_getNativeIndex(orig_utk->u_text));
    }
    FrtTokenStream *ts = frt_ts_clone_size(orig_ts, sizeof(UnicodeWhitespaceTokenizer));
    ((UnicodeWhitespaceTokenizer*)ts)->u_text = utext;
    return ts;
}

static void unicode_ws_destroy_i(FrtTokenStream *ts)
{
    UnicodeWhitespaceTokenizer *utk = (UnicodeWhitespaceTokenizer*)ts;
    if (utk->u_text)
        utk->u_text = utext_close(utk->u_text);
    free(ts);
}

static FrtTokenStream *unicode_ws_reset(FrtTokenStream *ts, char *text)
{
    UnicodeWhitespaceTokenizer *utk = (UnicodeWhitespaceTokenizer*)ts;
    if (text != ts->text) {
        UErrorCode status = U_ZERO_ERROR;
        if (utk->u_text) utk->u_text = utext_close(utk->u_text);
        utk->u_text = utext_openUTF8(utk->u_text, text, -1, &status);
        if (U_ZERO_ERROR != status)
            return NULL;
        utext_nativeLength(utk->u_text); // TODO: research why unicode_ws_next will not work without this one
        ts->text = text;
    } else {
        if (utk->u_text)
            utext_setNativeIndex(utk->u_text, 0);
    }
    ts->t = ts->text;
    return ts;
}

static FrtToken *unicode_ws_next(FrtTokenStream *ts)
{
    UnicodeWhitespaceTokenizer *unicode_tk = (UnicodeWhitespaceTokenizer*)ts;
    UText *text = unicode_tk->u_text;
    FrtToken *tok = &unicode_tk->super.token;

    off_t start = -1;
    off_t end = -1;

    UChar32 c = U_SENTINEL;
    BOOL word = false;
    BOOL digit = false;

    while ((end - start < FRT_MAX_WORD_SIZE-1) && (c = utext_next32(text)) != U_SENTINEL) {
        if (word) {
            if (!u_isalnum(c) && !(digit && c == '.')) {
                end = utext_getPreviousNativeIndex(text);
                break;
            }
        } else {
            if (u_isprint(c) && !u_isblank(c) && !u_ispunct(c)) {
                start = end = utext_getPreviousNativeIndex(text);
                digit = u_isdigit(c);
                word = true;
            }
        }
    }
    
    if (word && c == U_SENTINEL) {
        end = utext_getPreviousNativeIndex(text) + 1;
    }

    if (start == end) return NULL;

    tok->start = start;
    tok->end = end;
//    tok->len = end - start;
//    tok->text[tok->len] = 0;
    tok->pos_inc = 1;

    UErrorCode err = U_ZERO_ERROR;
    UChar ucharSrc[FRT_MAX_WORD_SIZE];
    UChar ucharDst[FRT_MAX_WORD_SIZE];
    int32_t ucharCount = utext_extract(text, start, end, ucharSrc, FRT_MAX_WORD_SIZE, &err);
    assert(err == U_ZERO_ERROR);

    ucharCount = u_strToLower(ucharDst, FRT_MAX_WORD_SIZE, ucharSrc, ucharCount, NULL, &err);

    char *retPtr = u_strToUTF8(tok->text, FRT_MAX_WORD_SIZE, NULL, ucharDst, ucharCount, &err);
//    NSLog(@"tok: (%lld, %lld) %d - '%s'\n", start, end, ucharCount, tok->text);
    tok->len = strlen(tok->text);
    assert(tok->text == retPtr);
    assert(err == U_ZERO_ERROR);

    ts->t = ts->text + tok->end;

    return tok;
}

static FrtTokenStream *unicode_ws_tokenizer_new()
{
    FrtTokenStream *ts = frt_ts_new(UnicodeWhitespaceTokenizer);
    ts->clone_i     = &unicode_ws_clone_i;
    ts->destroy_i   = &unicode_ws_destroy_i;
    ts->reset       = &unicode_ws_reset;
    ts->next        = &unicode_ws_next;
    return ts;
}
