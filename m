From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/7] e2fsprogs: Using discard in e2fsprogs tools
Date: Tue, 26 Oct 2010 19:54:11 +0200
Message-ID: <1288115658-7004-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, adilger@dilger.ca,
	lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0JZRyb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Oct 2010 13:54:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

We have came to consensus about using discard in e2fsprogs tools. These
patches generalize use of discard in e2fsprogs tools introduce changes
in mke2fs and e2fsck.

Short summary
-------------

 [PATCH 1/7] e2fsprogs: Add discard function into struct_io_manager
   * generalize use of discard in e2fsprogs and let any tool in e2fsprogs
     take advantage of it withou need to write its own BLKDISCARD wrappers.

 [PATCH 2/7] e2fsprogs: Add discard_zeroes_data into struct_io_manager
   * Give the opportunity for any io_manager to check if device discard
     support zeroes data and save the results into io_manager itself for
     use in any e2fsprofs tool.

 [PATCH 3/7] e2fsck: Keep track of problems during the check

 [PATCH 4/7] e2fsck: Discard free data and inode blocks.
   * In pass 5 after the group descriptors has been changed discard free
     data and inode blocks. The consensus was that it should be OFF by
     default, so it is.
   * Introduce new paid of extended options discard/nodiscard.

 [PATCH 5/7] mke2fs: Change -K option to discard/nodiscard
   * To the same of consistency and to gain ability to easily default it
     the new pair of extended options has been added.
   * The consensus was that it should stay ON by default, so it is.

 [PATCH 6/7] mke2fs: Use unix_discard() for discards

 [PATCH 7/7] mke2fs: Use io_manager discard_zeroes_data property


Any comments appreciated!

Thanks!

-Lukas

---
[PATCH 1/7] e2fsprogs: Add discard function into struct_io_manager
[PATCH 2/7] e2fsprogs: Add discard_zeroes_data into struct_io_manager
[PATCH 3/7] e2fsck: Keep track of problems during the check
[PATCH 4/7] e2fsck: Discard free data and inode blocks.
[PATCH 5/7] mke2fs: Change -K option to discard/nodiscard
[PATCH 6/7] mke2fs: Use unix_discard() for discards
[PATCH 7/7] mke2fs: Use io_manager discard_zeroes_data property

 e2fsck/e2fsck.8.in   |   14 ++++++++
 e2fsck/e2fsck.h      |    2 +
 e2fsck/pass5.c       |   81 +++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/problem.c     |   31 ++++++++++++-----
 e2fsck/problem.h     |    3 ++
 e2fsck/problemP.h    |    1 +
 e2fsck/unix.c        |   10 +++++-
 lib/ext2fs/ext2_io.h |    3 ++
 lib/ext2fs/test_io.c |    1 +
 lib/ext2fs/unix_io.c |   53 +++++++++++++++++++++++++++++
 misc/mke2fs.8.in     |   18 ++++++----
 misc/mke2fs.c        |   90 +++++++++++--------------------------------------
 12 files changed, 219 insertions(+), 88 deletions(-)

