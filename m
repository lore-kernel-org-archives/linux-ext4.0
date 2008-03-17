From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, REWORKED 08/11] Make debugfs uninit block group aware
Date: Mon, 17 Mar 2008 09:28:44 -0400
Message-ID: <1205760527-14858-9-git-send-email-tytso@mit.edu>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu>
 <1205760527-14858-2-git-send-email-tytso@mit.edu>
 <1205760527-14858-3-git-send-email-tytso@mit.edu>
 <1205760527-14858-4-git-send-email-tytso@mit.edu>
 <1205760527-14858-5-git-send-email-tytso@mit.edu>
 <1205760527-14858-6-git-send-email-tytso@mit.edu>
 <1205760527-14858-7-git-send-email-tytso@mit.edu>
 <1205760527-14858-8-git-send-email-tytso@mit.edu>
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60382 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753001AbYCQN3F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 09:29:05 -0400
In-Reply-To: <1205760527-14858-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/debugfs.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index c4da2a2..1a4471f 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -288,7 +288,10 @@ void do_show_super_stats(int argc, char *argv[])
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
@@ -324,7 +327,7 @@ void do_show_super_stats(int argc, char *argv[])
 		        "inode table at %u\n"
 		        "           %d free %s, "
 		        "%d free %s, "
-		        "%d used %s\n",
+		        "%d used %s%s",
 		        i, gdp->bg_block_bitmap,
 		        gdp->bg_inode_bitmap, gdp->bg_inode_table,
 		        gdp->bg_free_blocks_count,
@@ -333,12 +336,21 @@ void do_show_super_stats(int argc, char *argv[])
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
-- 
1.5.4.1.144.gdfee-dirty

