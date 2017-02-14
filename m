From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 1/4] e2fsprogs: supersede i_dir_acl with i_size_high
 for all cases
Date: Tue, 14 Feb 2017 13:06:14 -0700
Message-ID: <0A151488-448C-463A-8F44-A8ADFD2342CD@dilger.ca>
References: <1486977617-17216-1-git-send-email-artem.blagodarenko@gmail.com>
 <1486977617-17216-2-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_08C59766-B010-40C5-AFDA-1166B20251C9";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        adilger.kernel@dilger.ca
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34116 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbdBNUGY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Feb 2017 15:06:24 -0500
Received: by mail-oi0-f66.google.com with SMTP id w144so1369223oiw.1
        for <linux-ext4@vger.kernel.org>; Tue, 14 Feb 2017 12:06:19 -0800 (PST)
In-Reply-To: <1486977617-17216-2-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_08C59766-B010-40C5-AFDA-1166B20251C9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Feb 13, 2017, at 2:20 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>=20
> This patch removes i_dir_acl macros and macros users.
> Now stucture field can be accessed as i_size_high. This field
> is useful for largedir feature.
>=20
> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> debugfs/debugfs.c                        |   16 +++++++---------
> debugfs/set_fields.c                     |    1 -
> e2fsck/message.c                         |    4 ++--
> e2fsck/pass1.c                           |    2 +-
> e2fsck/pass2.c                           |    6 +++---
> e2fsck/problem.c                         |    6 +++---
> e2fsck/problem.h                         |    4 ++--
> ext2ed/doc/ext2ed-design.sgml            |    2 +-
> ext2ed/doc/ext2fs-overview.sgml          |    2 +-
> ext2ed/ext2.descriptors                  |    2 +-
> lib/ext2fs/ext2_fs.h                     |    6 ++----
> lib/ext2fs/swapfs.c                      |    2 +-
> po/at-expand.pl                          |    2 +-
> tests/d_fallocate_blkmap/expect          |    4 ++--
> tests/d_inline_dump/expect               |   12 ++++++------
> tests/d_special_files/expect             |   10 +++++-----
> tests/f_badcluster/expect                |   14 +++++++-------
> tests/f_convert_bmap/expect.1            |    2 +-
> tests/f_convert_bmap_and_extent/expect.1 |    2 +-
> tests/f_create_symlinks/expect           |    8 ++++----
> tests/f_recnect_bad/expect.1             |    2 +-
> 21 files changed, 52 insertions(+), 57 deletions(-)
>=20
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index 165f924..ba942ce 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -841,16 +841,15 @@ void internal_dump_inode(FILE *out, const char =
*prefix,
> 		fprintf(out, "%d\n", inode->i_size);
> 	if (os =3D=3D EXT2_OS_HURD)
> 		fprintf(out,
> -			"%sFile ACL: %d    Directory ACL: %d Translator: =
%d\n",
> +			"%sFile ACL: %d Translator: %d\n",
> 			prefix,
> -			inode->i_file_acl, LINUX_S_ISDIR(inode->i_mode) =
? inode->i_dir_acl : 0,
> +			inode->i_file_acl,
> 			inode->osd1.hurd1.h_i_translator);
> 	else
> -		fprintf(out, "%sFile ACL: %llu    Directory ACL: %d\n",
> +		fprintf(out, "%sFile ACL: %llu\n",
> 			prefix,
> 			inode->i_file_acl | ((long long)
> -				(inode->osd2.linux2.l_i_file_acl_high) =
<< 32),
> -			LINUX_S_ISDIR(inode->i_mode) ? inode->i_dir_acl =
: 0);
> +				(inode->osd2.linux2.l_i_file_acl_high) =
<< 32));
> 	if (os !=3D EXT2_OS_HURD)
> 		fprintf(out, "%sLinks: %d   Blockcount: %llu\n",
> 			prefix, inode->i_links_count,
> @@ -1347,10 +1346,9 @@ void do_modify_inode(int argc, char *argv[])
> 	modify_u32(argv[0], "Reserved1", decimal_format, =
&inode.i_reserved1);
> #endif
> 	modify_u32(argv[0], "File acl", decimal_format, =
&inode.i_file_acl);
> -	if (LINUX_S_ISDIR(inode.i_mode))
> -		modify_u32(argv[0], "Directory acl", decimal_format, =
&inode.i_dir_acl);
> -	else
> -		modify_u32(argv[0], "High 32bits of size", =
decimal_format, &inode.i_size_high);
> +
> +	modify_u32(argv[0], "High 32bits of size", decimal_format,
> +		   &inode.i_size_high);
>=20
> 	if (os =3D=3D EXT2_OS_HURD)
> 		modify_u32(argv[0], "Translator Block",
> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
> index ff9b7b6..ca68862 100644
> --- a/debugfs/set_fields.c
> +++ b/debugfs/set_fields.c
> @@ -212,7 +212,6 @@ static struct field_set_info inode_fields[] =3D {
> 	/* Special case: i_file_acl_high is 2 bytes */
> 	{ "file_acl", &set_inode.i_file_acl,
> 		&set_inode.osd2.linux2.l_i_file_acl_high, 6, parse_uint =
},
> -	{ "dir_acl", &set_inode.i_dir_acl, NULL, 4, parse_uint, =
FLAG_ALIAS },
> 	{ "faddr", &set_inode.i_faddr, NULL, 4, parse_uint },
> 	{ "frag", &set_inode.osd2.hurd2.h_i_frag, NULL, 1, parse_uint, =
FLAG_ALIAS },
> 	{ "fsize", &set_inode.osd2.hurd2.h_i_fsize, NULL, 1, parse_uint =
},
> diff --git a/e2fsck/message.c b/e2fsck/message.c
> index 1c3fcd8..34201a3 100644
> --- a/e2fsck/message.c
> +++ b/e2fsck/message.c
> @@ -32,7 +32,7 @@
>  * 	%IM	<inode> -> i_mtime
>  * 	%IF	<inode> -> i_faddr
>  * 	%If	<inode> -> i_file_acl
> - * 	%Id	<inode> -> i_dir_acl
> + * 	%Id	<inode> -> i_size_high
>  * 	%Iu	<inode> -> i_uid
>  * 	%Ig	<inode> -> i_gid
>  *	%It	<inode type>
> @@ -320,7 +320,7 @@ static _INLINE_ void expand_inode_expression(FILE =
*f, ext2_filsys fs, char ch,
> 		break;
> 	case 'd':
> 		fprintf(f, "%u", (LINUX_S_ISDIR(inode->i_mode) ?
> -				  inode->i_dir_acl : 0));
> +			inode->i_size_high : 0));
> 		break;
> 	case 'u':
> 		fprintf(f, "%d", inode_uid(*inode));
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 8ef40f6..ce37176 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -1716,7 +1716,7 @@ void e2fsck_pass1(e2fsck_t ctx)
> 		}
>=20
> 		if (inode->i_faddr || frag || fsize ||
> -		    (LINUX_S_ISDIR(inode->i_mode) && inode->i_dir_acl))
> +		    (LINUX_S_ISDIR(inode->i_mode) && =
inode->i_size_high))
> 			mark_inode_bad(ctx, ino);
> 		if ((fs->super->s_creator_os !=3D EXT2_OS_HURD) &&
> 		    !ext2fs_has_feature_64bit(fs->super) &&
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 11c19e8..b89ebc9 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -1811,10 +1811,10 @@ int e2fsck_process_bad_inode(e2fsck_t ctx, =
ext2_ino_t dir,
> 		} else
> 			not_fixed++;
> 	}
> -	if (inode.i_dir_acl &&
> +	if (inode.i_size_high &&
> 	    LINUX_S_ISDIR(inode.i_mode)) {
> -		if (fix_problem(ctx, PR_2_DIR_ACL_ZERO, &pctx)) {
> -			inode.i_dir_acl =3D 0;
> +		if (fix_problem(ctx, PR_2_DIR_SIZE_HIGH_ZERO, &pctx)) {
> +			inode.i_size_high =3D 0;
> 			inode_modified++;
> 		} else
> 			not_fixed++;
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index 34a671e..8b28819 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1360,9 +1360,9 @@ static struct e2fsck_problem problem_table[] =3D =
{
> 	  N_("i_file_acl @F %If, @s zero.\n"),
> 	  PROMPT_CLEAR, 0 },
>=20
> -	/* i_dir_acl should be zero */
> -	{ PR_2_DIR_ACL_ZERO,
> -	  N_("i_dir_acl @F %Id, @s zero.\n"),
> +	/* i_size_high should be zero */
> +	{ PR_2_DIR_SIZE_HIGH_ZERO,
> +	  N_("i_size_high @F %Id, @s zero.\n"),
> 	  PROMPT_CLEAR, 0 },
>=20
> 	/* i_frag should be zero */
> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index 86cb614..3306560 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -808,8 +808,8 @@ struct problem_context {
> /* i_file_acl should be zero */
> #define PR_2_FILE_ACL_ZERO	0x02000E
>=20
> -/* i_dir_acl should be zero */
> -#define PR_2_DIR_ACL_ZERO	0x02000F
> +/* i_size_high should be zero */
> +#define PR_2_DIR_SIZE_HIGH_ZERO	0x02000F
>=20
> /* i_frag should be zero */
> #define PR_2_FRAG_ZERO		0x020010
> diff --git a/ext2ed/doc/ext2ed-design.sgml =
b/ext2ed/doc/ext2ed-design.sgml
> index ad2df96..7841358 100644
> --- a/ext2ed/doc/ext2ed-design.sgml
> +++ b/ext2ed/doc/ext2ed-design.sgml
> @@ -2726,7 +2726,7 @@ struct ext2_inode {
> 	__u32	i_block[EXT2_N_BLOCKS];	/* Pointers to blocks */
> 	__u32	i_version;		/* File version (for NFS) */
> 	__u32	i_file_acl;		/* File ACL */
> -	__u32	i_dir_acl;		/* Directory ACL */
> +	__u32	i_size_high;		/* High 32bits of size */
> 	__u32	i_faddr;		/* Fragment address */
> 	union {
> 		struct {
> diff --git a/ext2ed/doc/ext2fs-overview.sgml =
b/ext2ed/doc/ext2fs-overview.sgml
> index a6ebf5a..900c393 100644
> --- a/ext2ed/doc/ext2fs-overview.sgml
> +++ b/ext2ed/doc/ext2fs-overview.sgml
> @@ -487,7 +487,7 @@ struct ext2_inode {
> 	__u32	i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
> 	__u32	i_version;	/* File version (for NFS) */
> 	__u32	i_file_acl;	/* File ACL */
> -	__u32	i_dir_acl;	/* Directory ACL */
> +	__u32	i_size_high;	/* High 32bits of size */
> 	__u32	i_faddr;	/* Fragment address */
> 	union {
> 		struct {
> diff --git a/ext2ed/ext2.descriptors b/ext2ed/ext2.descriptors
> index bf927b0..b1ac4c4 100644
> --- a/ext2ed/ext2.descriptors
> +++ b/ext2ed/ext2.descriptors
> @@ -102,7 +102,7 @@ struct ext2_inode {
> 	__u32  i_block[14]; /* Pointers to blocks */
> 	__u32  i_version;	/* File version (for NFS) */
> 	__u32  i_file_acl;	/* File ACL */
> -	__u32  i_dir_acl;	/* Directory ACL */
> +	__u32  i_size_high;	/* High 32bits of size */
> 	__u32  i_faddr;		/* Fragment address */
> 	__u8   l_i_frag;	/* Fragment number */
> 	__u8   l_i_fsize;	/* Fragment size */
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 27a7d3a..195e366 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -398,7 +398,7 @@ struct ext2_inode {
> 	__u32	i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
> 	__u32	i_generation;	/* File version (for NFS) */
> 	__u32	i_file_acl;	/* File ACL */
> -	__u32	i_size_high;	/* Formerly i_dir_acl, directory ACL */
> +	__u32	i_size_high;
> 	__u32	i_faddr;	/* Fragment address */
> 	union {
> 		struct {
> @@ -446,7 +446,7 @@ struct ext2_inode_large {
> 	__u32	i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
> 	__u32	i_generation;	/* File version (for NFS) */
> 	__u32	i_file_acl;	/* File ACL */
> -	__u32	i_size_high;	/* Formerly i_dir_acl, directory ACL */
> +	__u32	i_size_high;
> 	__u32	i_faddr;	/* Fragment address */
> 	union {
> 		struct {
> @@ -484,8 +484,6 @@ struct ext2_inode_large {
> #define EXT4_EPOCH_BITS 2
> #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
>=20
> -#define i_dir_acl	i_size_high
> -
> #define i_checksum_lo	osd2.linux2.l_i_checksum_lo
>=20
> #define inode_includes(size, field)			\
> diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
> index d63fc55..2d05ee7 100644
> --- a/lib/ext2fs/swapfs.c
> +++ b/lib/ext2fs/swapfs.c
> @@ -247,7 +247,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct =
ext2_inode_large *t,
> 		has_extents =3D 1;
> 	if (!hostorder && (t->i_flags & EXT4_INLINE_DATA_FL))
> 		has_inline_data =3D 1;
> -	t->i_dir_acl =3D ext2fs_swab32(f->i_dir_acl);
> +	t->i_size_high =3D ext2fs_swab32(f->i_size_high);
> 	/*
> 	 * Extent data and inline data are swapped on access, not here
> 	 */
> diff --git a/po/at-expand.pl b/po/at-expand.pl
> index bc1a744..47e4ebd 100644
> --- a/po/at-expand.pl
> +++ b/po/at-expand.pl
> @@ -45,7 +45,7 @@ my @translator_help =3D (
>  "#.	%IM	<inode> -> i_mtime\n",
>  "#.	%IF	<inode> -> i_faddr\n",
>  "#.	%If	<inode> -> i_file_acl\n",
> - "#.	%Id	<inode> -> i_dir_acl\n",
> + "#.	%Id	<inode> -> i_size_high\n",
>  "#.	%Iu	<inode> -> i_uid\n",
>  "#.	%Ig	<inode> -> i_gid\n",
>  "#.	%It	<str>			file type\n",
> diff --git a/tests/d_fallocate_blkmap/expect =
b/tests/d_fallocate_blkmap/expect
> index 8ce79ff..f588511 100644
> --- a/tests/d_fallocate_blkmap/expect
> +++ b/tests/d_fallocate_blkmap/expect
> @@ -18,7 +18,7 @@ debugfs: stat /a
> Inode: 12   Type: regular    Mode:  0666   Flags: 0x0
> Generation: 0    Version: 0x00000000:00000000
> User:     0   Group:     0   Project:     0   Size: 40960
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 82
> Fragment:  Address: 0    Number: 0    Size: 0
> Size of extra inode fields: 32
> @@ -30,7 +30,7 @@ debugfs: stat /b
> Inode: 13   Type: regular    Mode:  0666   Flags: 0x0
> Generation: 0    Version: 0x00000000:00000000
> User:     0   Group:     0   Project:     0   Size: 10240000
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 20082
> Fragment:  Address: 0    Number: 0    Size: 0
> Size of extra inode fields: 32
> diff --git a/tests/d_inline_dump/expect b/tests/d_inline_dump/expect
> index c84f64d..f0ba471 100644
> --- a/tests/d_inline_dump/expect
> +++ b/tests/d_inline_dump/expect
> @@ -2,7 +2,7 @@
> Inode: 13   Type: regular    Mode:  0644   Flags: 0x10000000
> Generation: 3289262644    Version: 0x00000000:00000001
> User:     0   Group:     0   Size: 80
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x53cec6b4:c72e3c00 -- Tue Jul 22 20:16:52 2014
> @@ -18,7 +18,7 @@ Size of inline data: 80
> Inode: 18   Type: regular    Mode:  0644   Flags: 0x10000000
> Generation: 3842229473    Version: 0x00000000:00000001
> User:     0   Group:     0   Size: 20
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x53cec6b4:cafecc00 -- Tue Jul 22 20:16:52 2014
> @@ -35,7 +35,7 @@ Size of inline data: 60
> Inode: 16   Type: directory    Mode:  0755   Flags: 0x10000000
> Generation: 3842229469    Version: 0x00000000:00000004
> User:     0   Group:     0   Size: 132
> -File ACL: 7    Directory ACL: 0
> +File ACL: 7
> Links: 2   Blockcount: 8
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x53cec6e3:27eac000 -- Tue Jul 22 20:17:39 2014
> @@ -51,7 +51,7 @@ Size of inline data: 132
> Inode: 20   Type: directory    Mode:  0755   Flags: 0x10000000
> Generation: 3710818931    Version: 0x00000000:00000001
> User:     0   Group:     0   Size: 60
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 2   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x53cec6b4:ca0aa800 -- Tue Jul 22 20:16:52 2014
> @@ -68,7 +68,7 @@ Size of inline data: 60
> Inode: 12   Type: symlink    Mode:  0777   Flags: 0x10000000
> Generation: 3289262643    Version: 0x00000000:00000001
> User:     0   Group:     0   Size: 80
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x53cec47f:724db800 -- Tue Jul 22 20:07:27 2014
> @@ -83,7 +83,7 @@ Fast link dest: =
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> Inode: 19   Type: symlink    Mode:  0777   Flags: 0x0
> Generation: 3842229474    Version: 0x00000000:00000001
> User:     0   Group:     0   Size: 20
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x53cec44c:a1fcc000 -- Tue Jul 22 20:06:36 2014
> diff --git a/tests/d_special_files/expect =
b/tests/d_special_files/expect
> index f729b0f..c825932 100644
> --- a/tests/d_special_files/expect
> +++ b/tests/d_special_files/expect
> @@ -5,7 +5,7 @@ debugfs -R ''stat foo'' -w test.img
> Inode: 12   Type: symlink    Mode:  0777   Flags: 0x0
> Generation: 0    Version: 0x00000000
> User:     0   Group:     0   Size: 3
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
> @@ -17,7 +17,7 @@ debugfs -R ''stat foo2'' -w test.img
> Inode: 13   Type: symlink    Mode:  0777   Flags: 0x0
> Generation: 0    Version: 0x00000000
> User:     0   Group:     0   Size: 80
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 2
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
> @@ -42,7 +42,7 @@ debugfs -R ''stat pipe'' -w test.img
> Inode: 14   Type: FIFO    Mode:  0000   Flags: 0x0
> Generation: 0    Version: 0x00000000
> User:     0   Group:     0   Size: 0
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
> @@ -55,7 +55,7 @@ debugfs -R ''stat sda'' -w test.img
> Inode: 15   Type: block special    Mode:  0000   Flags: 0x0
> Generation: 0    Version: 0x00000000
> User:     0   Group:     0   Size: 0
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
> @@ -67,7 +67,7 @@ debugfs -R ''stat null'' -w test.img
> Inode: 16   Type: character special    Mode:  0000   Flags: 0x0
> Generation: 0    Version: 0x00000000
> User:     0   Group:     0   Size: 0
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
> diff --git a/tests/f_badcluster/expect b/tests/f_badcluster/expect
> index 65a1641..75a3820 100644
> --- a/tests/f_badcluster/expect
> +++ b/tests/f_badcluster/expect
> @@ -116,7 +116,7 @@ debugfs: stat /a
> Inode: 12   Type: regular    Mode:  0644   Flags: 0x80000
> Generation: 1117152157    Version: 0x00000001
> User:     0   Group:     0   Size: 3072
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 32
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
> @@ -128,7 +128,7 @@ debugfs: stat /b
> Inode: 13   Type: regular    Mode:  0644   Flags: 0x80000
> Generation: 1117152158    Version: 0x00000001
> User:     0   Group:     0   Size: 3072
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 32
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
> @@ -140,7 +140,7 @@ debugfs: stat /c
> Inode: 14   Type: regular    Mode:  0644   Flags: 0x80000
> Generation: 1117152159    Version: 0x00000001
> User:     0   Group:     0   Size: 3072
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 32
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
> @@ -152,7 +152,7 @@ debugfs: stat /d
> Inode: 15   Type: regular    Mode:  0644   Flags: 0x80000
> Generation: 1117152160    Version: 0x00000001
> User:     0   Group:     0   Size: 3072
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
> @@ -163,7 +163,7 @@ debugfs: stat /e
> Inode: 16   Type: regular    Mode:  0644   Flags: 0x80000
> Generation: 1117152161    Version: 0x00000001
> User:     0   Group:     0   Size: 6144
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 32
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
> @@ -175,7 +175,7 @@ debugfs: stat /f
> Inode: 17   Type: regular    Mode:  0644   Flags: 0x80000
> Generation: 1117152162    Version: 0x00000001
> User:     0   Group:     0   Size: 3072
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 32
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
> @@ -187,7 +187,7 @@ debugfs: stat /g
> Inode: 18   Type: regular    Mode:  0644   Flags: 0x80000
> Generation: 1117152163    Version: 0x00000001
> User:     0   Group:     0   Size: 3072
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 32
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
> diff --git a/tests/f_convert_bmap/expect.1 =
b/tests/f_convert_bmap/expect.1
> index 7d2ca86..0291f94 100644
> --- a/tests/f_convert_bmap/expect.1
> +++ b/tests/f_convert_bmap/expect.1
> @@ -2,7 +2,7 @@ debugfs: stat /a
> Inode: 12   Type: regular    Mode:  0644   Flags: 0x0
> Generation: 1573716129    Version: 0x00000000:00000001
> User:     0   Group:     0   Size: 524288
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 1030
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x5457f87a:62ae2980 -- Mon Nov  3 21:49:46 2014
> diff --git a/tests/f_convert_bmap_and_extent/expect.1 =
b/tests/f_convert_bmap_and_extent/expect.1
> index 7af91aa..eb55db7 100644
> --- a/tests/f_convert_bmap_and_extent/expect.1
> +++ b/tests/f_convert_bmap_and_extent/expect.1
> @@ -2,7 +2,7 @@ debugfs: stat /a
> Inode: 12   Type: regular    Mode:  0644   Flags: 0x0
> Generation: 1573716129    Version: 0x00000000:00000001
> User:     0   Group:     0   Size: 524288
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 1030
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x5457f87a:62ae2980 -- Mon Nov  3 21:49:46 2014
> diff --git a/tests/f_create_symlinks/expect =
b/tests/f_create_symlinks/expect
> index dca6e92..4409385 100644
> --- a/tests/f_create_symlinks/expect
> +++ b/tests/f_create_symlinks/expect
> @@ -20,7 +20,7 @@ debugfs -R "stat /l_30" test.img
> Inode: 12   Type: symlink    Mode:  0777   Flags: 0x0
> Generation: 0    Version: 0x00000000:00000000
> User:     0   Group:     0   Project:     0   Size: 31
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> Size of extra inode fields: 32
> @@ -29,7 +29,7 @@ debugfs -R "stat /l_70" test.img
> Inode: 13   Type: symlink    Mode:  0777   Flags: 0x10000000
> Generation: 0    Version: 0x00000000:00000000
> User:     0   Group:     0   Project:     0   Size: 71
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> Size of extra inode fields: 32
> @@ -40,7 +40,7 @@ debugfs -R "stat /l_500" test.img
> Inode: 14   Type: symlink    Mode:  0777   Flags: 0x80000
> Generation: 0    Version: 0x00000000:00000000
> User:     0   Group:     0   Project:     0   Size: 501
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 2
> Fragment:  Address: 0    Number: 0    Size: 0
> Size of extra inode fields: 32
> @@ -50,7 +50,7 @@ debugfs -R "stat /l_1023" test.img
> Inode: 15   Type: symlink    Mode:  0777   Flags: 0x80000
> Generation: 0    Version: 0x00000000:00000000
> User:     0   Group:     0   Project:     0   Size: 1024
> -File ACL: 0    Directory ACL: 0
> +File ACL: 0
> Links: 1   Blockcount: 2
> Fragment:  Address: 0    Number: 0    Size: 0
> Size of extra inode fields: 32
> diff --git a/tests/f_recnect_bad/expect.1 =
b/tests/f_recnect_bad/expect.1
> index 8ba81e6..d4f72a1 100644
> --- a/tests/f_recnect_bad/expect.1
> +++ b/tests/f_recnect_bad/expect.1
> @@ -3,7 +3,7 @@ Pass 2: Checking directory structure
> i_faddr for inode 15 (/test/quux) is 23, should be zero.
> Clear? yes
>=20
> -i_dir_acl for inode 15 (/test/quux) is 12, should be zero.
> +i_size_high for inode 15 (/test/quux) is 12, should be zero.
> Clear? yes
>=20
> i_file_acl for inode 13 (/test/???) is 12, should be zero.
> --
> 1.7.1
>=20


Cheers, Andreas






--Apple-Mail=_08C59766-B010-40C5-AFDA-1166B20251C9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYo2M3pIg59Q01vtYRAkK6AKCHPY9vPjLIgtQOXeouIRjw2k8DJwCfQStS
6eRLeLrrOKLoAA8vAp9Ttek=
=NLK4
-----END PGP SIGNATURE-----

--Apple-Mail=_08C59766-B010-40C5-AFDA-1166B20251C9--
