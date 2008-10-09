From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 41/42] ext4: Avoid double dirtying of super block in ext4_put_super()
Date: Thu,  9 Oct 2008 00:05:59 -0400
Message-ID: <1223525160-9887-42-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
 <1223525160-9887-8-git-send-email-tytso@mit.edu>
 <1223525160-9887-9-git-send-email-tytso@mit.edu>
 <1223525160-9887-10-git-send-email-tytso@mit.edu>
 <1223525160-9887-11-git-send-email-tytso@mit.edu>
 <1223525160-9887-12-git-send-email-tytso@mit.edu>
 <1223525160-9887-13-git-send-email-tytso@mit.edu>
 <1223525160-9887-14-git-send-email-tytso@mit.edu>
 <1223525160-9887-15-git-send-email-tytso@mit.edu>
 <1223525160-9887-16-git-send-email-tytso@mit.edu>
 <1223525160-9887-17-git-send-email-tytso@mit.edu>
 <1223525160-9887-18-git-send-email-tytso@mit.edu>
 <1223525160-9887-19-git-send-email-tytso@mit.edu>
 <1223525160-9887-20-git-send-email-tytso@mit.edu>
 <1223525160-9887-21-git-send-email-tytso@mit.edu>
 <1223525160-9887-22-git-send-email-tytso@mit.edu>
 <1223525160-9887-23-git-send-email-tytso@mit.edu>
 <1223525160-9887-24-git-send-email-tytso@mit.edu>
 <1223525160-9887-25-git-send-email-tytso@mit.edu>
 <1223525160-9887-26-git-send-email-tytso@mit.edu>
 <1223525160-9887-27-git-send-email-tytso@mit.edu>
 <1223525160-9887-28-git-send-email-tytso@mit.edu>
 <1223525160-9887-29-git-send-email-tytso@mit.edu>
 <1223525160-9887-30-git-send-email-tytso@mit.edu>
 <1223525160-9887-31-git-send-email-tytso@mit.edu>
 <1223525160-9887-32-git-send-email-tytso@mit.edu>
 <1223525160-9887-33-git-send-email-tytso@mit.edu>
 <1223525160-9887-34-git-send-email-tytso@mit.edu>
 <1223525160-9887-35-git-send-email-tytso@mit.edu>
 <1223525160-9887-36-git-send-email-tytso@mit.edu>
 <1223525160-9887-37-git-send-email-tytso@mit.edu>
 <1223525160-9887-38-git-send-email-tytso@mit.edu>
 <1223525160-9887-39-git-send-email-tytso@mit.edu>
 <1223525160-9887-40-git-send-email-tytso@mit.edu>
 <1223525160-9887-41-git-send-email-tytso@mit.edu>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54545 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757630AbYJIEGP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:15 -0400
In-Reply-To: <1223525160-9887-41-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andi Kleen <andi@firstfloor.org>

While reading code I noticed that ext4_put_super() dirties the
superblock bh twice. It is always done in ext4_commit_super()
too. Remove the redundant dirty operation.
Should be a nop semantically.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/ext4/super.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9c02146..7d86560 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -512,8 +512,6 @@ static void ext4_put_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
-		BUFFER_TRACE(sbi->s_sbh, "marking dirty");
-		mark_buffer_dirty(sbi->s_sbh);
 		ext4_commit_super(sb, es, 1);
 	}
 	if (sbi->s_proc) {
-- 
1.5.6.1.205.ge2c7.dirty

