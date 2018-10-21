Return-Path: <SRS0=nfm4=NB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51193 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbeJVB3l (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2018 21:29:41 -0400
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
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
        Will Deacon <will.deacon@arm.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Paul Burton <paul.burton@mips.com>,
        David Rientjes <rientjes@google.com>, Willy Tarreau <w@1wt.eu>,
        Martin Sebor <msebor@gmail.com>,
        Christopher Li <sparse@chrisli.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Theodore Ts'o <tytso@mit.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH 2/2] Compiler Attributes: auxdisplay: panel: use __fallthrough
Date: Sun, 21 Oct 2018 19:14:14 +0200
Message-Id: <20181021171414.22674-3-miguel.ojeda.sandonis@gmail.com>
In-Reply-To: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Let gcc know these cases are meant to fall through to the next label
by annotating them with the new __fallthrough statement attribute;
and remove the comment since it conveys the same information
(which was also parsed by gcc to suppress the warning).

Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 drivers/auxdisplay/panel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/auxdisplay/panel.c b/drivers/auxdisplay/panel.c
index 21b9b2f2470a..0755034e49ba 100644
--- a/drivers/auxdisplay/panel.c
+++ b/drivers/auxdisplay/panel.c
@@ -1367,7 +1367,7 @@ static void panel_process_inputs(void)
 				break;
 			input->rise_timer = 0;
 			input->state = INPUT_ST_RISING;
-			/* fall through */
+			__fallthrough;
 		case INPUT_ST_RISING:
 			if ((phys_curr & input->mask) != input->value) {
 				input->state = INPUT_ST_LOW;
@@ -1380,11 +1380,11 @@ static void panel_process_inputs(void)
 			}
 			input->high_timer = 0;
 			input->state = INPUT_ST_HIGH;
-			/* fall through */
+			__fallthrough;
 		case INPUT_ST_HIGH:
 			if (input_state_high(input))
 				break;
-			/* fall through */
+			__fallthrough;
 		case INPUT_ST_FALLING:
 			input_state_falling(input);
 		}
-- 
2.17.1
