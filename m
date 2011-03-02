From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Ext4 kernel patches ready for benchmarking
Date: Tue, 01 Mar 2011 19:55:39 -0500
Message-ID: <E1PuaLr-0001dQ-Hr@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <eric.whitney@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49361 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757226Ab1CBAzq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Mar 2011 19:55:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric (and the rest of the ext4 development team),

I still have some ext4 patches to merge, but all or most of the ones
that should affect performance are in the ext4 tree now.  You can get
them via

   git fetch git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git \
		for-enw-benchmark

This patch series is based off of 2.6.38-rc5, plus one fixup commit,
3abb17e82f: "vfs: fix BUG_ON() in fs/namei.c:1461", which shouldn't be
performance relevant (FFSB doesn't use symlinks, which is probably why
you haven't noticed any problems).

This patch series has passed a large number of xfstests runs using 4k
and 1k block sizes.  I am currently using this patch set merged with
2.6.38-rc7 on my laptop, and it "feels" faster, but could be becauses of
other optimizations and improvements that went in post-2.6.38, and it
could be because I've enabled CONFIG_SCHED_AUTOGROUP, not just the ext4
improvements :-)  --- although commit b616844 could very well help
synchronous write workloads.

A short summary of patches in for-enw-bencmark can be found below.  A
"P" indicates patches that will hopefully help improve performance.  A
"B" indicates that it's a bug fix (addresses a hang, crash, or potential
data corruption --- the last is the FIEMAP fix, only if you are using a
new coreutils).  The rest are cleanups, or fixups in error path
handling.

Note!  Just because a patch isn't listed here doesn't mean it won't get
merged in the next merge window.  It just means that I've reached a
convenient stopping point, and since I'm headed up to the Heavenly Ski
Resort in Lake Tahoe with a good part of the Google prod kernel team
tomorrow, and most of the performance-impactful changes have been merged
at this point, I thought this would be a good place to summarize where
we are at, and give Eric a stable patch set for performance testing.

						- Ted

Alexander V. Lukyanov (1):
      [5dbd571] ext4: allow inode_readahead_blks=0 (linux-2.6.37)

Amir Goldstein (2):
      [8e8eaab] ext4: use the nblocks arg to ext4_truncate_restart_trans()
      [d39195c] ext4: skip orphan cleanup if fs has unknown ROCOMPAT features

Coly Li (5):
      [84b775a] ext4: code cleanup in mb_find_buddy()
      [235772d] ext4: remove unncessary call mb_find_buddy() in debugging code
      [7c78605] mballoc: add comments to ext4_mb_mark_free_simple()
      [58696f3] ext4: clarify description of ac_g_ex in struct ext4_allocation_context
    P [5a54b2f] ext4: mballoc: don't replace the current preallocation group unnecessarily

Curt Wohlgemuth (2):
    B [e0fd9b9] ext4: mark multi-page IO complete on mapping failure
    B [c7f5938] ext4: fix ext4_da_block_invalidatepages() to handle page range properly

Eric Sandeen (1):
      [ea66333] ext4: enable acls and user_xattr by default

Lukas Czerner (4):
      [6f9524e] ext4: update ext4 documentation
      [0b75a84] ext4: mark file-local functions and variables as static
      [4143179] ext4: check if device support discard in FITRIM ioctl
      [5c2ed62] ext4: Adjust minlen with discard_granularity in the FITRIM ioctl

Manish Katiyar (1):
      [32a9bb5] ext4: fix missing iput of root inode for some mount error paths

Peter Huewe (1):
      [7dc5761] ext4: Fix sparse warning: Using plain integer as NULL pointer

Theodore Ts'o (11):
      [da48894] ext4: fix compile warnings with EXT4FS_DEBUG enabled
    P [6fd7a46] ext4: enable mblk_io_submit by default
      [8eb9e5c] ext4: fold __mpage_da_writepage() into write_cache_pages_da()
      [4f01b02] ext4: simple cleanups to write_cache_pages_da()
    P [9749895] ext4: clear the dirty bit for a page in writeback at the last minute
    P [ee6ecbc] ext4: remove page_skipped hackery in ext4_da_writepages()
    P [78aaced] ext4: don't lock the next page in write_cache_pages if not needed
      [168fc02] ext4: move setup of the mpd structure to write_cache_pages_da()
    B [a54aa76] ext4: don't leave PageWriteback set after memory failure
      [4dd89fc] ext4: suppress verbose debugging information if malloc-debug is off
    P [b616844] ext4: optimize ext4_bio_write_page() when no extent conversion is needed

Yongqiang Yang (1):
    B [6d9c85e] ext4: make FIEMAP and delayed allocation play well together

 Documentation/ABI/testing/sysfs-fs-ext4 |   13 +-
 Documentation/filesystems/ext4.txt      |  207 +++++++++++++++++++-
 fs/ext4/extents.c                       |  195 ++++++++++++++----
 fs/ext4/ialloc.c                        |    2 +-
 fs/ext4/inode.c                         |  339 ++++++++++++-------------------
 fs/ext4/ioctl.c                         |    6 +
 fs/ext4/mballoc.c                       |   21 ++-
 fs/ext4/mballoc.h                       |    2 +-
 fs/ext4/migrate.c                       |   10 +-
 fs/ext4/page-io.c                       |   13 +-
 fs/ext4/resize.c                        |    4 +-
 fs/ext4/super.c                         |   44 +++--
 fs/ext4/xattr.c                         |    2 +-
 13 files changed, 561 insertions(+), 297 deletions(-)
