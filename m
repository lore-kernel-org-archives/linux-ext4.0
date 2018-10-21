Return-Path: <SRS0=nfm4=NB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from smtprelay0037.hostedemail.com ([216.40.44.37]:56813 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727446AbeJVDHq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 21 Oct 2018 23:07:46 -0400
Message-ID: <d56762f8856201f520a3ee5553276621237e8e27.camel@perches.com>
Subject: Re: [PATCH 0/2] Compiler Attributes: __fallthrough
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: linux-kernel@vger.kernel.org,
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
        Arnd Bergmann <arnd@arndb.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Sun, 21 Oct 2018 11:52:21 -0700
In-Reply-To: <20181021182926.GB6683@kroah.com>
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
         <20181021182926.GB6683@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2018-10-21 at 19:29 +0100, Greg Kroah-Hartman wrote:i
> On Sun, Oct 21, 2018 at 07:14:12PM +0200, Miguel Ojeda wrote:
> > These are two patches are meant to go on top of the rest of the compiler
> > attributes series on:
> > 
> >   https://github.com/ojeda/linux/tree/compiler-attributes
> > 
> > which will be sent to Greg for the next merge window.
> > 
> > Please review them and let me know! (specially if someone is against
> > __fallthrough for some reason :-).
> 
> Will this work with all of the static tools that are currently looking
> for the comment instead?

Does anyone have a list of the static tools that
use comment style fallthrough notations?

> I know coverity handles that, what about others?

No doubt tool updates would be useful.
