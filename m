From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] e2fsprogs: reserving code points for new ext4 quota feature
Date: Tue, 15 Feb 2011 06:39:02 +0200
Message-ID: <AANLkTim8JqZpG2gf0Jhy3nPd6Xr-rYj9BdKot0BpshoH@mail.gmail.com>
References: <AANLkTik3Ff7jokEL47uaLphwAP9hcd_16-eb3P8Cvagf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43653 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab1BOEjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Feb 2011 23:39:04 -0500
Received: by qwa26 with SMTP id 26so3659251qwa.19
        for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 20:39:03 -0800 (PST)
In-Reply-To: <AANLkTik3Ff7jokEL47uaLphwAP9hcd_16-eb3P8Cvagf@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 15, 2011 at 3:07 AM, Aditya Kali <adityakali@google.com> wr=
ote:
> This patch adds support for detecting the new 'quota' feature in ext4=
=2E
> The patch reserves code points for usr and group quota inodes and als=
o
> for the feature flag EXT4_FEATURE_RO_COMPAT_QUOTA.
>
> Signed-off-by: Aditya Kali <adityakali@google.com>
> ---
> =A0debugfs/set_fields.c =A0 =A0 =A0 =A0| =A0 =A02 ++
> =A0lib/blkid/probe.h =A0 =A0 =A0 =A0 =A0 | =A0 =A01 +
> =A0lib/e2p/feature.c =A0 =A0 =A0 =A0 =A0 | =A0 =A02 ++
> =A0lib/e2p/ls.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A04 ++++
> =A0lib/ext2fs/ext2_fs.h =A0 =A0 =A0 =A0| =A0 =A08 +++++++-
> =A0lib/ext2fs/tst_super_size.c | =A0 =A02 ++
> =A06 files changed, 18 insertions(+), 1 deletions(-)
>
> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
> index 1f4c501..a54f3e1 100644
> --- a/debugfs/set_fields.c
> +++ b/debugfs/set_fields.c
> @@ -141,6 +141,8 @@ static struct field_set_info super_fields[] =3D {
> =A0 =A0 =A0 =A0 =A0parse_uint },
> =A0 =A0 =A0 =A0{ "snapshot_list", &set_sb.s_snapshot_list, 4, parse_u=
int },
> =A0 =A0 =A0 =A0{ "mount_opts", =A0&set_sb.s_mount_opts, 64, parse_str=
ing },
> + =A0 =A0 =A0 { "usr_quota_inum", &set_sb.s_usr_quota_inum, 4, parse_=
uint },
> + =A0 =A0 =A0 { "grp_quota_inum", &set_sb.s_grp_quota_inum, 4, parse_=
uint },
> =A0 =A0 =A0 =A0{ 0, 0, 0, 0 }
> =A0};
>
> diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
> index 37fc9c0..37e80ef 100644
> --- a/lib/blkid/probe.h
> +++ b/lib/blkid/probe.h
> @@ -109,6 +109,7 @@ struct ext2_super_block {
> =A0#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A00x0010
> =A0#define EXT4_FEATURE_RO_COMPAT_DIR_NLINK =A0 =A0 =A0 0x0020
> =A0#define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE =A0 =A0 0x0040
> +#define EXT4_FEATURE_RO_COMPAT_QUOTA =A0 =A0 =A0 =A0 =A0 0x0100
>
> =A0/* for s_feature_incompat */
> =A0#define EXT2_FEATURE_INCOMPAT_FILETYPE =A0 =A0 =A0 =A0 0x0002
> diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
> index c7f8a35..9324199 100644
> --- a/lib/e2p/feature.c
> +++ b/lib/e2p/feature.c
> @@ -55,6 +55,8 @@ static struct feature feature_list[] =3D {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"dir_nlink" },
> =A0 =A0 =A0 =A0{ =A0 =A0 =A0 E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO=
_COMPAT_EXTRA_ISIZE,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"extra_isize" },
> + =A0 =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_=
COMPAT_QUOTA,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "quota" },
>
> =A0 =A0 =A0 =A0{ =A0 =A0 =A0 E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOM=
PAT_COMPRESSION,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"compression" },
> diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
> index d76902b..235832f 100644
> --- a/lib/e2p/ls.c
> +++ b/lib/e2p/ls.c
> @@ -394,6 +394,10 @@ void list_super2(struct ext2_super_block * sb, F=
ILE *f)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(f, "Last error block #: =A0 =A0=
 =A0 %llu\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_last_error_block=
);
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 fprintf(f, "User quota inode: =A0 =A0 =A0 =A0 %u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_usr_quota_inum);
> + =A0 =A0 =A0 fprintf(f, "Group quota inode: =A0 =A0 =A0 =A0%u\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_grp_quota_inum);
> =A0}
>
> =A0void list_super (struct ext2_super_block * s)
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index fee3919..74f5a2f 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -52,6 +52,9 @@
> =A0#define EXT2_JOURNAL_INO =A0 =A0 =A0 =A08 =A0 =A0 =A0/* Journal in=
ode */
> =A0#define EXT2_EXCLUDE_INO =A0 =A0 =A0 =A09 =A0 =A0 =A0/* The "exclu=
de" inode, for snapshots */
>
> +#define EXT4_USR_QUOTA_INO =A0 =A0 =A03 =A0 =A0 =A0/* User quota ino=
de */
> +#define EXT4_GRP_QUOTA_INO =A0 =A0 =A04 =A0 =A0 =A0/* Group quota in=
ode */
> +
> =A0/* First non-reserved inode for old ext2 filesystems */
> =A0#define EXT2_GOOD_OLD_FIRST_INO =A0 =A0 =A0 =A011
>
> @@ -617,7 +620,9 @@ struct ext2_super_block {
> =A0 =A0 =A0 =A0__u8 =A0 =A0s_last_error_func[32]; =A0/* function wher=
e the error happened */
> =A0#define EXT4_S_ERR_END ext4_offsetof(struct ext2_super_block, s_mo=
unt_opts)
> =A0 =A0 =A0 =A0__u8 =A0 =A0s_mount_opts[64];
> - =A0 =A0 =A0 __u32 =A0 s_reserved[112]; =A0 =A0 =A0 =A0/* Padding to=
 the end of the block */
> + =A0 =A0 =A0 __u32 =A0 s_usr_quota_inum;
> + =A0 =A0 =A0 __u32 =A0 s_grp_quota_inum;
> + =A0 =A0 =A0 __u32 =A0 s_reserved[110]; =A0 =A0 =A0 =A0/* Padding to=
 the end of the block */
> =A0};
>
> =A0#define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)
> @@ -675,6 +680,7 @@ struct ext2_super_block {
> =A0#define EXT4_FEATURE_RO_COMPAT_DIR_NLINK =A0 =A0 =A0 0x0020
> =A0#define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE =A0 =A0 0x0040
> =A0#define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT =A0 =A00x0080
> +#define EXT4_FEATURE_RO_COMPAT_QUOTA =A0 =A0 =A0 =A0 =A0 0x0100
>
> =A0#define EXT2_FEATURE_INCOMPAT_COMPRESSION =A0 =A0 =A00x0001
> =A0#define EXT2_FEATURE_INCOMPAT_FILETYPE =A0 =A0 =A0 =A0 0x0002
> diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.=
c
> index eb9114f..a3a5b44 100644
> --- a/lib/ext2fs/tst_super_size.c
> +++ b/lib/ext2fs/tst_super_size.c
> @@ -123,6 +123,8 @@ void check_superblock_fields()
> =A0 =A0 =A0 =A0check_field(s_last_error_block);
> =A0 =A0 =A0 =A0check_field(s_last_error_func);
> =A0 =A0 =A0 =A0check_field(s_mount_opts);
> + =A0 =A0 =A0 check_field(s_usr_quota_inum);
> + =A0 =A0 =A0 check_field(s_grp_quota_inum);
> =A0 =A0 =A0 =A0check_field(s_reserved);
> =A0 =A0 =A0 =A0printf("Ending offset is %d\n\n", cur_offset);
> =A0#endif
> --
> 1.7.3.1
> --

Your fields should probably be added to swap_super() as well.

Other then that, looks fine to me.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
