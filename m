From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/4] e2fsprogs: Tidy up mmp handling in debugfs
Date: Thu, 10 Nov 2011 16:53:22 -0600
Message-ID: <4EBC55E2.3080600@redhat.com>
References: <4EBC5524.3000105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081Ab1KJWxY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Nov 2011 17:53:24 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAAMrOBi014247
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2011 17:53:24 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id pAAMrNkO010278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2011 17:53:24 -0500
In-Reply-To: <4EBC5524.3000105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Several small fixes:

* Gracefully fail mmp commands if fs is not open
* Show magic number in dump_mmp command
* Fix header in output for set_mmp_value -l

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index eba3b69..1fb8f44 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2165,11 +2165,15 @@ void do_punch(int argc, char *argv[])
 
 void do_dump_mmp(int argc, char *argv[])
 {
-	struct ext2_super_block *sb = current_fs->super;
+	struct ext2_super_block *sb;
 	struct mmp_struct *mmp_s;
 	time_t t;
 	errcode_t retval = 0;
 
+	if (check_fs_open(argv[0]))
+		return;
+
+	sb  = current_fs->super;
 	if (sb->s_mmp_block <= sb->s_first_data_block ||
 	    sb->s_mmp_block >= ext2fs_blocks_count(sb)) {
 		com_err(argv[0], EXT2_ET_MMP_BAD_BLOCK, "while dumping it.\n");
@@ -2203,6 +2207,7 @@ void do_dump_mmp(int argc, char *argv[])
 	fprintf(stdout, "time: %lld -- %s", mmp_s->mmp_time, ctime(&t));
 	fprintf(stdout, "node_name: %s\n", mmp_s->mmp_nodename);
 	fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
+	fprintf(stdout, "magic: 0x%x\n", mmp_s->mmp_magic);
 }
 
 static int source_file(const char *cmd_file, int sci_idx)
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index d461275..0041160 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -242,6 +242,9 @@ static struct field_set_info ext4_bg_fields[] = {
 	{ 0, 0, 0, 0 }
 };
 
+/* forward declaration */
+static struct field_set_info mmp_fields[];
+
 static int check_suffix(const char *field)
 {
 	int len = strlen(field);
@@ -561,6 +564,9 @@ static void print_possible_fields(struct field_set_info *fields)
 	} else if (fields == inode_fields) {
 		type = "Inode";
 		cmd = "set_inode";
+	} else if (fields == mmp_fields) {
+		type = "MMP";
+		cmd = "set_mmp_value";
 	} else {
 		type = "Block group descriptor";
 		cmd = "set_block_group";
@@ -768,6 +774,9 @@ void do_set_mmp_value(int argc, char *argv[])
 		return;
 	}
 
+	if (check_fs_open(argv[0]))
+		return;
+
 	if (current_fs->super->s_mmp_block == 0) {
 		com_err(argv[0], 0, "no MMP block allocated\n");
 		return;


