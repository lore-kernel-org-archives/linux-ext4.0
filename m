Return-Path: <SRS0=aByE=NM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39089 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbeKBFTy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Nov 2018 01:19:54 -0400
MIME-Version: 1.0
References: <20181022105944.GA1411@gmail.com> <CAHk-=whpBiV5sVTvPsWOVx5WYOouxbNG1fWeCdpK4oFiaH0Zqg@mail.gmail.com>
In-Reply-To: <CAHk-=whpBiV5sVTvPsWOVx5WYOouxbNG1fWeCdpK4oFiaH0Zqg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 1 Nov 2018 21:15:12 +0100
Message-ID: <CANiq72=Cz8XiYc=FGMwrNBFq2uiO55JBmoNc+NSDXYr_awosKw@mail.gmail.com>
Subject: Re: [GIT PULL] Compiler Attributes for v4.20-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dan <dan.carpenter@oracle.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Olof Johansson <olof@lxom.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
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
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org,
        gor@linux.ibm.com, schwidefsky@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 1, 2018 at 6:06 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm not sure how much that matters (maybe the original check for 4.9.2
> was just a random pick by Andrey? Added to cc), but together with the
> movement to <linux/compiler_attributes.h> that looks like it also
> wouldn't want the CONFIG_KASAN tests, I wonder what the right merge
> resolution would be.

Good catch. I don't recall any special logic when I did that change,
so most likely I simply did like for the rest of the attributes and
took a look at when it was first supported (and documentation in gcc's
docs) in order to implement __has_attribute by hand.

But indeed, it *may* be that there is an (undocumented) problem
between 4.8 <= gcc < 4.9.2 with it. If so, we should document it down
and fix it. Andrey?

> Yes, I see the resolution in linux-next, and I think that one is odd
> and dubious, and now it *mixes* that old test of gcc-4.9.2 with the
> different test in compiler-attributes.

I missed that conflict completely, my bad (I did not miss all of them,
at least; one required fixing).

Hm.... at a quick look, why is it only on compiler-gcc.h? It should
either have a corresponding #define elsewhere or just be put directly
in another common header, no? (Adding Vasily & Martin to CC.)

> But I'm also unsure whether you meant for the "__has_attribute()" test
> to be usable outside the linux/compiler_attributes.h file, in which
> case I could just do
>
>   #if defined(CONFIG_KASAN) && __has_attribute(__no_sanitize_address__)
>
> instead.

I think that (using __has_attribute() outside) may be a good idea: I
wanted to keep compiler_attributes.h as simple as possible by avoiding
#ifdefs inside that header (except for __has_attribute itself), as an
attempt to avoid going back to the mess of #ifdefs we had previously.
Basically, keeping the attributes in compiler_attributes.h that do not
depend on complex logic. So using __has_attribute *outside* the header
actually goes well with that principle, because it helps keeping stuff
out of it if they depend on other config options; without having to
rely on GCC_VERSION either.

[By the way, in case it clarifies: note that "optional" in that file
actually is a bit of a misnomer. I meant to say "optional" as in "not
supported by all compilers, so conditionally defined" ("optionally"
defined); rather than "optional" in the sense of "code still works
without the attribute". It caught Rasmus in one of his patches sent a
few days ago on top of this tree, so I want to change it or explain it
to avoid confusion.]

Cheers,
Miguel
