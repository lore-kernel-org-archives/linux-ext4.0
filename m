From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/2] dumpe2fs: add displaying file system block usage feature
Date: Tue, 25 Jan 2011 14:02:26 +0800
Message-ID: <1295935346-2480-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44734 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1AYGCh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Jan 2011 01:02:37 -0500
Received: by iyj18 with SMTP id 18so4744320iyj.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Jan 2011 22:02:36 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

[Purpose]
Having a view of blocks usage of block group descriptors, block/inode bitmaps, inode table, block pointer blocks, extents .etc, can help users in many cases,
1) Make estimation on how many memory might be occupied as buffer cache or page cache.
2) For some specific workload, is a file system is well formatted for block usage, e.g. whether there are never-be-used blocks allocated for inode table.
3) If there is a chance to allocated meta data from non-seek-cost device like SSD as a meta-data device, first of all user should know how many meta data blocks are allocated/used on the file system.

Therefore a tool to collect block usage information and display in a clear view is necessary. 
This patch is a first effort to add such a feature to dumpe2fs tool.

[Example]
An example of dumpe2fs execution looks like this:

#dumpe2fs -s /dev/mapper/sys-var

result:
[Blocks Usage (Unit: blocks)]
Super block:              9
Group descriptor:         9
Reserved GDT:             4600
Inode table:              65536
Inode bitmap:             64
Block bitmap:             64
Link block:               0
Journal:                  32802
Directory:                766
Extent(ext4):             0
Ind-Block:                583
Dind-Block:               177
Tind-Block:               0
File Data:                315653
ACL block:                194

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 misc/dumpe2fs.c |  302 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 300 insertions(+), 2 deletions(-)

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index c01ffe5..f3bdeb1 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -44,13 +44,51 @@ extern int optind;
 
 #define in_use(m, x)	(ext2fs_test_bit ((x), (m)))
 
+#define SECTOR_SIZE 512
+
 const char * program_name = "dumpe2fs";
 char * device_name = NULL;
 int hex_format = 0;
 
+struct fs_usage_count {
+	__u32 super_block;
+	__u32 group_desc_block;
+	__u32 reserved_gdt_block;
+	__u32 inode_table_block;
+	__u32 inode_bitmap_block;
+	__u32 block_bitmap_block;
+	__u32 dir_block;
+	__u32 acl_block;
+	__u32 file_data_block;
+	__u32 file_data_extent_block;
+	__u32 file_data_ind_block;
+	__u32 file_data_dind_block;
+	__u32 file_data_tind_block;
+	__u32 link_block;
+	__u32 journal_block;
+};
+
+struct fs_usage_count usage_counter;
+
+struct process_block_struct {
+	ext2_ino_t	ino;
+	int	is_dir;
+	__u32 i_flags;
+	struct fs_usage_count *counter;
+};
+
+/*
+ * These subroutines short circuits ext2fs_get_blocks and
+ * ext2fs_check_directory; we use them since we already have the inode
+ * structure, so there's no point in letting the ext2fs library read
+ * the inode again.
+ */
+static ino_t stashed_ino = 0;
+static struct ext2_inode *stashed_inode;
+
 static void usage(void)
 {
-	fprintf (stderr, _("Usage: %s [-bfhixV] [-o superblock=<num>] "
+	fprintf (stderr, _("Usage: %s [-bfhsixV] [-o superblock=<num>] "
 		 "[-o blocksize=<num>] device\n"), program_name);
 	exit (1);
 }
@@ -404,6 +442,257 @@ static void print_journal_information(ext2_filsys fs)
 	}
 }
 
+static errcode_t meta_get_blocks(ext2_filsys fs EXT2FS_ATTR((unused)),
+				 ext2_ino_t ino,
+				 blk_t *blocks)
+{
+	int	i;
+
+	if ((ino != stashed_ino) || !stashed_inode)
+		return EXT2_ET_CALLBACK_NOTHANDLED;
+
+	for (i=0; i < EXT2_N_BLOCKS; i++)
+		blocks[i] = stashed_inode->i_block[i];
+	return 0;
+}
+
+static errcode_t meta_check_directory(ext2_filsys fs EXT2FS_ATTR((unused)),
+				      ext2_ino_t ino)
+{
+	if ((ino != stashed_ino) || !stashed_inode)
+		return EXT2_ET_CALLBACK_NOTHANDLED;
+
+	if (!LINUX_S_ISDIR(stashed_inode->i_mode))
+		return EXT2_ET_NO_DIRECTORY;
+	return 0;
+}
+
+static errcode_t meta_read_inode(ext2_filsys fs EXT2FS_ATTR((unused)),
+				 ext2_ino_t ino,
+				 struct ext2_inode *inode)
+{
+	if ((ino != stashed_ino) || !stashed_inode)
+		return EXT2_ET_CALLBACK_NOTHANDLED;
+	*inode = *stashed_inode;
+	return 0;
+}
+
+static void use_inode_shortcuts(ext2_filsys fs, int bool)
+{
+	if (bool) {
+		fs->get_blocks = meta_get_blocks;
+		fs->check_directory = meta_check_directory;
+		fs->read_inode = meta_read_inode;
+		stashed_ino = 0;
+	} else {
+		fs->get_blocks = 0;
+		fs->check_directory = 0;
+		fs->read_inode = 0;
+	}
+}
+
+static int process_file_block(ext2_filsys fs EXT2FS_ATTR((unused)),
+			      blk64_t *block_nr,
+			      e2_blkcnt_t blockcnt,
+			      blk64_t ref_block EXT2FS_ATTR((unused)),
+			      int ref_offset EXT2FS_ATTR((unused)),
+			      void *priv_data EXT2FS_ATTR((unused)))
+{
+	struct process_block_struct *p;
+
+	p = (struct process_block_struct *) priv_data;
+
+	if (p->i_flags & EXT4_EXTENTS_FL) {
+		/*
+		 * leaf node block
+		 */
+		if (blockcnt == -1) {
+			p->counter->file_data_extent_block ++;
+		}
+	} else {
+		if (blockcnt == BLOCK_COUNT_IND) {
+			p->counter->file_data_ind_block ++;
+		} else if (blockcnt == BLOCK_COUNT_DIND) {
+			p->counter->file_data_dind_block ++;
+		} else if (blockcnt == BLOCK_COUNT_TIND) {
+			p->counter->file_data_tind_block ++;
+		}
+	}
+
+	p->counter->file_data_block ++;
+
+	return 0;
+}
+
+static void calculate_table_blocks(ext2_filsys fs,
+				struct fs_usage_count *counter)
+{
+	blk64_t	first_block, b;
+	unsigned int	i,j;
+
+	first_block = fs->super->s_first_data_block;
+
+	/*
+	 * calculate the block_bitmap/inode_bitmap/inode_table
+	 */
+	counter->block_bitmap_block = fs->group_desc_count;
+	counter->inode_bitmap_block = fs->group_desc_count;
+	counter->inode_table_block =
+		fs->inode_blocks_per_group * fs->group_desc_count;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		if (i == 0) {
+			counter->reserved_gdt_block += 1;
+		}
+
+		if (ext2fs_bg_has_super(fs, i)) {
+			counter->super_block += 1;
+			counter->group_desc_block += fs->desc_blocks;
+			counter->reserved_gdt_block +=
+				fs->super->s_reserved_gdt_blocks;
+		}
+	}
+}
+
+static void calculate_blocks_usage(ext2_filsys fs,
+				struct fs_usage_count *counter)
+{
+	struct process_block_struct	pb;
+	struct ext2_inode		inode;
+	ext2_inode_scan			scan;
+	ext2_ino_t			ino;
+	errcode_t			retval;
+	char *				block_buf;
+
+	calculate_table_blocks(fs, counter);
+
+	retval = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (retval) {
+		com_err(program_name, retval, _("while opening inode scan"));
+		exit(1);
+	}
+
+	block_buf = malloc(fs->blocksize * 3);
+	if (!block_buf) {
+		com_err(program_name, 0, "Can't allocate block buffer");
+		exit(1);
+	}
+
+	use_inode_shortcuts(fs, 1);
+	stashed_inode = &inode;
+	while (1) {
+		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		if (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE)
+			continue;
+		if (retval) {
+			com_err(program_name, retval,
+				_("while getting next inode"));
+			exit(1);
+		}
+		if (ino == 0)
+			break;
+		if (!inode.i_links_count)
+			continue;
+		if (ext2fs_file_acl_block(&inode)) {
+			counter->acl_block++;
+		}
+		if (!ext2fs_inode_has_valid_blocks(&inode))
+			continue;
+
+		stashed_ino = ino;
+		pb.ino = ino;
+		pb.is_dir = LINUX_S_ISDIR(inode.i_mode);
+		pb.i_flags = inode.i_flags;
+		/* calc journal block */
+		if (ino == fs->super->s_journal_inum) {
+			counter->journal_block += inode.i_blocks * 
+					SECTOR_SIZE / fs->blocksize;
+		} else if (LINUX_S_ISDIR(inode.i_mode)) {
+			counter->dir_block += inode.i_blocks * 
+					SECTOR_SIZE / fs->blocksize;
+		} else if (LINUX_S_ISLNK(inode.i_mode) &&
+		     ext2fs_inode_has_valid_blocks(&inode)) {
+			counter->link_block += inode.i_blocks * 
+				SECTOR_SIZE / fs->blocksize;
+		} else {
+			pb.counter = counter;
+			if ((inode.i_flags & EXT4_EXTENTS_FL) ||
+			    inode.i_block[EXT2_IND_BLOCK] ||
+			    inode.i_block[EXT2_DIND_BLOCK] ||
+			    inode.i_block[EXT2_TIND_BLOCK]) 
+			{
+				retval = ext2fs_block_iterate3(fs,
+				       ino, BLOCK_FLAG_READ_ONLY, block_buf,
+				       process_file_block, &pb);
+				if (retval) {
+					com_err(program_name, retval,
+					"while iterating over inode %u", ino);
+					exit(1);
+				}
+			} else {
+				counter->file_data_block += inode.i_blocks * 
+					SECTOR_SIZE / fs->blocksize;
+			}
+		}
+	}
+	use_inode_shortcuts(fs, 0);
+	free(block_buf);
+}
+
+static void print_blocks_usage_information(ext2_filsys fs)
+{
+	struct fs_usage_count usage_counter;
+
+	memset(&usage_counter, 0, sizeof(struct fs_usage_count));
+
+	calculate_blocks_usage(fs, &usage_counter);
+
+	/*
+	 * take off the blocks of  Reserved_GDT
+	 */
+	usage_counter.file_data_ind_block -=
+			fs->super->s_reserved_gdt_blocks;
+	usage_counter.file_data_dind_block -= 1;
+	usage_counter.file_data_block -= usage_counter.reserved_gdt_block;
+
+	/*
+	 * take off the xattr block (ACL block)
+	 */
+	usage_counter.file_data_block -= usage_counter.acl_block;
+
+	printf("[Blocks Usage (Unit: blocks)]\n");
+	printf("Super block:              %lu\n",
+			usage_counter.super_block);
+	printf("Group descriptor:         %lu\n",
+			usage_counter.group_desc_block);
+	printf("Reserved GDT:             %lu\n",
+			usage_counter.reserved_gdt_block);
+	printf("Inode table:              %lu\n",
+			usage_counter.inode_table_block);
+	printf("Inode bitmap:             %lu\n",
+			usage_counter.inode_bitmap_block);
+	printf("Block bitmap:             %lu\n",
+			usage_counter.block_bitmap_block);
+	printf("Link block:               %lu\n",
+			usage_counter.link_block);
+	printf("Journal:                  %lu\n",
+			usage_counter.journal_block);
+	printf("Directory:                %lu\n",
+			usage_counter.dir_block);
+	printf("Extent(ext4):             %lu\n",
+			usage_counter.file_data_extent_block);
+	printf("Ind-Block:                %lu\n",
+			usage_counter.file_data_ind_block);
+	printf("Dind-Block:               %lu\n",
+			usage_counter.file_data_dind_block);
+	printf("Tind-Block:               %lu\n",
+			usage_counter.file_data_tind_block);
+	printf("File Data:                %lu\n",
+			usage_counter.file_data_block);
+	printf("ACL block:                %lu\n",
+			usage_counter.acl_block);
+}
+
 static void parse_extended_opts(const char *opts, blk64_t *superblock,
 				int *blocksize)
 {
@@ -492,6 +781,7 @@ int main (int argc, char ** argv)
 	int		force = 0;
 	int		flags;
 	int		header_only = 0;
+	int		usage_info = 0;
 	int		c;
 
 #ifdef ENABLE_NLS
@@ -506,7 +796,7 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 
-	while ((c = getopt (argc, argv, "bfhixVo:")) != EOF) {
+	while ((c = getopt (argc, argv, "bfhsixVo:")) != EOF) {
 		switch (c) {
 		case 'b':
 			print_badblocks++;
@@ -517,6 +807,9 @@ int main (int argc, char ** argv)
 		case 'h':
 			header_only++;
 			break;
+		case 's':
+			usage_info++;
+			break;
 		case 'i':
 			image_dump++;
 			break;
@@ -568,6 +861,11 @@ int main (int argc, char ** argv)
 	if (print_badblocks) {
 		list_bad_blocks(fs, 1);
 	} else {
+		if (usage_info) {
+			print_blocks_usage_information(fs);
+			ext2fs_close (fs);
+			exit (0);
+		}
 		list_super (fs->super);
 		if (fs->super->s_feature_incompat &
 		      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
-- 
1.7.3.5

