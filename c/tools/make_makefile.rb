#!/usr/bin/env ruby

require 'set'

$dep_tree = {}
$files = Dir["src/*.c"] + Dir["include/*.h"] + Dir["test/*.[ch]"]
$files.each do |file_name|
  File.open(file_name) do |file|
    file.each do |line|
      if line =~ /#include "(.*)"/
        ($dep_tree[File.basename(file_name)] ||= Set.new) << $1
      end
    end
  end
end

objs = Dir["src/*.c"].map {|full_path| File.basename(full_path).gsub(/c$/, "o")}
objs << "q_parser.o" unless objs.index("q_parser.o")
test_objs = Dir["test/*.c"].map {|full_path| File.basename(full_path).gsub(/c$/, "o")}

print """
CFLAGS = -std=c99 -pedantic -fno-stack-protector -Wall -Wextra -Iinclude -Ilib/libstemmer_c/include -fno-common -g -DDEBUG -D_FILE_OFFSET_BITS=64

LFLAGS = -lm -lpthread

include lib/libstemmer_c/mkinc.mak

STEMMER_OBJS = $(patsubst %.c,src/libstemmer_c/%.o, $(snowball_sources))

TEST_OBJS = #{test_objs.join(" ")}

OBJS = #{objs.join(" ")} libstemmer.o

vpath %.c test src

vpath %.h test include lib/libstemmer_c/include

runtests: testall
	./testall -v -f -q

testall: $(OBJS) $(TEST_OBJS)
	$(CC) $(CFLAGS) $(LFLAGS) $(OBJS) $(TEST_OBJS) -o testall

valgrind: testall
	valgrind --leak-check=yes --show-reachable=yes --workaround-gcc296-bugs=yes -v ./testall -q

bench: bench.c $(OBJS)
	$(CC) $(CFLAGS) -lpthread bench.c $(OBJS) $(LFLAGS) -o bench

search_bench: search_bench.c $(OBJS)
	$(CC) $(CFLAGS) search_bench.c $(OBJS) $(LFLAGS) -o search_bench

sort_bench: sort_bench.c $(OBJS)
	$(CC) $(CFLAGS) sort_bench.c $(OBJS) $(LFLAGS) -o sort_bench

libstemmer.o: $(snowball_sources:%.c=lib/libstemmer_c/%.o)
	$(AR) -cru $@ $^

q_parser.o: src/q_parser.c
	$(CC) $(CFLAGS) src/q_parser.c -c

src/q_parser.c: src/q_parser.y

.PHONY: clean
clean:
	rm -f *.o testall gmon.out bench search_bench
"""

def get_deps(src)
  deps = Set.new
  direct_deps = $dep_tree[src]
  return deps unless direct_deps
  deps.merge(direct_deps)
  direct_deps.each {|dep| deps.merge(get_deps(dep))}
  deps
end

$dep_tree.each_key do |src|
  next unless src =~ /\.c$/
  puts src.gsub(/c$/, "o") + ": " + get_deps(src).to_a.join(" ") + "\n\n"
end