From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [v1 2/4] Add project quota support
Date: Sat, 12 Dec 2015 04:04:25 -0700
Message-ID: <EB95134E-B618-4673-B658-9A16DC431B06@dilger.ca>
References: <1446046933-26571-1-git-send-email-lixi@ddn.com> <1446046933-26571-3-git-send-email-lixi@ddn.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_0A337BA1-175E-4C57-B757-7976B1CC7416"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36722 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbbLLLEc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Dec 2015 06:04:32 -0500
Received: by iofo67 with SMTP id o67so1988141iof.3
        for <linux-ext4@vger.kernel.org>; Sat, 12 Dec 2015 03:04:31 -0800 (PST)
In-Reply-To: <1446046933-26571-3-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_0A337BA1-175E-4C57-B757-7976B1CC7416
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 28, 2015, at 9:42 AM, Li Xi <pkuelelixi@gmail.com> wrote:
>=20
> Signed-off-by: Li Xi <lixi@ddn.com>
> Change-Id: I30e6e56f8d45e26e2c6c5a1ffae1cf32f1c923cb
> ---
> debugfs/set_fields.c            |    1 +
> e2fsck/pass1.c                  |   17 ++++++++++++-----
> lib/e2p/ls.c                    |    1 +
> lib/ext2fs/ext2_fs.h            |    6 +++++-
> lib/ext2fs/swapfs.c             |    2 ++
> lib/ext2fs/tst_inode_size.c     |    1 +
> lib/ext2fs/tst_super_size.c     |    3 ++-
> lib/support/mkquota.c           |    5 +++++
> lib/support/quotaio.c           |    9 ++++++++-
> lib/support/quotaio.h           |   11 ++++++++---
> misc/mke2fs.c                   |    6 ++++++
> misc/tune2fs.c                  |    4 ++++
> tests/d_fallocate_blkmap/expect |    4 ++--
> tests/f_create_symlinks/expect  |    8 ++++----
> tests/m_bigjournal/expect.1     |    4 ++--
> tests/m_large_file/expect.1     |    4 ++--
> tests/m_quota/expect.1          |   15 ++++++++-------
> 17 files changed, 73 insertions(+), 28 deletions(-)
>=20
> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
> index 57ef871..c027d8e 100644
> --- a/debugfs/set_fields.c
> +++ b/debugfs/set_fields.c
> @@ -153,6 +153,7 @@ static struct field_set_info super_fields[] =3D {
> 	{ "mount_opts",  &set_sb.s_mount_opts, NULL, 64, parse_string },
> 	{ "usr_quota_inum", &set_sb.s_usr_quota_inum, NULL, 4, =
parse_uint },
> 	{ "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, =
parse_uint },
> +	{ "prj_quota_inum", &set_sb.s_prj_quota_inum, NULL, 4, =
parse_uint },
> 	{ "overhead_blocks", &set_sb.s_overhead_blocks, NULL, 4, =
parse_uint },
> 	{ "backup_bgs", &set_sb.s_backup_bgs[0], NULL, 4, parse_uint,
> 	  FLAG_ARRAY, 2 },
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 23d15bd..eb3d19d 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -965,13 +965,20 @@ static int quota_inum_is_super(struct =
ext2_super_block *sb, ext2_ino_t ino)
> 	return 0;
> }
>=20
> -static int quota_inum_is_reserved(ext2_ino_t ino)
> +static int quota_inum_is_reserved(ext2_filsys fs, ext2_ino_t ino)
> {
> 	enum quota_type qtype;
>=20
> -	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++)
> -		if (quota_type2inum(qtype) =3D=3D ino)
> -			return 1;
> +	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +		if (quota_type2inum(qtype) =3D=3D ino) {
> +			if (qtype !=3D PRJQUOTA)
> +				return 1;

No need for "else" after return.

> +			else if (quota_inum_is_super(fs->super, ino))
> +				return 1;
> +			else
> +				return 0;

The complexity of this check makes me feel that it is doing the wrong
thing.  quota_type2inum() returns only the reserved quota inodes
EXT4_USR_QUOTA_INO, EXT4_GRP_QUOTA_INO, EXT4_PRJ_QUOTA_INO even
if they are not in use.  Is the intent of checking quota_inum_is_super()
to see if the superblock is referencing the reserved inode also?  Why
would it matter, instead of:

                        return (ino < fs->super->s_first_ino);

That would always be true for USR and GRP, and would be true if PRJ
quota was enabled at format time, or if something else increased the
reserved inode count, in which case the EXT4_PRJ_QUOTA_INO should
also be handled in the same way as USR and GRP inodes.

If we decide that (ino < fs->super->s_first_ino) is correct, it could
be moved into the 1/4 patch I think, though it doesn't really matter.

> +		}
> +	}
>=20
> 	return 0;
> }
> @@ -1526,7 +1533,7 @@ void e2fsck_pass1(e2fsck_t ctx)
> 							inode_size, =
"pass1");
> 				failed_csum =3D 0;
> 			}
> -		} else if (quota_inum_is_reserved(ino)) {
> +		} else if (quota_inum_is_reserved(fs, ino)) {
> 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, =
ino);
> 			if ((fs->super->s_feature_ro_compat &
> 					EXT4_FEATURE_RO_COMPAT_QUOTA) &&
> diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
> index 4e80372..d9594cd 100644
> --- a/lib/e2p/ls.c
> +++ b/lib/e2p/ls.c
> @@ -210,6 +210,7 @@ static const char *checksum_type(__u8 type)
> static const char const *quota_prefix[MAXQUOTAS] =3D {
>         [USRQUOTA] =3D "User quota inode:",
>         [GRPQUOTA] =3D "Group quota inode:",
> +        [PRJQUOTA] =3D "Project quota inode:",
> };
>=20
> /**
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index cfeaa05..a5f4124 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -52,6 +52,7 @@
> #define EXT2_JOURNAL_INO	 8	/* Journal inode */
> #define EXT2_EXCLUDE_INO	 9	/* The "exclude" inode, for =
snapshots */
> #define EXT4_REPLICA_INO	10	/* Used by non-upstream feature =
*/
> +#define EXT4_PRJ_QUOTA_INO	11	/* Project quota inode */

This should be reserved as EXT4_LOST_FOUND_INO just to avoid many =
potential
compatibility problems, and then use "12" for EXT4_PRJ_QUOTA_INO.

> /* First non-reserved inode for old ext2 filesystems */
> #define EXT2_GOOD_OLD_FIRST_INO	11

This value should be left as-is, and then a new constant used to =
increase the
reserved inodes significantly, like:

#define EXT2_NEW_FIRST_INO 32

Some places need to keep using EXT2_GOOD_OLD_FIRST_INO, but we should =
consider
to change ext2fs_initialize() to use EXT2_NEW_FIRST_INO as well, or =
should
that only be done on a case-by-case basis for features that need a new
reserved inode, and hope that the feature flags will deter other tools
that assume "11 =3D lost+found"?

> @@ -473,6 +474,7 @@ struct ext2_inode_large {
> 	__u32	i_crtime;	/* File creation time */
> 	__u32	i_crtime_extra;	/* extra File creation time (nsec << 2 | =
epoch)*/
> 	__u32	i_version_hi;	/* high 32 bits for 64-bit version */
> +	__u32   i_projid;       /* Project ID */
> };
>=20
> #define EXT4_INODE_CSUM_HI_EXTRA_END	\
> @@ -506,6 +508,7 @@ struct ext2_inode_large {
>=20
> #define inode_uid(inode)	((inode).i_uid | =
(inode).osd2.linux2.l_i_uid_high << 16)
> #define inode_gid(inode)	((inode).i_gid | =
(inode).osd2.linux2.l_i_gid_high << 16)
> +#define inode_projid(large_inode) ((large_inode).i_projid)
> #define ext2fs_set_i_uid_high(inode,x) =
((inode).osd2.linux2.l_i_uid_high =3D (x))
> #define ext2fs_set_i_gid_high(inode,x) =
((inode).osd2.linux2.l_i_gid_high =3D (x))
>=20
> @@ -719,7 +722,8 @@ struct ext2_super_block {
> 	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  =
*/
> 	__u8	s_encrypt_pw_salt[16];	/* Salt used for string2key =
algorithm */
> 	__le32	s_lpf_ino;		/* Location of the lost+found =
inode */
> -	__le32	s_reserved[100];	/* Padding to the end of the =
block */
> +	__u32   s_prj_quota_inum;	/* inode number of project quota =
file */
> +	__le32	s_reserved[99];		/* Padding to the end of the =
block */
> 	__u32	s_checksum;		/* crc32c(superblock) */
> };
>=20
> diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
> index ee7a455..bc50fd4 100644
> --- a/lib/ext2fs/swapfs.c
> +++ b/lib/ext2fs/swapfs.c
> @@ -320,6 +320,8 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct =
ext2_inode_large *t,
> 		t->i_crtime_extra =3D ext2fs_swab32(f->i_crtime_extra);
> 	if (extra_isize >=3D 28)
> 		t->i_version_hi =3D ext2fs_swab32(f->i_version_hi);
> +	if (extra_isize >=3D 32)
> +		t->i_projid =3D ext2fs_swab32(f->i_projid);

It seems to me that this should be using offsetof() instead of =
hard-coding
the field offsets, since that seems prone to error, but this is not =
worse
than any of the other code here.

> 	i =3D sizeof(struct ext2_inode) + extra_isize + sizeof(__u32);
> 	if (bufsize < (int) i)
> diff --git a/lib/ext2fs/tst_inode_size.c b/lib/ext2fs/tst_inode_size.c
> index e20ec98..cc5d165 100644
> --- a/lib/ext2fs/tst_inode_size.c
> +++ b/lib/ext2fs/tst_inode_size.c
> @@ -81,6 +81,7 @@ int main(int argc, char **argv)
> 	check_field(i_crtime, 4);
> 	check_field(i_crtime_extra, 4);
> 	check_field(i_version_hi, 4);
> +	check_field(i_projid, 4);
> 	/* This size will change as new fields are added */
> 	do_field("Large inode end", 0, 0, cur_offset, sizeof(inode));
> #endif
> diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
> index 8e3c21f..9b25cce 100644
> --- a/lib/ext2fs/tst_super_size.c
> +++ b/lib/ext2fs/tst_super_size.c
> @@ -140,7 +140,8 @@ int main(int argc, char **argv)
> 	check_field(s_encrypt_algos, 4);
> 	check_field(s_encrypt_pw_salt, 16);
> 	check_field(s_lpf_ino, 4);
> -	check_field(s_reserved, 100 * 4);
> +	check_field(s_prj_quota_inum, 4);
> +	check_field(s_reserved, 99 * 4);
> 	check_field(s_checksum, 4);
> 	do_field("Superblock end", 0, 0, cur_offset, 1024);
> #endif
> diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
> index b74c885..442fd38 100644
> --- a/lib/support/mkquota.c
> +++ b/lib/support/mkquota.c
> @@ -233,11 +233,16 @@ static int dict_uint_cmp(const void *a, const =
void *b)
>=20
> static inline qid_t get_qid(struct ext2_inode *inode, enum quota_type =
qtype)
> {
> +	struct ext2_inode_large *large_inode;
> +
> 	switch (qtype) {
> 		case USRQUOTA:
> 			return inode_uid(*inode);
> 		case GRPQUOTA:
> 			return inode_gid(*inode);
> +		case PRJQUOTA:
> +			large_inode =3D (struct ext2_inode_large *) =
inode;

No space after typecast.

> +			return inode_projid(*large_inode);
> 		default:
> 			return 0;
> 	}
> diff --git a/lib/support/quotaio.c b/lib/support/quotaio.c
> index bd8123e..6f52409 100644
> --- a/lib/support/quotaio.c
> +++ b/lib/support/quotaio.c
> @@ -20,7 +20,11 @@
> #include "common.h"
> #include "quotaio.h"
>=20
> -static const char * const extensions[MAXQUOTAS] =3D {"user", =
"group"};
> +static const char * const extensions[MAXQUOTAS] =3D {
> +	[USRQUOTA] =3D "user",
> +	[GRPQUOTA] =3D "group",
> +	[PRJQUOTA] =3D "project",
> +};
> static const char * const basenames[] =3D {
> 	"",		/* undefined */
> 	"quota",	/* QFMT_VFS_OLD */
> @@ -56,6 +60,9 @@ ext2_ino_t quota_type2inum(enum quota_type qtype)
> 	case GRPQUOTA:
> 		return EXT4_GRP_QUOTA_INO;
> 		break;
> +	case PRJQUOTA:
> +		return EXT4_PRJ_QUOTA_INO;
> +		break;
> 	default:
> 		return 0;
> 		break;
> diff --git a/lib/support/quotaio.h b/lib/support/quotaio.h
> index fc114e2..438d077 100644
> --- a/lib/support/quotaio.h
> +++ b/lib/support/quotaio.h
> @@ -46,9 +46,10 @@ typedef int64_t qsize_t;	/* Type in which we =
store size limitations */
> enum quota_type {
> 	USRQUOTA =3D 0,
> 	GRPQUOTA =3D 1,
> +	PRJQUOTA =3D 2,
> };
>=20
> -#define MAXQUOTAS 2
> +#define MAXQUOTAS 3

This should be the last item in the enum.

> #if MAXQUOTAS > 32
> #error "cannot have more than 32 quota types to fit in qtype_bits"
> @@ -56,7 +57,8 @@ enum quota_type {
>=20
> #define QUOTA_USR_BIT (1 << USRQUOTA)
> #define QUOTA_GRP_BIT (1 << GRPQUOTA)
> -#define QUOTA_ALL_BIT (QUOTA_USR_BIT | QUOTA_GRP_BIT)
> +#define QUOTA_PRJ_BIT (1 << PRJQUOTA)
> +#define QUOTA_ALL_BIT (QUOTA_USR_BIT | QUOTA_GRP_BIT | QUOTA_PRJ_BIT)
>=20
> typedef struct quota_ctx *quota_ctx_t;
> struct dict_t;
> @@ -72,7 +74,8 @@ struct quota_ctx {
>  */
> #define INITQMAGICS {\
> 	0xd9c01f11,	/* USRQUOTA */\
> -	0xd9c01927	/* GRPQUOTA */\
> +	0xd9c01927,	/* GRPQUOTA */\
> +	0xd9c03f14      /* PRJQUOTA */\
> }
>=20
> /* Size of blocks in which are counted size limits in generic utility =
parts */
> @@ -240,6 +243,8 @@ static inline ext2_ino_t *quota_sb_inump(struct =
ext2_super_block *sb, enum quota
> 			return &sb->s_usr_quota_inum;
> 		case GRPQUOTA:
> 			return &sb->s_grp_quota_inum;
> +		case PRJQUOTA:
> +			return &sb->s_prj_quota_inum;
> 		default:
> 			return NULL;
> 	}
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 5ead18e..97aa8c4 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1017,6 +1017,8 @@ static void parse_extended_opts(struct =
ext2_super_block *param,
> 				quotatype_bits =3D QUOTA_USR_BIT;
> 			} else if (!strncmp(arg, "grp", 3)) {
> 				quotatype_bits =3D QUOTA_GRP_BIT;
> +			} else if (!strncmp(arg, "prj", 3)) {
> +				quotatype_bits =3D QUOTA_PRJ_BIT;

See comments on previous patch.  This would only allow enabling a single
quota type at a time, which probably isn't enough if someone wants to
enable both "usr,grp" but not "prj".

> 			} else {
> 				fprintf(stderr,
> 					_("Invalid quotatype parameter: =
%s\n"),
> @@ -2961,6 +2963,10 @@ int main (int argc, char *argv[])
> 		exit(ext2fs_close_free(&fs) ? 1 : 0);
> 	}
>=20
> +	if (EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
> +				       EXT4_FEATURE_RO_COMPAT_QUOTA))
> +		fs->super->s_first_ino =3D EXT2_GOOD_OLD_FIRST_INO + 1;

This changes compatibility, but hides the details deep in the code here
and doesn't gain much benefit for the future.  This should use the
EXT2_NEW_FIRST_INO constant as described above.

> +
> 	if (bad_blocks_filename)
> 		read_bb_file(fs, &bb_list, bad_blocks_filename);
> 	if (cflag)
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 1684225..94e962c 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -1500,6 +1500,10 @@ static void parse_quota_opts(const char *opts)
> 			quota_enable[GRPQUOTA] =3D QOPT_ENABLE;
> 		} else if (strcmp(token, "^grpquota") =3D=3D 0) {
> 			quota_enable[GRPQUOTA] =3D QOPT_DISABLE;
> +		} else if (strcmp(token, "prjquota") =3D=3D 0) {
> +			quota_enable[PRJQUOTA] =3D QOPT_ENABLE;
> +		} else if (strcmp(token, "^prjquota") =3D=3D 0) {
> +			quota_enable[PRJQUOTA] =3D QOPT_DISABLE;
> 		} else {
> 			fputs(_("\nBad quota options specified.\n\n"
> 				"Following valid quota options are =
available "
> diff --git a/tests/d_fallocate_blkmap/expect =
b/tests/d_fallocate_blkmap/expect
> index f7ae606..a66b06a 100644
> --- a/tests/d_fallocate_blkmap/expect
> +++ b/tests/d_fallocate_blkmap/expect
> @@ -21,7 +21,7 @@ User:     0   Group:     0   Size: 40960
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 82
> Fragment:  Address: 0    Number: 0    Size: 0
> -Size of extra inode fields: 28
> +Size of extra inode fields: 32
> BLOCKS:
> (0-1):1312-1313, (2-11):8000-8009, (IND):8010, (12-39):8011-8038
> TOTAL: 41
> @@ -33,7 +33,7 @@ User:     0   Group:     0   Size: 10240000
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 20082
> Fragment:  Address: 0    Number: 0    Size: 0
> -Size of extra inode fields: 28
> +Size of extra inode fields: 32
> BLOCKS:
> (0-11):10000-10011, (IND):10012, (12-267):10013-10268, (DIND):10269, =
(IND):10270, (268-523):10271-10526, (IND):10527, (524-779):10528-10783, =
(IND):10784, (780-1035):10785-11040, (IND):11041, =
(1036-1291):11042-11297, (IND):11298, (1292-1547):11299-11554, =
(IND):11555, (1548-1803):11556-11811, (IND):11812, =
(1804-2059):11813-12068, (IND):12069, (2060-2315):12070-12325, =
(IND):12326, (2316-2571):12327-12582, (IND):12583, =
(2572-2827):12584-12839, (IND):12840, (2828-3083):12841-13096, =
(IND):13097, (3084-3339):13098-13353, (IND):13354, =
(3340-3595):13355-13610, (IND):13611, (3596-3851):13612-13867, =
(IND):13868, (3852-4107):13869-14124, (IND):14125, =
(4108-4363):14126-14381, (IND):14382, (4364-4619):14383-14638, =
(IND):14639, (4620-4875):14640-14895, (IND):14896, =
(4876-5131):14897-15152, (IND):15153, (5132-5387):15154-15409, =
(IND):15410, (5388-5643):15411-15666, (IND):15667, =
(5644-5899):15668-15923, (IND):15924, (5900-6155):15925-16180, =
(IND):16181, (6156-6411):16182-16437, (IND):16438, =
(6412-6667):16439-16694, (IND):16695, (6668-6923):16696-16951, =
(IND):16952, (6924-7179):16953-17208, (IND):17209, =
(7180-7435):17210-17465, (IND):17466, (7436-7691):17467-17722, =
(IND):17723, (7692-7947):17724-17979, (IND):17980, =
(7948-8203):17981-18236, (IND):18237, (8204-8459):18238-18493, =
(IND):18494, (8460-8715):18495-18750, (IND):18751, =
(8716-8971):18752-19007, (IND):19008, (8972-9227):19009-19264, =
(IND):19265, (9228-9483):19266-19521, (IND):19522, =
(9484-9739):19523-19778, (IND):19779, (9740-9995):19780-20035, =
(IND):20036, (9996-9999):20037-20040
> TOTAL: 10041
> diff --git a/tests/f_create_symlinks/expect =
b/tests/f_create_symlinks/expect
> index 47fa468..6e1553c 100644
> --- a/tests/f_create_symlinks/expect
> +++ b/tests/f_create_symlinks/expect
> @@ -23,7 +23,7 @@ User:     0   Group:     0   Size: 31
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> -Size of extra inode fields: 28
> +Size of extra inode fields: 32
> Fast link dest: "/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
> debugfs -R "stat /l_70" test.img
> Inode: 13   Type: symlink    Mode:  0777   Flags: 0x10000000
> @@ -32,7 +32,7 @@ User:     0   Group:     0   Size: 71
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> -Size of extra inode fields: 28
> +Size of extra inode fields: 32
> Extended attributes:
>   system.data (11)
> Fast link dest: =
"/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
> @@ -43,7 +43,7 @@ User:     0   Group:     0   Size: 501
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 2
> Fragment:  Address: 0    Number: 0    Size: 0
> -Size of extra inode fields: 28
> +Size of extra inode fields: 32
> EXTENTS:
> (0):153
> debugfs -R "stat /l_1023" test.img
> @@ -53,7 +53,7 @@ User:     0   Group:     0   Size: 1024
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 2
> Fragment:  Address: 0    Number: 0    Size: 0
> -Size of extra inode fields: 28
> +Size of extra inode fields: 32
> EXTENTS:
> (0):154
> debugfs -R "stat /l_1024" test.img
> diff --git a/tests/m_bigjournal/expect.1 b/tests/m_bigjournal/expect.1
> index 61d85f9..8900596 100644
> --- a/tests/m_bigjournal/expect.1
> +++ b/tests/m_bigjournal/expect.1
> @@ -35,8 +35,8 @@ Reserved blocks uid:      0
> Reserved blocks gid:      0
> First inode:              11
> Inode size:	          256
> -Required extra isize:     28
> -Desired extra isize:      28
> +Required extra isize:     32
> +Desired extra isize:      32
> Journal inode:            8
> Default directory hash:   half_md4
> Journal backup:           inode blocks
> diff --git a/tests/m_large_file/expect.1 b/tests/m_large_file/expect.1
> index 4acca41..06c8257 100644
> --- a/tests/m_large_file/expect.1
> +++ b/tests/m_large_file/expect.1
> @@ -40,8 +40,8 @@ Reserved blocks uid:      0
> Reserved blocks gid:      0
> First inode:              11
> Inode size:	          256
> -Required extra isize:     28
> -Desired extra isize:      28
> +Required extra isize:     32
> +Desired extra isize:      32
> Default directory hash:   half_md4
>=20
>=20
> diff --git a/tests/m_quota/expect.1 b/tests/m_quota/expect.1
> index 787871c..dc8eca9 100644
> --- a/tests/m_quota/expect.1
> +++ b/tests/m_quota/expect.1
> @@ -12,7 +12,7 @@ Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> -test_filesys: 11/32768 files (18.2% non-contiguous), 5703/131072 =
blocks
> +test_filesys: 12/32768 files (25.0% non-contiguous), 5709/131072 =
blocks
> Exit status is 0
> Filesystem volume name:   <none>
> Last mounted on:          <not available>
> @@ -26,8 +26,8 @@ Filesystem OS type:       Linux
> Inode count:              32768
> Block count:              131072
> Reserved block count:     6553
> -Free blocks:              125369
> -Free inodes:              32757
> +Free blocks:              125363
> +Free inodes:              32756
> First block:              1
> Block size:               1024
> Fragment size:            1024
> @@ -40,11 +40,12 @@ Mount count:              0
> Check interval:           15552000 (6 months)
> Reserved blocks uid:      0
> Reserved blocks gid:      0
> -First inode:              11
> +First inode:              12
> Inode size:	          128
> Default directory hash:   half_md4
> User quota inode:         3
> Group quota inode:        4
> +Project quota inode:      11
>=20
>=20
> Group 0: (Blocks 1-8192)
> @@ -52,9 +53,9 @@ Group 0: (Blocks 1-8192)
>   Reserved GDT blocks at 3-258
>   Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
>   Inode table at 261-516 (+260)
> -  7650 free blocks, 2037 free inodes, 2 directories
> -  Free blocks: 543-8192
> -  Free inodes: 12-2048
> +  7644 free blocks, 2036 free inodes, 2 directories
> +  Free blocks: 549-8192
> +  Free inodes: 13-2048
> Group 1: (Blocks 8193-16384)
>   Backup superblock at 8193, Group descriptors at 8194-8194
>   Reserved GDT blocks at 8195-8450
> --
> 1.7.1
>=20


Cheers, Andreas






--Apple-Mail=_0A337BA1-175E-4C57-B757-7976B1CC7416
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVmv/OXKl2rkXzB/gAQg9QhAAuCBmT3KVtk4zbnpFd77kvdbPj9e5DWHO
ZxEl8R5OXP0AcQ8D3/5ZMcdq0uAWhjZ+il8ZA4K2JwH8wl6ftZqRW5jO8aIE4YsO
7WqNbFfBXKbJn16l3DjCZuchgw9WXCcDNjHQO8htLMygF+orMZBVAyP0lVM4OJWm
/YhzlOfSwdiOSCyYcn0d8fLA8ZlIrwTPfNUtqRIKta7JikoWYlS3xlS8p4Znd4QR
XcgnwWpN2tF4wkh3EpY17JbOtaydxkufl48muWO/JNs4ey2LFWNwGsLfIVIDt71Q
cZ14GChCkDpaGkdfCDfzQSZK2o50mMR0KvuAn50CLr1ppQE/E59JeQrlu8ob2vr9
wRmNrv3ygdsuy3qVT9LQnA4QhK4lJ0M30Yi+HhZ3UTQzQyQ/5PjzBdPgNXZFYanO
s23LVGnyW2klydKLJVjNY1veX6uiD93tO+dDx5H0sje7vWuzkHpKp4FM7XB6Ypmh
NFjoM92mdxHt6ZG5Diq2KVUXCI/3DeSiCLGwb1A+COGXSPYcNbBcUEVbHJSeSHkX
FI48TfsEbHl1yxAibtXT94KzW/qk5bFwOXbAC5MoOjCw3HN1vrZLq1BFtoSRmTHX
zilMqnSeKjmxzRTqjlXHLsC97cTqYeVDQCxAHtjmljyqEKasJBmZzkRHINs0hHji
vkv3JQF1OrE=
=ASyJ
-----END PGP SIGNATURE-----

--Apple-Mail=_0A337BA1-175E-4C57-B757-7976B1CC7416--
