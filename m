From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/2 -v2] Clean up bitmap loading
Date: Mon,  6 Feb 2012 14:54:42 -0500
Message-ID: <1328558084-19430-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34463 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab2BFTyz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Feb 2012 14:54:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As it turns out we can't remove the forced initialization of the block
bitmap when initializing the inode bitmap; e2fsck will complain because
it explicitly checks for this condition.  Thanks to Rakish Iyer at
Google for finding this through his testing effort (debugging sucks;
testing rocks!) and Curt Wohlgemuth for his analysis of the test failure
and finding its cause.

I've removed the first patch that was in the previous version of this
patch series for now, and will be patching e2fsprogs to eliminate this
check.  Since we can't guarantee that people will be running a
sufficiently new version of e2fsprogs, we'll probably have to keep the
block bitmap initialization in the upstream kernel for at least a year
or two.

Theodore Ts'o (2):
  ext4: fold ext4_claim_inode into ext4_new_inode
  ext4: fix race when setting bitmap_uptodate flag

 fs/ext4/balloc.c  |   59 +++++++++----
 fs/ext4/ext4.h    |   11 ++-
 fs/ext4/ialloc.c  |  238 ++++++++++++++++++++++-------------------------------
 fs/ext4/mballoc.c |   79 ++++--------------
 4 files changed, 161 insertions(+), 226 deletions(-)

-- 
1.7.9.107.g8e04a

