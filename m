From: Coly Li <coyli@suse.de>
Subject: [PATCH] e2fsprogs: obsolete hurd and masix support
Date: Mon, 13 Aug 2007 01:45:18 +0800
Message-ID: <46BF472E.1040105@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB3FB7866921175C3F76D774A"
To: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:38019 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763958AbXHLRok (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Aug 2007 13:44:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB3FB7866921175C3F76D774A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Theodore,

Here is the patch to remove obsoleted code piece by piece.
This patch remove hurd and masix support, including union of inode and re=
lated source code.

I find there (likely) are some hurd related code in lib/ext2fs/ismounted.=
c. But I am not sure
whether the "#ifndef __GNU__" is hurd specific only. What is your comment=
 ?

This time, I use MIME/PGP in my signature, and tested by sending the patc=
h to another account. Hope
the format is ok this time :-)

Signed-Off-By: Coly Li <coyli@suse.de>

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 190c4b7..0d1b7c2 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -545,16 +545,9 @@ void internal_dump_inode(FILE *out, const char *pref=
ix,
 		fprintf(out, "%llu\n", i_size);
 	} else
 		fprintf(out, "%d\n", inode->i_size);
-	if (os =3D=3D EXT2_OS_HURD)
-		fprintf(out,
-			"%sFile ACL: %d    Directory ACL: %d Translator: %d\n",
-			prefix,
-			inode->i_file_acl, LINUX_S_ISDIR(inode->i_mode) ? inode->i_dir_acl : =
0,
-			inode->osd1.hurd1.h_i_translator);
-	else
-		fprintf(out, "%sFile ACL: %d    Directory ACL: %d\n",
-			prefix,
-			inode->i_file_acl, LINUX_S_ISDIR(inode->i_mode) ? inode->i_dir_acl : =
0);
+	fprintf(out, "%sFile ACL: %d    Directory ACL: %d\n",
+		prefix,
+		inode->i_file_acl, LINUX_S_ISDIR(inode->i_mode) ? inode->i_dir_acl : 0=
);
 	if (os =3D=3D EXT2_OS_LINUX)
 		fprintf(out, "%sLinks: %d   Blockcount: %llu\n",
 			prefix, inode->i_links_count,
@@ -564,18 +557,7 @@ void internal_dump_inode(FILE *out, const char *pref=
ix,
 	else
 		fprintf(out, "%sLinks: %d   Blockcount: %u\n",
 			prefix, inode->i_links_count, inode->i_blocks);
-	switch (os) {
-	    case EXT2_OS_HURD:
-		frag =3D inode->osd2.hurd2.h_i_frag;
-		fsize =3D inode->osd2.hurd2.h_i_fsize;
-		break;
-	    case EXT2_OS_MASIX:
-		frag =3D inode->osd2.masix2.m_i_frag;
-		fsize =3D inode->osd2.masix2.m_i_fsize;
-		break;
-	    default:
-		frag =3D fsize =3D 0;
-	}
+	frag =3D fsize =3D 0;
 	fprintf(out, "%sFragment:  Address: %d    Number: %d    Size: %d\n",
 		prefix, inode->i_faddr, frag, fsize);
 	fprintf(out, "%sctime: 0x%08x -- %s", prefix, inode->i_ctime,
@@ -889,27 +871,7 @@ void do_modify_inode(int argc, char *argv[])
 	else
 		modify_u32(argv[0], "High 32bits of size", decimal_format, &inode.i_si=
ze_high);

-	if (os =3D=3D EXT2_OS_HURD)
-		modify_u32(argv[0], "Translator Block",
-			    decimal_format, &inode.osd1.hurd1.h_i_translator);
-=09
 	modify_u32(argv[0], "Fragment address", decimal_format, &inode.i_faddr)=
;
-	switch (os) {
-	    case EXT2_OS_HURD:
-		frag =3D &inode.osd2.hurd2.h_i_frag;
-		fsize =3D &inode.osd2.hurd2.h_i_fsize;
-		break;
-	    case EXT2_OS_MASIX:
-		frag =3D &inode.osd2.masix2.m_i_frag;
-		fsize =3D &inode.osd2.masix2.m_i_fsize;
-		break;
-	    default:
-		frag =3D fsize =3D 0;
-	}
-	if (frag)
-		modify_u8(argv[0], "Fragment number", decimal_format, frag);
-	if (fsize)
-		modify_u8(argv[0], "Fragment size", decimal_format, fsize);

 	for (i=3D0;  i < EXT2_NDIR_BLOCKS; i++) {
 		sprintf(buf, "Direct Block #%d", i);
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 9ff7f8c..04de624 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -132,7 +132,6 @@ static struct field_set_info inode_fields[] =3D {
 	{ "blocks", &set_inode.i_blocks, 4, parse_uint },
 	{ "flags", &set_inode.i_flags, 4, parse_uint },
 	{ "version", &set_inode.osd1.linux1.l_i_version, 4, parse_uint },
-	{ "translator", &set_inode.osd1.hurd1.h_i_translator, 4, parse_uint },
 	{ "block", &set_inode.i_block[0], 4, parse_uint, FLAG_ARRAY,
 	  EXT2_NDIR_BLOCKS },
 	{ "block[IND]", &set_inode.i_block[EXT2_IND_BLOCK], 4, parse_uint },
@@ -143,11 +142,8 @@ static struct field_set_info inode_fields[] =3D {
 	{ "dir_acl", &set_inode.i_dir_acl, 4, parse_uint },
 	{ "faddr", &set_inode.i_faddr, 4, parse_uint },
 	{ "blocks_hi", &set_inode.osd2.linux2.l_i_blocks_hi, 2, parse_uint },
-	{ "frag", &set_inode.osd2.hurd2.h_i_frag, 1, parse_uint },
-	{ "fsize", &set_inode.osd2.hurd2.h_i_fsize, 1, parse_uint },
 	{ "uid_high", &set_inode.osd2.linux2.l_i_uid_high, 2, parse_uint },
 	{ "gid_high", &set_inode.osd2.linux2.l_i_gid_high, 2, parse_uint },
-	{ "author", &set_inode.osd2.hurd2.h_i_author, 4, parse_uint },
 	{ "bmap", NULL, 4, parse_bmap, FLAG_ARRAY },
 	{ 0, 0, 0, 0 }
 };
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ceb9c7f..f0d3879 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -475,7 +475,6 @@ void e2fsck_pass1(e2fsck_t ctx)
 #ifdef RESOURCE_TRACK
 	struct resource_track	rtrack;
 #endif
-	unsigned char	frag, fsize;
 	struct		problem_context pctx;
 	struct		scan_callback_struct scan_struct;
 	struct ext2_super_block *sb =3D ctx->fs->super;
@@ -829,20 +828,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 		}
 	=09
 		ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
-		switch (fs->super->s_creator_os) {
-		    case EXT2_OS_HURD:
-			frag =3D inode->osd2.hurd2.h_i_frag;
-			fsize =3D inode->osd2.hurd2.h_i_fsize;
-			break;
-		    case EXT2_OS_MASIX:
-			frag =3D inode->osd2.masix2.m_i_frag;
-			fsize =3D inode->osd2.masix2.m_i_fsize;
-			break;
-		    default:
-			frag =3D fsize =3D 0;
-		}
 	=09
-		if (inode->i_faddr || frag || fsize ||
+		if (inode->i_faddr ||
 		    (LINUX_S_ISDIR(inode->i_mode) && inode->i_dir_acl))
 			mark_inode_bad(ctx, ino);
 		if ((fs->super->s_creator_os =3D=3D EXT2_OS_LINUX) &&
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 7f7635f..ef9a814 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1248,37 +1248,6 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, =
ext2_ino_t dir,
 			not_fixed++;
 	}

-	switch (fs->super->s_creator_os) {
-	    case EXT2_OS_HURD:
-		frag =3D &inode.osd2.hurd2.h_i_frag;
-		fsize =3D &inode.osd2.hurd2.h_i_fsize;
-		break;
-	    case EXT2_OS_MASIX:
-		frag =3D &inode.osd2.masix2.m_i_frag;
-		fsize =3D &inode.osd2.masix2.m_i_fsize;
-		break;
-	    default:
-		frag =3D fsize =3D 0;
-	}
-	if (frag && *frag) {
-		pctx.num =3D *frag;
-		if (fix_problem(ctx, PR_2_FRAG_ZERO, &pctx)) {
-			*frag =3D 0;
-			inode_modified++;
-		} else
-			not_fixed++;
-		pctx.num =3D 0;
-	}
-	if (fsize && *fsize) {
-		pctx.num =3D *fsize;
-		if (fix_problem(ctx, PR_2_FSIZE_ZERO, &pctx)) {
-			*fsize =3D 0;
-			inode_modified++;
-		} else
-			not_fixed++;
-		pctx.num =3D 0;
-	}
-
 	if ((fs->super->s_creator_os =3D=3D EXT2_OS_LINUX) &&
 	    !(fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 00a131c..2b13b7c 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -670,22 +670,6 @@ void check_super_block(e2fsck_t ctx)
 #endif

 	/*
-	 * For the Hurd, check to see if the filetype option is set,
-	 * since it doesn't support it.
-	 */
-	if (!(ctx->options & E2F_OPT_READONLY) &&
-	    fs->super->s_creator_os =3D=3D EXT2_OS_HURD &&
-	    (fs->super->s_feature_incompat &
-	     EXT2_FEATURE_INCOMPAT_FILETYPE)) {
-		if (fix_problem(ctx, PR_0_HURD_CLEAR_FILETYPE, &pctx)) {
-			fs->super->s_feature_incompat &=3D
-				~EXT2_FEATURE_INCOMPAT_FILETYPE;
-			ext2fs_mark_super_dirty(fs);
-
-		}
-	}
-
-	/*
 	 * If we have any of the compatibility flags set, we need to have a
 	 * revision 1 filesystem.  Most kernels will not check the flags on
 	 * a rev 0 filesystem and we may have corruption issues because of
diff --git a/ext2ed/super_com.c b/ext2ed/super_com.c
index 0541ff3..900ed54 100644
--- a/ext2ed/super_com.c
+++ b/ext2ed/super_com.c
@@ -97,14 +97,6 @@ void type_ext2_super_block___show (char *command_line)=

 			wprintw (show_pad,"Linux :-)");
 			break;

-		case EXT2_OS_HURD:
-			wprintw (show_pad,"Hurd");
-			break;
-
-		case EXT2_OS_MASIX:
-			wprintw (show_pad,"Masix");
-			break;
-
 		default:
 			wprintw (show_pad,"Unknown");
 			break;
diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 7685680..b95a97e 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -321,25 +321,6 @@ errcode_t ext2fs_block_iterate2(ext2_filsys fs,
 	ctx.tind_buf =3D ctx.dind_buf + fs->blocksize;

 	/*
-	 * Iterate over the HURD translator block (if present)
-	 */
-	if ((fs->super->s_creator_os =3D=3D EXT2_OS_HURD) &&
-	    !(flags & BLOCK_FLAG_DATA_ONLY)) {
-		ctx.errcode =3D ext2fs_read_inode(fs, ino, &inode);
-		if (ctx.errcode)
-			goto abort_exit;
-		got_inode =3D 1;
-		if (inode.osd1.hurd1.h_i_translator) {
-			ret |=3D (*ctx.func)(fs,
-					   &inode.osd1.hurd1.h_i_translator,
-					   BLOCK_COUNT_TRANSLATOR,
-					   0, 0, priv_data);
-			if (ret & BLOCK_ABORT)
-				goto abort_exit;
-		}
-	}
-=09
-	/*
 	 * Iterate over normal data blocks
 	 */
 	for (i =3D 0; i < EXT2_NDIR_BLOCKS ; i++, ctx.bcount++) {
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..1f36718 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -312,12 +312,6 @@ struct ext2_inode {
 		struct {
 			__u32	l_i_version; /* was l_i_reserved1 */
 		} linux1;
-		struct {
-			__u32  h_i_translator;
-		} hurd1;
-		struct {
-			__u32  m_i_reserved1;
-		} masix1;
 	} osd1;				/* OS dependent 1 */
 	__u32	i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
 	__u32	i_generation;	/* File version (for NFS) */
@@ -332,20 +326,6 @@ struct ext2_inode {
 			__u16	l_i_gid_high;	/* were reserved2[0] */
 			__u32	l_i_reserved2;
 		} linux2;
-		struct {
-			__u8	h_i_frag;	/* Fragment number */
-			__u8	h_i_fsize;	/* Fragment size */
-			__u16	h_i_mode_high;
-			__u16	h_i_uid_high;
-			__u16	h_i_gid_high;
-			__u32	h_i_author;
-		} hurd2;
-		struct {
-			__u8	m_i_frag;	/* Fragment number */
-			__u8	m_i_fsize;	/* Fragment size */
-			__u16	m_pad1;
-			__u32	m_i_reserved2[2];
-		} masix2;
 	} osd2;				/* OS dependent 2 */
 };

@@ -368,12 +348,6 @@ struct ext2_inode_large {
 		struct {
 			__u32	l_i_version; /* was l_i_reserved1 */
 		} linux1;
-		struct {
-			__u32  h_i_translator;
-		} hurd1;
-		struct {
-			__u32  m_i_reserved1;
-		} masix1;
 	} osd1;				/* OS dependent 1 */
 	__u32	i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
 	__u32	i_generation;	/* File version (for NFS) */
@@ -388,20 +362,6 @@ struct ext2_inode_large {
 			__u16	l_i_gid_high;	/* were reserved2[0] */
 			__u32	l_i_reserved2;
 		} linux2;
-		struct {
-			__u8	h_i_frag;	/* Fragment number */
-			__u8	h_i_fsize;	/* Fragment size */
-			__u16	h_i_mode_high;
-			__u16	h_i_uid_high;
-			__u16	h_i_gid_high;
-			__u32	h_i_author;
-		} hurd2;
-		struct {
-			__u8	m_i_frag;	/* Fragment number */
-			__u8	m_i_fsize;	/* Fragment size */
-			__u16	m_pad1;
-			__u32	m_i_reserved2[2];
-		} masix2;
 	} osd2;				/* OS dependent 2 */
 	__u16	i_extra_isize;
 	__u16	i_pad1;
@@ -428,26 +388,9 @@ struct ext2_inode_large {
 #else
 #if defined(__GNU__)

-#define i_translator	osd1.hurd1.h_i_translator
-#define i_frag		osd2.hurd2.h_i_frag;
-#define i_fsize		osd2.hurd2.h_i_fsize;
-#define i_uid_high	osd2.hurd2.h_i_uid_high
-#define i_gid_high	osd2.hurd2.h_i_gid_high
-#define i_author	osd2.hurd2.h_i_author
 #define inode_uid(inode)	((inode).i_uid | (inode).i_uid_high << 16)
 #define inode_gid(inode)	((inode).i_gid | (inode).i_gid_high << 16)

-#else
-#if defined(__masix__)
-
-#define i_reserved1	osd1.masix1.m_i_reserved1
-#define i_frag		osd2.masix2.m_i_frag
-#define i_fsize		osd2.masix2.m_i_fsize
-#define i_reserved2	osd2.masix2.m_i_reserved2
-#define inode_uid(inode)	((inode).i_uid)
-#define inode_gid(inode)	((inode).i_gid)
-
-#endif  /* __masix__ */
 #endif  /* __GNU__ */
 #endif	/* defined(__KERNEL__) || defined(__linux__) */

@@ -584,8 +527,6 @@ struct ext2_super_block {
  * Codes for operating systems
  */
 #define EXT2_OS_LINUX		0
-#define EXT2_OS_HURD		1
-#define EXT2_OS_MASIX		2
 #define EXT2_OS_FREEBSD		3
 #define EXT2_OS_LITES		4

diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index bd0844d..60dbd4d 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -184,31 +184,6 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct e=
xt2_inode_large *t,
 		t->osd2.linux2.l_i_reserved2 =3D
 			ext2fs_swab32(f->osd2.linux2.l_i_reserved2);
 		break;
-	case EXT2_OS_HURD:
-		t->osd1.hurd1.h_i_translator =3D
-		  ext2fs_swab32 (f->osd1.hurd1.h_i_translator);
-		t->osd2.hurd2.h_i_frag =3D f->osd2.hurd2.h_i_frag;
-		t->osd2.hurd2.h_i_fsize =3D f->osd2.hurd2.h_i_fsize;
-		t->osd2.hurd2.h_i_mode_high =3D
-		  ext2fs_swab16 (f->osd2.hurd2.h_i_mode_high);
-		t->osd2.hurd2.h_i_uid_high =3D
-		  ext2fs_swab16 (f->osd2.hurd2.h_i_uid_high);
-		t->osd2.hurd2.h_i_gid_high =3D
-		  ext2fs_swab16 (f->osd2.hurd2.h_i_gid_high);
-		t->osd2.hurd2.h_i_author =3D
-		  ext2fs_swab32 (f->osd2.hurd2.h_i_author);
-		break;
-	case EXT2_OS_MASIX:
-		t->osd1.masix1.m_i_reserved1 =3D
-			ext2fs_swab32(f->osd1.masix1.m_i_reserved1);
-		t->osd2.masix2.m_i_frag =3D f->osd2.masix2.m_i_frag;
-		t->osd2.masix2.m_i_fsize =3D f->osd2.masix2.m_i_fsize;
-		t->osd2.masix2.m_pad1 =3D ext2fs_swab16(f->osd2.masix2.m_pad1);
-		t->osd2.masix2.m_i_reserved2[0] =3D
-			ext2fs_swab32(f->osd2.masix2.m_i_reserved2[0]);
-		t->osd2.masix2.m_i_reserved2[1] =3D
-			ext2fs_swab32(f->osd2.masix2.m_i_reserved2[1]);
-		break;
 	}

 	if (bufsize < (int) (sizeof(struct ext2_inode) + sizeof(__u16)))
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4a6cace..d5956ef 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -738,10 +738,6 @@ static int set_os(struct ext2_super_block *sb, char =
*os)
 		sb->s_creator_os =3D atoi (os);
 	else if (strcasecmp(os, "linux") =3D=3D 0)
 		sb->s_creator_os =3D EXT2_OS_LINUX;
-	else if (strcasecmp(os, "GNU") =3D=3D 0 || strcasecmp(os, "hurd") =3D=3D=
 0)
-		sb->s_creator_os =3D EXT2_OS_HURD;
-	else if (strcasecmp(os, "masix") =3D=3D 0)
-		sb->s_creator_os =3D EXT2_OS_MASIX;
 	else if (strcasecmp(os, "freebsd") =3D=3D 0)
 		sb->s_creator_os =3D EXT2_OS_FREEBSD;
 	else if (strcasecmp(os, "lites") =3D=3D 0)
@@ -1591,14 +1587,6 @@ int main (int argc, char *argv[])
 	}

 	/*
-	 * For the Hurd, we will turn off filetype since it doesn't
-	 * support it.
-	 */
-	if (fs->super->s_creator_os =3D=3D EXT2_OS_HURD)
-		fs->super->s_feature_incompat &=3D
-			~EXT2_FEATURE_INCOMPAT_FILETYPE;
-
-	/*
 	 * Set the volume label...
 	 */
 	if (volume_label) {
diff --git a/tests/f_hurd/expect.1 b/tests/f_hurd/expect.1
deleted file mode 100644
index f7bfc56..0000000
--- a/tests/f_hurd/expect.1
+++ /dev/null
@@ -1,12 +0,0 @@
-The Hurd does not support the filetype feature.
-Clear? yes
-
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-
-test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 11/16 files (0.0% non-contiguous), 20/100 blocks
-Exit status is 1
diff --git a/tests/f_hurd/expect.2 b/tests/f_hurd/expect.2
deleted file mode 100644
index 44bff62..0000000
--- a/tests/f_hurd/expect.2
+++ /dev/null
@@ -1,7 +0,0 @@
-Pass 1: Checking inodes, blocks, and sizes
-Pass 2: Checking directory structure
-Pass 3: Checking directory connectivity
-Pass 4: Checking reference counts
-Pass 5: Checking group summary information
-test_filesys: 11/16 files (0.0% non-contiguous), 20/100 blocks
-Exit status is 0
diff --git a/tests/f_hurd/image.gz b/tests/f_hurd/image.gz
deleted file mode 100644
index 58ffe0c..0000000
Binary files a/tests/f_hurd/image.gz and /dev/null differ
diff --git a/tests/f_hurd/name b/tests/f_hurd/name
deleted file mode 100644
index a692986..0000000
--- a/tests/f_hurd/name
+++ /dev/null
@@ -1 +0,0 @@
-GNU/Hurd specific tests



--=20
Coly Li
SuSE PRC Labs


--------------enigB3FB7866921175C3F76D774A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGv0cxuTp8cyZ5lTERAgKxAJwIp+pubxTY4MuKGPc0ywCA8Tfz7gCfSItu
upMeQFaolqnneoNPw+sSIKY=
=Kwxk
-----END PGP SIGNATURE-----

--------------enigB3FB7866921175C3F76D774A--
