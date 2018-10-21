Return-Path: <SRS0=nfm4=NB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36852 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbeJVB3e (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2018 21:29:34 -0400
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
Subject: [PATCH 0/2] Compiler Attributes: __fallthrough
Date: Sun, 21 Oct 2018 19:14:12 +0200
Message-Id: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These are two patches are meant to go on top of the rest of the compiler
attributes series on:

  https://github.com/ojeda/linux/tree/compiler-attributes

which will be sent to Greg for the next merge window.

Please review them and let me know! (specially if someone is against
__fallthrough for some reason :-).

The first patch introduces the attribute and gives the rationale.
The second patch is an example of usage.

This was started in the following thread:

  https://lore.kernel.org/lkml/20181017062255.oiu44y4zuuwilan3@mwanda/

Cheers,
Miguel

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Olof Johansson <olof@lxom.net>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Lawrence <paullawrence@google.com>
Cc: Sandipan Das <sandipan@linux.vnet.ibm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Paul Burton <paul.burton@mips.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Martin Sebor <msebor@gmail.com>
Cc: Christopher Li <sparse@chrisli.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joe Perches <joe@perches.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Stefan Agner <stefan@agner.ch>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-doc@vger.kernel.org
Cc: linux-ext4@vger.kernel.org
Cc: linux-sparse@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org

Miguel Ojeda (2):
  Compiler Attributes: add support for __fallthrough (gcc >= 7.1)
  Compiler Attributes: auxdisplay: panel: use __fallthrough

 drivers/auxdisplay/panel.c          |  6 +++---
 include/linux/compiler_attributes.h | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 3 deletions(-)

-- 
2.17.1
