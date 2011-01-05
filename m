From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/6] Shrinking the size of ext4_inode_info
Date: Tue,  4 Jan 2011 20:01:04 -0500
Message-ID: <1294189270-16733-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56636 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab1AEBBO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jan 2011 20:01:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following set of patches shrink the size of ext4_inode_info, which
is present in memory for every single ext4 inode in the inode cache.
For example, on one of my machines I currently have 172261 ext4 inodes
in my cache, which represents 161 megabytes of memory.  On an x86_64
machine, these patches allow me to shrink the ext4 in-core inode size
from 952 bytes to 872 bytes.  This represents a 8.4% decrease.  Using
the SLUB allocator, this means we can now fit 18 inodes into an order 4
(16384 bytes) slab, instead of the previous 17 inodes.  This results in
an effective decrease of 5.6% of memory consumption by the ext4 inode
cache.

It would be possible to further slim down the ext4_inode_cache by
another 100 bytes or so, by breaking the ext4_inode_info into the
portion of the inode required a file is opened for writing, and
everything else.  That would be a fairly disruptive change, though, so
I'll save that for another time.

						- Ted

Theodore Ts'o (6):
  ext4: replace i_delalloc_reserved_flag with
    EXT4_STATE_DELALLOC_RESERVED
  ext4: Use ext4_lblk_t instead of sector_t for logical blocks
  ext4: Drop ec_type from the ext4_ext_cache structure
  ext4: reorder ext4_inode_info structure elements to remove unneeded
    padding
  ext4: Drop i_state_flags on architectures with 64-bit longs
  ext4: Dynamically allocate the jbd2_inode in ext4_inode_info as
    necessary

 fs/ext4/balloc.c       |    3 ++-
 fs/ext4/ext4.h         |   36 +++++++++++++++++++++++-------------
 fs/ext4/ext4_extents.h |    8 ++------
 fs/ext4/ext4_jbd2.h    |    2 +-
 fs/ext4/extents.c      |   39 ++++++++++++++++-----------------------
 fs/ext4/file.c         |   19 +++++++++++++++++++
 fs/ext4/ialloc.c       |    2 +-
 fs/ext4/inode.c        |   29 ++++++++++++++++++-----------
 fs/ext4/mballoc.c      |    5 +++--
 fs/ext4/super.c        |   17 +++++++----------
 fs/jbd2/journal.c      |   20 +++++++++++++-------
 include/linux/jbd2.h   |   20 ++++++++++++++++++--
 12 files changed, 123 insertions(+), 77 deletions(-)

-- 
1.7.3.1

