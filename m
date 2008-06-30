From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Don't allow nonextenst mount option for large file system.
Date: Mon, 30 Jun 2008 22:22:55 +0530
Message-ID: <1214844775-14881-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:46573 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752072AbYF3QxU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jun 2008 12:53:20 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5UGqwxQ011131
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jun 2008 22:22:58 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5UGqbWH1491034
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jun 2008 22:22:37 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5UGqvni001708
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jun 2008 22:22:57 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The block mapped inode format can address only blocks within
2**32. So with file system larger than 2**32 don't allow
noextents mount option.  There are multiple issues that need
to addressed in the long run.

a) When e2fsprogs support resizing an already existing  ext3
file system to greater than 2**32 we need to add support to block
allocator to handle growing already existing block  mapped inode
so that blocks allocated for them fall within 2**32

b) When we do that we should enable mounting  larger file system
with -o noextents mount option.

Till them we fail mount of large file systems with -o noextents.


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e104dd..2bf9cdd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1004,6 +1004,7 @@ static int parse_options (char *options, struct super_block *sb,
 	int qtype, qfmt;
 	char *qname;
 #endif
+	ext4_fsblk_t last_block;
 
 	if (!options)
 		return 1;
@@ -1326,6 +1327,20 @@ static int parse_options (char *options, struct super_block *sb,
 			set_opt (sbi->s_mount_opt, EXTENTS);
 			break;
 		case Opt_noextents:
+			/*
+			 * When e2fsprogs support resizing an already existing
+			 * ext3 file system to greater than 2**32 we need to
+			 * add support to block allocator to handle growing
+			 * already existing block  mapped inode so that blocks
+			 * allocated for them fall within 2**32
+			 */
+			last_block = ext4_blocks_count(sbi->s_es) - 1;
+			if (last_block  > 0xffffffffULL) {
+				printk(KERN_ERR "EXT4-fs: Filesystem too "
+						"large to mount with "
+						"-o noextents options\n");
+				return 0;
+			}
 			clear_opt (sbi->s_mount_opt, EXTENTS);
 			break;
 		case Opt_i_version:
-- 
1.5.6.1.102.g8e69d.dirty

