From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/5 v2] e2fsprogs: allow meta_bg/64-bit file systems to be online resized
Date: Thu, 13 Sep 2012 18:49:15 -0400
Message-ID: <1347576560-5820-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50578 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab2IMW4P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 18:56:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch series enhances resize2fs to allow it to support online
resizing of meta_bg and/or 64-bit file systems.   This was mainly be
fixing the sanity checks which previously wouldn't allow the online
resizing ioctl to be invoked since the userspace resize2fs program
thought the kernel would not support file system parameters.

In addition, the last patch in this series significantly speeds up
off-line resizing of ext4 file systems where the uninit_bg feature is
enabled, by skipping the write out of the inode table.

Theodore Ts'o (5):
  resize2fs: enforce the 16TB limit on 32-bit file systems correctly
  resize2fs: fix overhead calculation for meta_bg file systems
  resize2fs: allow meta_bg/64-bit file systems to be online resized
  resize2fs: enforce restrictions if the kernel doesn't do meta_bg
    resizing
  resize2fs: grow uninit_bg file systems more efficiently

 resize/main.c      | 67 ++++++++++++++++++++++---------------
 resize/online.c    | 41 +++++++++++++++--------
 resize/resize2fs.c | 96 ++++++++++++++++++++++++++++++++++--------------------
 resize/resize2fs.h |  5 +++
 4 files changed, 134 insertions(+), 75 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b

