From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/6 v3] Lazy itable initialization for Ext4
Date: Wed, 15 Sep 2010 18:36:02 +0200
Message-ID: <1284568568-13637-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, rwheeler@redhat.com, sandeen@redhat.com,
	adilger@dilger.ca, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab0IOQgW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Sep 2010 12:36:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

not much has changed since my last post. Some small cleanup and adjustments
proposed by Andreas. There are two noticeable changes though:

 * you can now mount with inititable=n option, where n is a number which
   be used as wait multiplier for thread scheduling purposes (see patch #3).

 * introduced sysfs interface for advertising features like lazy itable
   initialization, to user space (see patch #6)

Thanks for review!

-Lukas

---
 [PATCH 1/6] Add helper function for blkdev_issue_zeroout
 [PATCH 2/6] Add inititable/noinititable mount options for ext4
 [PATCH 3/6] Add inode table initialization code for Ext4
 [PATCH 4/6] Use sb_issue_zeroout in setup_new_group_blocks
 [PATCH 5/6] Use sb_issue_discard in ext4_ext_zeroout
 [PATCH 6/6] Add interface to advertise ext4 features in sysfs

 fs/ext4/ext4.h         |   44 +++++
 fs/ext4/extents.c      |   68 +------
 fs/ext4/ialloc.c       |  116 ++++++++++++
 fs/ext4/resize.c       |   44 +----
 fs/ext4/super.c        |  490 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blkdev.h |    8 +
 6 files changed, 671 insertions(+), 99 deletions(-)
