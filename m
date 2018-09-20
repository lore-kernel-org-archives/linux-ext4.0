From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: [PATCH v5 09/15] Compiler Attributes: remove uses of __attribute__ from compiler.h
Date: Thu, 20 Sep 2018 19:22:55 +0200
Message-ID: <20180920172301.21868-10-miguel.ojeda.sandonis@gmail.com>
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

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 include/linux/compiler.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 17ee9165ca51..b5fb034fa6fa 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -23,8 +23,8 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 #define __branch_check__(x, expect, is_constant) ({			\
 			long ______r;					\
 			static struct ftrace_likely_data		\
-				__attribute__((__aligned__(4)))		\
-				__attribute__((__section__("_ftrace_annotated_branch"))) \
+				__aligned(4)				\
+				__section("_ftrace_annotated_branch")	\
 				______f = {				\
 				.data.func = __func__,			\
 				.data.file = __FILE__,			\
@@ -59,8 +59,8 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 	({								\
 		int ______r;						\
 		static struct ftrace_branch_data			\
-			__attribute__((__aligned__(4)))			\
-			__attribute__((__section__("_ftrace_branch")))	\
+			__aligned(4)					\
+			__section("_ftrace_branch")			\
 			______f = {					\
 				.func = __func__,			\
 				.file = __FILE__,			\
@@ -146,7 +146,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 	extern typeof(sym) sym;					\
 	static const unsigned long __kentry_##sym		\
 	__used							\
-	__attribute__((__section__("___kentry" "+" #sym )))	\
+	__section("___kentry" "+" #sym )			\
 	= (unsigned long)&sym;
 #endif
 
@@ -287,7 +287,7 @@ unsigned long read_word_at_a_time(const void *addr)
  * visible to the compiler.
  */
 #define __ADDRESSABLE(sym) \
-	static void * __attribute__((__section__(".discard.addressable"), used)) \
+	static void * __section(".discard.addressable") __used \
 		__PASTE(__addressable_##sym, __LINE__) = (void *)&sym;
 
 /**
-- 
2.17.1
