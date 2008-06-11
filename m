From: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Subject: [PATCH] e2fsprogs: Dump extent/sindices using debugfs
Date: Wed, 11 Jun 2008 15:41:28 +0530
Message-ID: <1213179088.3298.12.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_EJr3YXaVAiT2fzVJD1wqfg)"
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:52055 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYFKKMs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2008 06:12:48 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m5BAD2Ac011900
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 10:13:07 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K2A00J01MRMUC00@mail-apac.sun.com>
 (original mail from Girish.Shilamkar@Sun.COM) for linux-ext4@vger.kernel.org;
 Wed, 11 Jun 2008 18:11:00 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_EJr3YXaVAiT2fzVJD1wqfg)
Content-type: text/plain
Content-transfer-encoding: 7BIT

Hi Ted,
	The attached patch adds a command to debugfs to display all the
extents/indices contained in an inode or the block specified.
	The options to the command includes tranversing and dumping the entire
extent tree (if inode specified) or the branch (in case of block) and
can display only the headers if required.

Would you please let me know your comments/suggestions ?

Thanks,
Girish

--Boundary_(ID_EJr3YXaVAiT2fzVJD1wqfg)
Content-type: text/x-patch; charset=UTF-8; name=disp-ext-map.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=disp-ext-map.patch

Index: e2fsprogs-1.40.7/debugfs/debug_cmds.ct
===================================================================
--- e2fsprogs-1.40.7.orig/debugfs/debug_cmds.ct
+++ e2fsprogs-1.40.7/debugfs/debug_cmds.ct
@@ -157,5 +157,8 @@ request do_set_current_time, "Set curren
 request do_supported_features, "Print features supported by this version of e2fsprogs",
 	supported_features;
 
+request do_dump_extent_map, "Dump extent map",
+	dump_extent_map, ext_map;
+
 end;
 
Index: e2fsprogs-1.40.7/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.40.7.orig/debugfs/debugfs.c
+++ e2fsprogs-1.40.7/debugfs/debugfs.c
@@ -42,6 +42,9 @@ extern char *optarg;
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 #endif
 
+#define DUMP_EXT_MAP_HEADER_ONLY 	1
+#define DUMP_EXT_MAP_TRAVERSE 		2
+
 extern ss_request_table debug_cmds;
 
 ext2_filsys	current_fs = NULL;
@@ -1858,6 +1861,177 @@ void do_supported_features(int argc, cha
 	}
 }
 
+void dump_ext_header(struct ext3_extent_header *eh)
+{
+	fprintf(stdout, "HEADER: magic=%x entries=%u max=%u depth=%u "
+		"generation=%u\n", eh->eh_magic, eh->eh_entries, eh->eh_max,
+		eh->eh_depth, eh->eh_generation);
+}
+
+void dump_ext_index(struct ext3_extent_idx *ix)
+{
+	fprintf(stdout, "INDEX: block=%u leaf=%u leaf_hi=%u unused=%u\n",
+		ix->ei_block, ix->ei_leaf, ix->ei_leaf_hi, ix->ei_unused);
+}
+
+void dump_ext_extent(struct ext3_extent *ex)
+{
+	fprintf(stdout, "EXTENT: block=%u-%u len=%u start=%u start_hi=%u\n",
+		ex->ee_block, ex->ee_block + ex->ee_len - 1,
+		ex->ee_len, ex->ee_start, ex->ee_start_hi);
+}
+
+void dump_extent_map(void *eh_buf, int size, int flag, blk_t blk)
+{
+	int i;
+	errcode_t err;
+	struct ext3_extent_header *eh = eh_buf;
+	void *block_buf;
+
+	if (blk == 0)
+		fprintf(stdout, "IN INODE:\n");
+	else
+		fprintf(stdout, "BLOCK NO. = %u:\n", blk);
+
+	err = ext2fs_extent_header_verify(eh, size);
+	if (err) {
+		com_err("ext_map", err, "");
+		dump_ext_header(eh);
+		return;
+	}
+
+	dump_ext_header(eh);
+
+	if (eh->eh_depth == 0) {
+		struct ext3_extent *ex = EXT_FIRST_EXTENT(eh);
+
+		if (!(flag & DUMP_EXT_MAP_HEADER_ONLY)) {
+			for (i = 0; i < eh->eh_entries; i++, ex++)
+				dump_ext_extent(ex);
+			printf("\n");
+		}
+	} else {
+		struct ext3_extent_idx *ix = EXT_FIRST_INDEX(eh);
+
+		if (!(flag & DUMP_EXT_MAP_HEADER_ONLY)) {
+			for (i = 0; i < eh->eh_entries; i++, ix++)
+				dump_ext_index(ix);
+			printf("\n");
+		}
+
+		if (flag & DUMP_EXT_MAP_TRAVERSE) {
+			if (ext2fs_get_mem(current_fs->blocksize, &block_buf))
+				return;
+
+			ix = EXT_FIRST_INDEX(eh);
+			for (i = 0; i < eh->eh_entries; i++, ix++) {
+				err = ext2fs_read_ext_block(current_fs,
+							    ix->ei_leaf,
+							    block_buf);
+				if (err) {
+					com_err("ext_map", 0,
+						"while reading block %u\n",
+						ix->ei_leaf);
+					return;
+				}
+				dump_extent_map(block_buf,
+						current_fs->blocksize, flag,
+						ix->ei_leaf);
+			}
+			ext2fs_free_mem(&block_buf);
+		}
+	}
+}
+
+void do_dump_extent_map(int argc, char *argv[])
+{
+	errcode_t err;
+	blk_t blknum;
+	int is_block = 0, c, flag = 0;
+	char *buf = NULL;
+	struct ext3_extent_header *eh;
+	ext2_ino_t ino;
+
+	if (common_args_process(argc, argv, 2, 5, argv[0],
+				" [-h] [-t] [-i <file>] [-b blocknr]", 0))
+		return;
+
+	reset_getopt();
+	while ((c = getopt(argc, argv, "b:hi:t")) != EOF) {
+		switch (c) {
+		case 'b':
+			is_block++;
+			if (strtoblk(argv[0], optarg, &blknum))
+				goto out;
+			if (blknum < 0 || blknum >=
+			    current_fs->super->s_blocks_count) {
+				com_err(argv[0], 0, "Invalid block number %u",
+					blknum);
+				goto out;
+			}
+			break;
+		case 'h':
+			flag |= DUMP_EXT_MAP_HEADER_ONLY;
+			break;
+		case 'i':
+			is_block = 0;
+			ino = string_to_inode(optarg);
+			if (!ino)
+				return;
+			break;
+		case 't':
+			flag |= DUMP_EXT_MAP_TRAVERSE;
+			break;
+		default:
+			com_err(argv[0], 0, "Usage: [-h] [-t] [-i <file>] "
+				"[-b blocknr]");
+			return;
+		}
+	}
+
+	if (is_block == 0) {
+		struct ext2_inode *inode;
+
+		inode = (struct ext2_inode *)
+			    malloc(EXT2_INODE_SIZE(current_fs->super));
+
+		if (debugfs_read_inode_full(ino, inode, argv[0],
+				EXT2_INODE_SIZE(current_fs->super))) {
+			free(inode);
+			return;
+		}
+
+		if (inode->i_flags & EXT4_EXTENTS_FL) {
+			eh = (struct ext3_extent_header *)&inode->i_block;
+			dump_extent_map(eh, sizeof(inode->i_block), flag, 0);
+		} else {
+			com_err(argv[0], 0, "Inode doesn't use extent map\n");
+		}
+
+		free(inode);
+	} else {
+		buf = malloc(current_fs->blocksize);
+		if (!buf) {
+			com_err(argv[0], 0, "Error allocating memory.\n");
+			return;
+		}
+
+		err = ext2fs_read_ext_block(current_fs, blknum, buf);
+		if (err) {
+			com_err(argv[0], err, "while reading block %u\n",
+				blknum);
+			goto out;
+		}
+
+		eh = (struct ext3_extent_header *)buf;
+
+		dump_extent_map(buf, current_fs->blocksize, flag, blknum);
+	}
+out:
+	if (buf)
+		free(buf);
+}
+
 static int source_file(const char *cmd_file, int sci_idx)
 {
 	FILE		*f;
Index: e2fsprogs-1.40.7/debugfs/debugfs.8.in
===================================================================
--- e2fsprogs-1.40.7.orig/debugfs/debugfs.8.in
+++ e2fsprogs-1.40.7/debugfs/debugfs.8.in
@@ -191,6 +191,22 @@ to match 
 Expand the directory
 .IR filespec .
 .TP
+.I ext_map [-h] [-t] [-i <filespec>] [-b block]
+Dump the extent map contained in inode/block.
+.IR -h
+option can be used to display only the extent headers.
+.IR -t
+option can be used to dump entire extent tree, in case inode
+is specified, or branch if block is specified.
+If
+.IR -i
+option is set, dump the extent map contained in the inode
+.IR filespec .
+If
+.IR -b
+option is set, dump the extent map contained in block
+.IR block .
+.TP
 .I feature [fs_feature] [-fs_feature] ...
 Set or clear various filesystem features in the superblock.  After setting
 or clearing any filesystem features that were requested, print the current

--Boundary_(ID_EJr3YXaVAiT2fzVJD1wqfg)--
