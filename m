From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: [PATCH v5 15/15] Compiler Attributes: ext4: remove local __nonstring definition
Date: Thu, 20 Sep 2018 19:23:01 +0200
Message-ID: <20180920172301.21868-16-miguel.ojeda.sandonis@gmail.com>
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

Commit 072ebb3bffe6 ("ext4: add nonstring annotations to ext4.h")
introduced a local definition of __nonstring to suppress some false
positives in gcc 8's -Wstringop-truncation.

Since now we support __nonstring for everyone, remove it.

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 fs/ext4/ext4.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index caff935fbeb8..2acdfdad3d3f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -45,15 +45,6 @@
 
 #include <linux/compiler.h>
 
-/* Until this gets included into linux/compiler-gcc.h */
-#ifndef __nonstring
-#if defined(GCC_VERSION) && (GCC_VERSION >= 80000)
-#define __nonstring __attribute__((nonstring))
-#else
-#define __nonstring
-#endif
-#endif
-
 /*
  * The fourth extended filesystem constants/structures
  */
-- 
2.17.1
