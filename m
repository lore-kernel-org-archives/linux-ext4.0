Return-Path: <SRS0=f65u=MO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36940 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbeJCEuM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Oct 2018 00:50:12 -0400
MIME-Version: 1.0
References: <CANiq72=rgT9cPWH64Tf_8gAU09EiH5FvGqFUdOjV=spVbM5m8Q@mail.gmail.com>
 <20181003071059.02b3fd6f@canb.auug.org.au>
In-Reply-To: <20181003071059.02b3fd6f@canb.auug.org.au>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 3 Oct 2018 00:04:29 +0200
Message-ID: <CANiq72nh0nybEC8SizQ9rv=RvncMuTH-dt5vciRtvQ1aFBzJcg@mail.gmail.com>
Subject: Re: [GIT PULL linux-next] Add Compiler Attributes tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
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
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Stephen,

On Tue, Oct 2, 2018 at 11:11 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Miguel,
>
> On Tue, 2 Oct 2018 15:47:12 +0200 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
> >
> > The Compiler Attributes series has been stable for 10+ days. To
> > increase testing before 4.20, I would to request it being picked up
> > for -next.
> >
> > The changes w.r.t. v5 in the LKML:
> >
> >   - Rebased on top of next-20180928, which required removing
>
> Unfortunately, trees/branches included in linux-next must be based on
> something stable (usually Linus' tree, but it could be another
> tree/branch that is included in linux-next that does not rebase).
> Linux-next itself rebases every day, so snything based on it would drag
> in a previous version of all the other trees :-(

I assumed you could apply changes as a diff/patches/cherry-pick, not
as a merge, for those that went on top of others (so that at the new
merge window, conflicts were already solved). Otherwise, why are
next-* tags/branches provided anyway?

>
> > aligned_largest, which was removed by 9503cd9cbaba
> > ("include/linux/compiler*.h: add version detection to
> > asm_volatile_goto").
>
> That commit is from Andrew's patch series which also rebases (usually
> at least every week), so you cannot depend on it.

Then who is solving the conflict?

Thanks!

Cheers,
Miguel
