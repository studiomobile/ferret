//
//  FerretAnalyzer.m
//  ferret
//
//  Created by Sergey Martynov on 04.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretAnalyzer.h"
#import "FerretInternals.h"
#import <unicode/utext.h>

typedef struct UnicodeTokenizer
{
    FrtCachedTokenStream super;
    UText *u_text;
} UnicodeTokenizer;

static FrtTokenStream *unicode_ts_new();


@implementation FerretAnalyzer

@synthesize analyzer;

+ (void)initialize
{
    [FerretStore class]; // force class loading - ferret initialization
}

- (id)initWithAnalyzer:(FrtAnalyzer*)_analyzer
{
    if (!_analyzer) return nil;
    self = [super init];
    if (self) {
        analyzer = _analyzer;
    }
    return self;
}

- (void)dealloc
{
    if (analyzer) frt_a_deref(analyzer);
    analyzer = NULL;
}

+ (FerretAnalyzer*)defaultAnalyzer
{
//    FrtAnalyzer *a = frt_utf8_standard_analyzer_new(false);
//    FrtAnalyzer *a = frt_analyzer_new(frt_hyphen_filter_new(frt_utf8_standard_tokenizer_new()), NULL, NULL);
//    FrtAnalyzer *a = frt_analyzer_new(frt_stem_filter_new(unicode_ts_new(), "ru", "UTF_8"), NULL, NULL);
    FrtAnalyzer *a = frt_analyzer_new(unicode_ts_new(), NULL, NULL);
    return [[self alloc] initWithAnalyzer:a];
}

@end


static FrtTokenStream *unicode_ts_clone_i(FrtTokenStream *orig_ts)
{
    UnicodeTokenizer *orig_utk = (UnicodeTokenizer*)orig_ts;
    UText *utext = NULL;
    if (orig_utk->u_text) {
        UErrorCode status = U_ZERO_ERROR;
        utext_clone(NULL, orig_utk->u_text, false, true, &status);
        if (U_ZERO_ERROR != status)
            return NULL;
    }
    FrtTokenStream *ts = frt_ts_clone_size(orig_ts, sizeof(UnicodeTokenizer));
    ((UnicodeTokenizer*)ts)->u_text = utext;
    return ts;
}

static void unicode_ts_destroy_i(FrtTokenStream *ts)
{
    UnicodeTokenizer *utk = (UnicodeTokenizer*)ts;
    if (utk->u_text) {
        utk->u_text = utext_close(utk->u_text);
    }
    free(ts);
}

static FrtTokenStream *unicode_ts_reset(FrtTokenStream *ts, char *text)
{
    UnicodeTokenizer *utk = (UnicodeTokenizer*)ts;
    if (text != ts->text) {
        UErrorCode status = U_ZERO_ERROR;
        utk->u_text = utext_openUTF8(utk->u_text, text, -1, &status);
        if (U_ZERO_ERROR != status)
            return NULL;
        ts->text = text;
    } else {
        if (utk->u_text)
            utext_setNativeIndex(utk->u_text, 0);
    }
    ts->t = ts->text;
    return ts;
}

static BOOL scan_utf8(UText *text, FrtToken *tok);

static FrtToken *unicode_ts_next(FrtTokenStream *ts)
{
    UnicodeTokenizer *unicode_tk = (UnicodeTokenizer*)ts;
    FrtToken *tok = &unicode_tk->super.token;
    tok->pos_inc = 1;

    if (!scan_utf8(unicode_tk->u_text, tok))
        return NULL;

    assert(tok->len);

    memcpy(tok->text, ts->text + tok->start, tok->len);
    tok->text[tok->len] = 0;

    ts->t = ts->text + tok->end;

    return tok;
}

static FrtTokenStream *unicode_ts_new()
{
    FrtTokenStream *ts = frt_ts_new(UnicodeTokenizer);
    ts->clone_i     = &unicode_ts_clone_i;
    ts->destroy_i   = &unicode_ts_destroy_i;
    ts->reset       = &unicode_ts_reset;
    ts->next        = &unicode_ts_next;
    return ts;
}

typedef enum {
    ScanStateFound,
    ScanStateSpace,
    ScanStateWord,
} ScanState;

static BOOL scan_utf8(UText *text, FrtToken *tok)
{
    off_t start = -1;
    off_t end = -1;
    UChar32 c = U_SENTINEL;
    ScanState state = ScanStateSpace;
    while (state != ScanStateFound && (end - start < FRT_MAX_WORD_SIZE-1) && (c = utext_next32(text)) != U_SENTINEL) {
        switch (state) {
            case ScanStateSpace:
                if (u_isalnum(c)) {
                    start = end = utext_getPreviousNativeIndex(text);
                    state = ScanStateWord;
                }
                break;
            case ScanStateWord:
                if (!u_isalnum(c)) {
                    end = utext_getPreviousNativeIndex(text);
                    state = ScanStateFound;
                }
                break;
            default:
                break;
        }
    }
    if (state == ScanStateFound) {
        tok->start = start;
        tok->end = end;
        tok->len = end - start;
        return true;
    }
    return false;
}
