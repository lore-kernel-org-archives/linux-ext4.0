Return-Path: <SRS0=f65u=MO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43408 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725753AbeJCE5z (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Oct 2018 00:57:55 -0400
MIME-Version: 1.0
References: <CANiq72=rgT9cPWH64Tf_8gAU09EiH5FvGqFUdOjV=spVbM5m8Q@mail.gmail.com>
 <20181003071059.02b3fd6f@canb.auug.org.au> <CAKwvOdmt4-jFv6d-ZVUH5OOvXSz38jpuNvQy-jtoSS3xEoh78A@mail.gmail.com>
In-Reply-To: <CAKwvOdmt4-jFv6d-ZVUH5OOvXSz38jpuNvQy-jtoSS3xEoh78A@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 3 Oct 2018 00:12:10 +0200
Message-ID: <CANiq72mmxiO6RWBTQfWYDaa6gmOF01nXmN6BJNCAjAFz3QJqqA@mail.gmail.com>
Subject: Re: [GIT PULL linux-next] Add Compiler Attributes tree
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
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
        Jonathan Corbet <corbet@lwn.net>, "Ted Ts'o" <tytso@mit.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Nick,

On Tue, Oct 2, 2018 at 11:16 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Tue, Oct 2, 2018 at 2:11 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Hi Miguel,
> >
> > On Tue, 2 Oct 2018 15:47:12 +0200 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
> > >
> > > The Compiler Attributes series has been stable for 10+ days. To
> > > increase testing before 4.20, I would to request it being picked up
> > > for -next.
> > >
> > > The changes w.r.t. v5 in the LKML:
> > >
> > >   - Rebased on top of next-20180928, which required removing
> >
> > Unfortunately, trees/branches included in linux-next must be based on
> > something stable (usually Linus' tree, but it could be another
> > tree/branch that is included in linux-next that does not rebase).
> > Linux-next itself rebases every day, so snything based on it would drag
> > in a previous version of all the other trees :-(
>
> I think of this like a branch that's force pushed to.  Can't base
> other branches or trees off of it cause it's always moving/force
> rewriting history.

As I have read, -next is supposed to be a vision of what the merge
window will look like after merging everything, i.e. ideally -rc1. For
that to work for files out-of-tree (like these ones, which are not
maintained by a single tree), changes should be allowed to be stacked
on each other; otherwise, we cannot handle conflicts :-(

>
> >
> > > aligned_largest, which was removed by 9503cd9cbaba
> > > ("include/linux/compiler*.h: add version detection to
> > > asm_volatile_goto").
> >
> > That commit is from Andrew's patch series which also rebases (usually
> > at least every week), so you cannot depend on it.
>
> Miguel, you should be able to drop that patch from your set then,
> since Andrew's -mm tree flows into this -next tree as well, IIUC.
> We'll take up that patch from there.

Not sure what you mean by "drop that patch". There is no patch to
drop, there is a conflict with a change already in -next.

Cheers,
Miguel
