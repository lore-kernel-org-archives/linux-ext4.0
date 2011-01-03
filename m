From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 25/32] ext4: convert to alloc_workqueue()
Date: Mon,  3 Jan 2011 14:49:48 +0100
Message-ID: <1294062595-30097-26-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab1ACNup (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jan 2011 08:50:45 -0500
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Convert create_workqueue() to alloc_workqueue().  This is an identity
conversion.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
It might be helpful to use higher max concurrency.  I don't think it
would make a lot of difference tho.  Please feel free to take it into
the subsystem tree or simply ack - I'll route it through the wq tree.

Thanks.

 fs/ext4/super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fb15c9c..f682c40 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3495,7 +3495,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	percpu_counter_set(&sbi->s_dirtyblocks_counter, 0);
 
 no_journal:
-	EXT4_SB(sb)->dio_unwritten_wq = create_workqueue("ext4-dio-unwritten");
+	/*
+	 * The maximum number of concurrent works can be high and
+	 * concurrency isn't really necessary.  Limit it to 1.
+	 */
+	EXT4_SB(sb)->dio_unwritten_wq =
+		alloc_workqueue("ext4-dio-unwritten", WQ_MEM_RECLAIM, 1);
 	if (!EXT4_SB(sb)->dio_unwritten_wq) {
 		printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
 		goto failed_mount_wq;
-- 
1.7.1

