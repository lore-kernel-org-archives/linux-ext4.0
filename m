From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: [PATCH v5 04/15] Compiler Attributes: homogenize __must_be_array
Date: Thu, 20 Sep 2018 19:22:50 +0200
Message-ID: <20180920172301.21868-5-miguel.ojeda.sandonis@gmail.com>
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

Different definitions of __must_be_array:

  * gcc: disabled for __CHECKER__

  * clang: same definition as gcc's, but without __CHECKER__

  * intel: the comment claims __builtin_types_compatible_p()
    is unsupported; but icc seems to support it since 13.0.1
    (released in 2012). See https://godbolt.org/z/S0l6QQ

Therefore, we can remove all of them and have a single definition
in compiler.h

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 include/linux/compiler-clang.h | 1 -
 include/linux/compiler-gcc.h   | 7 -------
 include/linux/compiler-intel.h | 3 ---
 include/linux/compiler.h       | 7 +++++++
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
index d11cad61ba5c..fa9532f8d885 100644
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -41,6 +41,5 @@
  * compilers, like ICC.
  */
 #define barrier() __asm__ __volatile__("" : : : "memory")
-#define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
 #define __assume_aligned(a, ...)	\
 	__attribute__((__assume_aligned__(a, ## __VA_ARGS__)))
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 7a1de7683df5..3b32bbfa5a49 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -68,13 +68,6 @@
  */
 #define uninitialized_var(x) x = x
 
-#ifdef __CHECKER__
-#define __must_be_array(a)	0
-#else
-/* &a[0] degrades to a pointer: a different type from an array */
-#define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
-#endif
-
 #ifdef RETPOLINE
 #define __noretpoline __attribute__((__indirect_branch__("keep")))
 #endif
diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index fef8bb3e53ef..6004b4588bd4 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -29,9 +29,6 @@
  */
 #define OPTIMIZER_HIDE_VAR(var) barrier()
 
-/* Intel ECC compiler doesn't support __builtin_types_compatible_p() */
-#define __must_be_array(a) 0
-
 #endif
 
 /* icc has this, but it's called _bswap16 */
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index ec4a28bad2c6..165b1d5683ed 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -357,4 +357,11 @@ static inline void *offset_to_ptr(const int *off)
 	compiletime_assert(__native_word(t),				\
 		"Need native word sized stores/loads for atomicity.")
 
+#ifdef __CHECKER__
+#define __must_be_array(a)	0
+#else
+/* &a[0] degrades to a pointer: a different type from an array */
+#define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
+#endif
+
 #endif /* __LINUX_COMPILER_H */
-- 
2.17.1
