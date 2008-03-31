From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] debugfs: Add support for "set_block_group <bg_num> checksum calc"
Date: Mon, 31 Mar 2008 19:36:24 -0400
Message-ID: <1207006592-13980-3-git-send-email-tytso@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int>
 <1207006592-13980-1-git-send-email-tytso@mit.edu>
 <1207006592-13980-2-git-send-email-tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61558 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbYCaXjb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:39:31 -0400
In-Reply-To: <1207006592-13980-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andreas Dilger <adilger@dilger.ca>

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/set_fields.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index a58c94e..ee51c45 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -42,6 +42,7 @@
 static struct ext2_super_block set_sb;
 static struct ext2_inode set_inode;
 static struct ext2_group_desc set_gd;
+static dgrp_t set_bg;
 static ext2_ino_t set_ino;
 static int array_idx;
 
@@ -63,6 +64,7 @@ static errcode_t parse_uuid(struct field_set_info *info, char *arg);
 static errcode_t parse_hashalg(struct field_set_info *info, char *arg);
 static errcode_t parse_time(struct field_set_info *info, char *arg);
 static errcode_t parse_bmap(struct field_set_info *info, char *arg);
+static errcode_t parse_gd_csum(struct field_set_info *info, char *arg);
 
 static struct field_set_info super_fields[] = {
 	{ "inodes_count", &set_sb.s_inodes_count, 4, parse_uint },
@@ -178,7 +180,7 @@ static struct field_set_info ext2_bg_fields[] = {
 	{ "flags", &set_gd.bg_flags, 2, parse_uint },
 	{ "reserved", &set_gd.bg_reserved, 2, parse_uint, FLAG_ARRAY, 2 },
 	{ "itable_unused", &set_gd.bg_itable_unused, 2, parse_uint },
-	{ "checksum", &set_gd.bg_checksum, 2, parse_uint },
+	{ "checksum", &set_gd.bg_checksum, 2, parse_gd_csum },
 	{ 0, 0, 0, 0 }
 };
 
@@ -402,6 +404,19 @@ static errcode_t parse_bmap(struct field_set_info *info, char *arg)
 	return retval;
 }
 
+static errcode_t parse_gd_csum(struct field_set_info *info, char *arg)
+{
+
+	if (strcmp(arg, "calc") == 0) {
+		ext2fs_group_desc_csum_set(current_fs, set_bg);
+		set_gd = current_fs->group_desc[set_bg];
+		printf("Checksum set to 0x%04x\n", 
+		       current_fs->group_desc[set_bg].bg_checksum);
+		return 0;
+	}
+
+	return parse_uint(info, arg);
+}
 
 static void print_possible_fields(struct field_set_info *fields)
 {
@@ -521,7 +536,6 @@ void do_set_block_group_descriptor(int argc, char *argv[])
 		"\t\"set_block_group_descriptor -l\" will list the names of "
 		"the fields in a block group descriptor\n\twhich can be set.";
 	struct field_set_info	*ss;
-	dgrp_t			set_bg;
 	char			*end;
 
 	if ((argc == 2) && !strcmp(argv[1], "-l")) {
-- 
1.5.4.1.144.gdfee-dirty

