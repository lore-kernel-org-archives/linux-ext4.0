Return-Path: <SRS0=oRRr=OR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39163 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbeLHVtP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2018 16:49:15 -0500
Received: by mail-lj1-f193.google.com with SMTP id t9-v6so6452683ljh.6
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2018 13:49:13 -0800 (PST)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id k11-v6sm1303979ljk.40.2018.12.08.13.49.11
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Dec 2018 13:49:12 -0800 (PST)
Received: by mail-lj1-f171.google.com with SMTP id k19-v6so6414060lji.11
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2018 13:49:11 -0800 (PST)
MIME-Version: 1.0
References: <20181206230903.30011-1-krisman@collabora.com> <20181208194128.GE20708@thunk.org>
In-Reply-To: <20181208194128.GE20708@thunk.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 8 Dec 2018 13:48:54 -0800
Message-ID: <CAHk-=wg2JvjXfdZ8K5Tv3vm6+bKRedotF5cr5AwVZVBypVfdAQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kernel@collabora.com, linux-ext4@vger.kernel.org,
        krisman@collabora.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 8, 2018 at 12:22 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> There's a patch series that's been baking for a while that will likely
> go upstream either in the next upcoming merge window, or the one after
> that.  Since it adds support for Unicode case-folding, it involves a
> non-trivial number of changes to fs/nls.  As near as I can tell, no
> one is really maintaining fs/nls.

Christ.

Why do people want to do this? We know it's a crazy and stupid thing
to do. And we know that, exactly because people have done it, and it
has always been a mistake.

It causes actual and very subtle security issues.

It breaks things subtly even when they supposedly "know" about case
folding because different things will do it differently (ie user space
vs kernel space not having the *exact* same rules due to using
different tables, for example).

It doesn't work with locales, because people often want different
locales at the same time.

And it slows things down enormously because you can't do hashing well,
and comparisons get hugely more expensive.

And to add insult to injury, people always implement it so *horribly*
badly that it's not even funny.

For example, the usual way that people do it is to case-fold two
strings, and then compare the end results. And that's *incredibly*
stupid and slow and generates extra temporary allocations etc.

Or people to it character-by-character instead, and don't understand
utf-8 (which is literally designed to be easy to see character
boundaries *without* having to do a full decode!), and do *that*
incredibly badly instead.

And when you create a file with an ambiguous name, what does readdir
report? Does it report the name you used, some normalized thing, or
what?

Finally, people then invariably do it in ways that preclude any
concurrent sane uses.

For example, they make it a single mount-time flag for the whole
filesystem, so now if you are (for example) wanting to do emulation of
bad system decisions, you now force the *host* to buy into the whole
mistake too.

And they make it a whole-filesystem flag, instead of (for example)
allowing just the emulated environment to do case-insensitive
filesystem operations on an operation-by-operation basis, and possibly
only within a particular subdirectory structure (or bind mount).

So the first thing I want to know is who really needs it, *why* they
need it, and what the design is for.

Because I can almost guarantee that the design is horrible, and the
reasons are really really bad.

And what *are* the case insensitivity rules, and how do you co-exist
when there are two *different* folding rules at the same time? For
example, OS X has some truly horrendously bad rules, that take the
badness that Windows did to a whole different level. What if you're a
file server (or emulation environment) and you want to expose the same
filesystem to both of those environments?

Because it would quite possibly be a whole lot better to allow
per-operation flags, so that you can do

    fd = openat(dir, path, O_RDONLY | O_ICASE);

so that you can allow *one* process to treat a filesystem as if it was
case insensitive (think "Wine in with a ~/.wine/C directory"), without
forcing the whole filesystem to be icase.

Yes, allowing concurrent use then generates whole new "interesting"
questions, like "what happens if a case _sensitive_ user creates two
files with names that are identical to a in-sensitive user", but they
aren't necessarily any worse than the issues you face *not* allowing
that.

> Given your recent comments about not wanting to see pull requests for
> things outside of fs/xfs as part of the xfs pull, do you have any
> opinions about how to do manage this feature going upstream?  My
> original plan was to send them through the ext4 tree, since I very
> much doubt Al cares much about nls issues, and they will only impact
> ext4.

I really want to know what is driving this insanity, and what the
actual use-case is.

You have a diffstat, but not a git tree to look at what the heck is going on.

Seriously, case insensitivity is *such* a horrendously bad idea that
people need to think about it deeply, and nobody seems to ever do
that.

And yes, we have d_hash() and some rudimentary support for it in the
VFS layer, but that VFS layer bit was always meant purely for
interoperability filesystems that nobody really cared about as a real
filesystem for Linux. Notably FAT and its ilk.

If we have a major native filesystem doing it, I think we need to
actively think about the big picture and do it *right*. None of the
crazy "ok, you can't even look things up in the dcache directly at
all" stuff that we have as a hack to just allow _bad_ filesystems to
do their thing.

So I think this is a bigger deal than that diffstat of yours implies.
I don't think people understand just how *bad* case insensitivity is.

The old DOS/Mac people thought case insensitivity was a "helpful"
idea, and that was understandable - but wrong - even back in the 80's.
They are still living with the end result of that horrendously bad
decision decades later. They've _tried_ to fix their bad decisions,
and have never been able to (except, apparently, in iOS where somebody
finally had a glimmer of a clue).

                 Linus
