Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:46205 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727590AbeJWAHZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 22 Oct 2018 20:07:25 -0400
Message-ID: <93bda268c5f55571b47c7f283c027454bbcb8469.camel@perches.com>
Subject: Re: [PATCH 2/2] Compiler Attributes: auxdisplay: panel: use
 __fallthrough
From: Joe Perches <joe@perches.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan <dan.carpenter@oracle.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Olof Johansson <olof@lxom.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
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
        Jonathan Corbet <corbet@lwn.net>, Ted Ts'o <tytso@mit.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Arnd Bergmann <arnd@arndb.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Mon, 22 Oct 2018 08:48:11 -0700
In-Reply-To: <CANiq72=Eo-c7M1g1gmE0kXNpxe4vkOBT54n9gMB9UBSEfzTMAw@mail.gmail.com>
References: <20181021171414.22674-1-miguel.ojeda.sandonis@gmail.com>
         <20181021171414.22674-3-miguel.ojeda.sandonis@gmail.com>
         <f46baa5bb0e3373c89d09b6e0d15170902e5f55c.camel@perches.com>
         <CANiq72=Eo-c7M1g1gmE0kXNpxe4vkOBT54n9gMB9UBSEfzTMAw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2018-10-22 at 11:51 +0200, Miguel Ojeda wrote:
> On Sun, Oct 21, 2018 at 8:11 PM Joe Perches <joe@perches.com> wrote:
> > On Sun, 2018-10-21 at 19:14 +0200, Miguel Ojeda wrote:
> > > Let gcc know these cases are meant to fall through to the next label
> > > by annotating them with the new __fallthrough statement attribute;
> > > and remove the comment since it conveys the same information
> > > (which was also parsed by gcc to suppress the warning).
> > 
> > Instead of many individual conversion patches,
> > perhaps a script to do all the conversions at once.
> 
> Note that this was only an example of the attribute (some people asked
> for an example when introducing another one, so I preemptively did it
> for this one).
> 
> Doing the conversion (and how :-) I left it for afterwards, if people
> agree with the attribute.
> 
> > Maybe:
> > 
> > pattern='(?:\/\*\s*fall(?:\s*|\s*\-\s*)thr(?:u|ough)\s*\*\/|\/\/\s*fall\s*thr(?:u|ough)\s*$)'
> > git grep -P -i --name-only "$pattern" -- '*.[ch]' |
> >     xargs perl -p -i -e "s/$pattern/__fallthrough;/gi"
> 
> By the way, I checked first if coccinelle could match input comments,
> but it doesn't, according to Julia. I am also thinking whether a
> compiler plugin could easily do this, but I don't have my hopes high
> given these are comments...
> 
> Also, regardless of how it is done, the patches need to be sent
> individually to maintainers, no?

Not really no.  For instance the spdx license treewide change.
commit b24413180f5600bcb3bb70fbed5cf186b60864bd

> I have a vague memory that big &
> automated conversions were a bit frozen upon in the kernel. Greg...?

There really needs to be some method to do treewide
conversions without involving multiple maintainers.

It'd be a good topic for a maintainer summit one day.
