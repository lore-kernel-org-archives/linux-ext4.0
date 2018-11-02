Return-Path: <SRS0=yllL=NN=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35631 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbeKBT4X (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Nov 2018 15:56:23 -0400
MIME-Version: 1.0
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
 <20181021171414.22674-3-miguel.ojeda.sandonis@gmail.com> <CAGXu5j+3pR2mfcdbURv7MrPxUVjmjQEDRHH8BLpTNGiasJs1pg@mail.gmail.com>
 <20181023053542.lsklua2p3lnbkqir@mwanda>
In-Reply-To: <20181023053542.lsklua2p3lnbkqir@mwanda>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 2 Nov 2018 11:49:26 +0100
Message-ID: <CANiq72nrd70qTxEAfxxuNHNoi19MBo=yrJnm9_EnfrpEMQHXCg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Compiler Attributes: auxdisplay: panel: use __fallthrough
To: Dan <dan.carpenter@oracle.com>
Cc: Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Olof Johansson <olof@lxom.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
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
        Jonathan Corbet <corbet@lwn.net>, "Ted Ts'o" <tytso@mit.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dan,

On Tue, Oct 23, 2018 at 7:37 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Mon, Oct 22, 2018 at 07:10:02AM -0700, Kees Cook wrote:
> > I would prefer we continue to use the comment style until we've got
> > confirmed support for (at least) Clang, Coverity, CPPcheck, smatch,
> > and eclipse.
>
> Clang and Smatch don't support fall throught comments.  Coverity
> supports both.  CPPcheck is unknown.
>
> Eclipse doesn't support attributes.  So it's just Eclipse and maybe
> CPP check.

Thanks for checking! Let's wait then a few months and see if we can
get cppcheck/Eclipse to support it.

Cheers,
Miguel
