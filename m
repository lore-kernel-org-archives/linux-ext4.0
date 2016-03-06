From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 5/6] findsuper: improve output if s_mkfs_time unset
Date: Sat,  5 Mar 2016 17:38:35 -0700
Message-ID: <1457224716-72388-5-git-send-email-adilger@dilger.ca>
References: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:33820 "EHLO
	smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcCFAqd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Mar 2016 19:46:33 -0500
In-Reply-To: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If s_mkfs_time is not set in the superblock, print the s_mtime field
instead to identify the different superblocks.  This can happen if the
superblock is corrupted, since s_mkfs_time is not reset by e2fsck.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/findsuper.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/misc/findsuper.c b/misc/findsuper.c
index eb9130b..b3b76cd 100644
--- a/misc/findsuper.c
+++ b/misc/findsuper.c
@@ -187,7 +187,7 @@ int main(int argc, char *argv[])
 	if (print_jnl_copies)
 		printf(_("[*] probably superblock written in the ext3 "
 			 "journal superblock,\n\tso start/end/grp wrong\n"));
-	printf(_("byte_offset  byte_start     byte_end  fs_blocks blksz  grp  last_mount_time           sb_uuid label\n"));
+	printf(_("byte_offset  byte_start     byte_end  fs_blocks blksz  grp  mkfs/mount_time           sb_uuid label\n"));
 	for (; lseek64(fd, sk, SEEK_SET) != -1 &&
 	       read(fd, &ext2, 512) == 512; sk += skiprate) {
 		static unsigned char last_uuid[16] = "blah";
@@ -230,7 +230,10 @@ int main(int argc, char *argv[])
 			WHY("free_inodes_count > inodes_count (%u > %u)\n",
 			    ext2.s_free_inodes_count, ext2.s_inodes_count);
 
-		tm = ext2.s_mtime;
+		if (ext2.s_mkfs_time != 0)
+			tm = ext2.s_mkfs_time;
+		else
+			tm = ext2.s_mtime;
 		s = ctime(&tm);
 		s[24] = 0;
 		bsize = 1 << (ext2.s_log_block_size + 10);
-- 
1.8.0

