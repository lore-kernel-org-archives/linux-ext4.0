From: Coly Li <coyli@suse.de>
Subject: [PATCH] e2fsprogs: remove fragment support (V3)
Date: Sat, 11 Aug 2007 01:13:39 +0800
Message-ID: <46BC9CC3.9090005@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:54192 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbXHJRMz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Aug 2007 13:12:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

in V3, modifications are:
1) by Andreas' feedback, keep rest macros of error number untouched.
2) by Andreas' suggestion, remove all "masix" related source code.
3) include modification of documents. I missed the patches of documents=
 (man, .po) in V2.

Thanks.

Signed-Off-By: Coly Li <coyli@suse.de>

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 190c4b7..e94302d 100644
- --- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -521,7 +521,6 @@ void internal_dump_inode(FILE *out, const char *pre=
fix,
 			 int do_dump_blocks)
 {
 	const char *i_type;
- -	char frag, fsize;
 	int os =3D current_fs->super->s_creator_os;
 =09
 	if (LINUX_S_ISDIR(inode->i_mode)) i_type =3D "directory";
@@ -564,20 +563,6 @@ void internal_dump_inode(FILE *out, const char *pr=
efix,
 	else
 		fprintf(out, "%sLinks: %d   Blockcount: %u\n",
 			prefix, inode->i_links_count, inode->i_blocks);
- -	switch (os) {
- -	    case EXT2_OS_HURD:
- -		frag =3D inode->osd2.hurd2.h_i_frag;
- -		fsize =3D inode->osd2.hurd2.h_i_fsize;
- -		break;
- -	    case EXT2_OS_MASIX:
- -		frag =3D inode->osd2.masix2.m_i_frag;
- -		fsize =3D inode->osd2.masix2.m_i_fsize;
- -		break;
- -	    default:
- -		frag =3D fsize =3D 0;
- -	}
- -	fprintf(out, "%sFragment:  Address: %d    Number: %d    Size: %d\n"=
,
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
 	const char	*hex_format =3D "0x%x";
@@ -893,24 +877,6 @@ void do_modify_inode(int argc, char *argv[])
 		modify_u32(argv[0], "Translator Block",
 			    decimal_format, &inode.osd1.hurd1.h_i_translator);
 =09
- -	modify_u32(argv[0], "Fragment address", decimal_format, &inode.i_fa=
ddr);
- -	switch (os) {
- -	    case EXT2_OS_HURD:
- -		frag =3D &inode.osd2.hurd2.h_i_frag;
- -		fsize =3D &inode.osd2.hurd2.h_i_fsize;
- -		break;
- -	    case EXT2_OS_MASIX:
- -		frag =3D &inode.osd2.masix2.m_i_frag;
- -		fsize =3D &inode.osd2.masix2.m_i_fsize;
- -		break;
- -	    default:
- -		frag =3D fsize =3D 0;
- -	}
- -	if (frag)
- -		modify_u8(argv[0], "Fragment number", decimal_format, frag);
- -	if (fsize)
- -		modify_u8(argv[0], "Fragment size", decimal_format, fsize);
- -
 	for (i=3D0;  i < EXT2_NDIR_BLOCKS; i++) {
 		sprintf(buf, "Direct Block #%d", i);
 		modify_u32(argv[0], buf, decimal_format, &inode.i_block[i]);
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 9ff7f8c..5f95a60 100644
- --- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -65,9 +65,7 @@ static struct field_set_info super_fields[] =3D {
 	{ "free_inodes_count", &set_sb.s_free_inodes_count, 4, parse_uint },
 	{ "first_data_block", &set_sb.s_first_data_block, 4, parse_uint },
 	{ "log_block_size", &set_sb.s_log_block_size, 4, parse_uint },
- -	{ "log_frag_size", &set_sb.s_log_frag_size, 4, parse_int },
 	{ "blocks_per_group", &set_sb.s_blocks_per_group, 4, parse_uint },
- -	{ "frags_per_group", &set_sb.s_frags_per_group, 4, parse_uint },
 	{ "inodes_per_group", &set_sb.s_inodes_per_group, 4, parse_uint },
 	{ "mtime", &set_sb.s_mtime, 4, parse_time },
 	{ "wtime", &set_sb.s_wtime, 4, parse_time },
@@ -141,10 +139,7 @@ static struct field_set_info inode_fields[] =3D {
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
diff --git a/doc/libext2fs.texinfo b/doc/libext2fs.texinfo
index 1277c3a..983e7ec 100644
- --- a/doc/libext2fs.texinfo
+++ b/doc/libext2fs.texinfo
@@ -297,10 +297,8 @@ default value is zero blocks.
 The blocksize of the filesystem.  Valid values are 0 (1024 bytes), 1
 (2048 bytes), or 2 (4096 bytes).  The default blocksize is 1024 bytes.

- -@item s_log_frag_size
- -The size of fragments.  The ext2 filesystem does not support fragmen=
ts
- -(and may never support fragments).  Currently this field must be the
- -same as @code{s_log_block_size}.
+@item s_obso_log_frag_size
+The obsoleted size of fragments.

 @item s_first_data_block
 The first data block for the filesystem.  For filesystem with a
diff --git a/e2fsck/message.c b/e2fsck/message.c
index b2e3e0f..e263bca 100644
- --- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -293,9 +293,6 @@ static _INLINE_ void expand_inode_expression(char c=
h,
 		time_str =3D asctime(do_gmt ? gmtime(&t) : localtime(&t));
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
- -   fragments in a block have been freed, the block itself is freed. =
 */
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
index ceb9c7f..a8dc51f 100644
- --- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -475,7 +475,6 @@ void e2fsck_pass1(e2fsck_t ctx)
 #ifdef RESOURCE_TRACK
 	struct resource_track	rtrack;
 #endif
- -	unsigned char	frag, fsize;
 	struct		problem_context pctx;
 	struct		scan_callback_struct scan_struct;
 	struct ext2_super_block *sb =3D ctx->fs->super;
@@ -828,22 +827,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 		}
 	=09
- -		ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
- -		switch (fs->super->s_creator_os) {
- -		    case EXT2_OS_HURD:
- -			frag =3D inode->osd2.hurd2.h_i_frag;
- -			fsize =3D inode->osd2.hurd2.h_i_fsize;
- -			break;
- -		    case EXT2_OS_MASIX:
- -			frag =3D inode->osd2.masix2.m_i_frag;
- -			fsize =3D inode->osd2.masix2.m_i_fsize;
- -			break;
- -		    default:
- -			frag =3D fsize =3D 0;
- -		}
- -	=09
- -		if (inode->i_faddr || frag || fsize ||
- -		    (LINUX_S_ISDIR(inode->i_mode) && inode->i_dir_acl))
+		if (LINUX_S_ISDIR(inode->i_mode) && inode->i_dir_acl)
 			mark_inode_bad(ctx, ino);
 		if ((fs->super->s_creator_os =3D=3D EXT2_OS_LINUX) &&
 		    !(fs->super->s_feature_ro_compat &
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 7f7635f..84774d6 100644
- --- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1187,7 +1187,6 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx,=
 ext2_ino_t dir,
 	struct ext2_inode	inode;
 	int			inode_modified =3D 0;
 	int			not_fixed =3D 0;
- -	unsigned char		*frag, *fsize;
 	struct problem_context	pctx;
 	int	problem =3D 0;

@@ -1240,45 +1239,6 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx=
, ext2_ino_t dir,
 		problem =3D 0;
 	}
 	=09
- -	if (inode.i_faddr) {
- -		if (fix_problem(ctx, PR_2_FADDR_ZERO, &pctx)) {
- -			inode.i_faddr =3D 0;
- -			inode_modified++;
- -		} else
- -			not_fixed++;
- -	}
- -
- -	switch (fs->super->s_creator_os) {
- -	    case EXT2_OS_HURD:
- -		frag =3D &inode.osd2.hurd2.h_i_frag;
- -		fsize =3D &inode.osd2.hurd2.h_i_fsize;
- -		break;
- -	    case EXT2_OS_MASIX:
- -		frag =3D &inode.osd2.masix2.m_i_frag;
- -		fsize =3D &inode.osd2.masix2.m_i_fsize;
- -		break;
- -	    default:
- -		frag =3D fsize =3D 0;
- -	}
- -	if (frag && *frag) {
- -		pctx.num =3D *frag;
- -		if (fix_problem(ctx, PR_2_FRAG_ZERO, &pctx)) {
- -			*frag =3D 0;
- -			inode_modified++;
- -		} else
- -			not_fixed++;
- -		pctx.num =3D 0;
- -	}
- -	if (fsize && *fsize) {
- -		pctx.num =3D *fsize;
- -		if (fix_problem(ctx, PR_2_FSIZE_ZERO, &pctx)) {
- -			*fsize =3D 0;
- -			inode_modified++;
- -		} else
- -			not_fixed++;
- -		pctx.num =3D 0;
- -	}
- -
 	if ((fs->super->s_creator_os =3D=3D EXT2_OS_LINUX) &&
 	    !(fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 0b6fd39..e733df1 100644
- --- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -132,13 +132,6 @@ static struct e2fsck_problem problem_table[] =3D {
 	  "Either the @S or the partition table is likely to be corrupt!\n"),
 	  PROMPT_ABORT, 0 },

- -	/* Fragments not supported */	=09
- -	{ PR_0_NO_FRAGMENTS,
- -	  N_("@S @b_size =3D %b, fragsize =3D %c.\n"
- -	  "This version of e2fsck does not support fragment sizes different=
\n"
- -	  "from the @b size.\n"),
- -	  PROMPT_NONE, PR_FATAL },
- -
 	  /* Bad blocks_per_group */
 	{ PR_0_BLOCKS_PER_GROUP,
 	  N_("@S @bs_per_group =3D %b, should have been %c\n"),
@@ -944,11 +937,6 @@ static struct e2fsck_problem problem_table[] =3D {
 	  N_("Second @e '%Dn' (@i=3D%Di) in @d @i %i @s '..'\n"),
 	  PROMPT_FIX, 0 },
 	=09
- -	/* i_faddr should be zero */
- -	{ PR_2_FADDR_ZERO,
- -	  N_("i_faddr @F %IF, @s zero.\n"),
- -	  PROMPT_CLEAR, 0 },
- -
   	/* i_file_acl should be zero */
 	{ PR_2_FILE_ACL_ZERO,
 	  N_("i_file_acl @F %If, @s zero.\n"),
@@ -959,16 +947,6 @@ static struct e2fsck_problem problem_table[] =3D {
 	  N_("i_dir_acl @F %Id, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },

- -  	/* i_frag should be zero */
- -	{ PR_2_FRAG_ZERO,
- -	  N_("i_frag @F %N, @s zero.\n"),
- -	  PROMPT_CLEAR, 0 },
- -
- -  	/* i_fsize should be zero */
- -	{ PR_2_FSIZE_ZERO,
- -	  N_("i_fsize @F %N, @s zero.\n"),
- -	  PROMPT_CLEAR, 0 },
- -
 	/* inode has bad mode */
 	{ PR_2_BAD_MODE,
 	  N_("@i %i (%Q) has @n mode (%Im).\n"),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index f5f7212..92794df 100644
- --- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -70,9 +70,6 @@ struct problem_context {
 /* Filesystem size is wrong */
 #define PR_0_FS_SIZE_WRONG	0x000005

- -/* Fragments not supported */
- -#define PR_0_NO_FRAGMENTS	0x000006
- -
 /* Bad blocks_per_group */
 #define PR_0_BLOCKS_PER_GROUP	0x000007

@@ -558,21 +555,12 @@ struct problem_context {
 /* Second entry in directory inode doesn't contain '..' */
 #define PR_2_2ND_NOT_DOT_DOT	0x02000C

- -/* i_faddr should be zero */
- -#define PR_2_FADDR_ZERO		0x02000D
- -
 /* i_file_acl should be zero */
 #define PR_2_FILE_ACL_ZERO	0x02000E

 /* i_dir_acl should be zero */
 #define PR_2_DIR_ACL_ZERO	0x02000F

- -/* i_frag should be zero */
- -#define PR_2_FRAG_ZERO		0x020010
- -
- -/* i_fsize should be zero */
- -#define PR_2_FSIZE_ZERO		0x020011
- -	=09
 /* inode has bad mode */
 #define PR_2_BAD_MODE		0x020012

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

- -	if (sb->s_log_block_size !=3D (__u32) sb->s_log_frag_size) {
- -		pctx.blk =3D EXT2_BLOCK_SIZE(sb);
- -		pctx.blk2 =3D EXT2_FRAG_SIZE(sb);
- -		fix_problem(ctx, PR_0_NO_FRAGMENTS, &pctx);
- -		ctx->flags |=3D E2F_FLAG_ABORT;
- -		return;
- -	}
- -
- -	should_be =3D sb->s_frags_per_group >>
- -		(sb->s_log_block_size - sb->s_log_frag_size);	=09
- -	if (sb->s_blocks_per_group !=3D should_be) {
- -		pctx.blk =3D sb->s_blocks_per_group;
- -		pctx.blk2 =3D should_be;
- -		fix_problem(ctx, PR_0_BLOCKS_PER_GROUP, &pctx);
- -		ctx->flags |=3D E2F_FLAG_ABORT;
- -		return;
- -	}
- -
 	should_be =3D (sb->s_log_block_size =3D=3D 0) ? 1 : 0;
 	if (sb->s_first_data_block !=3D should_be) {
 		pctx.blk =3D sb->s_first_data_block;
diff --git a/ext2ed/ext2.descriptors b/ext2ed/ext2.descriptors
index bf927b0..d23f9bf 100644
- --- a/ext2ed/ext2.descriptors
+++ b/ext2ed/ext2.descriptors
@@ -103,9 +103,9 @@ struct ext2_inode {
 	__u32  i_version;	/* File version (for NFS) */
 	__u32  i_file_acl;	/* File ACL */
 	__u32  i_dir_acl;	/* Directory ACL */
- -	__u32  i_faddr;		/* Fragment address */
- -	__u8   l_i_frag;	/* Fragment number */
- -	__u8   l_i_fsize;	/* Fragment size */
+	__u32  i_obso_faddr;	/* Obsoleted fragment address */
+	__u8   l_i_obso_frag;	/* Obsoleted fragment number */
+	__u8   l_i_obso_fsize;	/* Obsoleted fragment size */
 	__u16  i_pad1;
 	__u16	l_i_uid_high;	/* these 2 fields    */
 	__u16	l_i_gid_high;	/* were reserved2[0] */
@@ -123,10 +123,10 @@ struct ext2_super_block {
 	__u32	s_free_inodes_count;	/* Free inodes count */
 	__u32	s_first_data_block;	/* First Data Block */
 	__u32	s_log_block_size;	/* Block size */
- -	__s32	s_log_frag_size;	/* Fragment size */
- -	__u32	s_blocks_per_group;	/* # Blocks per group */
- -	__u32	s_frags_per_group;	/* # Fragments per group */
- -	__u32	s_inodes_per_group;	/* # Inodes per group */
+	__s32	s_obso_log_frag_size;	/* Obsoleted fragment size */
+	__u32	s_blocks_per_group;	/* Blocks per group */
+	__u32	s_obso_frags_per_group;	/* Obsoleted fragments per group */
+	__u32	s_inodes_per_group;	/* Inodes per group */
 	__u32	s_mtime;		/* Mount time */
 	__u32	s_wtime;		/* Write time */
 	__u16	s_mnt_count;		/* Mount count */
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index b9ae14a..771addb 100644
- --- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -221,12 +221,10 @@ void list_super2(struct ext2_super_block * sb, FI=
LE *f)
 	fprintf(f, "Free inodes:              %u\n", sb->s_free_inodes_count)=
;
 	fprintf(f, "First block:              %u\n", sb->s_first_data_block);
 	fprintf(f, "Block size:               %u\n", EXT2_BLOCK_SIZE(sb));
- -	fprintf(f, "Fragment size:            %u\n", EXT2_FRAG_SIZE(sb));
 	if (sb->s_reserved_gdt_blocks)
 		fprintf(f, "Reserved GDT blocks:      %u\n",
 			sb->s_reserved_gdt_blocks);
 	fprintf(f, "Blocks per group:         %u\n", sb->s_blocks_per_group);
- -	fprintf(f, "Fragments per group:      %u\n", sb->s_frags_per_group)=
;
 	fprintf(f, "Inodes per group:         %u\n", sb->s_inodes_per_group);
 	fprintf(f, "Inode blocks per group:   %u\n", inode_blocks_per_group);
 	if (sb->s_first_meta_bg)
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..d1902c6 100644
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
- -# define EXT2_FRAG_SIZE(s)		(EXT2_MIN_FRAG_SIZE << (s)->s_log_frag_s=
ize)
- -# define EXT2_FRAGS_PER_BLOCK(s)	(EXT2_BLOCK_SIZE(s) / EXT2_FRAG_SIZ=
E(s))
- -#endif
- -
- -/*
  * ACL structures
  */
 struct ext2_acl_header	/* Header of Access Control Lists */
@@ -315,15 +301,12 @@ struct ext2_inode {
 		struct {
 			__u32  h_i_translator;
 		} hurd1;
- -		struct {
- -			__u32  m_i_reserved1;
- -		} masix1;
 	} osd1;				/* OS dependent 1 */
 	__u32	i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
 	__u32	i_generation;	/* File version (for NFS) */
 	__u32	i_file_acl;	/* File ACL */
 	__u32	i_dir_acl;	/* Directory ACL */
- -	__u32	i_faddr;	/* Fragment address */
+	__u32	i_obso_faddr;	/* Obsoleted fragment address */
 	union {
 		struct {
 			__u16	l_i_blocks_hi;
@@ -333,19 +316,12 @@ struct ext2_inode {
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
- -		struct {
- -			__u8	m_i_frag;	/* Fragment number */
- -			__u8	m_i_fsize;	/* Fragment size */
- -			__u16	m_pad1;
- -			__u32	m_i_reserved2[2];
- -		} masix2;
 	} osd2;				/* OS dependent 2 */
 };

@@ -371,15 +347,12 @@ struct ext2_inode_large {
 		struct {
 			__u32  h_i_translator;
 		} hurd1;
- -		struct {
- -			__u32  m_i_reserved1;
- -		} masix1;
 	} osd1;				/* OS dependent 1 */
 	__u32	i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
 	__u32	i_generation;	/* File version (for NFS) */
 	__u32	i_file_acl;	/* File ACL */
 	__u32	i_dir_acl;	/* Directory ACL */
- -	__u32	i_faddr;	/* Fragment address */
+	__u32	i_obso_faddr;	/* Obsoleted fragment address */
 	union {
 		struct {
 			__u16	l_i_blocks_hi;
@@ -389,19 +362,12 @@ struct ext2_inode_large {
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
- -		struct {
- -			__u8	m_i_frag;	/* Fragment number */
- -			__u8	m_i_fsize;	/* Fragment size */
- -			__u16	m_pad1;
- -			__u32	m_i_reserved2[2];
- -		} masix2;
 	} osd2;				/* OS dependent 2 */
 	__u16	i_extra_isize;
 	__u16	i_pad1;
@@ -416,8 +382,6 @@ struct ext2_inode_large {

 #if defined(__KERNEL__) || defined(__linux__)
 #define i_reserved1	osd1.linux1.l_i_reserved1
- -#define i_frag		osd2.linux2.l_i_frag
- -#define i_fsize		osd2.linux2.l_i_fsize
 #define i_uid_low	i_uid
 #define i_gid_low	i_gid
 #define i_uid_high	osd2.linux2.l_i_uid_high
@@ -429,25 +393,12 @@ struct ext2_inode_large {
 #if defined(__GNU__)

 #define i_translator	osd1.hurd1.h_i_translator
- -#define i_frag		osd2.hurd2.h_i_frag;
- -#define i_fsize		osd2.hurd2.h_i_fsize;
 #define i_uid_high	osd2.hurd2.h_i_uid_high
 #define i_gid_high	osd2.hurd2.h_i_gid_high
 #define i_author	osd2.hurd2.h_i_author
 #define inode_uid(inode)	((inode).i_uid | (inode).i_uid_high << 16)
 #define inode_gid(inode)	((inode).i_gid | (inode).i_gid_high << 16)

- -#else
- -#if defined(__masix__)
- -
- -#define i_reserved1	osd1.masix1.m_i_reserved1
- -#define i_frag		osd2.masix2.m_i_frag
- -#define i_fsize		osd2.masix2.m_i_fsize
- -#define i_reserved2	osd2.masix2.m_i_reserved2
- -#define inode_uid(inode)	((inode).i_uid)
- -#define inode_gid(inode)	((inode).i_gid)
- -
- -#endif  /* __masix__ */
 #endif  /* __GNU__ */
 #endif	/* defined(__KERNEL__) || defined(__linux__) */

@@ -504,10 +455,10 @@ struct ext2_super_block {
 	__u32	s_free_inodes_count;	/* Free inodes count */
 	__u32	s_first_data_block;	/* First Data Block */
 	__u32	s_log_block_size;	/* Block size */
- -	__s32	s_log_frag_size;	/* Fragment size */
- -	__u32	s_blocks_per_group;	/* # Blocks per group */
- -	__u32	s_frags_per_group;	/* # Fragments per group */
- -	__u32	s_inodes_per_group;	/* # Inodes per group */
+	__s32	s_obso_log_frag_size;	/* Obsoleted fragment size */
+	__u32	s_blocks_per_group;	/* Blocks per group */
+	__u32	s_obso_frags_per_group;	/* Obsoleted fragments per group, remov=
ed now */
+	__u32	s_inodes_per_group;	/* Inodes per group */
 	__u32	s_mtime;		/* Mount time */
 	__u32	s_wtime;		/* Write time */
 	__u16	s_mnt_count;		/* Mount count */
@@ -585,7 +536,6 @@ struct ext2_super_block {
  */
 #define EXT2_OS_LINUX		0
 #define EXT2_OS_HURD		1
- -#define EXT2_OS_MASIX		2
 #define EXT2_OS_FREEBSD		3
 #define EXT2_OS_LITES		4

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
@@ -96,7 +96,6 @@ errcode_t ext2fs_initialize(const char *name, int fla=
gs,
 	ext2_filsys	fs;
 	errcode_t	retval;
 	struct ext2_super_block *super;
- -	int		frags_per_block;
 	unsigned int	rem;
 	unsigned int	overhead =3D 0;
 	unsigned int	ipg;
@@ -148,7 +147,6 @@ errcode_t ext2fs_initialize(const char *name, int f=
lags,
 	super->s_state =3D EXT2_VALID_FS;

 	set_field(s_log_block_size, 0);	/* default blocksize: 1024 bytes */
- -	set_field(s_log_frag_size, 0); /* default fragsize: 1024 bytes */
 	set_field(s_first_data_block, super->s_log_block_size ? 0 : 1);
 	set_field(s_max_mnt_count, EXT2_DFL_MAX_MNT_COUNT);
 	set_field(s_errors, EXT2_ERRORS_DEFAULT);
@@ -177,14 +175,11 @@ errcode_t ext2fs_initialize(const char *name, int=
 flags,
 	super->s_creator_os =3D CREATOR_OS;

 	fs->blocksize =3D EXT2_BLOCK_SIZE(super);
- -	fs->fragsize =3D EXT2_FRAG_SIZE(super);
- -	frags_per_block =3D fs->blocksize / fs->fragsize;

 	/* default: (fs->blocksize*8) blocks/group, up to 2^16 (GDT limit) */
 	set_field(s_blocks_per_group, fs->blocksize * 8);
 	if (super->s_blocks_per_group > EXT2_MAX_BLOCKS_PER_GROUP(super))
 		super->s_blocks_per_group =3D EXT2_MAX_BLOCKS_PER_GROUP(super);
- -	super->s_frags_per_group =3D super->s_blocks_per_group * frags_per_=
block;
 =09
 	super->s_blocks_count =3D param->s_blocks_count;
 	super->s_r_blocks_count =3D param->s_r_blocks_count;
@@ -237,8 +232,6 @@ retry:
 			/* Try again with slightly different parameters */
 			super->s_blocks_per_group -=3D 8;
 			super->s_blocks_count =3D param->s_blocks_count;
- -			super->s_frags_per_group =3D super->s_blocks_per_group *
- -				frags_per_block;
 			goto retry;
 		} else
 			return EXT2_ET_TOO_MANY_INODES;
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 55cc077..0861c64 100644
- --- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -234,7 +234,6 @@ errcode_t ext2fs_open2(const char *name, const char=
 *io_options,
 		retval =3D EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
- -	fs->fragsize =3D EXT2_FRAG_SIZE(fs->super);
 	fs->inode_blocks_per_group =3D ((fs->super->s_inodes_per_group *
 				       EXT2_INODE_SIZE(fs->super) +
 				       EXT2_BLOCK_SIZE(fs->super) - 1) /
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 6576c59..90f178b 100644
- --- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -31,9 +31,9 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_free_inodes_count =3D ext2fs_swab32(sb->s_free_inodes_count);
 	sb->s_first_data_block =3D ext2fs_swab32(sb->s_first_data_block);
 	sb->s_log_block_size =3D ext2fs_swab32(sb->s_log_block_size);
- -	sb->s_log_frag_size =3D ext2fs_swab32(sb->s_log_frag_size);
+	sb->s_obso_log_frag_size =3D ext2fs_swab32(sb->s_obso_log_frag_size);
 	sb->s_blocks_per_group =3D ext2fs_swab32(sb->s_blocks_per_group);
- -	sb->s_frags_per_group =3D ext2fs_swab32(sb->s_frags_per_group);
+	sb->s_obso_frags_per_group =3D ext2fs_swab32(sb->s_obso_frags_per_gro=
up);
 	sb->s_inodes_per_group =3D ext2fs_swab32(sb->s_inodes_per_group);
 	sb->s_mtime =3D ext2fs_swab32(sb->s_mtime);
 	sb->s_wtime =3D ext2fs_swab32(sb->s_wtime);
@@ -168,7 +168,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct =
ext2_inode_large *t,
 			t->i_block[i] =3D f->i_block[i];
 	}
 	t->i_generation =3D ext2fs_swab32(f->i_generation);
- -	t->i_faddr =3D ext2fs_swab32(f->i_faddr);
+	t->i_obso_faddr =3D ext2fs_swab32(f->i_obso_faddr);

 	switch (fs->super->s_creator_os) {
 	case EXT2_OS_LINUX:
@@ -187,8 +187,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct =
ext2_inode_large *t,
 	case EXT2_OS_HURD:
 		t->osd1.hurd1.h_i_translator =3D
 		  ext2fs_swab32 (f->osd1.hurd1.h_i_translator);
- -		t->osd2.hurd2.h_i_frag =3D f->osd2.hurd2.h_i_frag;
- -		t->osd2.hurd2.h_i_fsize =3D f->osd2.hurd2.h_i_fsize;
+		t->osd2.hurd2.h_i_reserved1 =3D f->osd2.hurd2.h_i_reserved1;
 		t->osd2.hurd2.h_i_mode_high =3D
 		  ext2fs_swab16 (f->osd2.hurd2.h_i_mode_high);
 		t->osd2.hurd2.h_i_uid_high =3D
@@ -198,17 +197,6 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct=
 ext2_inode_large *t,
 		t->osd2.hurd2.h_i_author =3D
 		  ext2fs_swab32 (f->osd2.hurd2.h_i_author);
 		break;
- -	case EXT2_OS_MASIX:
- -		t->osd1.masix1.m_i_reserved1 =3D
- -			ext2fs_swab32(f->osd1.masix1.m_i_reserved1);
- -		t->osd2.masix2.m_i_frag =3D f->osd2.masix2.m_i_frag;
- -		t->osd2.masix2.m_i_fsize =3D f->osd2.masix2.m_i_fsize;
- -		t->osd2.masix2.m_pad1 =3D ext2fs_swab16(f->osd2.masix2.m_pad1);
- -		t->osd2.masix2.m_i_reserved2[0] =3D
- -			ext2fs_swab32(f->osd2.masix2.m_i_reserved2[0]);
- -		t->osd2.masix2.m_i_reserved2[1] =3D
- -			ext2fs_swab32(f->osd2.masix2.m_i_reserved2[1]);
- -		break;
 	}

 	if (bufsize < (int) (sizeof(struct ext2_inode) + sizeof(__u16)))
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index a3dc4a1..afe3065 100644
- --- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -18,10 +18,6 @@ mke2fs \- create an ext2/ext3 filesystem
 .I block-size
 ]
 [
- -.B \-f
- -.I fragment-size
- -]
- -[
 .B \-g
 .I blocks-per-group
 ]
@@ -189,9 +185,6 @@ Reserve enough space so that the block group descri=
ptor table can grow
 to support a filesystem that has max-online-resize blocks.
 .RE
 .TP
- -.BI \-f " fragment-size"
- -Specify the size of fragments in bytes.
- -.TP
 .B \-F
 Force
 .B mke2fs
@@ -482,14 +475,6 @@ and exit.
 This version of
 .B mke2fs
 has been written by Theodore Ts'o <tytso@mit.edu>.
- -.SH BUGS
- -.B mke2fs
- -accepts the
- -.B \-f
- -option but currently ignores it because the second
- -extended file system does not support fragments yet.
- -.br
- -There may be other ones.  Please, report them to the author.
 .SH AVAILABILITY
 .B mke2fs
 is part of the e2fsprogs package and is available from
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4a6cace..f12d6d4 100644
- --- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -95,8 +95,7 @@ int linux_version_code =3D 0;
 static void usage(void)
 {
 	fprintf(stderr, _("Usage: %s [-c|-t|-l filename] [-b block-size] "
- -	"[-f fragment-size]\n\t[-i bytes-per-inode] [-I inode-size] "
- -	"[-j] [-J journal-options]\n"
+	"[-i bytes-per-inode]\n\t[-I inode-size] [-j] [-J journal-options]\n"
 	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
 	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
@@ -682,8 +681,6 @@ static void show_stats(ext2_filsys fs)
 	printf("\n");
 	printf(_("Block size=3D%u (log=3D%u)\n"), fs->blocksize,
 		s->s_log_block_size);
- -	printf(_("Fragment size=3D%u (log=3D%u)\n"), fs->fragsize,
- -		s->s_log_frag_size);
 	printf(_("%u inodes, %u blocks\n"), s->s_inodes_count,
 	       s->s_blocks_count);
 	printf(_("%u blocks (%2.2f%%) reserved for the super user\n"),
@@ -699,8 +696,7 @@ static void show_stats(ext2_filsys fs)
 		printf(_("%u block groups\n"), fs->group_desc_count);
 	else
 		printf(_("%u block group\n"), fs->group_desc_count);
- -	printf(_("%u blocks per group, %u fragments per group\n"),
- -	       s->s_blocks_per_group, s->s_frags_per_group);
+	printf(_("%u blocks per group\n"), s->s_blocks_per_group);
 	printf(_("%u inodes per group\n"), s->s_inodes_per_group);

 	if (fs->group_desc_count =3D=3D 1) {
@@ -740,8 +736,6 @@ static int set_os(struct ext2_super_block *sb, char=
 *os)
 		sb->s_creator_os =3D EXT2_OS_LINUX;
 	else if (strcasecmp(os, "GNU") =3D=3D 0 || strcasecmp(os, "hurd") =3D=
=3D 0)
 		sb->s_creator_os =3D EXT2_OS_HURD;
- -	else if (strcasecmp(os, "masix") =3D=3D 0)
- -		sb->s_creator_os =3D EXT2_OS_MASIX;
 	else if (strcasecmp(os, "freebsd") =3D=3D 0)
 		sb->s_creator_os =3D EXT2_OS_FREEBSD;
 	else if (strcasecmp(os, "lites") =3D=3D 0)
@@ -1018,16 +1012,6 @@ static void PRS(int argc, char *argv[])
 			cflag++;
 			break;
 		case 'f':
- -			size =3D strtoul(optarg, &tmp, 0);
- -			if (size < EXT2_MIN_BLOCK_SIZE ||
- -			    size > EXT2_MAX_BLOCK_SIZE || *tmp) {
- -				com_err(program_name, 0,
- -					_("invalid fragment size - %s"),
- -					optarg);
- -				exit(1);
- -			}
- -			fs_param.s_log_frag_size =3D
- -				int_log2(size >> EXT2_MIN_BLOCK_LOG_SIZE);
 			fprintf(stderr, _("Warning: fragments not supported.  "
 			       "Ignoring -f option\n"));
 			break;
@@ -1228,8 +1212,6 @@ static void PRS(int argc, char *argv[])
 		check_plausibility(device_name);
 	check_mount(device_name, force, _("filesystem"));

- -	fs_param.s_log_frag_size =3D fs_param.s_log_block_size;
- -
 	if (noaction && fs_param.s_blocks_count) {
 		dev_size =3D fs_param.s_blocks_count;
 		retval =3D 0;
@@ -1411,7 +1393,7 @@ static void PRS(int argc, char *argv[])
 			inode_ratio =3D blocksize;
 	}

- -	fs_param.s_log_frag_size =3D fs_param.s_log_block_size =3D
+	fs_param.s_log_block_size =3D
 		int_log2(blocksize >> EXT2_MIN_BLOCK_LOG_SIZE);

 	blocksize =3D EXT2_BLOCK_SIZE(&fs_param);
diff --git a/po/at-expand.pl b/po/at-expand.pl
index 6bd441f..fc0a597 100644
- --- a/po/at-expand.pl
+++ b/po/at-expand.pl
@@ -40,7 +40,7 @@ my @translator_help =3D (
  "#.	%Il	<inode> -> i_links_count\n",
  "#.	%Im	<inode> -> i_mode\n",
  "#.	%IM	<inode> -> i_mtime\n",
- - "#.	%IF	<inode> -> i_faddr\n",
+ "#.	%IF	<inode> -> i_obso_faddr\n",
  "#.	%If	<inode> -> i_file_acl\n",
  "#.	%Id	<inode> -> i_dir_acl\n",
  "#.	%Iu	<inode> -> i_uid\n",
diff --git a/po/ca.gmo b/po/ca.gmo
deleted file mode 100644
index b5380fc..0000000
Binary files a/po/ca.gmo and /dev/null differ
diff --git a/po/ca.po b/po/ca.po
index e5f75fe..9ffd99a 100644
- --- a/po/ca.po
+++ b/po/ca.po
@@ -42,7 +42,7 @@
 #. 	%Il	<inode> -> i_links_count
 #. 	%Im	<inode> -> i_mode
 #. 	%IM	<inode> -> i_mtime
- -#. 	%IF	<inode> -> i_faddr
+#. 	%IF	<inode> -> i_obso_faddr
 #. 	%If	<inode> -> i_file_acl
 #. 	%Id	<inode> -> i_dir_acl
 #. 	%Iu	<inode> -> i_uid
@@ -759,16 +759,6 @@ msgid ""
 "Either the @S or the partition table is likely to be corrupt!\n"
 msgstr ""

- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -#: e2fsck/problem.c:137
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr ""
- -
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 #: e2fsck/problem.c:144
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1630,11 +1620,6 @@ msgstr ""
 msgid "Second @e '%Dn' (@i=3D%Di) in @d @i %i @s '..'\n"
 msgstr ""

- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -#: e2fsck/problem.c:949
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr ""
- -
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 #: e2fsck/problem.c:954
 msgid "i_file_acl @F %If, @s zero.\n"
@@ -1645,16 +1630,6 @@ msgstr ""
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr ""

- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:964
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr ""
- -
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:969
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr ""
- -
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 #: e2fsck/problem.c:974
 msgid "@i %i (%Q) has @n mode (%Im).\n"
@@ -3248,8 +3223,8 @@ msgstr "En llegir la versi=C3=83=C2=B3 a %s"
 #: misc/mke2fs.c:97
 #, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-I inode-size] [-j] [-J journal-options]\n"
 "\t[-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator-o=
s]\n"
 "\t[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]=
\n"
 "\t[-O feature[,...]] [-r fs-revision] [-R options] [-qvSV]\n"
@@ -3396,11 +3371,6 @@ msgstr "Tipus de sistema operatiu: "
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr ""

- -#: misc/mke2fs.c:685
- -#, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr ""
- -
 #: misc/mke2fs.c:687
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3431,11 +3401,6 @@ msgstr ""
 msgid "%u block group\n"
 msgstr ""

- -#: misc/mke2fs.c:702
- -#, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr "%u blocs per grup, %u fragments per grup\n"
- -
 #: misc/mke2fs.c:704
 #, c-format
 msgid "%u inodes per group\n"
@@ -3508,11 +3473,6 @@ msgstr "mida de bloc inv=C3=83 lida - %s"
 msgid "Warning: blocksize %d not usable on most systems.\n"
 msgstr ""

- -#: misc/mke2fs.c:1025
- -#, c-format
- -msgid "invalid fragment size - %s"
- -msgstr "mida de fragment inv=C3=83 lida - %s"
- -
 #: misc/mke2fs.c:1031
 #, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"
diff --git a/po/cs.gmo b/po/cs.gmo
deleted file mode 100644
index c03f50f..0000000
Binary files a/po/cs.gmo and /dev/null differ
diff --git a/po/cs.po b/po/cs.po
index 5c3a363..7d2ec87 100644
- --- a/po/cs.po
+++ b/po/cs.po
@@ -42,7 +42,7 @@
 #. 	%Il	<inode> -> i_links_count
 #. 	%Im	<inode> -> i_mode
 #. 	%IM	<inode> -> i_mtime
- -#. 	%IF	<inode> -> i_faddr
+#. 	%IF	<inode> -> i_obos_faddr
 #. 	%If	<inode> -> i_file_acl
 #. 	%Id	<inode> -> i_dir_acl
 #. 	%Iu	<inode> -> i_uid
@@ -782,19 +782,6 @@ msgstr ""
 "Fyzick=C3=83=C2=A1 velikost za=C3=85=C2=99=C3=83=C2=ADzen=C3=83=C2=AD=
 je %c blok=C3=85=C2=AF\n"
 "Bu=C3=84=C2=8F superblok nebo tabulka odd=C3=83=C2=ADl=C3=85=C2=AF je=
 pravd=C3=84=C2=9Bpodobn=C3=84=C2=9B po=C3=85=C2=A1kozena!\n"

- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -#: e2fsck/problem.c:137
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr ""
- -"V superbloku block_size =3D %b, fragsize =3D %c.\n"
- -"Tato verze e2fsck nepodporuje velikosti fragment=C3=85=C2=AF r=C3=85=
=C2=AFzn=C3=83=C2=A9\n"
- -"od velikosti bloku.\n"
- -
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 #: e2fsck/problem.c:144
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1759,11 +1746,6 @@ msgid "Second @e '%Dn' (@i=3D%Di) in @d @i %i @s=
 '..'\n"
 msgstr ""
 "Druh=C3=83=C2=A1 polo=C3=85=C2=BEka '%Dn' (inode=3D%Di) v inode adres=
=C3=83=C2=A1=C3=85=C2=99e %i (%p) by m=C3=84=C2=9Bla b=C3=83=C2=BDt '..=
'\n"

- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -#: e2fsck/problem.c:949
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr "i_faddr pro inode %i (%Q) je %IF, m=C3=84=C2=9Bla by b=C3=83=
=C2=BDt nula.\n"
- -
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 #: e2fsck/problem.c:954
 msgid "i_file_acl @F %If, @s zero.\n"
@@ -1774,16 +1756,6 @@ msgstr "i_file_acl pro inode %i (%Q) je %If, m=C3=
=84=C2=9Blo by b=C3=83=C2=BDt nula.\n"
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr "i_dir_acl pro inode %i (%Q) je %N, m=C3=84=C2=9Blo by b=C3=83=C2=
=BDt nula.\n"

- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:964
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr "i_frag pro inode %i (%Q) je %N, m=C3=84=C2=9Blo by b=C3=83=C2=
=BDt nula.\n"
- -
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:969
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr "i_fsize pro inode %i (%Q) je %N, m=C3=84=C2=9Bla by b=C3=83=C2=
=BDt nula.\n"
- -
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 #: e2fsck/problem.c:974
 #, fuzzy
@@ -2037,7 +2009,7 @@ msgstr ""
 #: e2fsck/problem.c:1188
 #, fuzzy
 msgid "i_blocks_hi @F %N, @s zero.\n"
- -msgstr "i_fsize pro inode %i (%Q) je %N, m=C3=84=C2=9Bla by b=C3=83=C2=
=BDt nula.\n"
+msgstr "i_blocks_hi pro inode %i (%Q) je %N, m=C3=84=C2=9Bla by b=C3=83=
=C2=BDt nula.\n"

 #. @-expanded: Pass 3: Checking directory connectivity\n
 #: e2fsck/problem.c:1195
@@ -3507,15 +3479,14 @@ msgstr "P=C3=85=C2=99i =C3=84=C2=8Dten=C3=83=C2=
=AD verze %s"
 #: misc/mke2fs.c:97
 #, fuzzy, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-I inode-size] [-j] [-J journal-options]\n"
 "\t[-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator-o=
s]\n"
 "\t[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]=
\n"
 "\t[-O feature[,...]] [-r fs-revision] [-R options] [-qvSV]\n"
 "\tdevice [blocks-count]\n"
 msgstr ""
- -"Pou=C3=85=C2=BEit=C3=83=C2=AD: %s [-c|-t|-l n=C3=83=C2=A1zevsouboru=
] [-b velikost-bloku] [-f velkost-"
- -"fragmentu]\n"
+"Pou=C3=85=C2=BEit=C3=83=C2=AD: %s [-c|-t|-l n=C3=83=C2=A1zevsouboru] =
[-b velikost-bloku]\n"
 "\t[-i bajt=C3=85=C2=AF-v-inode] [-j] [-J p=C3=85=C2=99ep=C3=83=C2=ADn=
a=C3=84=C2=8De-=C3=85=C2=BEurn=C3=83=C2=A1lu] [-N po=C3=84=C2=8Det-inod=
e]\n"
 "\t[-m procenta-rezervovan=C3=83=C2=BDch-blok=C3=85=C2=AF] [-o tvo=C3=85=
=C2=99=C3=83=C2=ADc=C3=83=C2=AD-os] [-g blok=C3=85=C2=AF-ve-skupin=C3=84=
=C2=9B]\n"
 "\t[-L jmenovka-svazku] [-M adres=C3=83=C2=A1=C3=85=C2=99-posledn=C3=83=
=C2=ADho-p=C3=85=C2=99ipojen=C3=83=C2=AD]\n"
@@ -3669,11 +3640,6 @@ msgstr "Typ OS: "
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr "Velikost bloku=3D%u (log=3D%u)\n"

- -#: misc/mke2fs.c:685
- -#, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr "Velikost fragmentu=3D%u (log=3D%u)\n"
- -
 #: misc/mke2fs.c:687
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3704,11 +3670,6 @@ msgstr "%u skupin blok=C3=85=C2=AF\n"
 msgid "%u block group\n"
 msgstr "%u skupina blok=C3=85=C2=AF\n"

- -#: misc/mke2fs.c:702
- -#, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr "%u blok=C3=85=C2=AF ve skupin=C3=84=C2=9B, %u fragment=C3=85=
=C2=AF ve skupin=C3=84=C2=9B\n"
- -
 #: misc/mke2fs.c:704
 #, c-format
 msgid "%u inodes per group\n"
@@ -3789,11 +3750,6 @@ msgstr "=C3=85=C2=A1patn=C3=83=C2=A1 velikost bl=
oku - %s"
 msgid "Warning: blocksize %d not usable on most systems.\n"
 msgstr "Varov=C3=83=C2=A1n=C3=83=C2=AD: velikost bloku %d nen=C3=83=C2=
=AD na v=C3=84=C2=9Bt=C3=85=C2=A1in=C3=84=C2=9B syst=C3=83=C2=A9m=C3=85=
=C2=AF pou=C3=85=C2=BEiteln=C3=83=C2=A1.\n"

- -#: misc/mke2fs.c:1025
- -#, fuzzy, c-format
- -msgid "invalid fragment size - %s"
- -msgstr "=C3=85=C2=A1patn=C3=83=C2=A1 velikost fragmentu - %s"
- -
 #: misc/mke2fs.c:1031
 #, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"
diff --git a/po/de.gmo b/po/de.gmo
deleted file mode 100644
index 95f706a..0000000
Binary files a/po/de.gmo and /dev/null differ
diff --git a/po/de.po b/po/de.po
index b29f3f8..36e63ad 100644
- --- a/po/de.po
+++ b/po/de.po
@@ -42,7 +42,7 @@
 #. 	%Il	<inode> -> i_links_count
 #. 	%Im	<inode> -> i_mode
 #. 	%IM	<inode> -> i_mtime
- -#. 	%IF	<inode> -> i_faddr
+#. 	%IF	<inode> -> i_obso_faddr
 #. 	%If	<inode> -> i_file_acl
 #. 	%Id	<inode> -> i_dir_acl
 #. 	%Iu	<inode> -> i_uid
@@ -784,19 +784,6 @@ msgstr ""
 "Die physikalische Gr=C3=B6=C3=9Fe von @v ist %c @bs\n"
 "Entweder der @S oder die Partionstabelle ist besch=C3=A4digt!\n"

- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -#: e2fsck/problem.c:137
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"Diese Version von e2fsck unterst=C3=BCtzt keine von @b-Gr=C3=B6=C3=9F=
en verschiedene "
- -"Fragmentgr=C3=B6=C3=9Fen.\n"
- -
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 #: e2fsck/problem.c:144
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1737,11 +1724,6 @@ msgstr "Erster @e '%Dn' (inode=3D%Di) in @d @i %=
i (%p) @s '.'\n"
 msgid "Second @e '%Dn' (@i=3D%Di) in @d @i %i @s '..'\n"
 msgstr "Zweiter @e '%Dn' (inode=3D%Di) in @d @i %i @s '..'\n"

- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -#: e2fsck/problem.c:949
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr "i_faddr @F %IF, @s null.\n"
- -
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 #: e2fsck/problem.c:954
 msgid "i_file_acl @F %If, @s zero.\n"
@@ -1752,16 +1734,6 @@ msgstr "i_file_acl @F %If, @s null.\n"
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr "i_dir_acl @F %Id, @s null.\n"

- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:964
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr "i_frag @F %N, @s null.\n"
- -
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:969
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr "i_fsize @F %N, @s null.\n"
- -
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 #: e2fsck/problem.c:974
 #, fuzzy
@@ -2008,7 +1980,7 @@ msgstr ""
 #: e2fsck/problem.c:1188
 #, fuzzy
 msgid "i_blocks_hi @F %N, @s zero.\n"
- -msgstr "i_fsize @F %N, @s null.\n"
+msgstr "i_blocks_hi @F %N, @s null.\n"

 #. @-expanded: Pass 3: Checking directory connectivity\n
 #: e2fsck/problem.c:1195
@@ -3480,15 +3452,15 @@ msgstr "Beim Lesen der Version von %s"
 #: misc/mke2fs.c:97
 #, fuzzy, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-I inode-size] [-j] [-J journal-options]\n"
 "\t[-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator-o=
s]\n"
 "\t[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]=
\n"
 "\t[-O feature[,...]] [-r fs-revision] [-R options] [-qvSV]\n"
 "\tdevice [blocks-count]\n"
 msgstr ""
- -"Verwendung: %s [-c|-t|-l Dateiname] [-b Blockgr=C3=B6=C3=9Fe] [-f F=
ragmentgr=C3=B6=C3=9Fe]\n"
- -"\t[-i Bytes-pro-Inode] [-j] [-J Journal-Optionen] [-N Anzahl_der_In=
oden]\n"
+"Verwendung: %s [-c|-t|-l Dateiname] [-b Blockgr=C3=B6=C3=9Fe] [-i Byt=
es-pro-Inode]\n"
+"\t[-j] [-J Journal-Optionen] [-N Anzahl_der_Inoden]\n"
 "\t[-m Reservierte-Bl=C3=B6cke-Prozent] [-o creator-os] [-g Bl=C3=B6ck=
e-pro-Gruppe]\n"
 "\t[-L volume-label] [-M last-mounted-directory] [-O feature[,...]]\n"
 "\t[-r fs-revision] [-R raid_opts] [-qvSV] Ger=C3=A4t [Blockanzahl]\n"
@@ -3643,11 +3615,6 @@ msgstr "OS-Typ: "
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr "Blockgr=C3=B6=C3=9Fe=3D%u (log=3D%u)\n"

- -#: misc/mke2fs.c:685
- -#, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr "Fragmentgr=C3=B6=C3=9Fe=3D%u (log=3D%u)\n"
- -
 #: misc/mke2fs.c:687
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3678,11 +3645,6 @@ msgstr "%u Blockgruppen\n"
 msgid "%u block group\n"
 msgstr "%u Blockgruppe\n"

- -#: misc/mke2fs.c:702
- -#, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr "%u Bl=C3=B6cke pro Gruppe, %u Fragmente pro Gruppe\n"
- -
 #: misc/mke2fs.c:704
 #, c-format
 msgid "%u inodes per group\n"
@@ -3766,11 +3728,6 @@ msgstr "bad block Gr=C3=B6=C3=9Fe - %s"
 msgid "Warning: blocksize %d not usable on most systems.\n"
 msgstr "Warnung: Blockgr=C3=B6=C3=9Fe %d ist auf den meisten Systemen =
unbrauchbar.\n"

- -#: misc/mke2fs.c:1025
- -#, fuzzy, c-format
- -msgid "invalid fragment size - %s"
- -msgstr "falsche Fragmentgr=C3=B6=C3=9Fe - %s"
- -
 #: misc/mke2fs.c:1031
 #, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"
diff --git a/po/e2fsprogs.pot b/po/e2fsprogs.pot
index 25c1ee1..972e46f 100644
- --- a/po/e2fsprogs.pot
+++ b/po/e2fsprogs.pot
@@ -42,7 +42,7 @@
 #.	%Il	<inode> -> i_links_count
 #.	%Im	<inode> -> i_mode
 #.	%IM	<inode> -> i_mtime
- -#.	%IF	<inode> -> i_faddr
+#.	%IF	<inode> -> i_obso_faddr
 #.	%If	<inode> -> i_file_acl
 #.	%Id	<inode> -> i_dir_acl
 #.	%Iu	<inode> -> i_uid
@@ -760,16 +760,6 @@ msgid ""
 "Either the @S or the partition table is likely to be corrupt!\n"
 msgstr ""

- -#: e2fsck/problem.c:137
- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr ""
- -
 #: e2fsck/problem.c:144
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1632,11 +1622,6 @@ msgstr ""
 msgid "Second @e '%Dn' (@i=3D%Di) in @d @i %i @s '..'\n"
 msgstr ""

- -#: e2fsck/problem.c:949
- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr ""
- -
 #: e2fsck/problem.c:954
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 msgid "i_file_acl @F %If, @s zero.\n"
@@ -1647,16 +1632,6 @@ msgstr ""
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr ""

- -#: e2fsck/problem.c:964
- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr ""
- -
- -#: e2fsck/problem.c:969
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr ""
- -
 #: e2fsck/problem.c:974
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 msgid "@i %i (%Q) has @n mode (%Im).\n"
@@ -3255,8 +3230,8 @@ msgstr ""
 #: misc/mke2fs.c:97
 #, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-I inode-size] [-j] [-J journal-options]\n"
 "\t[-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator-o=
s]\n"
 "\t[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]=
\n"
 "\t[-O feature[,...]] [-r fs-revision] [-R options] [-qvSV]\n"
@@ -3403,11 +3378,6 @@ msgstr ""
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr ""

- -#: misc/mke2fs.c:685
- -#, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr ""
- -
 #: misc/mke2fs.c:687
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3438,11 +3408,6 @@ msgstr ""
 msgid "%u block group\n"
 msgstr ""

- -#: misc/mke2fs.c:702
- -#, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr ""
- -
 #: misc/mke2fs.c:704
 #, c-format
 msgid "%u inodes per group\n"
@@ -3515,11 +3480,6 @@ msgstr ""
 msgid "Warning: blocksize %d not usable on most systems.\n"
 msgstr ""

- -#: misc/mke2fs.c:1025
- -#, c-format
- -msgid "invalid fragment size - %s"
- -msgstr ""
- -
 #: misc/mke2fs.c:1031
 #, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"
diff --git a/po/es.gmo b/po/es.gmo
deleted file mode 100644
index 23d22c2..0000000
Binary files a/po/es.gmo and /dev/null differ
diff --git a/po/es.po b/po/es.po
index cf683d7..d4dbdf8 100644
- --- a/po/es.po
+++ b/po/es.po
@@ -41,7 +41,7 @@
 #. 	%Il	<inode> -> i_links_count
 #. 	%Im	<inode> -> i_mode
 #. 	%IM	<inode> -> i_mtime
- -#. 	%IF	<inode> -> i_faddr
+#. 	%IF	<inode> -> i_obso_faddr
 #. 	%If	<inode> -> i_file_acl
 #. 	%Id	<inode> -> i_dir_acl
 #. 	%Iu	<inode> -> i_uid
@@ -786,19 +786,6 @@ msgstr ""
 "El tama=C3=B1o f=C3=ADsico del @v es de %c @bs\n"
 "=C2=A1Puede ser que, o el @S, o la tabla de partici=C3=B3n, est=C3=A9=
n corrompidos!\n"

- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -#: e2fsck/problem.c:137
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr ""
- -"tama=C3=B1o_del_@b =3D %b del @S, tama=C3=B1o del fragmento =3D %c.=
\n"
- -"Esta versi=C3=B3n de e2fsck no tiene implementado el manejo de tama=
=C3=B1os de\n"
- -"fragmentos distintos al tama=C3=B1o del @b.\n"
- -
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 #: e2fsck/problem.c:144
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1755,11 +1742,6 @@ msgstr "La primera @e '%Dn' (nodo i=3D%Di) en el=
 @i del @d %i (%p) @s '.'\n"
 msgid "Second @e '%Dn' (@i=3D%Di) in @d @i %i @s '..'\n"
 msgstr "La segunda @e '%Dn' (nodo i=3D%Di) en el @i del @d %i @s '..'\=
n"

- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -#: e2fsck/problem.c:949
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr "El i_faddr @F %IF, @s cero.\n"
- -
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 #: e2fsck/problem.c:954
 msgid "i_file_acl @F %If, @s zero.\n"
@@ -1770,16 +1752,6 @@ msgstr "El i_file_acl @F %If, %s cero.\n"
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr "El i_dir_acl @F %Id, @s cero.\n"

- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:964
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr "El i_frag @F %N, @s cero.\n"
- -
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:969
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr "El i_fsize @F %N, @s cero.\n"
- -
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 #: e2fsck/problem.c:974
 #, fuzzy
@@ -2033,7 +2005,7 @@ msgstr ""
 #: e2fsck/problem.c:1188
 #, fuzzy
 msgid "i_blocks_hi @F %N, @s zero.\n"
- -msgstr "El i_fsize @F %N, @s cero.\n"
+msgstr "El i_blocks_hi @F %N, @s cero.\n"

 #. @-expanded: Pass 3: Checking directory connectivity\n
 #: e2fsck/problem.c:1195
@@ -3531,18 +3503,17 @@ msgstr "Mientras se le=C3=ADa la versi=C3=B3n e=
n %s"
 #: misc/mke2fs.c:97
 #, fuzzy, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-I inode-size] [-j] [-J journal-options]\n"
 "\t[-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator-o=
s]\n"
 "\t[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]=
\n"
 "\t[-O feature[,...]] [-r fs-revision] [-R options] [-qvSV]\n"
 "\tdevice [blocks-count]\n"
 msgstr ""
 "Modo de empleo: %s [-c|-t|-l nombredelfichero] [-b tama=C3=B1o-del-bl=
oque]\n"
- -"\t[-f tama=C3=B1o-del fragmento] [-i bytes-por-nodo-i] [-j] \n"
- -"\t[-J opciones-de-fichero-de-transacciones] [-N n=C3=BAmero-de-nodo=
s-i]\n"
- -"\t[-m porcentaje-de-bloques-reservados] [-o so-creador]\n"
- -"\t[-g bloques-por-grupo] [-L etiqueta-de-volumen]\n"
+"\t[-i bytes-por-nodo-i] [-j] [-J opciones-de-fichero-de-transacciones=
]\n"
+"\t[-N n=C3=BAmero-de-nodos-i] [-m porcentaje-de-bloques-reservados]\n=
"
+"\t[-o so-creador] [-g bloques-por-grupo] [-L etiqueta-de-volumen]\n"
 "\t[-M =C3=BAltimo-directorio-montado] [-O caracter=C3=ADstica[,...]]\=
n"
 " \t[-r revisi=C3=B3n-del-fs] [-R opciones-raid]\n"
 "\t[-qsSV] dispositivo [cuenta-de-bloques]\n"
@@ -3702,11 +3673,6 @@ msgstr "Tipo de SO: "
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr "Tama=C3=B1o del bloque=3D%u (bit=C3=A1cora=3D%u)\n"

- -#: misc/mke2fs.c:685
- -#, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr "Tama=C3=B1o del fragmento=3D%u (bit=C3=A1cora=3D%u)\n"
- -
 #: misc/mke2fs.c:687
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3737,11 +3703,6 @@ msgstr "%u bloque de grupos\n"
 msgid "%u block group\n"
 msgstr "%u bloque de grupo\n"

- -#: misc/mke2fs.c:702
- -#, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr "%u bloques por grupo, %u fragmentos por grupo\n"
- -
 #: misc/mke2fs.c:704
 #, c-format
 msgid "%u inodes per group\n"
@@ -3827,11 +3788,6 @@ msgid "Warning: blocksize %d not usable on most =
systems.\n"
 msgstr ""
 "Cuidado: el tama=C3=B1o del bloque %d no se puede utilizar en muchos =
sistemas.\n"

- -#: misc/mke2fs.c:1025
- -#, fuzzy, c-format
- -msgid "invalid fragment size - %s"
- -msgstr "Tama=C3=B1o incorrecto del fragmento - %s"
- -
 #: misc/mke2fs.c:1031
 #, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"
diff --git a/po/fr.gmo b/po/fr.gmo
deleted file mode 100644
index 197b073..0000000
Binary files a/po/fr.gmo and /dev/null differ
diff --git a/po/fr.po b/po/fr.po
index 1c2bee3..7b276ac 100644
- --- a/po/fr.po
+++ b/po/fr.po
@@ -41,7 +41,7 @@
 #. 	%Il	<inode> -> i_links_count
 #. 	%Im	<inode> -> i_mode
 #. 	%IM	<inode> -> i_mtime
- -#. 	%IF	<inode> -> i_faddr
+#. 	%IF	<inode> -> i_obso_faddr
 #. 	%If	<inode> -> i_file_acl
 #. 	%Id	<inode> -> i_dir_acl
 #. 	%Iu	<inode> -> i_uid
@@ -720,19 +720,6 @@ msgstr ""
 "La taille physique du @v est de %c @bs\n"
 "Le @S ou la table des partitions est peut-=C3=AAtre corrompue !\n"

- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -#: e2fsck/problem.c:137
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"Cette version d'e2fsck ne supporte pas les fragments de tailles dif=
f=C3=A9rentes\n"
- -"de la taille des @b.\n"
- -
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 #: e2fsck/problem.c:144
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1658,11 +1645,6 @@ msgstr "La premi=C3=A8re @e =C2=AB %Dn =C2=BB (@=
i=3D%Di) dans l'@i de @d %i (%p) @s =C2=AB . =C2=BB\n"
 msgid "Second @e '%Dn' (@i=3D%Di) in @d @i %i @s '..'\n"
 msgstr "La seconde @e =C2=AB %Dn =C2=BB (@i=3D%Di) dans l'@i de @d %i =
@s =C2=AB .. =C2=BB\n"

- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -#: e2fsck/problem.c:939
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr "i_faddr @F %IF, @s z=C3=A9ro.\n"
- -
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 #: e2fsck/problem.c:944
 msgid "i_file_acl @F %If, @s zero.\n"
@@ -1673,16 +1655,6 @@ msgstr "i_file_acl @F %If, @s z=C3=A9ro.\n"
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr "i_dir_acl @F %Id, @s z=C3=A9ro.\n"

- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:954
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr "i_frag @F %N, @s z=C3=A9ro.\n"
- -
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:959
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr "i_fsize @F %N, @s z=C3=A9ro.\n"
- -
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 #: e2fsck/problem.c:964
 msgid "@i %i (%Q) has @n mode (%Im).\n"
@@ -3370,16 +3342,15 @@ msgstr "Lors de la lecture de la version sur %s=
"
 #: misc/mke2fs.c:96
 #, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-j] [-J journal-options] [-N number-of-inod=
es]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-j] [-J journal-options] [-N number-of-inodes]\n"
 "\t[-m reserved-blocks-percentage] [-o creator-os] [-g blocks-per-grou=
p]\n"
 "\t[-L volume-label] [-M last-mounted-directory] [-O feature[,...]]\n"
 "\t[-r fs-revision] [-R options] [-qvSV] device [blocks-count]\n"
 msgstr ""
 "Usage : %s [-c|-t|-l nom-de-fichier] [-b taille-de-bloc]\n"
- -"\t[-f taille-de-fragment] [-i octets-par-i-noeud] [-j]\n"
- -"\t[-J options-journal] [-N nombre-d-i-noeuds]\n"
- -"\t[-m pourcentage-de-blocs-r=C3=A9serv=C3=A9s]\n"
+"\t[-i octets-par-i-noeud] [-j] [-J options-journal]\n"
+"\t[-N nombre-d-i-noeuds] [-m pourcentage-de-blocs-r=C3=A9serv=C3=A9s]=
\n"
 "\t[-o syst=C3=A8me-d-exploitation-de-cr=C3=A9ation] [-g blocs-par-gro=
upe]\n"
 "\t[-L =C3=A9tiquette-du-volume] [-M dernier-r=C3=A9pertoire-mont=C3=A9=
]\n"
 "\t[-O fonctionnalit=C3=A9s [,...]] [-r r=C3=A9vision-du-syst=C3=A8me-=
de-fichier]\n"
@@ -3537,11 +3508,6 @@ msgstr "Type de syst=C3=A8me d'exploitation : "
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr "Taille de bloc=3D%u (log=3D%u)\n"

- -#: misc/mke2fs.c:638
- -#, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr "Taille de fragment=3D%u (log=3D%u)\n"
- -
 #: misc/mke2fs.c:640
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3572,11 +3538,6 @@ msgstr "%u groupes de blocs\n"
 msgid "%u block group\n"
 msgstr "%u groupe de bloc\n"

- -#: misc/mke2fs.c:655
- -#, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr "%u blocs par groupe, %u fragments par groupe\n"
- -
 #: misc/mke2fs.c:657
 #, c-format
 msgid "%u inodes per group\n"
@@ -3661,11 +3622,6 @@ msgstr ""
 "Avertissement : la taille de bloc %d n'est pas utilisable\n"
 "sur la plupart des syst=C3=A8mes.\n"

- -#: misc/mke2fs.c:959
- -#, c-format
- -msgid "invalid fragment size - %s"
- -msgstr "taille de fragment invalide - %s"
- -
 #: misc/mke2fs.c:965
 #, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"
diff --git a/po/it.gmo b/po/it.gmo
deleted file mode 100644
index 61e87c4..0000000
Binary files a/po/it.gmo and /dev/null differ
diff --git a/po/it.po b/po/it.po
index 5c069a0..4ee517b 100644
- --- a/po/it.po
+++ b/po/it.po
@@ -43,7 +43,7 @@
 #. 	%Il	<inode> -> i_links_count
 #. 	%Im	<inode> -> i_mode
 #. 	%IM	<inode> -> i_mtime
- -#. 	%IF	<inode> -> i_faddr
+#. 	%IF	<inode> -> i_obso_faddr
 #. 	%If	<inode> -> i_file_acl
 #. 	%Id	<inode> -> i_dir_acl
 #. 	%Iu	<inode> -> i_uid
@@ -782,19 +782,6 @@ msgstr ""
 "La dimensione fisica del @v =C3=A8 %c @b(i)\n"
 "=C3=88 probabile che il @S o la tavola delle partizioni siano corrott=
i!\n"

- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -#: e2fsck/problem.c:137
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr ""
- -"Dimensione del @b del @S =3D %b, dimensione frammento =3D %c.\n"
- -"Questa versione di e2fsck non supporta dimensioni di frammento\n"
- -"differenti dalla dimensione del @b.\n"
- -
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 #: e2fsck/problem.c:144
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1765,12 +1752,6 @@ msgstr "Il primo @e '%Dn' (inode=3D%Di) nell'@i =
%i della @d (%p) @s '.'\n"
 msgid "Second @e '%Dn' (@i=3D%Di) in @d @i %i @s '..'\n"
 msgstr "Il secondo @e '%Dn' (inode=3D%Di) nell'@i %i della @d (%p) @s =
'.'\n"

- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -#: e2fsck/problem.c:949
- -#, fuzzy
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr "i_faddr @F %IF @s zero.\n"
- -
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 #: e2fsck/problem.c:954
 #, fuzzy
@@ -1783,18 +1764,6 @@ msgstr "i_file_acl @F %If @s zero.\n"
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr "i_dir_acl @F %Id @s zero.\n"

- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:964
- -#, fuzzy
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr "i_frag @F %N @s zero.\n"
- -
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:969
- -#, fuzzy
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr "i_fsize @F %N @s zero.\n"
- -
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 #: e2fsck/problem.c:974
 #, fuzzy
@@ -2048,7 +2017,7 @@ msgstr ""
 #: e2fsck/problem.c:1188
 #, fuzzy
 msgid "i_blocks_hi @F %N, @s zero.\n"
- -msgstr "i_fsize @F %N @s zero.\n"
+msgstr "i_blocks_hi @F %N @s zero.\n"

 #. @-expanded: Pass 3: Checking directory connectivity\n
 #: e2fsck/problem.c:1195
@@ -3530,15 +3499,15 @@ msgstr "Durante la lettura della versione di %s=
"
 #: misc/mke2fs.c:97
 #, fuzzy, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-I inode-size] [-j] [-J journal-options]\n"
 "\t[-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator-o=
s]\n"
 "\t[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]=
\n"
 "\t[-O feature[,...]] [-r fs-revision] [-R options] [-qvSV]\n"
 "\tdevice [blocks-count]\n"
 msgstr ""
- -"Uso: %s [-c|-t|-l nomefile] [-b dim_blocchi] [-f dim_frammento]\n"
- -"\t[-i byte-per-inode] [-j] [-J opzioni-journal] [-N numero-di-inode=
]\n"
+"Uso: %s [-c|-t|-l nomefile] [-b dim_blocchi] [-i byte-per-inode]\n"
+"\t[-j] [-J opzioni-journal] [-N numero-di-inode]\n"
 "\t[-m percentuale-blocchi-riservati] [-o os-origine] [-g blocchi-per-=
"
 "gruppo]\n"
 "\t[-L etichetta-volume] [-M ultima-dir-montata] [-O caratteristica[,.=
=2E.]]\n"
@@ -3695,11 +3664,6 @@ msgstr "Tipo SO: "
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr "Dimensione blocco=3D%u (log=3D%u)\n"

- -#: misc/mke2fs.c:685
- -#, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr "Dimensione frammento=3D%u (log=3D%u)\n"
- -
 #: misc/mke2fs.c:687
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3730,11 +3694,6 @@ msgstr "%u gruppi di blocchi\n"
 msgid "%u block group\n"
 msgstr "%u gruppo di blocchi\n"

- -#: misc/mke2fs.c:702
- -#, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr "%u blocchi per gruppo, %u frammenti per gruppo\n"
- -
 #: misc/mke2fs.c:704
 #, c-format
 msgid "%u inodes per group\n"
@@ -3817,11 +3776,6 @@ msgid "Warning: blocksize %d not usable on most =
systems.\n"
 msgstr ""
 "Attenzione: la dimensione di blocco %d non =C3=A8 utilizzabile su mol=
ti sistemi.\n"

- -#: misc/mke2fs.c:1025
- -#, fuzzy, c-format
- -msgid "invalid fragment size - %s"
- -msgstr "dimensione del frammento non valida - %s"
- -
 #: misc/mke2fs.c:1031
 #, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"
diff --git a/po/nl.gmo b/po/nl.gmo
deleted file mode 100644
index 585bc89..0000000
Binary files a/po/nl.gmo and /dev/null differ
diff --git a/po/nl.po b/po/nl.po
index efd1d3d..44e4f81 100644
- --- a/po/nl.po
+++ b/po/nl.po
@@ -41,7 +41,7 @@
 #. 	%Il	<inode> -> i_links_count
 #. 	%Im	<inode> -> i_mode
 #. 	%IM	<inode> -> i_mtime
- -#. 	%IF	<inode> -> i_faddr
+#. 	%IF	<inode> -> i_obso_faddr
 #. 	%If	<inode> -> i_file_acl
 #. 	%Id	<inode> -> i_dir_acl
 #. 	%Iu	<inode> -> i_uid
@@ -775,19 +775,6 @@ msgstr ""
 "De fysieke grootte van het apparaat is %c blokken.\n"
 "Waarschijnlijk is ofwel het superblok ofwel de partitietabel beschadi=
gd!\n"

- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -#: e2fsck/problem.c:137
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr ""
- -"Superblok: blokgrootte =3D %b, fragmentgrootte =3D %c.\n"
- -"Deze versie van e2fsck ondersteunt geen fragmentgrootte\n"
- -"verschillend van de blokgrootte.\n"
- -
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 #: e2fsck/problem.c:144
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1744,11 +1731,6 @@ msgstr "Eerste item '%Dn' (inode=3D%Di) in map-i=
node %i (%p) moet '.' zijn.\n"
 msgid "Second @e '%Dn' (@i=3D%Di) in @d @i %i @s '..'\n"
 msgstr "Tweede item '%Dn' (inode=3D%Di) in map-inode %i moet '..' zijn=
=2E\n"

- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -#: e2fsck/problem.c:949
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr "'i_faddr' @F is %IF, moet nul zijn.\n"
- -
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 #: e2fsck/problem.c:954
 msgid "i_file_acl @F %If, @s zero.\n"
@@ -1759,16 +1741,6 @@ msgstr "'i_file_acl' @F is %If, moet nul zijn.\n=
"
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr "'i_dir_acl' @F is %Id, moet nul zijn.\n"

- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:964
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr "'i_frag' @F is %N, moet nul zijn.\n"
- -
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:969
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr "'i_fsize' @F is %N, moet nul zijn.\n"
- -
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 #: e2fsck/problem.c:974
 msgid "@i %i (%Q) has @n mode (%Im).\n"
@@ -3494,16 +3466,16 @@ msgstr "Tijdens lezen van versie op %s"
 #: misc/mke2fs.c:97
 #, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-I inode-size] [-j] [-J journal-options]\n"
 "\t[-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator-o=
s]\n"
 "\t[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]=
\n"
 "\t[-O feature[,...]] [-r fs-revision] [-R options] [-qvSV]\n"
 "\tdevice [blocks-count]\n"
 msgstr ""
- -"Gebruik:  %s [-b blokgrootte] [-c|-l bestandsnaam] [-f fragmentgroo=
tte]\n"
- -"          [-g blokken_per_groep] [-i bytes_per_inode] [-I inode-gro=
otte]\n"
- -"          [-j] [-J journalopties] [-L label] [-M laatst_aangekoppel=
de_map]\n"
+"Gebruik:  %s [-b blokgrootte] [-c|-l bestandsnaam] [-g blokken_per_gr=
oep]\n"
+"          [-i bytes_per_inode] [-I inode-grootte] [-j] [-J journalopt=
ies]\n"
+"          [-L label] [-M laatst_aangekoppelde_map]\n"
 "          [-m percentage_gereserveerde_blokken] [-N aantal_inodes]\n"
 "          [-o naam_van_aanmakende_besturingssyteem] [-O functie[,...]=
]\n"
 "          [-r bestandssysteemversie] [-R opties] [-T bestandssysteemt=
ype]\n"
@@ -3659,11 +3631,6 @@ msgstr "Soort besturingssysteem: "
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr "Blokgrootte=3D%u (log=3D%u)\n"

- -#: misc/mke2fs.c:685
- -#, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr "Fragmentgrootte=3D%u (log=3D%u)\n"
- -
 #: misc/mke2fs.c:687
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3694,11 +3661,6 @@ msgstr "%u blokgroepen\n"
 msgid "%u block group\n"
 msgstr "%u blokgroep\n"

- -#: misc/mke2fs.c:702
- -#, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr "%u blokken per groep, %u fragmenten per groep\n"
- -
 # src/main.c:425
 #: misc/mke2fs.c:704
 #, c-format
@@ -3788,11 +3750,6 @@ msgid "Warning: blocksize %d not usable on most =
systems.\n"
 msgstr ""
 "Waarschuwing: blokgrootte %d is op de meeste systemen niet bruikbaar.=
\n"

- -#: misc/mke2fs.c:1025
- -#, c-format
- -msgid "invalid fragment size - %s"
- -msgstr "ongeldige fragmentgrootte: %s"
- -
 #: misc/mke2fs.c:1031
 #, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"
diff --git a/po/pl.gmo b/po/pl.gmo
deleted file mode 100644
index 7dc3a82..0000000
Binary files a/po/pl.gmo and /dev/null differ
diff --git a/po/pl.po b/po/pl.po
index dbd6445..533554f 100644
- --- a/po/pl.po
+++ b/po/pl.po
@@ -42,7 +42,7 @@
 #. 	%Il	<inode> -> i_links_count
 #. 	%Im	<inode> -> i_mode
 #. 	%IM	<inode> -> i_mtime
- -#. 	%IF	<inode> -> i_faddr
+#. 	%IF	<inode> -> i_obso_faddr
 #. 	%If	<inode> -> i_file_acl
 #. 	%Id	<inode> -> i_dir_acl
 #. 	%Iu	<inode> -> i_uid
@@ -773,19 +773,6 @@ msgstr ""
 "Fizyczny rozmiar urz=C2=B1dzenia wynosi %c @b=C3=B3w\n"
 "Mo=C2=BFliwe, =C2=BFe @S albo tablica partycji jest uszkodzona!\n"

- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -#: e2fsck/problem.c:137
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr ""
- -"W @Su block_size (rozm. bloku) =3D %b, fragsize (rozm. fragmentu) =3D=
 %c.\n"
- -"Ta wersja e2fsck nie obs=C2=B3uguje rozmiar=C3=B3w fragmentu r=C3=B3=
=C2=BFnych od rozmiaru\n"
- -"@bu.\n"
- -
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 #: e2fsck/problem.c:144
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1696,11 +1683,6 @@ msgstr "Pierwszym @eem '%Dn' (@i=3D%Di) w i-w=C3=
=AA=C2=BCle @du %i (%p) @s '.'\n"
 msgid "Second @e '%Dn' (@i=3D%Di) in @d @i %i @s '..'\n"
 msgstr "Drugim @eem '%Dn' (@i=3D%Di) w i-w=C3=AA=C2=BCle @du %i @s '..=
'\n"

- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -#: e2fsck/problem.c:949
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr "i_faddr @F %IF, @s zero.\n"
- -
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 #: e2fsck/problem.c:954
 msgid "i_file_acl @F %If, @s zero.\n"
@@ -1711,16 +1693,6 @@ msgstr "i_file_acl @F %If, @s zero.\n"
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr "i_dir_acl @F %Id, @s zero.\n"

- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:964
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr "i_frag @F %N, @s zero.\n"
- -
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:969
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr "i_fsize @F %N, @s zero.\n"
- -
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 #: e2fsck/problem.c:974
 msgid "@i %i (%Q) has @n mode (%Im).\n"
@@ -3408,17 +3380,17 @@ msgstr "Podczas odczytu wersji %s"
 #: misc/mke2fs.c:97
 #, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-I inode-size] [-j] [-J journal-options]\n"
 "\t[-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator-o=
s]\n"
 "\t[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]=
\n"
 "\t[-O feature[,...]] [-r fs-revision] [-R options] [-qvSV]\n"
 "\tdevice [blocks-count]\n"
 msgstr ""
- -"Sk=C2=B3adnia: %s [-c|-t|-l nazwa-pliku] [-b rozm.bloku] [-f rozm.f=
ragm.]\n"
- -"\t[-i bajt=C3=B3w-na-i-w=C3=AAze=C2=B3] [-I rozm-i-w=C3=AAz=C2=B3a]=
 [-j] [-J opcje-kroniki]\n"
- -"\t[-N liczba-i-w=C3=AAz=C2=B3=C3=B3w] [-m procent-rezerw.-blok=C3=B3=
w] [-o os-tw=C3=B3rcy]\n"
- -"\t[-g blok=C3=B3w-w-grupie] [-L etykieta-wolumenu] [-M ost.-mont.-k=
atalog]\n"
+"Sk=C2=B3adnia: %s [-c|-t|-l nazwa-pliku] [-b rozm.bloku] [-i bajt=C3=B3=
w-na-i-w=C3=AAze=C2=B3]\n"
+"\t[-I rozm-i-w=C3=AAz=C2=B3a] [-j] [-J opcje-kroniki] [-N liczba-i-w=C3=
=AAz=C2=B3=C3=B3w]\n"
+"\t[-m procent-rezerw.-blok=C3=B3w] [-o os-tw=C3=B3rcy] [-g blok=C3=B3=
w-w-grupie]\n"
+"\t[-L etykieta-wolumenu] [-M ost.-mont.-katalog]\n"
 "\t[-O cecha[,...]] [-r wersja-fs] [-R opcje] [-qvSV]\n"
 "\turz=C2=B1dzenie [liczba-blok=C3=B3w]\n"

@@ -3569,11 +3541,6 @@ msgstr "Typ OS: "
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr "Rozmiar bloku=3D%u (log=3D%u)\n"

- -#: misc/mke2fs.c:685
- -#, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr "Rozmiar fragmentu=3D%u (log=3D%u)\n"
- -
 #: misc/mke2fs.c:687
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3604,11 +3571,6 @@ msgstr "%u grup blok=C3=B3w\n"
 msgid "%u block group\n"
 msgstr "%u grupa blok=C3=B3w\n"

- -#: misc/mke2fs.c:702
- -#, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr "%u blok=C3=B3w w grupie, %u fragment=C3=B3w w grupie\n"
- -
 #: misc/mke2fs.c:704
 #, c-format
 msgid "%u inodes per group\n"
@@ -3693,11 +3655,6 @@ msgstr "b=C2=B3=C3=AAdny rozmiar bloku - %s"
 msgid "Warning: blocksize %d not usable on most systems.\n"
 msgstr "Uwaga: rozmiar bloku %d nie u=C2=BFywalny na wi=C3=AAkszo=C2=B6=
ci system=C3=B3w.\n"

- -#: misc/mke2fs.c:1025
- -#, c-format
- -msgid "invalid fragment size - %s"
- -msgstr "z=C2=B3y rozmiar fragmentu - %s"
- -
 #: misc/mke2fs.c:1031
 #, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"
diff --git a/po/rw.gmo b/po/rw.gmo
deleted file mode 100644
index 4bbe6af..0000000
Binary files a/po/rw.gmo and /dev/null differ
diff --git a/po/rw.po b/po/rw.po
index 0ee8224..ef34c36 100644
- --- a/po/rw.po
+++ b/po/rw.po
@@ -51,7 +51,7 @@
 #. 	%Il	<inode> -> i_links_count
 #. 	%Im	<inode> -> i_mode
 #. 	%IM	<inode> -> i_mtime
- -#. 	%IF	<inode> -> i_faddr
+#. 	%IF	<inode> -> i_obso_faddr
 #. 	%If	<inode> -> i_file_acl
 #. 	%Id	<inode> -> i_dir_acl
 #. 	%Iu	<inode> -> i_uid
@@ -841,17 +841,6 @@ msgstr ""
 "F Ingano Kuri i ni Ifatika Ingano Bya i v ni i Cyangwa i imbonerahamw=
e# ni "
 "Kuri"

- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -#: e2fsck/problem.c:137
- -#, fuzzy
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr "@Verisiyo Bya OYA Gushigikira i B Ingano"
- -
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 #: e2fsck/problem.c:144
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1847,12 +1836,6 @@ msgstr ""
 "X- Generator: KBabel 1. 0\n"
 "."

- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -#: e2fsck/problem.c:949
- -#, fuzzy
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr "S Zeru"
- -
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 #: e2fsck/problem.c:954
 #, fuzzy
@@ -1865,18 +1848,6 @@ msgstr "S Zeru"
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr "S Zeru"

- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:964
- -#, fuzzy
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr "S Zeru"
- -
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:969
- -#, fuzzy
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr "S Zeru"
- -
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 #: e2fsck/problem.c:974
 #, fuzzy
@@ -3672,9 +3643,9 @@ msgstr "Verisiyo ku"
 #: misc/mke2fs.c:97
 #, fuzzy, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]\n"
- -"\t[-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator=
-os]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-I inode-size] [-j] [-J journal-options] [-N number-of-inodes]\n"
+"\t[-m reserved-blocks-percentage] [-o creator-os]\n"
 "\t[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]=
\n"
 "\t[-O feature[,...]] [-r fs-revision] [-R options] [-qvSV]\n"
 "\tdevice [blocks-count]\n"
@@ -3839,11 +3810,6 @@ msgstr "Ubwoko"
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr "Ingano LOG"

- -#: misc/mke2fs.c:685
- -#, fuzzy, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr "Ingano LOG"
- -
 #: misc/mke2fs.c:687
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3874,11 +3840,6 @@ msgstr "%uFunga"
 msgid "%u block group\n"
 msgstr "%uFunga"

- -#: misc/mke2fs.c:702
- -#, fuzzy, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr "%uItsinda"
- -
 #: misc/mke2fs.c:704
 #, c-format
 msgid "%u inodes per group\n"
@@ -3953,11 +3914,6 @@ msgstr "Funga Ingano"
 msgid "Warning: blocksize %d not usable on most systems.\n"
 msgstr "OYA ku"

- -#: misc/mke2fs.c:1025
- -#, fuzzy, c-format
- -msgid "invalid fragment size - %s"
- -msgstr "Ingano"
- -
 #: misc/mke2fs.c:1031
 #, fuzzy, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"
diff --git a/po/sv.gmo b/po/sv.gmo
deleted file mode 100644
index 84404f5..0000000
Binary files a/po/sv.gmo and /dev/null differ
diff --git a/po/sv.po b/po/sv.po
index 44521a5..d093d94 100644
- --- a/po/sv.po
+++ b/po/sv.po
@@ -43,7 +43,7 @@
 #. 	%Il	<inode> -> i_links_count
 #. 	%Im	<inode> -> i_mode
 #. 	%IM	<inode> -> i_mtime
- -#. 	%IF	<inode> -> i_faddr
+#. 	%IF	<inode> -> i_obso_faddr
 #. 	%If	<inode> -> i_file_acl
 #. 	%Id	<inode> -> i_dir_acl
 #. 	%Iu	<inode> -> i_uid
@@ -790,19 +790,6 @@ msgstr ""
 "Den fysiska storleken p=C3=A5 enheten =C3=A4r %c block\n"
 "Superblocket eller partitionstabellen =C3=A4r f=C3=B6rmodligen trasig=
!\n"

- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -#: e2fsck/problem.c:137
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr ""
- -"Superblockets blockstorlek =3D %b, fragmentstorlek =3D %c.\n"
- -"Denna version av e2fsck st=C3=B6djer inte andra fragmentstorlekar =C3=
=A4n\n"
- -"blockstorleken.\n"
- -
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 #: e2fsck/problem.c:144
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1708,11 +1695,6 @@ msgstr "F=C3=B6rsta post \"%Dn\" (inod=3D%Di) i =
kataloginod %i (%p) skulle varit \".\"\
 msgid "Second @e '%Dn' (@i=3D%Di) in @d @i %i @s '..'\n"
 msgstr "Andra post \"%Dn\" (inod=3D%Di) i kataloginod %i skulle varit =
\"..\"\n"

- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -#: e2fsck/problem.c:949
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr "i_faddr f=C3=B6r inod %i (%Q) =C3=A4r %IF, skulle varit noll=
=2E\n"
- -
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 #: e2fsck/problem.c:954
 msgid "i_file_acl @F %If, @s zero.\n"
@@ -1723,16 +1705,6 @@ msgstr "i_file_acl f=C3=B6r inod %i (%Q) =C3=A4r=
 %If, skulle varit noll.\n"
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr "i_dir_acl f=C3=B6r inod %i (%Q) =C3=A4r %Id, skulle varit noll=
=2E\n"

- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:964
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr "i_frag f=C3=B6r inod %i (%Q) =C3=A4r %N, skulle varit noll.\=
n"
- -
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:969
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr "i_fsize f=C3=B6r inod %i (%Q) =C3=A4r %N, skulle varit noll.=
\n"
- -
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 #: e2fsck/problem.c:974
 msgid "@i %i (%Q) has @n mode (%Im).\n"
@@ -3424,16 +3396,16 @@ msgstr "Vid l=C3=A4sning av version p=C3=A5 %s"
 #: misc/mke2fs.c:97
 #, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]\n"
- -"\t[-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator=
-os]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-I inode-size] [-j] [-J journal-options] [-N number-of-inodes]\n"
+"\t[-m reserved-blocks-percentage] [-o creator-os]\n"
 "\t[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]=
\n"
 "\t[-O feature[,...]] [-r fs-revision] [-R options] [-qvSV]\n"
 "\tdevice [blocks-count]\n"
 msgstr ""
- -"Anv=C3=A4ndning: %s [-c|-t|-l filnamn] [-b blockstorlek] [-f fragme=
ntstorlek]\n"
- -"\t[-i byte-per-inod] [-I inodstorlek] [-j] [-J journalflaggor]\n"
- -"\t[-N antal-inoder] [-m reservade-block-procent] [-o skapar-os]\n"
+"Anv=C3=A4ndning: %s [-c|-t|-l filnamn] [-b blockstorlek] [-i byte-per=
-inod]\n"
+"\t[-I inodstorlek] [-j] [-J journalflaggor] [-N antal-inoder]\n"
+"\t[-m reservade-block-procent] [-o skapar-os]\n"
 "\t[-g block-per-grupp] [-L volymetikett] [-M senast-monterad-katalog]=
\n"
 "\t[-O funktion[,...]] [-r fs-revision] [-R flaggor] [-qvSV]\n"
 "\tenhet [blockantal]\n"
@@ -3585,11 +3557,6 @@ msgstr "OS-typ: "
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr "Blockstorlek=3D%u (log=3D%u)\n"

- -#: misc/mke2fs.c:685
- -#, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr "Fragmentstorlek=3D%u (log=3D%u)\n"
- -
 #: misc/mke2fs.c:687
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3620,11 +3587,6 @@ msgstr "%u blockgrupper\n"
 msgid "%u block group\n"
 msgstr "%u blockgrupp\n"

- -#: misc/mke2fs.c:702
- -#, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr "%u block per grupp, %u fragment per grupp\n"
- -
 #: misc/mke2fs.c:704
 #, c-format
 msgid "%u inodes per group\n"
@@ -3709,11 +3671,6 @@ msgstr "felaktig blockstorlek - %s"
 msgid "Warning: blocksize %d not usable on most systems.\n"
 msgstr "Varning: blockstorlek %d =C3=A4r inte anv=C3=A4ndbar p=C3=A5 d=
e flesta system.\n"

- -#: misc/mke2fs.c:1025
- -#, c-format
- -msgid "invalid fragment size - %s"
- -msgstr "ogiltig fragmentstorlek - %s"
- -
 #: misc/mke2fs.c:1031
 #, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"
diff --git a/po/tr.gmo b/po/tr.gmo
deleted file mode 100644
index 43be86d..0000000
Binary files a/po/tr.gmo and /dev/null differ
diff --git a/po/tr.po b/po/tr.po
index e8bb554..3d26af2 100644
- --- a/po/tr.po
+++ b/po/tr.po
@@ -41,7 +41,7 @@
 #. 	%Il	<inode> -> i_links_count
 #. 	%Im	<inode> -> i_mode
 #. 	%IM	<inode> -> i_mtime
- -#. 	%IF	<inode> -> i_faddr
+#. 	%IF	<inode> -> i_obso_faddr
 #. 	%If	<inode> -> i_file_acl
 #. 	%Id	<inode> -> i_dir_acl
 #. 	%Iu	<inode> -> i_uid
@@ -778,19 +778,6 @@ msgstr ""
 "ayg=C3=84=C2=B1t=C3=84=C2=B1n ger=C3=83=C2=A7ek boyutu ise %c bloktur=
=2E\n"
 "Hem s=C3=83=C2=BCper blok hem de disk b=C3=83=C2=B6l=C3=83=C2=BCmleme=
 tablosu bozuk olabilir!\n"

- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -#: e2fsck/problem.c:137
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr ""
- -"S=C3=83=C2=BCperblok blok_uzunlu=C3=84=C2=9Fu =3D %b, ad=C3=84=C2=B1=
mlama_uzunlu=C3=84=C2=9Fu =3D %c.\n"
- -"Bu e2fsck s=C3=83=C2=BCr=C3=83=C2=BCm=C3=83=C2=BCnde ad=C3=84=C2=B1=
mlama uzunluklar=C3=84=C2=B1n=C3=84=C2=B1n blok uzunluklar=C3=84=C2=B1n=
dan\n"
- -"farkl=C3=84=C2=B1 olmas=C3=84=C2=B1 desteklenmiyor.\n"
- -
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 #: e2fsck/problem.c:144
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1739,11 +1726,6 @@ msgid "Second @e '%Dn' (@i=3D%Di) in @d @i %i @s=
 '..'\n"
 msgstr ""
 "Dizin d=C3=83=C2=BC=C3=84=C2=9F=C3=83=C2=BCm=C3=83=C2=BC %i i=C3=83=C2=
=A7indeki ikinci girdi '%Dn' (d=C3=83=C2=BC=C3=84=C2=9F=C3=83=C2=BCm=3D=
%Di) '..' olmal=C3=84=C2=B1yd=C3=84=C2=B1.\n"

- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -#: e2fsck/problem.c:949
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr "d=C3=83=C2=BC=C3=84=C2=9F=C3=83=C2=BCm %i (%Q) %IF i=C3=83=C2=
=A7in i_faddr, s=C3=84=C2=B1f=C3=84=C2=B1r olmal=C3=84=C2=B1.\n"
- -
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 #: e2fsck/problem.c:954
 msgid "i_file_acl @F %If, @s zero.\n"
@@ -1754,16 +1736,6 @@ msgstr "d=C3=83=C2=BC=C3=84=C2=9F=C3=83=C2=BCm %=
i (%Q) %If i=C3=83=C2=A7in i_file_acl, s=C3=84=C2=B1f=C3=84=C2=B1r olma=
l=C3=84=C2=B1.\n"
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr "d=C3=83=C2=BC=C3=84=C2=9F=C3=83=C2=BCm %i (%Q) %Id i=C3=83=C2=A7=
in i_dir_acl, s=C3=84=C2=B1f=C3=84=C2=B1r olmal=C3=84=C2=B1.\n"

- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:964
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr "d=C3=83=C2=BC=C3=84=C2=9F=C3=83=C2=BCm %i (%Q) %N i=C3=83=C2=
=A7in i_frag, s=C3=84=C2=B1f=C3=84=C2=B1r olmal=C3=84=C2=B1.\n"
- -
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:969
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr "d=C3=83=C2=BC=C3=84=C2=9F=C3=83=C2=BCm %i (%Q)  %N i=C3=83=C2=
=A7in i_fsize, s=C3=84=C2=B1f=C3=84=C2=B1r olmal=C3=84=C2=B1.\n"
- -
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 #: e2fsck/problem.c:974
 msgid "@i %i (%Q) has @n mode (%Im).\n"
@@ -2008,7 +1980,7 @@ msgstr ""
 #: e2fsck/problem.c:1188
 #, fuzzy
 msgid "i_blocks_hi @F %N, @s zero.\n"
- -msgstr "d=C3=83=C2=BC=C3=84=C2=9F=C3=83=C2=BCm %i (%Q)  %N i=C3=83=C2=
=A7in i_fsize, s=C3=84=C2=B1f=C3=84=C2=B1r olmal=C3=84=C2=B1.\n"
+msgstr "d=C3=83=C2=BC=C3=84=C2=9F=C3=83=C2=BCm %i (%Q)  %N i=C3=83=C2=A7=
iblocks_hi, s=C3=84=C2=B1f=C3=84=C2=B1r olmal=C3=84=C2=B1.\n"

 #. @-expanded: Pass 3: Checking directory connectivity\n
 #: e2fsck/problem.c:1195
@@ -3636,8 +3608,8 @@ msgstr "- %s =C3=83=C2=BCzerinde s=C3=83=C2=BCr=C3=
=83=C2=BCm okunurken hata olu=C3=85=C2=9Ftu"
 #: misc/mke2fs.c:97
 #, fuzzy, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-I inode-size] [-j] [-J journal-options]\n"
 "\t[-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator-o=
s]\n"
 "\t[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]=
\n"
 "\t[-O feature[,...]] [-r fs-revision] [-R options] [-qvSV]\n"
@@ -3651,7 +3623,6 @@ msgstr ""
 "Se=C3=83=C2=A7enekler:\n"
 "   -b 1024|2048|4096         dosya sisteminin blok uzunlu=C3=84=C2=9F=
u belirtilir\n"
 "   -c                        salt-okunur kipte hatal=C3=84=C2=B1 blok=
lar aran=C3=84=C2=B1r\n"
- -"   -f ad=C3=84=C2=B1m-boyu              bu s=C3=83=C2=BCr=C3=83=C2=BC=
mde ad=C3=84=C2=B1m boyu blok boyuna e=C3=85=C2=9Fittir\n"
 "   -g her-gruptaki-blok-say=C3=84=C2=B1s=C3=84=C2=B1\n"
 "   -i d=C3=83=C2=BC=C3=84=C2=9F=C3=83=C2=BCm-uzunlu=C3=84=C2=9Fu     =
    bo=C3=85=C2=9F bir dizinin disk =C3=83=C2=BCzerinde kaplayabilece=C3=
=84=C2=9Fi\n"
 "                             en k=C3=83=C2=BC=C3=83=C2=A7=C3=83=C2=BC=
k alan, bayt cinsinden verilir.\n"
@@ -3845,11 +3816,6 @@ msgstr "=C3=84=C2=B0=C3=85=C2=9Fl. Sist. t=C3=83=
=C2=BCr=C3=83=C2=BC: "
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr "Blok boyu =3D %u (g=C3=83=C2=BCnl=C3=83=C2=BCk kayd=C3=84=C2=B1=
 =3D %u)\n"

- -#: misc/mke2fs.c:685
- -#, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr "Ad=C3=84=C2=B1mlama boyu =3D %u (g=C3=83=C2=BCnl=C3=83=C2=BC=
k kayd=C3=84=C2=B1 =3D %u)\n"
- -
 #: misc/mke2fs.c:687
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3880,11 +3846,6 @@ msgstr "%u blok grubu\n"
 msgid "%u block group\n"
 msgstr "%u blok grubu\n"

- -#: misc/mke2fs.c:702
- -#, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr "Grup ba=C3=85=C2=9F=C3=84=C2=B1na %u blok ve %u sekme\n"
- -
 #: misc/mke2fs.c:704
 #, c-format
 msgid "%u inodes per group\n"
@@ -3971,11 +3932,6 @@ msgstr "blok uzunlu=C3=84=C2=9Fu hatal=C3=84=C2=B1=
 - %s"
 msgid "Warning: blocksize %d not usable on most systems.\n"
 msgstr "Uyar=C3=84=C2=B1: blok uzunlu=C3=84=C2=9Fu %d bir=C3=83=C2=A7o=
k sistemde kullan=C3=84=C2=B1md=C3=84=C2=B1=C3=85=C2=9F=C3=84=C2=B1d=C3=
=84=C2=B1r.\n"

- -#: misc/mke2fs.c:1025
- -#, c-format
- -msgid "invalid fragment size - %s"
- -msgstr "sekme boyu hatal=C3=84=C2=B1 - %s"
- -
 #: misc/mke2fs.c:1031
 #, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"
diff --git a/po/vi.gmo b/po/vi.gmo
deleted file mode 100644
index 65bb5d5..0000000
Binary files a/po/vi.gmo and /dev/null differ
diff --git a/po/vi.po b/po/vi.po
index e8a7eae..959d93e 100644
- --- a/po/vi.po
+++ b/po/vi.po
@@ -41,7 +41,7 @@
 #. 	%Il	<inode> -> i_links_count
 #. 	%Im	<inode> -> i_mode
 #. 	%IM	<inode> -> i_mtime
- -#. 	%IF	<inode> -> i_faddr
+#. 	%IF	<inode> -> i_obso_faddr
 #. 	%If	<inode> -> i_file_acl
 #. 	%Id	<inode> -> i_dir_acl
 #. 	%Iu	<inode> -> i_uid
@@ -776,19 +776,6 @@ msgstr ""
 "K=C3=83=C2=ADch c=C3=A1=C2=BB=C2=A1 v=C3=A1=C2=BA=C2=ADt l=C3=83=C2=BD=
 c=C3=A1=C2=BB=C2=A7a @v l=C3=83  %c @b\n"
 "Ho=C3=A1=C2=BA=C2=B7c @S ho=C3=A1=C2=BA=C2=B7c b=C3=A1=C2=BA=C2=A3ng =
ph=C3=83=C2=A2n v=C3=83=C2=B9ng r=C3=A1=C2=BA=C2=A5t c=C3=83=C2=B3 th=C3=
=A1=C2=BB=C2=83 b=C3=A1=C2=BB=C2=8B h=C3=A1=C2=BB=C2=8Fng.\n"

- -#. @-expanded: superblock block_size =3D %b, fragsize =3D %c.\n
- -#. @-expanded: This version of e2fsck does not support fragment size=
s different\n
- -#. @-expanded: from the block size.\n
- -#: e2fsck/problem.c:137
- -msgid ""
- -"@S @b_size =3D %b, fragsize =3D %c.\n"
- -"This version of e2fsck does not support fragment sizes different\n"
- -"from the @b size.\n"
- -msgstr ""
- -"@S k=C3=83=C2=ADch c=C3=A1=C2=BB=C2=A1 @b =3D %b, k=C3=83=C2=ADch c=
=C3=A1=C2=BB=C2=A1 =C3=84=C2=91o=C3=A1=C2=BA=C2=A1n =3D %c.\n"
- -"Phi=C3=83=C2=AAn b=C3=A1=C2=BA=C2=A3n e2fsck n=C3=83 y kh=C3=83=C2=B4=
ng h=C3=A1=C2=BB=C2=97 tr=C3=A1=C2=BB=C2=A3 k=C3=83=C2=ADch c=C3=A1=C2=BB=
=C2=A1 =C3=84=C2=91o=C3=A1=C2=BA=C2=A1n\n"
- -"kh=C3=83=C2=A1c v=C3=A1=C2=BB=C2=9Bi k=C3=83=C2=ADch c=C3=A1=C2=BB=C2=
=A1 @b.\n"
- -
 #. @-expanded: superblock blocks_per_group =3D %b, should have been %c=
\n
 #: e2fsck/problem.c:144
 msgid "@S @bs_per_group =3D %b, should have been %c\n"
@@ -1701,11 +1688,6 @@ msgstr "@e '%Dn' th=C3=A1=C2=BB=C2=A9 nh=C3=A1=C2=
=BA=C2=A5t (@i=3D%Di) trong @i @d %i (%p) @s =C3=82=C2=AB . =C3=82=C2=BB=
\n"
 msgid "Second @e '%Dn' (@i=3D%Di) in @d @i %i @s '..'\n"
 msgstr "@e '%Dn' th=C3=A1=C2=BB=C2=A9 hai (@i=3D%Di) trong @i @d %i @s=
 =C3=82=C2=AB .. =C3=82=C2=BB\n"

- -#. @-expanded: i_faddr for inode %i (%Q) is %IF, should be zero.\n
- -#: e2fsck/problem.c:949
- -msgid "i_faddr @F %IF, @s zero.\n"
- -msgstr "=C3=84=C2=90=C3=A1=C2=BB=C2=8Ba ch=C3=A1=C2=BB=C2=89 i_faddr=
 cho n=C3=83=C2=BAt injode %i (%Q) l=C3=83  %IF, c=C3=83=C2=B2n n=C3=83=
=C2=AAn l=C3=83  s=C3=A1=C2=BB=C2=91 kh=C3=83=C2=B4ng.\n"
- -
 #. @-expanded: i_file_acl for inode %i (%Q) is %If, should be zero.\n
 #: e2fsck/problem.c:954
 msgid "i_file_acl @F %If, @s zero.\n"
@@ -1716,16 +1698,6 @@ msgstr "i_file_acl @F %If, @s s=C3=A1=C2=BB=C2=91=
 kh=C3=83=C2=B4ng.\n"
 msgid "i_dir_acl @F %Id, @s zero.\n"
 msgstr "i_dir_acl @F %Id, @s s=C3=A1=C2=BB=C2=91 kh=C3=83=C2=B4ng.\n"

- -#. @-expanded: i_frag for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:964
- -msgid "i_frag @F %N, @s zero.\n"
- -msgstr "i_frag @F %N, @s s=C3=A1=C2=BB=C2=91 kh=C3=83=C2=B4ng.\n"
- -
- -#. @-expanded: i_fsize for inode %i (%Q) is %N, should be zero.\n
- -#: e2fsck/problem.c:969
- -msgid "i_fsize @F %N, @s zero.\n"
- -msgstr "i_fsize @F %N, @s s=C3=A1=C2=BB=C2=91 kh=C3=83=C2=B4ng.\n"
- -
 #. @-expanded: inode %i (%Q) has invalid mode (%Im).\n
 #: e2fsck/problem.c:974
 msgid "@i %i (%Q) has @n mode (%Im).\n"
@@ -3443,14 +3415,14 @@ msgstr "Trong khi =C3=84=C2=91=C3=A1=C2=BB=C2=8D=
c phi=C3=83=C2=AAn b=C3=A1=C2=BA=C2=A3n tr=C3=83=C2=AAn %s"
 #: misc/mke2fs.c:97
 #, c-format
 msgid ""
- -"Usage: %s [-c|-t|-l filename] [-b block-size] [-f fragment-size]\n"
- -"\t[-i bytes-per-inode] [-I inode-size] [-j] [-J journal-options]\n"
+"Usage: %s [-c|-t|-l filename] [-b block-size] [-i bytes-per-inode]\n"
+"\t[-I inode-size] [-j] [-J journal-options]\n"
 "\t[-N number-of-inodes] [-m reserved-blocks-percentage] [-o creator-o=
s]\n"
 "\t[-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]=
\n"
 "\t[-O feature[,...]] [-r fs-revision] [-R options] [-qvSV]\n"
 "\tdevice [blocks-count]\n"
 msgstr ""
- -"C=C3=83=C2=A1ch s=C3=A1=C2=BB=C2=AD d=C3=A1=C2=BB=C2=A5ng: %s [-c|-=
t|-l t=C3=83=C2=AAn_t=C3=A1=C2=BA=C2=ADp_tin] [-b c=C3=A1=C2=BB=C2=A1_k=
h=C3=A1=C2=BB=C2=91i] [-f c=C3=A1=C2=BB=C2=A1_=C3=84=C2=91o=C3=A1=C2=BA=
=C2=A1n]\n"
+"C=C3=83=C2=A1ch s=C3=A1=C2=BB=C2=AD d=C3=A1=C2=BB=C2=A5ng: %s [-c|-t|=
-l t=C3=83=C2=AAn_t=C3=A1=C2=BA=C2=ADp_tin] [-b c=C3=A1=C2=BB=C2=A1_kh=C3=
=A1=C2=BB=C2=91i]\n"
 "\t[-i byte_m=C3=A1=C2=BB=C2=97i_n=C3=83=C2=BAt_th=C3=83=C2=B4ng_tin] =
[-I c=C3=A1=C2=BB=C2=A1_n=C3=83=C2=BAt_th=C3=83=C2=B4ng_tin] [-j] [-J "
 "t=C3=83=C2=B9y_ch=C3=A1=C2=BB=C2=8Dn_nh=C3=A1=C2=BA=C2=ADt_k=C3=83=C2=
=BD]\n"
 "\t[-N s=C3=A1=C2=BB=C2=91_n=C3=83=C2=BAt_th=C3=83=C2=B4ng_tin] [-m ph=
=C3=A1=C2=BA=C2=A7n_tr=C3=84=C2=83m_kh=C3=A1=C2=BB=C2=91i_d=C3=83 nh_ri=
=C3=83=C2=AAng] [-o H=C3=84=C2=90H_t=C3=A1=C2=BA=C2=A1o]\n"
@@ -3609,11 +3581,6 @@ msgstr "Ki=C3=A1=C2=BB=C2=83u H=C3=84=C2=90H: "
 msgid "Block size=3D%u (log=3D%u)\n"
 msgstr "C=C3=A1=C2=BB=C2=A1 kh=C3=A1=C2=BB=C2=91i=3D%u (b=C3=A1=C2=BA=C2=
=A3n ghi=3D%u)\n"

- -#: misc/mke2fs.c:685
- -#, c-format
- -msgid "Fragment size=3D%u (log=3D%u)\n"
- -msgstr "C=C3=A1=C2=BB=C2=A1 =C3=84=C2=91o=C3=A1=C2=BA=C2=A1n=3D%u (b=
=C3=A1=C2=BA=C2=A3n ghi=3D%u)\n"
- -
 #: misc/mke2fs.c:687
 #, c-format
 msgid "%u inodes, %u blocks\n"
@@ -3644,11 +3611,6 @@ msgstr "%u nh=C3=83=C2=B3m kh=C3=A1=C2=BB=C2=91i=
\n"
 msgid "%u block group\n"
 msgstr "%u nh=C3=83=C2=B3m kh=C3=A1=C2=BB=C2=91i\n"

- -#: misc/mke2fs.c:702
- -#, c-format
- -msgid "%u blocks per group, %u fragments per group\n"
- -msgstr "%u kh=C3=A1=C2=BB=C2=91i tr=C3=83=C2=AAn m=C3=A1=C2=BB=C2=97=
i nh=C3=83=C2=B3m, %u =C3=84=C2=91o=C3=A1=C2=BA=C2=A1n tr=C3=83=C2=AAn =
m=C3=A1=C2=BB=C2=97i nh=C3=83=C2=B3m\n"
- -
 #: misc/mke2fs.c:704
 #, c-format
 msgid "%u inodes per group\n"
@@ -3736,11 +3698,6 @@ msgstr "c=C3=A1=C2=BB=C2=A1 kh=C3=A1=C2=BB=C2=91=
i kh=C3=83=C2=B4ng h=C3=A1=C2=BB=C2=A3p l=C3=A1=C2=BB=C2=87 =C3=A2=C2=80=
=C2=94 %s"
 msgid "Warning: blocksize %d not usable on most systems.\n"
 msgstr "C=C3=A1=C2=BA=C2=A3nh b=C3=83=C2=A1o : k=C3=83=C2=ADch c=C3=A1=
=C2=BB=C2=A1 kh=C3=A1=C2=BB=C2=91i %d v=C3=83=C2=B4 =C3=83=C2=ADch tr=C3=
=83=C2=AAn ph=C3=A1=C2=BA=C2=A7n l=C3=A1=C2=BB=C2=9Bn h=C3=A1=C2=BB=C2=87=
 th=C3=A1=C2=BB=C2=91ng.\n"

- -#: misc/mke2fs.c:1025
- -#, c-format
- -msgid "invalid fragment size - %s"
- -msgstr "c=C3=A1=C2=BB=C2=A1 =C3=84=C2=91o=C3=A1=C2=BA=C2=A1n kh=C3=83=
=C2=B4ng h=C3=A1=C2=BB=C2=A3p l=C3=A1=C2=BB=C2=87 =C3=A2=C2=80=C2=94 %s=
"
- -
 #: misc/mke2fs.c:1031
 #, c-format
 msgid "Warning: fragments not supported.  Ignoring -f option\n"


- --
Coly Li
SuSE PRC Labs

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGvJzDuTp8cyZ5lTERAqWZAJwLetdzYMXfaDBq2/i+a2ANL/Ax+wCgnYeU
Ao+qRNF9ab6Lkcck5gjaJJc=3D
=3D+iQC
-----END PGP SIGNATURE-----
