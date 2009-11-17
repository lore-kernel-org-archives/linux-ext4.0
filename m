From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2 V2] ext4: make trim/discard optional (and off by default)
Date: Tue, 17 Nov 2009 10:54:15 -0600
Message-ID: <4B02D537.8000103@redhat.com>
References: <4B01D5B5.7090302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbZKQQyO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Nov 2009 11:54:14 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAHGsKBN018699
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 11:54:20 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id nAHGsFDp025253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 11:54:19 -0500
In-Reply-To: <4B01D5B5.7090302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It is anticipated that when sb_issue_discard starts doing
real work on trim-capable devices, we may see issues.  Make
this mount-time optional, and default it to off until we know
that things are working out OK.

V2: rename "trim" to "discard" to match btrfs & gfs2

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 6d94e06..26904ff 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -353,6 +353,12 @@ noauto_da_alloc		replacing existing files via patterns such as
 			system crashes before the delayed allocation
 			blocks are forced to disk.
 
+discard		Controls whether ext4 should issue discard/TRIM
+nodiscard(*)		commands to the underlying block device when
+			blocks are freed.  This is useful for SSD devices
+			and sparse/thinly-provisioned LUNs, but it is off
+			by default until sufficient testing has been done.
+
 Data Mode
 =========
 There are 3 different data modes:
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8825515..05ce38b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -750,6 +750,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
 #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
+#define EXT4_MOUNT_DISCARD		0x40000000 /* Issue DISCARD requests */
 
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
 #define set_opt(o, opt)			o |= EXT4_MOUNT_##opt
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index bba1282..6e5a23a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2529,7 +2529,6 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 	struct ext4_group_info *db;
 	int err, count = 0, count2 = 0;
 	struct ext4_free_data *entry;
-	ext4_fsblk_t discard_block;
 	struct list_head *l, *ltmp;
 
 	list_for_each_safe(l, ltmp, &txn->t_private_list) {
@@ -2559,13 +2558,19 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 			page_cache_release(e4b.bd_bitmap_page);
 		}
 		ext4_unlock_group(sb, entry->group);
-		discard_block = (ext4_fsblk_t) entry->group * EXT4_BLOCKS_PER_GROUP(sb)
-			+ entry->start_blk
-			+ le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
-		trace_ext4_discard_blocks(sb, (unsigned long long)discard_block,
-					  entry->count);
-		sb_issue_discard(sb, discard_block, entry->count);
-
+		if (test_opt(sb, DISCARD)) {
+			ext4_fsblk_t discard_block;
+			struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+
+			discard_block = (ext4_fsblk_t)entry->group *
+						EXT4_BLOCKS_PER_GROUP(sb)
+					+ entry->start_blk
+					+ le32_to_cpu(es->s_first_data_block);
+			trace_ext4_discard_blocks(sb,
+					(unsigned long long)discard_block,
+					entry->count);
+			sb_issue_discard(sb, discard_block, entry->count);
+		}
 		kmem_cache_free(ext4_free_ext_cachep, entry);
 		ext4_mb_release_desc(&e4b);
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d4ca92a..b9638d9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -899,6 +899,9 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (test_opt(sb, NO_AUTO_DA_ALLOC))
 		seq_puts(seq, ",noauto_da_alloc");
 
+	if (test_opt(sb, DISCARD))
+		seq_puts(seq, ",discard");
+
 	ext4_show_quota_options(seq, sb);
 
 	return 0;
@@ -1079,7 +1082,8 @@ enum {
 	Opt_usrquota, Opt_grpquota, Opt_i_version,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc,
 	Opt_block_validity, Opt_noblock_validity,
-	Opt_inode_readahead_blks, Opt_journal_ioprio
+	Opt_inode_readahead_blks, Opt_journal_ioprio,
+	Opt_discard, Opt_nodiscard,
 };
 
 static const match_table_t tokens = {
@@ -1144,6 +1148,8 @@ static const match_table_t tokens = {
 	{Opt_auto_da_alloc, "auto_da_alloc=%u"},
 	{Opt_auto_da_alloc, "auto_da_alloc"},
 	{Opt_noauto_da_alloc, "noauto_da_alloc"},
+	{Opt_discard, "discard"},
+	{Opt_nodiscard, "nodiscard"},
 	{Opt_err, NULL},
 };
 
@@ -1565,6 +1571,12 @@ set_qf_format:
 			else
 				set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
 			break;
+		case Opt_discard:
+			set_opt(sbi->s_mount_opt, DISCARD);
+			break;
+		case Opt_nodiscard:
+			clear_opt(sbi->s_mount_opt, DISCARD);
+			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "

