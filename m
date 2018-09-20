From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: [PATCH v5 07/15] Compiler Attributes: use feature checks instead of version checks
Date: Thu, 20 Sep 2018 19:22:53 +0200
Message-ID: <20180920172301.21868-8-miguel.ojeda.sandonis@gmail.com>
References: <20180920172301.21868-1-miguel.ojeda.sandonis@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Olof Johansson <olof@lxom.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul Lawrence <paullawrence@google.com>,
        Sandipan Das <sandipan@linux.vnet.ibm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Will Deac
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920172301.21868-1-miguel.ojeda.sandonis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Instead of using version checks per-compiler to define (or not)
each attribute, use __has_attribute to test for them, following
the cleanup started with commit 815f0ddb346c
("include/linux/compiler*.h: make compiler-*.h mutually exclusive"),
which is supported on gcc >= 5, clang >= 2.9 and icc >= 17.
In the meantime, to support 4.6 <= gcc < 5, we implement
__has_attribute by hand.

All the attributes that can be unconditionally defined and directly
map to compiler attribute(s) (even if optional) have been moved
to a new file include/linux/compiler_attributes.h

In an effort to make the file as regular as possible, comments
stating the purpose of attributes have been removed. Instead,
links to the compiler docs have been added (i.e. to gcc and,
if available, to clang as well). In addition, they have been sorted.

Finally, if an attribute is optional (i.e. if it is guarded
by __has_attribute), the reason has been stated for future reference.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 include/linux/compiler-clang.h      |   4 -
 include/linux/compiler-gcc.h        |  51 ------
 include/linux/compiler-intel.h      |   6 -
 include/linux/compiler_attributes.h | 244 ++++++++++++++++++++++++++++
 include/linux/compiler_types.h      |  74 ++-------
 5 files changed, 254 insertions(+), 125 deletions(-)
 create mode 100644 include/linux/compiler_attributes.h

diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
index fa9532f8d885..3e7dafb3ea80 100644
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -21,8 +21,6 @@
 #define __SANITIZE_ADDRESS__
 #endif
 
-#define __no_sanitize_address __attribute__((__no_sanitize__("address")))
-
 /*
  * Not all versions of clang implement the the type-generic versions
  * of the builtin overflow checkers. Fortunately, clang implements
@@ -41,5 +39,3 @@
  * compilers, like ICC.
  */
 #define barrier() __asm__ __volatile__("" : : : "memory")
-#define __assume_aligned(a, ...)	\
-	__attribute__((__assume_aligned__(a, ## __VA_ARGS__)))
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 1ca6a51cfaa9..cfac027e1625 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -108,9 +108,6 @@
 		__builtin_unreachable();	\
 	} while (0)
 
-/* Mark a function definition as prohibited from being cloned. */
-#define __noclone	__attribute__((__noclone__, __optimize__("no-tracer")))
-
 #if defined(RANDSTRUCT_PLUGIN) && !defined(__CHECKER__)
 #define __randomize_layout __attribute__((randomize_layout))
 #define __no_randomize_layout __attribute__((no_randomize_layout))
@@ -119,32 +116,6 @@
 #define randomized_struct_fields_end	} __randomize_layout;
 #endif
 
-/*
- * When used with Link Time Optimization, gcc can optimize away C functions or
- * variables which are referenced only from assembly code.  __visible tells the
- * optimizer that something else uses this function or variable, thus preventing
- * this.
- */
-#define __visible	__attribute__((__externally_visible__))
-
-/* gcc version specific checks */
-
-#if GCC_VERSION >= 40900
-/*
- * __assume_aligned(n, k): Tell the optimizer that the returned
- * pointer can be assumed to be k modulo n. The second argument is
- * optional (default 0), so we use a variadic macro to make the
- * shorthand.
- *
- * Beware: Do not apply this to functions which may return
- * ERR_PTRs. Also, it is probably unwise to apply it to functions
- * returning extra information in the low bits (but in that case the
- * compiler should see some alignment anyway, when the return value is
- * massaged by 'flags = ptr & 3; ptr &= ~3;').
- */
-#define __assume_aligned(a, ...) __attribute__((__assume_aligned__(a, ## __VA_ARGS__)))
-#endif
-
 /*
  * GCC 'asm goto' miscompiles certain code sequences:
  *
@@ -176,32 +147,10 @@
 #define KASAN_ABI_VERSION 3
 #endif
 
-#if GCC_VERSION >= 40902
-/*
- * Tell the compiler that address safety instrumentation (KASAN)
- * should not be applied to that function.
- * Conflicts with inlining: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=67368
- */
-#define __no_sanitize_address __attribute__((__no_sanitize_address__))
-#endif
-
 #if GCC_VERSION >= 50100
-/*
- * Mark structures as requiring designated initializers.
- * https://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html
- */
-#define __designated_init __attribute__((__designated_init__))
 #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
 #endif
 
-#if !defined(__noclone)
-#define __noclone	/* not needed */
-#endif
-
-#if !defined(__no_sanitize_address)
-#define __no_sanitize_address
-#endif
-
 /*
  * Turn individual warnings and errors on and off locally, depending
  * on version.
diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index 6004b4588bd4..517bd14e1222 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -34,9 +34,3 @@
 /* icc has this, but it's called _bswap16 */
 #define __HAVE_BUILTIN_BSWAP16__
 #define __builtin_bswap16 _bswap16
-
-/* The following are for compatibility with GCC, from compiler-gcc.h,
- * and may be redefined here because they should not be shared with other
- * compilers, like clang.
- */
-#define __visible	__attribute__((__externally_visible__))
diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
new file mode 100644
index 000000000000..f0f9fc398440
--- /dev/null
+++ b/include/linux/compiler_attributes.h
@@ -0,0 +1,244 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_COMPILER_ATTRIBUTES_H
+#define __LINUX_COMPILER_ATTRIBUTES_H
+
+/*
+ * The attributes in this file are unconditionally defined and they directly
+ * map to compiler attribute(s) -- except those that are optional.
+ *
+ * Any other "attributes" (i.e. those that depend on a configuration option,
+ * on a compiler, on an architecture, on plugins, on other attributes...)
+ * should be defined elsewhere (e.g. compiler_types.h or compiler-*.h).
+ *
+ * This file is meant to be sorted (by actual attribute name,
+ * not by #define identifier). Use the __attribute__((__name__)) syntax
+ * (i.e. with underscores) to avoid future collisions with other macros.
+ * If an attribute is optional, state the reason in the comment.
+ */
+
+/*
+ * To check for optional attributes, we use __has_attribute, which is supported
+ * on gcc >= 5, clang >= 2.9 and icc >= 17. In the meantime, to support
+ * 4.6 <= gcc < 5, we implement __has_attribute by hand.
+ *
+ * sparse does not support __has_attribute (yet) and defines __GNUC_MINOR__
+ * depending on the compiler used to build it; however, these attributes have
+ * no semantic effects for sparse, so it does not matter. Also note that,
+ * in order to avoid sparse's warnings, even the unsupported ones must be
+ * defined to 0.
+ */
+#ifndef __has_attribute
+# define __has_attribute(x) __GCC4_has_attribute_##x
+# define __GCC4_has_attribute___assume_aligned__      (__GNUC_MINOR__ >= 9)
+# define __GCC4_has_attribute___designated_init__     0
+# define __GCC4_has_attribute___externally_visible__  1
+# define __GCC4_has_attribute___noclone__             1
+# define __GCC4_has_attribute___optimize__            1
+# define __GCC4_has_attribute___no_sanitize_address__ (__GNUC_MINOR__ >= 8)
+#endif
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alias-function-attribute
+ */
+#define __alias(symbol)                 __attribute__((__alias__(#symbol)))
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-aligned-function-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html#index-aligned-type-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-aligned-variable-attribute
+ */
+#define __aligned(x)                    __attribute__((__aligned__(x)))
+#define __aligned_largest               __attribute__((__aligned__))
+
+/*
+ * Note: users of __always_inline currently do not write "inline" themselves,
+ * which seems to be required by gcc to apply the attribute according
+ * to its docs (and also "warning: always_inline function might not be
+ * inlinable [-Wattributes]" is emitted).
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-always_005finline-function-attribute
+ * clang: mentioned
+ */
+#define __always_inline                 inline __attribute__((__always_inline__))
+
+/*
+ * The second argument is optional (default 0), so we use a variadic macro
+ * to make the shorthand.
+ *
+ * Beware: Do not apply this to functions which may return
+ * ERR_PTRs. Also, it is probably unwise to apply it to functions
+ * returning extra information in the low bits (but in that case the
+ * compiler should see some alignment anyway, when the return value is
+ * massaged by 'flags = ptr & 3; ptr &= ~3;').
+ *
+ * Optional: only supported since gcc >= 4.9
+ * Optional: not supported by icc
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-assume_005faligned-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#assume-aligned
+ */
+#if __has_attribute(__assume_aligned__)
+# define __assume_aligned(a, ...)       __attribute__((__assume_aligned__(a, ## __VA_ARGS__)))
+#else
+# define __assume_aligned(a, ...)
+#endif
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-cold-function-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Label-Attributes.html#index-cold-label-attribute
+ */
+#define __cold                          __attribute__((__cold__))
+
+/*
+ * Note the long name.
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-const-function-attribute
+ */
+#define __attribute_const__             __attribute__((__const__))
+
+/*
+ * Don't. Just don't. See commit 771c035372a0 ("deprecate the '__deprecated'
+ * attribute warnings entirely and for good") for more information.
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-deprecated-function-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html#index-deprecated-type-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-deprecated-variable-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Enumerator-Attributes.html#index-deprecated-enumerator-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#deprecated
+ */
+#define __deprecated
+
+/*
+ * Optional: only supported since gcc >= 5.1
+ * Optional: not supported by clang
+ * Optional: not supported by icc
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html#index-designated_005finit-type-attribute
+ */
+#if __has_attribute(__designated_init__)
+# define __designated_init              __attribute__((__designated_init__))
+#else
+# define __designated_init
+#endif
+
+/*
+ * Optional: not supported by clang
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-externally_005fvisible-function-attribute
+ */
+#if __has_attribute(__externally_visible__)
+# define __visible                      __attribute__((__externally_visible__))
+#else
+# define __visible
+#endif
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-format-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#format
+ */
+#define __printf(a, b)                  __attribute__((__format__(printf, a, b)))
+#define __scanf(a, b)                   __attribute__((__format__(scanf, a, b)))
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-gnu_005finline-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#gnu-inline
+ */
+#define __gnu_inline                    __attribute__((__gnu_inline__))
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-malloc-function-attribute
+ */
+#define __malloc                        __attribute__((__malloc__))
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html#index-mode-type-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-mode-variable-attribute
+ */
+#define __mode(x)                       __attribute__((__mode__(x)))
+
+/*
+ * Optional: not supported by clang
+ * Note: icc does not recognize gcc's no-tracer
+ *
+ *  gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-noclone-function-attribute
+ *  gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-optimize-function-attribute
+ */
+#if __has_attribute(__noclone__)
+# if __has_attribute(__optimize__)
+#  define __noclone                     __attribute__((__noclone__, __optimize__("no-tracer")))
+# else
+#  define __noclone                     __attribute__((__noclone__))
+# endif
+#else
+# define __noclone
+#endif
+
+/*
+ * Note the missing underscores.
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-noinline-function-attribute
+ * clang: mentioned
+ */
+#define   noinline                      __attribute__((__noinline__))
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-noreturn-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#noreturn
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#id1
+ */
+#define __noreturn                      __attribute__((__noreturn__))
+
+/*
+ * Optional: only supported since gcc >= 4.8
+ * Optional: not supported by icc
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fsanitize_005faddress-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#no-sanitize-address-no-address-safety-analysis
+ */
+#if __has_attribute(__no_sanitize_address__)
+# define __no_sanitize_address          __attribute__((__no_sanitize_address__))
+#else
+# define __no_sanitize_address
+#endif
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html#index-packed-type-attribute
+ * clang: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-packed-variable-attribute
+ */
+#define __packed                        __attribute__((__packed__))
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-pure-function-attribute
+ */
+#define __pure                          __attribute__((__pure__))
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-section-function-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-section-variable-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#section-declspec-allocate
+ */
+#define __section(S)                    __attribute__((__section__(#S)))
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-unused-function-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html#index-unused-type-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-unused-variable-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Label-Attributes.html#index-unused-label-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#maybe-unused-unused
+ */
+#define __always_unused                 __attribute__((__unused__))
+#define __maybe_unused                  __attribute__((__unused__))
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-used-function-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-used-variable-attribute
+ */
+#define __used                          __attribute__((__used__))
+
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-weak-function-attribute
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-weak-variable-attribute
+ */
+#define __weak                          __attribute__((__weak__))
+
+#endif /* __LINUX_COMPILER_ATTRIBUTES_H */
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index ed7c0e4a180e..3439d7d0249a 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -55,6 +55,9 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 
 #ifdef __KERNEL__
 
+/* Attributes */
+#include <linux/compiler_attributes.h>
+
 /* Compiler specific macros. */
 #ifdef __clang__
 #include <linux/compiler-clang.h>
@@ -79,12 +82,6 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 #include <asm/compiler.h>
 #endif
 
-/*
- * Generic compiler-independent macros required for kernel
- * build go below this comment. Actual compiler/compiler version
- * specific implementations come from the above header files
- */
-
 struct ftrace_branch_data {
 	const char *func;
 	const char *file;
@@ -107,9 +104,6 @@ struct ftrace_likely_data {
 	unsigned long			constant;
 };
 
-/* Don't. Just don't. */
-#define __deprecated
-
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
@@ -119,10 +113,6 @@ struct ftrace_likely_data {
  * compilers. We don't consider that to be an error, so set them to nothing.
  * For example, some of them are for compiler specific plugins.
  */
-#ifndef __designated_init
-# define __designated_init
-#endif
-
 #ifndef __latent_entropy
 # define __latent_entropy
 #endif
@@ -140,17 +130,6 @@ struct ftrace_likely_data {
 # define randomized_struct_fields_end
 #endif
 
-#ifndef __visible
-#define __visible
-#endif
-
-/*
- * Assume alignment of return value.
- */
-#ifndef __assume_aligned
-#define __assume_aligned(a, ...)
-#endif
-
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 
@@ -159,10 +138,6 @@ struct ftrace_likely_data {
 	(sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
 	 sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
 
-#ifndef __noclone
-#define __noclone
-#endif
-
 /* Helpers for emitting diagnostics in pragmas. */
 #ifndef __diag
 #define __diag(string)
@@ -182,37 +157,6 @@ struct ftrace_likely_data {
 #define __diag_error(compiler, version, option, comment) \
 	__diag_ ## compiler(version, error, option)
 
-/*
- * From the GCC manual:
- *
- * Many functions have no effects except the return value and their
- * return value depends only on the parameters and/or global
- * variables.  Such a function can be subject to common subexpression
- * elimination and loop optimization just as an arithmetic operator
- * would be.
- * [...]
- */
-#define __pure			__attribute__((__pure__))
-#define __attribute_const__	__attribute__((__const__))
-#define __aligned(x)		__attribute__((__aligned__(x)))
-#define __aligned_largest	__attribute__((__aligned__))
-#define __printf(a, b)		__attribute__((__format__(printf, a, b)))
-#define __scanf(a, b)		__attribute__((__format__(scanf, a, b)))
-#define __maybe_unused		__attribute__((__unused__))
-#define __always_unused		__attribute__((__unused__))
-#define __mode(x)		__attribute__((__mode__(x)))
-#define __malloc		__attribute__((__malloc__))
-#define __used			__attribute__((__used__))
-#define __noreturn		__attribute__((__noreturn__))
-#define __packed		__attribute__((__packed__))
-#define __weak			__attribute__((__weak__))
-#define __alias(symbol)		__attribute__((__alias__(#symbol)))
-#define __cold			__attribute__((__cold__))
-#define __section(S)		__attribute__((__section__(#S)))
-#define __always_inline		inline __attribute__((__always_inline__))
-#define __gnu_inline		__attribute__((__gnu_inline__))
-
-
 #ifdef CONFIG_ENABLE_MUST_CHECK
 #define __must_check		__attribute__((__warn_unused_result__))
 #else
@@ -246,18 +190,20 @@ struct ftrace_likely_data {
  * semantics rather than c99. This prevents multiple symbol definition errors
  * of extern inline functions at link time.
  * A lot of inline functions can cause havoc with function tracing.
+ * Do not use __always_inline here, since currently it expands to inline again
+ * (which would break users of __always_inline).
  */
 #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
 	!defined(CONFIG_OPTIMIZE_INLINING)
-#define inline \
-	inline __attribute__((__always_inline__, __unused__)) notrace __gnu_inline
+#define inline inline __attribute__((__always_inline__)) __gnu_inline \
+	__maybe_unused notrace
 #else
-#define inline inline	__attribute__((__unused__)) notrace __gnu_inline
+#define inline inline                                    __gnu_inline \
+	__maybe_unused notrace
 #endif
 
 #define __inline__ inline
-#define __inline inline
-#define noinline	__attribute__((__noinline__))
+#define __inline   inline
 
 /*
  * Rather then using noinline to prevent stack consumption, use
-- 
2.17.1
