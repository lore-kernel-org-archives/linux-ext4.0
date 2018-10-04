Return-Path: <SRS0=Op7R=MQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36091 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbeJDP7R (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Oct 2018 11:59:17 -0400
MIME-Version: 1.0
References: <CANiq72=rgT9cPWH64Tf_8gAU09EiH5FvGqFUdOjV=spVbM5m8Q@mail.gmail.com>
 <20181003071059.02b3fd6f@canb.auug.org.au> <CAKwvOdmt4-jFv6d-ZVUH5OOvXSz38jpuNvQy-jtoSS3xEoh78A@mail.gmail.com>
 <CANiq72mmxiO6RWBTQfWYDaa6gmOF01nXmN6BJNCAjAFz3QJqqA@mail.gmail.com>
 <20181002232454.GB2483@thunk.org> <CANiq72=cRpqnB3BxLsmj-rMdUGJK+pac1SRppoRgsON69ErfQg@mail.gmail.com>
 <20181003153303.GC2835@thunk.org> <CANiq72=Jq8HZ1=CsSvV4GenG+F6z3vRFmiB7Joct5VKdUFo8pA@mail.gmail.com>
 <CANiq72nMu6NXg1Ovn49qJ=FP_S4_LQJSwPuS+Q_zofhOEbVZng@mail.gmail.com> <20181004050140.GC646@thunk.org>
In-Reply-To: <20181004050140.GC646@thunk.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 4 Oct 2018 11:06:46 +0200
Message-ID: <CANiq72nTAF6SyM+mgMG-DT=nOLz5DyEjfHKgq5uJLwufBNWViA@mail.gmail.com>
Subject: Re: [GIT PULL linux-next] Add Compiler Attributes tree
To: "Ted Ts'o" <tytso@mit.edu>,
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
        Jonathan Corbet <corbet@lwn.net>,
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

Hi Ted,

On Thu, Oct 4, 2018 at 7:02 AM Theodore Y. Ts'o <tytso@mit.edu> wrote:
> In this case, yes.  Again, I emphasize that I was using the ext4.h
> cleanup as an *example*.  The point I was trying to make was that your
> change did *not* do a full set of deep ext4 regression tests because
> the your change didn't go through the ext4.git tree.  I have seen

Because it shouldn't matter from which tree they come from to get the
tests run. *That* is the problem: effectively we have independent
projects in the kernel. If you tell me that my change did not run the
ext4 tests (even if I Cc'd you or maybe some ML, etc.), it means there
is something wrong.

> cases where "simple mechanical changes" were anything but, and while
> the kernel *compiled* it resulted in the file system not working.
> (And in the worst case, it resulted actual data loss or file system
> corruption.)

Yes, I have also experienced one-liners breaking entire projects.
Ideally, any change should be assumed to break everything unless
proved otherwise, and I agree with having as much testing as possible
-- see above for the actual problem here.

> My test scripts are public, and in fact I've gone out of my way to
> make them easy for other people to run them, with documentation[1][2],
> slide sets[3], etc.  But the vast majority of people who submit
> patches to ext4.git don't bother --- and as far as I know *no one* who
> sends ext4 changes via other git trees *ever* bothered.  (And, for one
> recent patchset where the ext4 developer spent a lot of time using
> kvm-xfstests before submission, accepting that set of changes was easy
> and was a joy.  I'm a big believe in tests.)

I believe you -- but actually I would *expect* that. Nobody runs them
because nobody has either the time, the expertise, or feels the need
to do so. It is not a matter of "being easy to run". It is simply that
people won't do it unless you force them to (and if you force them,
you will lose some contributions).

The solution is not providing slides, documentation, or making it
fool-proof. The solution, in my view, is avoiding people having to do
the tests. Currently, I thought we do that in the kernel by Cc'ing
whoever is a maintainer of the code and letting that person do
whatever is required for those changes. Of course, you can automate
this in many fancy ways as many projects/companies have done (and as
you describe for Google).

However...

> So if you are willing to completely standardize your testing
> infrastructure and devote utterly lavish amounts of automated testing

...I don't agree. I don't think this follows from the above
discussion. While release management and testing are topics that go
together (pretty much always), they are two different, independent
problems. I am talking here about the need for some "software" to do
the release management (i.e. merging many trees, doing integration,
etc.), not the testing side of it (which can change irrespective of
the release management side; e.g. may have different triggers, may
have different requirements, may use different systems to help, etc.).

Actually, it is fairly easy to prove: Pick Documentation/ and imagine
it was only plain text files without processing required (as in the
old days). For that "project", you don't need any testing whatsoever,
but you still need to do release integration. For ext4, you may want
to use your testing scripts. For drivers/foo/bar.c, maybe the only way
of testing is plugging the hardware and seeing that it works. So,
different projects, different testing mechanisms; but same release
integration at the end of the day.

> which is deeply integrated into a standardized, non-email code review
> system, the challenge you have identified *has* been solved.  But

Of course it has been "solved". All projects with hundreds of
contributors/subprojects/... have to deal with the same issues, and
they have to keep moving forward at the end of the day. The point is
not how Google, or CERN, or anybody else does it. The point is that
there should be a better way to handle this which makes kernel
development better.

I explained the issue we faced at CERN years ago simply because it was
very similar to this (merging given tags of different trees,
basically). I am not sure how/if your Google example is relevant here,
since it is a completely custom system, it is very different to what
the kernel does, etc. I understand you are trying to say "this is no
news, there are other ways of solving it, it is solved at Google"; but
with my "example" I was not trying to say "we solved it at CERN" or
trying to say I am a "guru"; I was simply stating that it seems there
could be a project coming out of this to solve this space *in the
context of the kernel workflow*.

> trust me when I say that it is a very non-trivial thing to do, and it
> requires a lot of very strict code development practices that are
> imposed on all Google C++ developers working in the common tree (which
> is probably 90%+ of the SWE's inside Google).  I'm not at all
> convinced that it could be adopted or imposed on the kernel
> development process.  In fact, I'm quite confident it could not be.

This paragraph seems to follow from the fact that you connect
heavily-automated testing with release integration. I don't
necessarily agree with that as explained above, so I think I could cut
here this part of the discussion, but anyway, here it goes: coding
development practices are not completely tied to release integration.
Same as testing: i.e. you *can* do release integration (and heavy
testing) without strict coding development guidelines. We actually do
that at the kernel nowadays (and we did it at CERN too).

>
> I actually think the Linux Kernel's approach of carefully segregating
> how code and headers to avoid merge conflicts (and worse, semantic
> conflicts that may git merge and build succesfully, but then blow up

Not sure how the kernel is preventing semantic conflicts (in different
ways than other projects, I mean). What do you mean?

> in subtle ways leading to user data loss) is actually a pretty good
> way of doing things.  It works 99.99% of the the commits.  True, it

I would say many commits are local enough that it is not really a
problem. The issue is non-local commits, and I am not that confident
it works for 99.99% of those.

> wasn't optimal for the changes you were trying to make; but your
> experience is the exception, not the rule.

Sure, but regardless of how well it works, the fact is that Stephen is
managing some custom (and AFAIK, ad hoc) scripts. That usually means
there is something that may be factorized out.

>
> The risk here is that it's very easy to engineer changes in processes
> for corner cases, and which make things much worse (either taking more
> time, or more effort, or being less reliable) for the common case.

Agreed, but changes are not necessarily bad, i.e. they are not
guaranteed to be worse than the previous state. Actually, I would
argue we could reach a better state of the art for *all*
commits/cases, not only corner ones.

Cheers,
Miguel
