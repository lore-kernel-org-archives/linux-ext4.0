From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v4 0/3] dioread_nolock patch
Date: Fri, 15 Jan 2010 14:30:09 -0500
Message-ID: <1263583812-21355-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60036 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab0AOTaS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jan 2010 14:30:18 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've worked with Jiaying to ready this patch for submission.

It's currently a mount option for maximum safety, but after we do some
benchmarking to make sure it doesn't degrade performance for buffered
writes, we may want to make this the default.  Once really nice side
effect of this patch is that it effectively gives us "guarded mode" by
default, since the blocks are marked as uninitialized and only converted
to be initialized when the I/O has completed for both buffered and
direct I/O writes now.  This means that we could possibly change the
default mode to be data=writeback if the extents feature is enabled,
since data=ordered would only needed for safety when writing new
old-style indirect blocks.

The plan is to merge this for 2.6.34.  I've looked this over pretty
carefully, but another pair of eyes would be appreciated, especially if
we make this the default.  Beyond the advantages of being able to use
data=writeback, I believe this should be a major win for database
workloads.

					- Ted

Theodore Ts'o (3):
  ext4: mechanical change on dio get_block code in prepare for it to be
    used by buffer write
  ext4: use ext4_get_block_write in buffer write
  ext4: Use direct_IO_no_locking in ext4 dio read.

 fs/ext4/ext4.h      |   28 +++++---
 fs/ext4/ext4_jbd2.h |   24 +++++++
 fs/ext4/extents.c   |   36 +++++-----
 fs/ext4/fsync.c     |    2 +-
 fs/ext4/inode.c     |  192 +++++++++++++++++++++++++++++++++-----------------
 fs/ext4/super.c     |   32 +++++++--
 6 files changed, 217 insertions(+), 97 deletions(-)

