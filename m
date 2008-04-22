From: Theodore Ts'o <tytso@mit.edu>
Subject: [E2FSPROGS, RFC] Basic flexible block group support
Date: Tue, 22 Apr 2008 08:46:18 -0400
Message-ID: <1208868379-17580-2-git-send-email-tytso@mit.edu>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, "Jose R. Santos" <jrs@us.ibm.com>,
	Valerie Clement <valerie.clement@bull.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40893 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753303AbYDVMqe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2008 08:46:34 -0400
In-Reply-To: <1208868379-17580-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add superblock definition, and dumpe2fs and debugfs support.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Valerie Clement <valerie.clement@bull.net>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 debugfs/set_fields.c |    1 +
 lib/e2p/ls.c         |    3 +++
 lib/ext2fs/ext2_fs.h |    5 ++++-
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index ee51c45..25343f0 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -132,6 +132,7 @@ static struct field_set_info super_fields[] = {
 	{ "mmp_interval", &set_sb.s_mmp_interval, 2, parse_uint },
 	{ "mmp_block", &set_sb.s_mmp_block, 8, parse_uint },
 	{ "raid_stripe_width", &set_sb.s_raid_stripe_width, 4, parse_uint },
+	{ "log_groups_per_flex", &set_sb.s_log_groups_per_flex, 1, parse_uint },
 	{ 0, 0, 0, 0 }
 };
 
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index b119606..c211dce 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -242,6 +242,9 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	if (sb->s_first_meta_bg)
 		fprintf(f, "First meta block group:   %u\n",
 			sb->s_first_meta_bg);
+	if (sb->s_log_groups_per_flex)
+		fprintf(f, "Flex block group size:    %u\n",
+			1 << sb->s_log_groups_per_flex);
 	if (sb->s_mkfs_time) {
 		tm = sb->s_mkfs_time;
 		fprintf(f, "Filesystem created:       %s", ctime(&tm));
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index ad42cf8..f23c8fd 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -564,7 +564,10 @@ struct ext2_super_block {
 	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
 	__u64   s_mmp_block;            /* Block for multi-mount protection */
 	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
-	__u32   s_reserved[163];        /* Padding to the end of the block */
+	__u8	s_log_groups_per_flex;	/* FLEX_BG group size */
+	__u8    s_reserved_char_pad;
+	__u16	s_reserved_pad;		/* Padding to next 32bits */
+	__u32   s_reserved[162];        /* Padding to the end of the block */
 };
 
 /*
-- 
1.5.4.1.144.gdfee-dirty

