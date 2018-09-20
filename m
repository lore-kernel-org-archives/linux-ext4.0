From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: [PATCH v5 12/15] Compiler Attributes: add support for __nonstring (gcc >= 8)
Date: Thu, 20 Sep 2018 19:22:58 +0200
Message-ID: <20180920172301.21868-13-miguel.ojeda.sandonis@gmail.com>
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

>From the GCC manual:

  nonstring

    The nonstring variable attribute specifies that an object or member
    declaration with type array of char, signed char, or unsigned char,
    or pointer to such a type is intended to store character arrays that
    do not necessarily contain a terminating NUL. This is useful in detecting
    uses of such arrays or pointers with functions that expect NUL-terminated
    strings, and to avoid warnings when such an array or pointer is used as
    an argument to a bounded string manipulation function such as strncpy.

  https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html

This attribute can be used for documentation purposes (i.e. replacing
comments), but it is most helpful when the following warnings are enabled:

  -Wstringop-overflow

    Warn for calls to string manipulation functions such as memcpy and
    strcpy that are determined to overflow the destination buffer.

    [...]

  -Wstringop-truncation

    Warn for calls to bounded string manipulation functions such as
    strncat, strncpy, and stpncpy that may either truncate the copied
    string or leave the destination unchanged.

    [...]

    In situations where a character array is intended to store a sequence
    of bytes with no terminating NUL such an array may be annotated with
    attribute nonstring to avoid this warning. Such arrays, however,
    are not suitable arguments to functions that expect NUL-terminated
    strings. To help detect accidental misuses of such arrays GCC issues
    warnings unless it can prove that the use is safe.

  https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 include/linux/compiler_attributes.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index f0f9fc398440..6b28c1b7310c 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -34,6 +34,7 @@
 # define __GCC4_has_attribute___externally_visible__  1
 # define __GCC4_has_attribute___noclone__             1
 # define __GCC4_has_attribute___optimize__            1
+# define __GCC4_has_attribute___nonstring__           0
 # define __GCC4_has_attribute___no_sanitize_address__ (__GNUC_MINOR__ >= 8)
 #endif
 
@@ -181,6 +182,19 @@
  */
 #define   noinline                      __attribute__((__noinline__))
 
+/*
+ * Optional: only supported since gcc >= 8
+ * Optional: not supported by clang
+ * Optional: not supported by icc
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-nonstring-variable-attribute
+ */
+#if __has_attribute(__nonstring__)
+# define __nonstring                    __attribute__((__nonstring__))
+#else
+# define __nonstring
+#endif
+
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-noreturn-function-attribute
  * clang: https://clang.llvm.org/docs/AttributeReference.html#noreturn
-- 
2.17.1
