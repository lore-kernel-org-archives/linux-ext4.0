From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 08/13][e2fsprogs] Make debugfs uninit block group aware.
Date: Thu, 11 Oct 2007 14:16:48 -0500
Message-ID: <20071011191648.4599.80610.stgit@gara>
References: <20071011191559.4599.69332.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39730 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908AbXJKTQz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2007 15:16:55 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9BJGsBa024850
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:54 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9BJGsdt451890
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:54 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9BJGim9031298
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:44 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9BJGiSk030201
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:44 -0400
Received: from [127.0.1.1] (wecm-9-67-39-149.wecm.ibm.com [9.67.39.149])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l9BJGX9P040732
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 14:16:33 -0500
In-Reply-To: <20071011191559.4599.69332.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Make debugfs uninit block group aware.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
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
