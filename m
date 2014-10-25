From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/39] mke2fs: don't zero inode table blocks that are
 already zeroed
Date: Sat, 25 Oct 2014 13:57:53 -0700
Message-ID: <20141025205753.532.92273.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43928 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaJYU6R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:58:17 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At mke2fs time, if we discard the device and discard zeroes data,
don't bother zeroing the inode table blocks a second time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mke2fs.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a7bd35a..c6a2c2f 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -421,12 +421,14 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
 			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_ZEROED);
 			ext2fs_group_desc_csum_set(fs, i);
 		}
-		retval = ext2fs_zero_blocks2(fs, blk, num, &blk, &num);
-		if (retval) {
-			fprintf(stderr, _("\nCould not write %d "
-				  "blocks in inode table starting at %llu: %s\n"),
-				num, blk, error_message(retval));
-			exit(1);
+		if (!itable_zeroed) {
+			retval = ext2fs_zero_blocks2(fs, blk, num, &blk, &num);
+			if (retval) {
+				fprintf(stderr, _("\nCould not write %d "
+					  "blocks in inode table starting at %llu: %s\n"),
+					num, blk, error_message(retval));
+				exit(1);
+			}
 		}
 		if (sync_kludge) {
 			if (sync_kludge == 1)

