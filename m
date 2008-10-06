From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] EXT4: Avoid double dirtying of super block in ext4_put_super()
Date: Mon, 6 Oct 2008 23:21:18 +0200
Message-ID: <20081006212118.GA382@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:37045 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYJFVVU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 17:21:20 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EXT4: Avoid double dirtying of super block in ext4_put_super()

While reading code I noticed that ext4_put_super() dirties the 
superblock bh twice. It is always done in ext4_commit_super()
too. Remove the redundant dirty operation.

Should be a nop semantically.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff -up linux-2.6.27-rc6-csum/fs/ext4/super.c-o linux-2.6.27-rc6-csum/fs/ext4/super.c
--- linux-2.6.27-rc6-csum/fs/ext4/super.c-o	2008-08-29 10:10:08.000000000 +0200
+++ linux-2.6.27-rc6-csum/fs/ext4/super.c	2008-10-06 11:24:31.000000000 +0200
@@ -508,8 +509,6 @@
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
-		BUFFER_TRACE(sbi->s_sbh, "marking dirty");
-		mark_buffer_dirty(sbi->s_sbh);
 		ext4_commit_super(sb, es, 1);
 	}
 
