From: Coly Li <coyli@suse.de>
Subject: [RFC PATCH] e2fsprogs: remove fragment supporting
Date: Tue, 07 Aug 2007 01:15:00 +0800
Message-ID: <46B75714.8070908@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36247 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483AbXHFRNy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Aug 2007 13:13:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

This patch removes fragment supporting from e2fsprogs. Next step, I will have a
look in kernel code and remove the related code.

Though fragment supporting is removed, the "-f" option of mke2fsck is remained
for compatibility reason.

Need comments for:
1) in struct ext2_super_block, the original s_log_frag_size renamed to
s_log_frag_size_reserved, the original s_frags_per_group renamed to
s_frags_per_group_reserved. Is there any name better than "reserved" ?
2) same question to i_faddr of struct ext2_inode.

Also it seems all related sentences to fragment supporting in documents should
be removed too. Isn't it ?



Signed-Off-By: Coly Li <coyli@suse.de>

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 190c4b7..e94302d 100644
- --- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -521,7 +521,6 @@ void internal_dump_inode(FILE *out, const char *prefix,
 			 int do_dump_blocks)
 {
 	const char *i_type;
- -	char frag, fsize;
 	int os = current_fs->super->s_creator_os;
 	
 	if (LINUX_S_ISDIR(inode->i_mode)) i_type = "directory";
@@ -564,20 +563,6 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	else
 		fprintf(out, "%sLinks: %d   Blockcount: %u\n",
 			prefix, inode->i_links_count, inode->i_blocks);
- -	switch (os) {
- -	    case EXT2_OS_HURD:
- -		frag = inode->osd2.hurd2.h_i_frag;
- -		fsize = inode->osd2.hurd2.h_i_fsize;
- -		break;
- -	    case EXT2_OS_MASIX:
- -		frag = inode->osd2.masix2.m_i_frag;
- -		fsize = inode->osd2.masix2.m_i_fsize;
- -		break;
- -	    default:
- -		frag = fsize = 0;
- -	}
- -	fprintf(out, "%sFragment:  Address: %d    Number: %d    Size: %d\n",
- -		prefix, inode->i_faddr, frag, fsize);
 	fprintf(out, "%sctime: 0x%08x -- %s", prefix, inode->i_ctime,
 		time_to_string(inode->i_ctime));
 	fprintf(out, "%satime: 0x%08x -- %s", prefix, inode->i_atime,
@@ -849,7 +834,6 @@ void do_modify_inode(int argc, char *argv[])
 	struct ext2_inode inode;
 	ext2_ino_t	inode_num;
 	int 		i;
- -	unsigned char	*frag, *fsize;
 	char		buf[80];
 	int 		os;
 	const char	*hex_format = "0x%x";
@@ -893,24 +877,6 @@ void do_modify_inode(int argc, char *argv[])
 		modify_u32(argv[0], "Translator Block",
 			    decimal_format, &inode.osd1.hurd1.h_i_translator);
 	
- -	modify_u32(argv[0], "Fragment address", decimal_format, &inode.i_faddr);
- -	switch (os) {
- -	    case EXT2_OS_HURD:
- -		frag = &inode.osd2.hurd2.h_i_frag;
- -		fsize = &inode.osd2.hurd2.h_i_fsize;
- -		break;
- -	    case EXT2_OS_MASIX:
- -		frag = &inode.osd2.masix2.m_i_frag;
- -		fsize = &inode.osd2.masix2.m_i_fsize;
- -		break;
- -	    default:
- -		frag = fsize = 0;
- -	}
- -	if (frag)
- -		modify_u8(argv[0], "Fragment number", decimal_format, frag);
- -	if (fsize)
- -		modify_u8(argv[0], "Fragment size", decimal_format, fsize);
- -
 	for (i=0;  i < EXT2_NDIR_BLOCKS; i++) {
 		sprintf(buf, "Direct Block #%d", i);
 		modify_u32(argv[0], buf, decimal_format, &inode.i_block[i]);
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 9ff7f8c..5f95a60 100644
- --- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -65,9 +65,7 @@ static struct field_set_info super_fields[] = {
 	{ "free_inodes_count", &set_sb.s_free_inodes_count, 4, parse_uint },
 	{ "first_data_block", &set_sb.s_first_data_block, 4, parse_uint },
 	{ "log_block_size", &set_sb.s_log_block_size, 4, parse_uint },
- -	{ "log_frag_size", &set_sb.s_log_frag_size, 4, parse_int },
 	{ "blocks_per_group", &set_sb.s_blocks_per_group, 4, parse_uint },
- -	{ "frags_per_group", &set_sb.s_frags_per_group, 4, parse_uint },
 	{ "inodes_per_group", &set_sb.s_inodes_per_group, 4, parse_uint },
 	{ "mtime", &set_sb.s_mtime, 4, parse_time },
 	{ "wtime", &set_sb.s_wtime, 4, parse_time },
@@ -141,10 +139,7 @@ static struct field_set_info inode_fields[] = {
 	{ "generation", &set_inode.i_generation, 4, parse_uint },
 	{ "file_acl", &set_inode.i_file_acl, 4, parse_uint },
 	{ "dir_acl", &set_inode.i_dir_acl, 4, parse_uint },
- -	{ "faddr", &set_inode.i_faddr, 4, parse_uint },
 	{ "blocks_hi", &set_inode.osd2.linux2.l_i_blocks_hi, 2, parse_uint },
- -	{ "frag", &set_inode.osd2.hurd2.h_i_frag, 1, parse_uint },
- -	{ "fsize", &set_inode.osd2.hurd2.h_i_fsize, 1, parse_uint },
 	{ "uid_high", &set_inode.osd2.linux2.l_i_uid_high, 2, parse_uint },
 	{ "gid_high", &set_inode.osd2.linux2.l_i_gid_high, 2, parse_uint },
 	{ "author", &set_inode.osd2.hurd2.h_i_author, 4, parse_uint },
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
diff --git a/e2fsck/message.c b/e2fsck/message.c
index b2e3e0f..e263bca 100644
- --- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -293,9 +293,6 @@ static _INLINE_ void expand_inode_expression(char ch,
 		time_str = asctime(do_gmt ? gmtime(&t) : localtime(&t));
 		printf("%.24s", time_str);
 		break;
- -	case 'F':
- -		printf("%u", inode->i_faddr);
- -		break;
 	case 'f':
 		printf("%u", inode->i_file_acl);
 		break;
diff --git a/e2fsck/mtrace.h b/e2fsck/mtrace.h
index 2ed20eb..71b6c6f 100644
- --- a/e2fsck/mtrace.h
+++ b/e2fsck/mtrace.h
@@ -97,10 +97,7 @@ extern __ptr_t valloc __P ((size_t __size));
 #endif

 /* The allocator divides the heap into blocks of fixed size; large
- -   requests receive one or more whole blocks, and small requests
- -   receive a fragment of a block.  Fragment sizes are powers of two,
- -   and all fragments of a block are the same size.  When all the
- -   fragments in a block have been freed, the block itself is freed.  */
+   requests receive one or more whole blocks */
 #define INT_BIT		(CHAR_BIT * sizeof(int))
 #define BLOCKLOG	(INT_BIT > 16 ? 12 : 9)
 #define BLOCKSIZE	(1 << BLOCKLOG)
@@ -125,11 +122,7 @@ typedef union
 	int type;
 	union
 	  {
- -	    struct
- -	      {
- -		size_t nfree;	/* Free fragments in a fragmented block.  */
- -		size_t first;	/* First free fragment of the block.  */
- -	      } frag;
+	    size_t reserved[2];
 	    /* Size (in blocks) of a large cluster.  */
 	    size_t size;
 	  } info;
@@ -157,16 +150,6 @@ extern malloc_info *_heapinfo;
 /* Current search index for the heap table.  */
 extern size_t _heapindex;

- -/* Limit of valid info table indices.  */
- -extern size_t _heaplimit;
- -
- -/* Doubly linked lists of free fragments.  */
- -struct list
- -  {
- -    struct list *next;
- -    struct list *prev;
- -  };
- -
 /* Free list headers for each fragment size.  */
 extern struct list _fraghead[];

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ceb9c7f..7c17a74 100644
- --- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -475,7 +475,6 @@ void e2fsck_pass1(e2fsck_t ctx)
 #ifdef RESOURCE_TRACK
 	struct resource_track	rtrack;
 #endif
- -	unsigned char	frag, fsize;
 	struct		problem_context pctx;
 	struct		scan_callback_struct scan_struct;
 	struct ext2_super_block *sb = ctx->fs->super;
@@ -829,21 +828,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 		}
 		
 		ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
- -		switch (fs->super->s_creator_os) {
- -		    case EXT2_OS_HURD:
- -			frag = inode->osd2.hurd2.h_i_frag;
- -			fsize = inode->osd2.hurd2.h_i_fsize;
- -			break;
- -		    case EXT2_OS_MASIX:
- -			frag = inode->osd2.masix2.m_i_frag;
- -			fsize = inode->osd2.masix2.m_i_fsize;
- -			break;
- -		    default:
- -			frag = fsize = 0;
- -		}
 		
- -		if (inode->i_faddr || frag || fsize ||
- -		    (LINUX_S_ISDIR(inode->i_mode) && inode->i_dir_acl))
+		if ((LINUX_S_ISDIR(inode->i_mode) && inode->i_dir_acl))
 			mark_inode_bad(ctx, ino);
 		if ((fs->super->s_creator_os == EXT2_OS_LINUX) &&
 		    !(fs->super->s_feature_ro_compat &
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 7f7635f..84774d6 100644
- --- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1187,7 +1187,6 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx,
ext2_ino_t dir,
 	struct ext2_inode	inode;
 	int			inode_modified = 0;
 	int			not_fixed = 0;
- -	unsigned char		*frag, *fsize;
 	struct problem_context	pctx;
 	int	problem = 0;

@@ -1240,45 +1239,6 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx,
ext2_ino_t dir,
 		problem = 0;
 	}
 		
- -	if (inode.i_faddr) {
- -		if (fix_problem(ctx, PR_2_FADDR_ZERO, &pctx)) {
- -			inode.i_faddr = 0;
- -			inode_modified++;
- -		} else
- -			not_fixed++;
- -	}
- -
- -	switch (fs->super->s_creator_os) {
- -	    case EXT2_OS_HURD:
- -		frag = &inode.osd2.hurd2.h_i_frag;
- -		fsize = &inode.osd2.hurd2.h_i_fsize;
- -		break;
- -	    case EXT2_OS_MASIX:
- -		frag = &inode.osd2.masix2.m_i_frag;
- -		fsize = &inode.osd2.masix2.m_i_fsize;
- -		break;
- -	    default:
- -		frag = fsize = 0;
- -	}
- -	if (frag && *frag) {
- -		pctx.num = *frag;
- -		if (fix_problem(ctx, PR_2_FRAG_ZERO, &pctx)) {
- -			*frag = 0;
- -			inode_modified++;
- -		} else
- -			not_fixed++;
- -		pctx.num = 0;
- -	}
- -	if (fsize && *fsize) {
- -		pctx.num = *fsize;
- -		if (fix_problem(ctx, PR_2_FSIZE_ZERO, &pctx)) {
- -			*fsize = 0;
- -			inode_modified++;
- -		} else
- -			not_fixed++;
- -		pctx.num = 0;
- -	}
- -
 	if ((fs->super->s_creator_os == EXT2_OS_LINUX) &&
 	    !(fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 0b6fd39..d229579 100644
- --- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -959,11 +959,6 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("i_dir_acl @F %Id, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },

- -  	/* i_frag should be zero */
- -	{ PR_2_FRAG_ZERO,
- -	  N_("i_frag @F %N, @s zero.\n"),
- -	  PROMPT_CLEAR, 0 },
- -
   	/* i_fsize should be zero */
 	{ PR_2_FSIZE_ZERO,
 	  N_("i_fsize @F %N, @s zero.\n"),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index f5f7212..e8ba735 100644
- --- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -558,8 +558,8 @@ struct problem_context {
 /* Second entry in directory inode doesn't contain '..' */
 #define PR_2_2ND_NOT_DOT_DOT	0x02000C

- -/* i_faddr should be zero */
- -#define PR_2_FADDR_ZERO		0x02000D
+/* Duplicate directory entry found */
+#define PR_2_REPORT_DUP_DIRENT	0x02000D

 /* i_file_acl should be zero */
 #define PR_2_FILE_ACL_ZERO	0x02000E
@@ -567,11 +567,11 @@ struct problem_context {
 /* i_dir_acl should be zero */
 #define PR_2_DIR_ACL_ZERO	0x02000F

- -/* i_frag should be zero */
- -#define PR_2_FRAG_ZERO		0x020010
+/* Non-unique filename found */
+#define PR_2_NON_UNIQUE_FILE	0x020010

- -/* i_fsize should be zero */
- -#define PR_2_FSIZE_ZERO		0x020011
+/* i_blocks_hi should be zero */
+#define PR_2_BLOCKS_HI_ZERO	0x020011
 		
 /* inode has bad mode */
 #define PR_2_BAD_MODE		0x020012
@@ -699,14 +699,8 @@ struct problem_context {
 /* Duplicate directory entry found */
 #define PR_2_DUPLICATE_DIRENT	0x020041

- -/* Non-unique filename found */
- -#define PR_2_NON_UNIQUE_FILE	0x020042

- -/* Duplicate directory entry found */
- -#define PR_2_REPORT_DUP_DIRENT	0x020043

- -/* i_blocks_hi should be zero */
- -#define PR_2_BLOCKS_HI_ZERO	0x020044

 /*
  * Pass 3 errors
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 00a131c..f42e29d 100644
- --- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -497,11 +497,6 @@ void check_super_block(e2fsck_t ctx)
 	check_super_value(ctx, "log_block_size", sb->s_log_block_size,
 			  MIN_CHECK | MAX_CHECK, 0,
 			  EXT2_MAX_BLOCK_LOG_SIZE - EXT2_MIN_BLOCK_LOG_SIZE);
- -	check_super_value(ctx, "log_frag_size", sb->s_log_frag_size,
- -			  MIN_CHECK | MAX_CHECK, 0, sb->s_log_block_size);
- -	check_super_value(ctx, "frags_per_group", sb->s_frags_per_group,
- -			  MIN_CHECK | MAX_CHECK, sb->s_blocks_per_group,
- -			  bpg_max);
 	check_super_value(ctx, "blocks_per_group", sb->s_blocks_per_group,
 			  MIN_CHECK | MAX_CHECK, 8, bpg_max);
 	check_super_value(ctx, "inodes_per_group", sb->s_inodes_per_group,
@@ -533,24 +528,6 @@ void check_super_block(e2fsck_t ctx)
 		}
 	}

- -	if (sb->s_log_block_size != (__u32) sb->s_log_frag_size) {
- -		pctx.blk = EXT2_BLOCK_SIZE(sb);
- -		pctx.blk2 = EXT2_FRAG_SIZE(sb);
- -		fix_problem(ctx, PR_0_NO_FRAGMENTS, &pctx);
- -		ctx->flags |= E2F_FLAG_ABORT;
- -		return;
- -	}
- -
- -	should_be = sb->s_frags_per_group >>
- -		(sb->s_log_block_size - sb->s_log_frag_size);		
- -	if (sb->s_blocks_per_group != should_be) {
- -		pctx.blk = sb->s_blocks_per_group;
- -		pctx.blk2 = should_be;
- -		fix_problem(ctx, PR_0_BLOCKS_PER_GROUP, &pctx);
- -		ctx->flags |= E2F_FLAG_ABORT;
- -		return;
- -	}
- -
 	should_be = (sb->s_log_block_size == 0) ? 1 : 0;
 	if (sb->s_first_data_block != should_be) {
 		pctx.blk = sb->s_first_data_block;
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index b9ae14a..771addb 100644
- --- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -221,12 +221,10 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	fprintf(f, "Free inodes:              %u\n", sb->s_free_inodes_count);
 	fprintf(f, "First block:              %u\n", sb->s_first_data_block);
 	fprintf(f, "Block size:               %u\n", EXT2_BLOCK_SIZE(sb));
- -	fprintf(f, "Fragment size:            %u\n", EXT2_FRAG_SIZE(sb));
 	if (sb->s_reserved_gdt_blocks)
 		fprintf(f, "Reserved GDT blocks:      %u\n",
 			sb->s_reserved_gdt_blocks);
 	fprintf(f, "Blocks per group:         %u\n", sb->s_blocks_per_group);
- -	fprintf(f, "Fragments per group:      %u\n", sb->s_frags_per_group);
 	fprintf(f, "Inodes per group:         %u\n", sb->s_inodes_per_group);
 	fprintf(f, "Inode blocks per group:   %u\n", inode_blocks_per_group);
 	if (sb->s_first_meta_bg)
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..83929a2 100644
- --- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -97,20 +97,6 @@
 #define EXT2_ADDR_PER_BLOCK(s)	(EXT2_BLOCK_SIZE(s) / sizeof(__u32))

 /*
- - * Macro-instructions used to manage fragments
- - */
- -#define EXT2_MIN_FRAG_SIZE		EXT2_MIN_BLOCK_SIZE
- -#define EXT2_MAX_FRAG_SIZE		EXT2_MAX_BLOCK_SIZE
- -#define EXT2_MIN_FRAG_LOG_SIZE		EXT2_MIN_BLOCK_LOG_SIZE
- -#ifdef __KERNEL__
- -# define EXT2_FRAG_SIZE(s)		(EXT2_SB(s)->s_frag_size)
- -# define EXT2_FRAGS_PER_BLOCK(s)	(EXT2_SB(s)->s_frags_per_block)
- -#else
- -# define EXT2_FRAG_SIZE(s)		(EXT2_MIN_FRAG_SIZE << (s)->s_log_frag_size)
- -# define EXT2_FRAGS_PER_BLOCK(s)	(EXT2_BLOCK_SIZE(s) / EXT2_FRAG_SIZE(s))
- -#endif
- -
- -/*
  * ACL structures
  */
 struct ext2_acl_header	/* Header of Access Control Lists */
@@ -323,7 +309,7 @@ struct ext2_inode {
 	__u32	i_generation;	/* File version (for NFS) */
 	__u32	i_file_acl;	/* File ACL */
 	__u32	i_dir_acl;	/* Directory ACL */
- -	__u32	i_faddr;	/* Fragment address */
+	__u32	i_faddr_reserved;	/* Fragment address, removed */
 	union {
 		struct {
 			__u16	l_i_blocks_hi;
@@ -333,18 +319,14 @@ struct ext2_inode {
 			__u32	l_i_reserved2;
 		} linux2;
 		struct {
- -			__u8	h_i_frag;	/* Fragment number */
- -			__u8	h_i_fsize;	/* Fragment size */
+			__u16	h_i_reserved1;
 			__u16	h_i_mode_high;
 			__u16	h_i_uid_high;
 			__u16	h_i_gid_high;
 			__u32	h_i_author;
 		} hurd2;
 		struct {
- -			__u8	m_i_frag;	/* Fragment number */
- -			__u8	m_i_fsize;	/* Fragment size */
- -			__u16	m_pad1;
- -			__u32	m_i_reserved2[2];
+			__u32	m_i_reserved2[3];
 		} masix2;
 	} osd2;				/* OS dependent 2 */
 };
@@ -379,7 +361,7 @@ struct ext2_inode_large {
 	__u32	i_generation;	/* File version (for NFS) */
 	__u32	i_file_acl;	/* File ACL */
 	__u32	i_dir_acl;	/* Directory ACL */
- -	__u32	i_faddr;	/* Fragment address */
+	__u32	i_faddr_reserved;	/* Fragment address, removed */
 	union {
 		struct {
 			__u16	l_i_blocks_hi;
@@ -389,18 +371,14 @@ struct ext2_inode_large {
 			__u32	l_i_reserved2;
 		} linux2;
 		struct {
- -			__u8	h_i_frag;	/* Fragment number */
- -			__u8	h_i_fsize;	/* Fragment size */
+			__u16	h_i_reserved1;
 			__u16	h_i_mode_high;
 			__u16	h_i_uid_high;
 			__u16	h_i_gid_high;
 			__u32	h_i_author;
 		} hurd2;
 		struct {
- -			__u8	m_i_frag;	/* Fragment number */
- -			__u8	m_i_fsize;	/* Fragment size */
- -			__u16	m_pad1;
- -			__u32	m_i_reserved2[2];
+			__u32	m_i_reserved2[3];
 		} masix2;
 	} osd2;				/* OS dependent 2 */
 	__u16	i_extra_isize;
@@ -416,8 +394,6 @@ struct ext2_inode_large {

 #if defined(__KERNEL__) || defined(__linux__)
 #define i_reserved1	osd1.linux1.l_i_reserved1
- -#define i_frag		osd2.linux2.l_i_frag
- -#define i_fsize		osd2.linux2.l_i_fsize
 #define i_uid_low	i_uid
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
@@ -429,8 +405,6 @@ struct ext2_inode_large {
 #if defined(__GNU__)

 #define i_translator	osd1.hurd1.h_i_translator
- -#define i_frag		osd2.hurd2.h_i_frag;
- -#define i_fsize		osd2.hurd2.h_i_fsize;
 #define i_uid_high	osd2.hurd2.h_i_uid_high
 #define i_gid_high	osd2.hurd2.h_i_gid_high
 #define i_author	osd2.hurd2.h_i_author
@@ -441,8 +415,6 @@ struct ext2_inode_large {
 #if defined(__masix__)

 #define i_reserved1	osd1.masix1.m_i_reserved1
- -#define i_frag		osd2.masix2.m_i_frag
- -#define i_fsize		osd2.masix2.m_i_fsize
 #define i_reserved2	osd2.masix2.m_i_reserved2
 #define inode_uid(inode)	((inode).i_uid)
 #define inode_gid(inode)	((inode).i_gid)
@@ -504,9 +476,9 @@ struct ext2_super_block {
 	__u32	s_free_inodes_count;	/* Free inodes count */
 	__u32	s_first_data_block;	/* First Data Block */
 	__u32	s_log_block_size;	/* Block size */
- -	__s32	s_log_frag_size;	/* Fragment size */
+	__s32	s_log_frag_size_reserved;	/* Original fragment size, removed now */
 	__u32	s_blocks_per_group;	/* # Blocks per group */
- -	__u32	s_frags_per_group;	/* # Fragments per group */
+	__u32	s_frags_per_group_reserved;	/* Original fragments per group, removed now */
 	__u32	s_inodes_per_group;	/* # Inodes per group */
 	__u32	s_mtime;		/* Mount time */
 	__u32	s_wtime;		/* Write time */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 20c63c0..18cdf8e 100644
- --- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -198,7 +198,6 @@ struct struct_ext2_filsys {
 	char *				device_name;
 	struct ext2_super_block	* 	super;
 	unsigned int			blocksize;
- -	int				fragsize;
 	dgrp_t				group_desc_count;
 	unsigned long			desc_blocks;
 	struct ext2_group_desc *	group_desc;
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 16e9eaa..c1bf1a0 100644
- --- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -96,7 +96,6 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	ext2_filsys	fs;
 	errcode_t	retval;
 	struct ext2_super_block *super;
- -	int		frags_per_block;
 	unsigned int	rem;
 	unsigned int	overhead = 0;
 	unsigned int	ipg;
@@ -148,7 +147,6 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	super->s_state = EXT2_VALID_FS;

 	set_field(s_log_block_size, 0);	/* default blocksize: 1024 bytes */
- -	set_field(s_log_frag_size, 0); /* default fragsize: 1024 bytes */
 	set_field(s_first_data_block, super->s_log_block_size ? 0 : 1);
 	set_field(s_max_mnt_count, EXT2_DFL_MAX_MNT_COUNT);
 	set_field(s_errors, EXT2_ERRORS_DEFAULT);
@@ -177,14 +175,11 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	super->s_creator_os = CREATOR_OS;

 	fs->blocksize = EXT2_BLOCK_SIZE(super);
- -	fs->fragsize = EXT2_FRAG_SIZE(super);
- -	frags_per_block = fs->blocksize / fs->fragsize;

 	/* default: (fs->blocksize*8) blocks/group, up to 2^16 (GDT limit) */
 	set_field(s_blocks_per_group, fs->blocksize * 8);
 	if (super->s_blocks_per_group > EXT2_MAX_BLOCKS_PER_GROUP(super))
 		super->s_blocks_per_group = EXT2_MAX_BLOCKS_PER_GROUP(super);
- -	super->s_frags_per_group = super->s_blocks_per_group * frags_per_block;
 	
 	super->s_blocks_count = param->s_blocks_count;
 	super->s_r_blocks_count = param->s_r_blocks_count;
@@ -237,8 +232,6 @@ retry:
 			/* Try again with slightly different parameters */
 			super->s_blocks_per_group -= 8;
 			super->s_blocks_count = param->s_blocks_count;
- -			super->s_frags_per_group = super->s_blocks_per_group *
- -				frags_per_block;
 			goto retry;
 		} else
 			return EXT2_ET_TOO_MANY_INODES;
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 55cc077..0861c64 100644
- --- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -234,7 +234,6 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
- -	fs->fragsize = EXT2_FRAG_SIZE(fs->super);
 	fs->inode_blocks_per_group = ((fs->super->s_inodes_per_group *
 				       EXT2_INODE_SIZE(fs->super) +
 				       EXT2_BLOCK_SIZE(fs->super) - 1) /
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 6576c59..c357890 100644
- --- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -31,9 +31,9 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_free_inodes_count = ext2fs_swab32(sb->s_free_inodes_count);
 	sb->s_first_data_block = ext2fs_swab32(sb->s_first_data_block);
 	sb->s_log_block_size = ext2fs_swab32(sb->s_log_block_size);
- -	sb->s_log_frag_size = ext2fs_swab32(sb->s_log_frag_size);
+	sb->s_log_frag_size_reserved = ext2fs_swab32(sb->s_log_frag_size_reserved);
 	sb->s_blocks_per_group = ext2fs_swab32(sb->s_blocks_per_group);
- -	sb->s_frags_per_group = ext2fs_swab32(sb->s_frags_per_group);
+	sb->s_frags_per_group_reserved = ext2fs_swab32(sb->s_frags_per_group_reserved);
 	sb->s_inodes_per_group = ext2fs_swab32(sb->s_inodes_per_group);
 	sb->s_mtime = ext2fs_swab32(sb->s_mtime);
 	sb->s_wtime = ext2fs_swab32(sb->s_wtime);
@@ -168,7 +168,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct
ext2_inode_large *t,
 			t->i_block[i] = f->i_block[i];
 	}
 	t->i_generation = ext2fs_swab32(f->i_generation);
- -	t->i_faddr = ext2fs_swab32(f->i_faddr);
+	t->i_faddr_reserved = ext2fs_swab32(f->i_faddr_reserved);

 	switch (fs->super->s_creator_os) {
 	case EXT2_OS_LINUX:
@@ -187,8 +187,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct
ext2_inode_large *t,
 	case EXT2_OS_HURD:
 		t->osd1.hurd1.h_i_translator =
 		  ext2fs_swab32 (f->osd1.hurd1.h_i_translator);
- -		t->osd2.hurd2.h_i_frag = f->osd2.hurd2.h_i_frag;
- -		t->osd2.hurd2.h_i_fsize = f->osd2.hurd2.h_i_fsize;
+		t->osd2.hurd2.h_i_reserved1 = f->osd2.hurd2.h_i_reserved1;
 		t->osd2.hurd2.h_i_mode_high =
 		  ext2fs_swab16 (f->osd2.hurd2.h_i_mode_high);
 		t->osd2.hurd2.h_i_uid_high =
@@ -201,13 +200,12 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct
ext2_inode_large *t,
 	case EXT2_OS_MASIX:
 		t->osd1.masix1.m_i_reserved1 =
 			ext2fs_swab32(f->osd1.masix1.m_i_reserved1);
- -		t->osd2.masix2.m_i_frag = f->osd2.masix2.m_i_frag;
- -		t->osd2.masix2.m_i_fsize = f->osd2.masix2.m_i_fsize;
- -		t->osd2.masix2.m_pad1 = ext2fs_swab16(f->osd2.masix2.m_pad1);
 		t->osd2.masix2.m_i_reserved2[0] =
 			ext2fs_swab32(f->osd2.masix2.m_i_reserved2[0]);
 		t->osd2.masix2.m_i_reserved2[1] =
 			ext2fs_swab32(f->osd2.masix2.m_i_reserved2[1]);
+		t->osd2.masix2.m_i_reserved2[2] =
+			ext2fs_swab32(f->osd2.masix2.m_i_reserved2[2]);
 		break;
 	}

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4a6cace..15a2816 100644
- --- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -682,8 +682,6 @@ static void show_stats(ext2_filsys fs)
 	printf("\n");
 	printf(_("Block size=%u (log=%u)\n"), fs->blocksize,
 		s->s_log_block_size);
- -	printf(_("Fragment size=%u (log=%u)\n"), fs->fragsize,
- -		s->s_log_frag_size);
 	printf(_("%u inodes, %u blocks\n"), s->s_inodes_count,
 	       s->s_blocks_count);
 	printf(_("%u blocks (%2.2f%%) reserved for the super user\n"),
@@ -699,8 +697,7 @@ static void show_stats(ext2_filsys fs)
 		printf(_("%u block groups\n"), fs->group_desc_count);
 	else
 		printf(_("%u block group\n"), fs->group_desc_count);
- -	printf(_("%u blocks per group, %u fragments per group\n"),
- -	       s->s_blocks_per_group, s->s_frags_per_group);
+	printf(_("%u blocks per group\n"), s->s_blocks_per_group);
 	printf(_("%u inodes per group\n"), s->s_inodes_per_group);

 	if (fs->group_desc_count == 1) {
@@ -1018,16 +1015,6 @@ static void PRS(int argc, char *argv[])
 			cflag++;
 			break;
 		case 'f':
- -			size = strtoul(optarg, &tmp, 0);
- -			if (size < EXT2_MIN_BLOCK_SIZE ||
- -			    size > EXT2_MAX_BLOCK_SIZE || *tmp) {
- -				com_err(program_name, 0,
- -					_("invalid fragment size - %s"),
- -					optarg);
- -				exit(1);
- -			}
- -			fs_param.s_log_frag_size =
- -				int_log2(size >> EXT2_MIN_BLOCK_LOG_SIZE);
 			fprintf(stderr, _("Warning: fragments not supported.  "
 			       "Ignoring -f option\n"));
 			break;
@@ -1228,8 +1215,6 @@ static void PRS(int argc, char *argv[])
 		check_plausibility(device_name);
 	check_mount(device_name, force, _("filesystem"));

- -	fs_param.s_log_frag_size = fs_param.s_log_block_size;
- -
 	if (noaction && fs_param.s_blocks_count) {
 		dev_size = fs_param.s_blocks_count;
 		retval = 0;
@@ -1411,7 +1396,7 @@ static void PRS(int argc, char *argv[])
 			inode_ratio = blocksize;
 	}

- -	fs_param.s_log_frag_size = fs_param.s_log_block_size =
+	fs_param.s_log_block_size =
 		int_log2(blocksize >> EXT2_MIN_BLOCK_LOG_SIZE);

 	blocksize = EXT2_BLOCK_SIZE(&fs_param);




- --
Coly Li
SuSE PRC Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGt1cUuTp8cyZ5lTERArNtAJwO6KWqOb3NLtBmWUVnF0SV7ud/4gCgn6ah
kB/k4v+XpUS/+YMACtwI4F4=
=bTrK
-----END PGP SIGNATURE-----
