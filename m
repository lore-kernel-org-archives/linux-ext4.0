From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: [PATCH v5 13/15] Compiler Attributes: enable -Wstringop-truncation on W=1 (gcc >= 8)
Date: Thu, 20 Sep 2018 19:22:59 +0200
Message-ID: <20180920172301.21868-14-miguel.ojeda.sandonis@gmail.com>
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

Commit 217c3e019675 ("disable stringop truncation warnings for now")
disabled -Wstringop-truncation since it was too noisy.

Having __nonstring available allows us to let GCC know that a string
is not meant to be NUL-terminated, which helps suppressing some
-Wstringop-truncation warnings.

Note that using __nonstring actually triggers other warnings
(-Wstringop-overflow, which is on by default) which may be real
problems. Therefore, cleaning up -Wstringop-truncation warnings
also buys us the ability to uncover further potential problems.

To encourage the use of __nonstring, we put the warning back at W=1.
In the future, if we end up with a fairly warning-free tree,
we might want to enable it by default.

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 scripts/Makefile.extrawarn | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 8d5357053f86..b8f36f5f43f2 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -29,6 +29,7 @@ warning-1 += $(call cc-option, -Wmissing-include-dirs)
 warning-1 += $(call cc-option, -Wunused-but-set-variable)
 warning-1 += $(call cc-option, -Wunused-const-variable)
 warning-1 += $(call cc-option, -Wpacked-not-aligned)
+warning-1 += $(call cc-option, -Wstringop-truncation)
 warning-1 += $(call cc-disable-warning, missing-field-initializers)
 warning-1 += $(call cc-disable-warning, sign-compare)
 
-- 
2.17.1
