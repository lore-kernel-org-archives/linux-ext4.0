Return-Path: <SRS0=mHRP=MP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40184 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbeJCTWx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Oct 2018 15:22:53 -0400
MIME-Version: 1.0
References: <CANiq72=rgT9cPWH64Tf_8gAU09EiH5FvGqFUdOjV=spVbM5m8Q@mail.gmail.com>
 <20181003071059.02b3fd6f@canb.auug.org.au> <CAKwvOdmt4-jFv6d-ZVUH5OOvXSz38jpuNvQy-jtoSS3xEoh78A@mail.gmail.com>
 <CANiq72mmxiO6RWBTQfWYDaa6gmOF01nXmN6BJNCAjAFz3QJqqA@mail.gmail.com>
 <20181002223652.GA4290@nautica> <20181003090010.5150f914@canb.auug.org.au>
In-Reply-To: <20181003090010.5150f914@canb.auug.org.au>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 3 Oct 2018 14:34:28 +0200
Message-ID: <CANiq72nLLhTf3AsXqLkPmK6TV_g7E3tML9XaM_zE45dM7XPn-A@mail.gmail.com>
Subject: Re: [GIT PULL linux-next] Add Compiler Attributes tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dominique Martinet <asmadeus@codewreck.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Stephen,

On Wed, Oct 3, 2018 at 1:00 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Miguel,
>
> On Wed, 3 Oct 2018 00:36:52 +0200 Dominique Martinet <asmadeus@codewreck.org> wrote:
> >
> > Miguel Ojeda wrote on Wed, Oct 03, 2018:
> > > As I have read, -next is supposed to be a vision of what the merge
> > > window will look like after merging everything, i.e. ideally -rc1. For
> > > that to work for files out-of-tree (like these ones, which are not
> > > maintained by a single tree), changes should be allowed to be stacked
> > > on each other; otherwise, we cannot handle conflicts :-(
> >
> > The rule is the same as with a regular mainline pull; I don't have the
> > reference at hand but in some recent-ish pull request Linus said he
> > prefers the stable version with the conflict, and optionally you can
> > provide a second branch with the conflict resolved for reference, but
> > the pull request should be based on something stable even if it has
> > conflicts
> >
> > If there is a conflict Stefen will resolve it like Linus/Greg would, and
> > the resolved bit will be carried over everyday so it's not much more
> > work -- exactly like a regular pull request for inclusion in the main
> > tree :)
>
> Exactly what Dominique said.  I will fix up the conflict (unless it is
> a very complex conflict, in which case the author(s) should help) and
> the Linus (or Greg) will do the same.  If you do depend on a patch in
> Andrew's series, what happens if that patch does not get sent to Linus
> during the merge window or Linus rejects it?

This doesn't depend on anything. Not sure what is all the fuss about
-- people got confused into thinking we had to drop a patch for some
reason. As explained in the first email, I simply rebased v5 (which is
based on top of rcX) to resolve the conflict myself (i.e. it does
*not* depend on changes in -next). If you are the one solving
conflicts yourself (which is what I asked in my second email), there
is no problem to begin with; I will simply send v6 to you and we are
done.

When I sent the first email, I assumed that changes in -next were
supposed to be clean -- my mistake, but please document somewhere how
-next works! Specially that you are rerere'ing conflicts and
re-resolving them every day.

Then the discussion shifted to what to do with changes that actually
depend on other changes.

Cheers,
Miguel
