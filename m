From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Weird resize2fs failures when mounting ext3 as ext4
Date: Thu, 21 Feb 2013 01:07:27 -0500
Message-ID: <20130221060726.GA20124@thunk.org>
References: <51229FF7.7090003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49186 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab3BUGHa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2013 01:07:30 -0500
Content-Disposition: inline
In-Reply-To: <51229FF7.7090003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2013 at 03:41:11PM -0600, Eric Sandeen wrote:
> Can't remember how I stumbled on this testcase, but mounting
> an ext3 filesystem with "-t ext4" and then resizing leads to trouble.
> 
> With -o nodelalloc, the newly added space isn't seen by the allocator
> and we get ENOSPC for the extending writes in the script below.
> 
> Without -o nodelalloc, the writes worked but I got an umount hang.
> 
> Without -t ext4 (but letting ext4.ko handle the ext3 mount) it seems
> to work fine.
> 
> Haven't looked into it much at all yet but wanted to put it out
> there for posterity.

At least one of the problems is that ext4_alloc_blocks() is buggy if
it is asked to allocate one or more indirect blocks, and then it
doesn't have room to allocate any direct blocks.  In that case,
ext4_alloc_blocks() does not return ENOSPC, and so ext4_alloc_branch()
doesn't fail.  But since the number of direct blocks allocated is
zeor, ext4_splice_branch() will not actually initialize the indirect
block, and then we end up looping forever and calling
ext4_mballoc_alloc() --- demonstrating that one of the best definition
of insanity is doing the same thing over and over again and expecting
a different result:

    flush-254:32-2913  [001] ....  1073.028245: ext4_mballoc_alloc: dev 254,32 inode 21824 orig 0/4031/64@4981 goal 0/4029/2048@4096 result 0/0/0@0 blks 0 grps 0 cr 3 flags 0x0c20 tail 0 broken 0
    flush-254:32-2913  [001] ....  1073.050655: ext4_mballoc_alloc: dev 254,32 inode 21824 orig 0/4031/64@4981 goal 0/4029/2048@4096 result 0/0/0@0 blks 0 grps 0 cr 3 flags 0x0c20 tail 0 broken 0
    flush-254:32-2913  [001] ....  1073.073034: ext4_mballoc_alloc: dev 254,32 inode 21824 orig 0/4031/64@4981 goal 0/4029/2048@4096 result 0/0/0@0 blks 0 grps 0 cr 3 flags 0x0c20 tail 0 broken 0
    flush-254:32-2913  [001] ....  1073.112163: ext4_mballoc_alloc: dev 254,32 inode 21824 orig 0/4031/64@4981 goal 0/4029/2048@4096 result 0/0/0@0 blks 0 grps 0 cr 3 flags 0x0c20 tail 0 broken 0

I suspect the right way to deal with this is to nuke
ext4_alloc_blocks() from orbit, and change ext4_alloc_branch() to
allocate the indirect and direct blocks directly, calling
ext4_new_meta_block() and ext4_mb_new_blocks() directly.  What we have
right now is pretty gross....

The other problem is why resizing isn't adding the blocks so that they
are visible to the allocator.  Since we are using the same code path
for ext3 and ext4 file systems, I have a sneaking suspicion that we're
not actually making all of the newly allocated blocks for ext4 file
systems available too, but it's something like we're not making the
first block in each flex_bg group available (and that happens to be all
of the newly grown blocks for ext3 file systems).

As near as I can tell this isn't a regression, but since this is a
pretty seriouis bug, it's something we should try to fix during the
3.8 development cycle.

						 - Ted
