From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/9 v3] meta_bg online resize patches
Date: Thu, 13 Sep 2012 18:49:07 -0400
Message-ID: <1347576556-5725-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50565 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab2IMWtT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 18:49:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here is an updated meta_bg online resize patches.  This set of patches
needs to be paired with a set of e2fsprogs patches to enable online
resize.  With this set of patches, we can start with a file system which
uses the resize_inode scheme of reserved gdt blocks, but after we have
consumed all of the reserved gdt blocks, the kernel will switch over to
using the meta_bg scheme of online growth.

This works both with traditional 32-bit filesystems as well newer 64-bit
file systems.  As an example of the sort of on-line resizes that will
work, my testing included:

*  mke2fs -t ext4 /dev/vdc 2M ; mount /dev/vdc; resize2fs /dev/vdc 8G
*  mke2fs -t ext2 /dev/vdc 2M ; mount /dev/vdc; resize2fs /dev/vdc 8G
*  mke2fs -t ext4 -O 64bit /dev/vdc 12T ; mount /dev/vdc; resize2fs /dev/vdc 18T

Theodore Ts'o (6):
  ext4: grow the s_flex_groups array as needed when resizing
  ext4: grow the s_group_info array as needed
  ext4: set bg_itable_unused when resizing
  ext4: convert file system to meta_bg if needed during resizing
  ext4: log a resize update to the console every 10 seconds
  ext4: advertise the fact that the kernel supports meta_bg resizing

Yongqiang Yang (3):
  ext4: don't copy non-existent gdt blocks when resizing
  ext4: avoid duplicate writes of the backup bg descriptor blocks
  ext4: add online resizing support for meta_bg and 64-bit file systems

 fs/ext4/ext4.h    |   6 +
 fs/ext4/ioctl.c   |  15 ---
 fs/ext4/mballoc.c |  79 ++++++-----
 fs/ext4/resize.c  | 386 +++++++++++++++++++++++++++++++++++++++++++++---------
 fs/ext4/super.c   |  50 +++++--
 5 files changed, 405 insertions(+), 131 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b

