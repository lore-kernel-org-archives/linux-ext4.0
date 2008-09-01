From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: [PATCH] ext4: update flex bg counters when resizing
Date: Mon, 01 Sep 2008 16:02:18 +0200
Message-ID: <1220277738.3569.10.camel@frecb007923.frec.bull.fr>
References: <1219934280.3591.121.camel@frecb007923.frec.bull.fr>
	 <20080828171156.GK26987@mit.edu>  <20080828173652.GL26987@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	"; linux-ext4" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59494 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYIAMAQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Sep 2008 08:00:16 -0400
In-Reply-To: <20080828173652.GL26987@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frederic Bohe <frederic.bohe@bull.net>

Update flex_bg free blocks and free inodes counters when resizing.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
---
This patch fixes a bug which prevents to use the newly created inodes after a resize with flex bg.
I am not sure if it is really usefull to update free blocks too, but it is definitely cleaner code.

 resize.c |    9 +++++++++
 super.c  |    7 +++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6.27-rc5+patch_queue/fs/ext4/resize.c
===================================================================
--- linux-2.6.27-rc5+patch_queue.orig/fs/ext4/resize.c	2008-09-01 11:23:09.000000000 +0200
+++ linux-2.6.27-rc5+patch_queue/fs/ext4/resize.c	2008-09-01 13:16:03.000000000 +0200
@@ -929,6 +929,15 @@ int ext4_group_add(struct super_block *s
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb));
 
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		ext4_group_t flex_group;
+		flex_group = ext4_flex_group(sbi, input->group);
+		sbi->s_flex_groups[flex_group].free_blocks +=
+			input->free_blocks_count;
+		sbi->s_flex_groups[flex_group].free_inodes +=
+			EXT4_INODES_PER_GROUP(sb);
+	}
+
 	ext4_journal_dirty_metadata(handle, sbi->s_sbh);
 	sb->s_dirt = 1;
 
Index: linux-2.6.27-rc5+patch_queue/fs/ext4/super.c
===================================================================
--- linux-2.6.27-rc5+patch_queue.orig/fs/ext4/super.c	2008-09-01 12:38:03.000000000 +0200
+++ linux-2.6.27-rc5+patch_queue/fs/ext4/super.c	2008-09-01 13:29:39.000000000 +0200
@@ -1507,8 +1507,11 @@ static int ext4_fill_flex_info(struct su
 	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
 	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
 
-	flex_group_count = (sbi->s_groups_count + groups_per_flex - 1) /
-		groups_per_flex;
+	/* We allocate both existing and potentially added groups */
+	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
+			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
+			      EXT4_DESC_PER_BLOCK_BITS(sb))) /
+			   groups_per_flex;
 	sbi->s_flex_groups = kzalloc(flex_group_count *
 				     sizeof(struct flex_groups), GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {

--

