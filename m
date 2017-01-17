From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: =?utf-8?Q?EXT4?= =?utf-8?B?77ya?= About the method of compute
 journal blocks
Date: Tue, 17 Jan 2017 12:10:24 -0500
Message-ID: <20170117171024.lbunxryq5mjlvrvv@thunk.org>
References: <CAHndWeV=wT74J2TBWsxcFF0Ks_u0UYQeD=040+m8CtP2L9d7XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: yu xing <mdxy2014@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53990 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751025AbdAQSUV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 17 Jan 2017 13:20:21 -0500
Content-Disposition: inline
In-Reply-To: <CAHndWeV=wT74J2TBWsxcFF0Ks_u0UYQeD=040+m8CtP2L9d7XQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 17, 2017 at 11:50:13AM +0800, yu xing wrote:
> 
>          Currently, I am seeing the the make_ext4fs code of
> android，the source code is located at system/extras/ext4_utils

The make_ext4fs code in AOSP is something I've been trying to make go
away.  It exists because many years ago, the people who were working
on Android were desperately trying to avoid all GPLv2 code outside of
the kernel.  So make_ext4fs was a cleanroom rewrite from scratch of
mke2fs, and so they may have gotten a few things wrong.  As a result
file systems made with make_ext4fs are not completely identical to
those made by ext4 (especially when used on the device after a factory
reset) and this has caused some interesting and hard to debug problems
in the past.

E2fsprogs is now in AOSP, and I am hoping to make all of the use cases
of make_ext4fs go away, since it will make everyone's lives much
easier.  This has actually been a bit tricker since make_ext4fs has
some additional functionality that never should have been part of
make_ext4fs, but that is slowly being disentangled (see the very
latest AOSP git trees).   So tiny steps....

For this reason, most of the people on this list aren't going to be
able to answer questions about make_ext4fs, since it's Android
specific code.  I can answer some of these questions, but only because
I've been asked to debug some of these hard to understand bugs in
make_ext4fs (and I really don't want to do that any more, hence the
work to extirpate make_ext4fs from the AOSP source tree :-).

> I have some question, as following, can somebody help me to explain
> these questions? Thanks a lot!
> 
> 1. The method of compute journal blocks, why  divide 64 :
> 
>           static u32 compute_journal_blocks()
> {
>     u32 journal_blocks = DIV_ROUND_UP(info.len, info.block_size) / 64;
>    // is here, why divide 64 ???
>     if (journal_blocks < 1024)
>         journal_blocks = 1024;
>     if (journal_blocks > 32768)
>         journal_blocks = 32768;
>     return journal_blocks;
> }

This is to compute how many blocks should be allocated for the
journal.  It's a hueristic, and I suspect the authors of make_ext4fs
were trying to make the it work more or less like what mke2fs does.
See ext2fs_default_journal_size() in lib/ext2fs/mkjournal.c in
e2fsprogs for the original code.  It's a bit better documented, but in
the end, it's just a hueristic.  The hueristic has changed over the
years, by the way, for better performance on larger, faster devices.
So what make_ext4fs does is different from e2fsprogs's current defaults.

> 2. The method of compute jbg_desc_reserve_blocks , why multiply by 1024:
> static u32 compute_bg_desc_reserve_blocks()
> {
>     u32 blocks = DIV_ROUND_UP(info.len, info.block_size);
>     u32 block_groups = DIV_ROUND_UP(blocks, info.blocks_per_group);
>     u32 bg_desc_blocks = DIV_ROUND_UP(block_groups * sizeof(struct
> ext2_group_desc),
>             info.block_size);
> 
>     u32 bg_desc_reserve_blocks =
>             DIV_ROUND_UP(block_groups * 1024 * sizeof(struct
> ext2_group_desc),      // is here , why multiply by 1024 ???
>                     info.block_size) - bg_desc_blocks;
> 
>     if (bg_desc_reserve_blocks > info.block_size / sizeof(u32))
>         bg_desc_reserve_blocks = info.block_size / sizeof(u32);
> 
>     return bg_desc_reserve_blocks;
> }

These are reserved blocks used so the file system can be on-line
resized.  It's actually a waste of space since android file systems
are never resized, but again, cargo cult algorithms from clean room
reimplementations.  :-)

> 3. About compute_inodes function , why divide 4 ??
> static u32 compute_inodes()
> {
>     return DIV_ROUND_UP(info.len, info.block_size) / 4;  // is here
> why divide 4 ??
> }

Again, this is a hueristic to figure out roughly how many inodes
should be reserved given a particular file system size.  The default
assumes that the average size of files in the file system is 16k, and
allocates enough inodes so that the file system won't run out of
inodes given that average file size.

This is adjustable using mke2fs's command line arguments.  See the man
page for mke2fs for more details.  make_ext4fs was just using a hard
coded default that can't be adjusted, apparently.

Cheers,

					- Ted
