From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/6 v2] e2fsprogs: Using discard in e2fsprogs tools
Date: Thu, 18 Nov 2010 14:38:35 +0100
Message-ID: <1290087521-9123-1-git-send-email-lczerner@redhat.com>
Cc: sandeen@redhat.com, adilger@dilger.ca, lczerner@redhat.com,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757826Ab0KRNiu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 08:38:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

We have came to consensus about using discard in e2fsprogs tools. These
patches generalize use of discard in e2fsprogs tools introduce changes
in mke2fs and e2fsck.

Short summary
-------------

 [PATCH 1/6] e2fsprogs: Add discard function into struct_io_manager
   * generalize use of discard in e2fsprogs and let any tool in e2fsprogs
     take advantage of it withou need to write its own BLKDISCARD wrappers.

 [PATCH 2/6] e2fsprogs: Add CHANNEL_FLAGS_DISCARD_ZEROES flag for io_manager
   * Give the opportunity for any io_manager to check if device discard
     support zeroes data and save the results into io_channel for use in
     any e2fsprofs tool.

 [PATCH 3/6] e2fsck: Discard free data and inode blocks.
   * In pass 5 after the group descriptors has been changed discard free
     data and inode blocks. The consensus was that it should be OFF by
     default, so it is.
   * Introduce new paid of extended options discard/nodiscard.

 [PATCH 4/6] mke2fs: Deprecate -K option, introduce discard/nodiscard
   * To the same of consistency and to gain ability to easily default it
     the new pair of extended options has been added.
   * The consensus was that it should stay ON by default, so it is.

 [PATCH 5/6] mke2fs: Use unix_discard() for discards

 [PATCH 6/6] mke2fs: Add discard option into mke2fs.conf

Any comments appreciated!

Thanks!

-Lukas

---
[PATCH 1/6] e2fsprogs: Add discard function into struct_io_manager
[PATCH 2/6] e2fsprogs: Add CHANNEL_FLAGS_DISCARD_ZEROES flag for io_manager
[PATCH 3/6] e2fsck: Discard free data and inode blocks.
[PATCH 4/6] mke2fs: Deprecate -K option, introduce discard/nodiscard
[PATCH 5/6] mke2fs: Use unix_discard() for discards
[PATCH 6/6] mke2fs: Add discard option into mke2fs.conf

 e2fsck/e2fsck.8.in    |   14 +++++++
 e2fsck/e2fsck.h       |    1 +
 e2fsck/pass5.c        |   96 ++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/unix.c         |   10 ++++-
 lib/ext2fs/ext2_io.h  |    5 ++
 lib/ext2fs/unix_io.c  |   45 ++++++++++++++++++++++-
 misc/mke2fs.8.in      |   18 +++++---
 misc/mke2fs.c         |   98 ++++++++++++++-----------------------------------
 misc/mke2fs.conf.5.in |    5 ++
 9 files changed, 213 insertions(+), 79 deletions(-)

