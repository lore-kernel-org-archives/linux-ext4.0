From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 09/14] Make debugfs uninit block group aware.
Date: Sun, 21 Oct 2007 21:03:57 -0500
Message-ID: <20071022020357.23849.68075.stgit@toolssf2>
References: <20071022020308.23849.98773.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:43609 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbXJVCHX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2007 22:07:23 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9M27NuJ018240
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 22:07:23 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9M27M3J072868
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:22 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9M27M8f017805
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:22 -0600
Received: from [127.0.0.1] (toolssf2.ltc.austin.ibm.com [9.3.190.66])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9M27Mxk017801
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:22 -0600
In-Reply-To: <20071022020308.23849.98773.stgit@toolssf2>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Make debugfs uninit block group aware.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-Off-By: Andreas Dilger <adilger@clusterfs.com>
--

 debugfs/debugfs.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 190c4b7..c802b63 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -286,7 +286,10 @@ void do_show_super_stats(int argc, char *argv[])
 	FILE 	*out;
 	struct ext2_group_desc *gdp;
 	int	c, header_only = 0;
-	int	numdirs = 0, first;
+	int	numdirs = 0, first, gdt_csum;
+
+	gdt_csum = EXT2_HAS_RO_COMPAT_FEATURE(current_fs->super,
+					      EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 
 	reset_getopt();
 	while ((c = getopt (argc, argv, "h")) != EOF) {
@@ -322,7 +325,7 @@ void do_show_super_stats(int argc, char *argv[])
 		        "inode table at %u\n"
 		        "           %d free %s, "
 		        "%d free %s, "
-		        "%d used %s\n",
+		        "%d used %s%s",
 		        i, gdp->bg_block_bitmap,
 		        gdp->bg_inode_bitmap, gdp->bg_inode_table,
 		        gdp->bg_free_blocks_count,
@@ -331,12 +334,21 @@ void do_show_super_stats(int argc, char *argv[])
 		        gdp->bg_free_inodes_count != 1 ? "inodes" : "inode",
 		        gdp->bg_used_dirs_count,
 		        gdp->bg_used_dirs_count != 1 ? "directories"
-				: "directory");
+				: "directory", gdt_csum ? ", " : "\n");
+		if (gdt_csum)
+			fprintf(out, "%d unused %s\n",
+				gdp->bg_itable_unused,
+				gdp->bg_itable_unused != 1 ? "inodes":"inode");
 		first = 1;
 		print_bg_opts(gdp, EXT2_BG_INODE_UNINIT, "Inode not init",
 			      &first, out);
 		print_bg_opts(gdp, EXT2_BG_BLOCK_UNINIT, "Block not init",
 			      &first, out);
+		if (gdt_csum) {
+			fprintf(out, "%sChecksum 0x%04x",
+				first ? "           [":", ", gdp->bg_checksum);
+			first = 0;
+		}
 		if (!first)
 			fputs("]\n", out);
 	}
