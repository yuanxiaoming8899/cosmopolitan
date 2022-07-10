#-*-mode:makefile-gmake;indent-tabs-mode:t;tab-width:8;coding:utf-8-*-┐
#───vi: set et ft=make ts=8 tw=8 fenc=utf-8 :vi───────────────────────┘

PKGS += TEST_TOOL_NET

TEST_TOOL_NET = $(TOOL_NET_A_DEPS) $(TOOL_NET_A)
TEST_TOOL_NET_A = o/$(MODE)/test/tool/net/net.a
TEST_TOOL_NET_FILES := $(wildcard test/tool/net/*)
TEST_TOOL_NET_JSONORG := $(wildcard test/tool/net/samples/*)

TEST_TOOL_NET_JSONORG_STRICT = \
		test/tool/net/samples/fail10.lua	\
		test/tool/net/samples/fail19.lua	\
		test/tool/net/samples/fail20.lua	\
		test/tool/net/samples/fail21.lua	\
		test/tool/net/samples/fail25.lua	\
		test/tool/net/samples/fail26.lua	\
		test/tool/net/samples/fail27.lua	\
		test/tool/net/samples/fail28.lua	\
		test/tool/net/samples/fail4.lua	\
		test/tool/net/samples/fail5.lua	\
		test/tool/net/samples/fail6.lua	\
		test/tool/net/samples/fail7.lua	\
		test/tool/net/samples/fail8.lua	\
		test/tool/net/samples/fail9.lua

TEST_TOOL_NET_JSONORG_LUA = $(filter-out $(TEST_TOOL_NET_JSONORG_STRICT),$(filter %.lua,$(TEST_TOOL_NET_JSONORG)))
TEST_TOOL_NET_SRCS = $(filter %.c,$(TEST_TOOL_NET_FILES))
TEST_TOOL_NET_SRCS_TEST = $(filter %_test.c,$(TEST_TOOL_NET_SRCS))
TEST_TOOL_NET_LUAS_TEST = \
	$(filter %_test.lua,$(TEST_TOOL_NET_FILES)) \
	$(TEST_TOOL_NET_JSONORG_LUA)
TEST_TOOL_NET_HDRS = $(filter %.h,$(TEST_TOOL_NET_FILES))
TEST_TOOL_NET_COMS = $(TEST_TOOL_NET_SRCS:%.c=o/$(MODE)/%.com)

TEST_TOOL_NET_OBJS =						\
	$(TEST_TOOL_NET_SRCS:%.c=o/$(MODE)/%.o)			\
	o/$(MODE)/tool/net/redbean.com.zip.o

TEST_TOOL_NET_BINS =						\
	$(TEST_TOOL_NET_COMS)					\
	$(TEST_TOOL_NET_COMS:%=%.dbg)

TEST_TOOL_NET_TESTS =						\
	$(TEST_TOOL_NET_SRCS_TEST:%.c=o/$(MODE)/%.com.ok)

TEST_TOOL_NET_CHECKS =						\
	$(TEST_TOOL_NET_HDRS:%=o/$(MODE)/%.ok)			\
	$(TEST_TOOL_NET_SRCS_TEST:%.c=o/$(MODE)/%.com.runs)	\
	$(TEST_TOOL_NET_LUAS_TEST:%.lua=o/$(MODE)/%.lua.runs)

TEST_TOOL_NET_DIRECTDEPS =					\
	LIBC_CALLS						\
	LIBC_FMT						\
	LIBC_INTRIN						\
	LIBC_LOG						\
	LIBC_MEM						\
	LIBC_NEXGEN32E						\
	LIBC_RAND						\
	LIBC_RUNTIME						\
	LIBC_SOCK						\
	LIBC_STDIO						\
	LIBC_STR						\
	LIBC_STUBS						\
	LIBC_SYSV						\
	LIBC_TESTLIB						\
	LIBC_UNICODE						\
	LIBC_X							\
	LIBC_ZIPOS						\
	THIRD_PARTY_REGEX					\
	THIRD_PARTY_MBEDTLS					\
	THIRD_PARTY_SQLITE3

TEST_TOOL_NET_DEPS :=						\
	$(call uniq,$(foreach x,$(TEST_TOOL_NET_DIRECTDEPS),$($(x))))

$(TEST_TOOL_NET_A):						\
		test/tool/net/					\
		$(TEST_TOOL_NET_A).pkg				\
		$(TEST_TOOL_NET_OBJS)

$(TEST_TOOL_NET_A).pkg:						\
		$(TEST_TOOL_NET_OBJS)				\
		$(foreach x,$(TEST_TOOL_NET_DIRECTDEPS),$($(x)_A).pkg)

o/$(MODE)/test/tool/net/%.com.dbg:				\
		$(TEST_TOOL_NET_DEPS)				\
		$(TEST_TOOL_NET_A)				\
		o/$(MODE)/test/tool/net/%.o			\
		$(TEST_TOOL_NET_A).pkg				\
		$(LIBC_TESTMAIN)				\
		$(CRT)						\
		$(APE_NO_MODIFY_SELF)
	@$(APELINK)

.PHONY: o/$(MODE)/test/tool/net
o/$(MODE)/test/tool/net:					\
		$(TEST_TOOL_NET_BINS)				\
		$(TEST_TOOL_NET_CHECKS)
