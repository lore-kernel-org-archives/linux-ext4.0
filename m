Return-Path: <SRS0=oRRr=OR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43177 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbeLHXAH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2018 18:00:07 -0500
Received: by mail-lj1-f193.google.com with SMTP id 83-v6so6499247ljf.10
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2018 15:00:06 -0800 (PST)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id c203sm1306798lfe.95.2018.12.08.15.00.04
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Dec 2018 15:00:04 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id x85-v6so6527273ljb.2
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2018 15:00:04 -0800 (PST)
MIME-Version: 1.0
References: <20181206230903.30011-1-krisman@collabora.com> <20181208194128.GE20708@thunk.org>
 <CAHk-=wg2JvjXfdZ8K5Tv3vm6+bKRedotF5cr5AwVZVBypVfdAQ@mail.gmail.com> <CAHk-=wg9J+9H4kvzF0SmBP_CoSrBTxPc6xMRJKb3fDnOUs0DNw@mail.gmail.com>
In-Reply-To: <CAHk-=wg9J+9H4kvzF0SmBP_CoSrBTxPc6xMRJKb3fDnOUs0DNw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 8 Dec 2018 14:59:47 -0800
Message-ID: <CAHk-=wj62vGn5TeGDaPn41mev97VnA7px+R1Xor8+Ai_WmhQ9Q@mail.gmail.com>
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kernel@collabora.com, linux-ext4@vger.kernel.org,
        krisman@collabora.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 8, 2018 at 1:58 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm hoping you are at least doing it per-directory. That makes at
> least the "oh, the whole filesystem needs to do this wrong" issue a
> bit less bad.

So for example, if you do it per-directory, the rules could be something like:

 - new directories (ie "mkdir()") inherit the icase/folding semantics
of the parent directory

 - empty directories can have their case/folding rules changed with
some well-defined interface

and even from just those simple rules, now some icase behavior could
be useful to testing.

Not just filesystem testing (although that would be a thing - thing
fsstress), but for doing app development in a test directory.

Apps like git (and GNU fileutils) could use it for having test suites
for FAT etc filesystems.

And cross-platform apps could use it as a "I want to check that I do
the right thing" if you do development on Linux, but might have a
portable app for other platforms.

If the whole filesystem is that way, nobody is going to do it. Sure,
they could do it on a FAT filesystem using a USB disk, but nobody
really does that. But if you can troivially just run your tests in a
test subdirectory, it's another thing entirely.

So this is the kind of thing I mean when I think icase behavior for a
major Linux filesystem should have a real _design_. It's really quite
fundamentally different from the "oh, I need FAT to be icase" hack
that we have now.

(We might also be able to make the dcache better at handling
well-defined icase/folding rules, as opposed to the current "just give
up, let the filesystem hash it" behavior).

              Linus
