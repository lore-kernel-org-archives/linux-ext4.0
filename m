From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Ext4: wait for log to commit when putting super
Date: Mon, 7 Dec 2009 15:09:25 -0500
Message-ID: <20091207200924.GB8558@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758849AbZLGUJT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Dec 2009 15:09:19 -0500
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nB7K9Q8W021102
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 15:09:26 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is a problem where a transaction will be committing while we're unmounting
the filesystem and you will get a panic because EXT4_SB(sb)->s_group_info has
been kfree'ed in ext4_put_super.  The commit code does the callback for the
mballoc stuff to release free'ed blocks in the transaction and panic's trying to
access s_group_info.  The fix is to wait for the transaction to finish
committing before we start cleaning up the mballoc stuff.  This patch hasn't
been tested yet, but its an obvious fix.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/ext4/super.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d4ca92a..ddd115f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -593,6 +593,7 @@ static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
+	tid_t target;
 	int i, err;
 
 	flush_workqueue(sbi->dio_unwritten_wq);
@@ -603,6 +604,9 @@ static void ext4_put_super(struct super_block *sb)
 	if (sb->s_dirt)
 		ext4_commit_super(sb, 1);
 
+	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target))
+		jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
+
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
-- 
1.6.2.5

