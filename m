From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 4/4] ext4: remove unnecessary NULL pointer check
Date: Fri, 18 Jan 2013 16:01:14 +0800
Message-ID: <1358496074-6228-4-git-send-email-yan@linux.vnet.ibm.com>
References: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55367 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3ARIBZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jan 2013 03:01:25 -0500
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Fri, 18 Jan 2013 17:55:18 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id C04FB2CE804D
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 19:01:19 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r0I7ndSV36765852
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 18:49:39 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r0I81JYo032024
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jan 2013 19:01:19 +1100
In-Reply-To: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

brelse() and ext4_journal_force_commit() are both inlined and able
to handle NULL.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/ext4/namei.c |    3 +--
 fs/ext4/super.c |    6 +-----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index e35ea3d..f0812c0 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2110,8 +2110,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 journal_error:
 	ext4_std_error(dir->i_sb, err);
 cleanup:
-	if (bh)
-		brelse(bh);
+	brelse(bh);
 	dx_release(frames);
 	return err;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3d4fb81..f3acd6f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4476,16 +4476,12 @@ static void ext4_clear_journal_err(struct super_block *sb,
 int ext4_force_commit(struct super_block *sb)
 {
 	journal_t *journal;
-	int ret = 0;
 
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
 	journal = EXT4_SB(sb)->s_journal;
-	if (journal)
-		ret = ext4_journal_force_commit(journal);
