From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: [PATCH v5 03/15] Compiler Attributes: remove unneeded tests
Date: Thu, 20 Sep 2018 19:22:49 +0200
Message-ID: <20180920172301.21868-4-miguel.ojeda.sandonis@gmail.com>
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

Attributes const and always_inline have tests around them
which are unneeded, since they are supported by gcc >= 4.6,
clang >= 3 and icc >= 13. https://godbolt.org/z/DFPq37

In the case of gnu_inline, we do not need to test for
__GNUC_STDC_INLINE__ because, regardless of the current
inlining behavior, we can simply always force the old
GCC inlining behavior by using the attribute in all cases.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 include/linux/compiler_types.h | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 8fbdd47dd3d0..5ff9cda893f4 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -158,10 +158,6 @@ struct ftrace_likely_data {
 	(sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
 	 sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
 
-#ifndef __attribute_const__
-#define __attribute_const__	__attribute__((__const__))
-#endif
-
 #ifndef __noclone
 #define __noclone
 #endif
@@ -196,6 +192,7 @@ struct ftrace_likely_data {
  * [...]
  */
 #define __pure			__attribute__((__pure__))
+#define __attribute_const__	__attribute__((__const__))
 #define __aligned(x)		__attribute__((__aligned__(x)))
 #define __aligned_largest	__attribute__((__aligned__))
 #define __printf(a, b)		__attribute__((__format__(printf, a, b)))
@@ -211,6 +208,8 @@ struct ftrace_likely_data {
 #define __alias(symbol)		__attribute__((__alias__(#symbol)))
 #define __cold			__attribute__((__cold__))
 #define __section(S)		__attribute__((__section__(#S)))
+#define __always_inline		inline __attribute__((__always_inline__))
+#define __gnu_inline		__attribute__((__gnu_inline__))
 
 
 #ifdef CONFIG_ENABLE_MUST_CHECK
@@ -235,18 +234,6 @@ struct ftrace_likely_data {
 
 #define __compiler_offsetof(a, b)	__builtin_offsetof(a, b)
 
-/*
- * Feature detection for gnu_inline (gnu89 extern inline semantics). Either
- * __GNUC_STDC_INLINE__ is defined (not using gnu89 extern inline semantics,
- * and we opt in to the gnu89 semantics), or __GNUC_STDC_INLINE__ is not
- * defined so the gnu89 semantics are the default.
- */
-#ifdef __GNUC_STDC_INLINE__
-# define __gnu_inline	__attribute__((__gnu_inline__))
-#else
-# define __gnu_inline
-#endif
-
 /*
  * Force always-inline if the user requests it so via the .config.
  * GCC does not warn about unused static inline functions for
@@ -271,10 +258,6 @@ struct ftrace_likely_data {
 #define __inline inline
 #define noinline	__attribute__((__noinline__))
 
-#ifndef __always_inline
-#define __always_inline inline __attribute__((__always_inline__))
-#endif
-
 /*
  * Rather then using noinline to prevent stack consumption, use
  * noinline_for_stack instead.  For documentation reasons.
-- 
2.17.1
