From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Stable patches for ext4
Date: Sat, 18 Oct 2008 10:18:35 -0400
Message-ID: <E1KrCdX-0006L5-2q@closure.thunk.org>
Cc: stable@kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60920 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750910AbYJROSi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Oct 2008 10:18:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Now that we're done pushing patches to ext4 for the merge windows
(unless some really nasty bugs/regressions turn up), it's time to start
thinking which patches that have been pushed to mainline since 2.6.27
should be nominated for the 2.6.27.x -stable tree.

To do that, I've put together a couple of branches, all based off of
2.6.27, at the ext4 git tree:

   http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git

The first branch, ext4-stable, contains *all* ext4-related patches
pushed to Linus since 2.6.27.  This is intended for use by people who
want to apply patches from the ext4 patch queue during the merge window,
and also as convenience for ext4 developers trying to decide which
patches should be cherry picked for -stable.

>From that list, I picked a conservative set of commits that clearly met
the stable kernel criteria in the for-stable branch:

6d1c365... ext4: Do mballoc init before doing filesystem recovery
1708a97... ext4: Free ext4_prealloc_space using kmem_cache_free
bfe5327... ext4: fix xattr deadlock
cefdd90... jbd2: Fix buffer head leak when writing the commit block
a75c1c2... jbd2: abort instead of waiting for nonexistent transaction
73622b0... ext4: fix initialization of UNINIT bitmap blocks
66b63de... ext4/jbd2: Avoid WARN() messages when failing to write to the superbl
89376a6... ext4: Renumber EXT4_IOC_MIGRATE
8ecff40... ext4: elevate write count for migrate ioctl
75ff03e... ext4: add missing unlock in ext4_check_descriptors() on error path
cd2032b... jbd2: fix /proc setup for devices that contain '/' in their names
a27e215... ext4: fix #11321: create /proc/ext4/*/stats more carefully
903872b... Update flex_bg free blocks and free inodes counters when resizing.
70f61d7... ext4: Avoid printk floods in the face of directory corruption

This can be found here:

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for-stable
   http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=for-stable

The more troublesome set of patches are the ones to fix the ENOSPC when
using delayed allocations problems.  These patches violate the stable
criteria in being much harder to review, as well as exceeding the 100
line patch limit.  The for-stable-enospc branch includes the for-stable
patches listed above, as well as the following:

1eede11... ext4: Properly update i_disksize.
623865a... ext4: truncate block allocated on a failed ext4_write_begin
e7683a4... ext4: Retry block allocation if we have free blocks left
9337b86... ext4: Don't add the inode to journal handle until after the block is 
83519a2... ext4: Fix ext4 nomballoc allocator for ENOSPC
0aa4055... ext4: Signed arithmetic fix
52ea747... ext4: Switch to non delalloc mode when we are low on free blocks coun
1e69693... ext4: Add percpu dirty block accounting.
22e5981... ext4: Retry block reservation
d1e9424... ext4: Make sure all the block allocation paths reserve blocks
6be82f3... ext4: invalidate pages if delalloc block allocation fails.

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for-stable-enospc
   http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=for-stable-enospc

I'm a bit concerned about asking Greg or Chris to take the delayed
allocation ENOSPC patches, although they really are critical for someone
considering using ext4 in production (and granted, they would probably
be better waiting until 2.6.28).

So I think the for-stable branch is probably the right set to nominate
for 2.6.27.x.   Comments?   Can folks give it some quick testing before
I formally send it off to the stable folks?

							- Ted

