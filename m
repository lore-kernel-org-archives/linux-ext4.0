From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/3] Clean up bitmap loading
Date: Fri, 13 Jan 2012 16:30:46 -0500
Message-ID: <1326490249-1685-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42561 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759230Ab2AMVa4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jan 2012 16:30:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The code to load the block and inode bitmaps was a wretched hive of scum
and villany.... the code to handle uninitialized bitmap violated the
ext4 journal write protocols, which meant it was possible for file
system corruptions if the file system crashed at exactly the wrong time.
In addition there was a race that could cause blocks or inodes to be
doubly allocated if two processes race against each other while trying
to load an uninitialized bitmap block.

Finally, it was hard to understand the code because it was badly
structured, and the with the block bitmap uninit code duplicated in
three different places, one unnecessary, and not all of the completely
identical.  Fixing this means we can trim a cool 100 lines from the ext4
sources.

Theodore Ts'o (3):
  ext4: remove block bitmap initialization in ext4_new_inode()
  ext4: fold ext4_claim_inode into ext4_new_inode
  ext4: fix race when setting bitmap_uptdate flag

 fs/ext4/balloc.c  |   59 ++++++++----
 fs/ext4/ext4.h    |   11 ++-
 fs/ext4/ialloc.c  |  256 ++++++++++++++++++----------------------------------
 fs/ext4/mballoc.c |   79 +++-------------
 4 files changed, 153 insertions(+), 252 deletions(-)

-- 
1.7.8.11.gefc1f.dirty

