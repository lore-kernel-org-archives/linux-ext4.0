From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: [PATCH v5 10/15] Compiler Attributes: add Doc/process/programming-language.rst
Date: Thu, 20 Sep 2018 19:22:56 +0200
Message-ID: <20180920172301.21868-11-miguel.ojeda.sandonis@gmail.com>
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

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 Documentation/process/index.rst               |  1 +
 .../process/programming-language.rst          | 45 +++++++++++++++++++
 2 files changed, 46 insertions(+)
 create mode 100644 Documentation/process/programming-language.rst

diff --git a/Documentation/process/index.rst b/Documentation/process/index.rst
index 9ae3e317bddf..00558b6d2649 100644
--- a/Documentation/process/index.rst
+++ b/Documentation/process/index.rst
@@ -23,6 +23,7 @@ Below are the essential guides that every developer should read.
    code-of-conduct
    development-process
    submitting-patches
+   programming-language
    coding-style
    maintainer-pgp-guide
    email-clients
diff --git a/Documentation/process/programming-language.rst b/Documentation/process/programming-language.rst
new file mode 100644
index 000000000000..e5f5f065dc24
--- /dev/null
+++ b/Documentation/process/programming-language.rst
@@ -0,0 +1,45 @@
+.. _programming_language:
+
+Programming Language
+====================
+
+The kernel is written in the C programming language [c-language]_.
+More precisely, the kernel is typically compiled with ``gcc`` [gcc]_
+under ``-std=gnu89`` [gcc-c-dialect-options]_: the GNU dialect of ISO C90
+(including some C99 features).
+
+This dialect contains many extensions to the language [gnu-extensions]_,
+and many of them are used within the kernel as a matter of course.
+
+There is some support for compiling the kernel with ``clang`` [clang]_
+and ``icc`` [icc]_ for several of the architectures, although at the time
+of writing it is not completed, requiring third-party patches.
+
+Attributes
+----------
+
+One of the common extensions used throughout the kernel are attributes
+[gcc-attribute-syntax]_. Attributes allow to introduce
+implementation-defined semantics to language entities (like variables,
+functions or types) without having to make significant syntactic changes
+to the language (e.g. adding a new keyword) [n2049]_.
+
+In some cases, attributes are optional (i.e. a compiler not supporting them
+should still produce proper code, even if it is slower or does not perform
+as many compile-time checks/diagnostics).
+
+The kernel defines pseudo-keywords (e.g. ``__pure``) instead of using
+directly the GNU attribute syntax (e.g. ``__attribute__((__pure__))``)
+in order to feature detect which ones can be used and/or to shorten the code.
+
+Please refer to ``include/linux/compiler_attributes.h`` for more information.
+
+.. [c-language] http://www.open-std.org/jtc1/sc22/wg14/www/standards
+.. [gcc] https://gcc.gnu.org
+.. [clang] https://clang.llvm.org
+.. [icc] https://software.intel.com/en-us/c-compilers
+.. [gcc-c-dialect-options] https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html
+.. [gnu-extensions] https://gcc.gnu.org/onlinedocs/gcc/C-Extensions.html
+.. [gcc-attribute-syntax] https://gcc.gnu.org/onlinedocs/gcc/Attribute-Syntax.html
+.. [n2049] http://www.open-std.org/jtc1/sc22/wg14/www/docs/n2049.pdf
+
-- 
2.17.1
