From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: [PATCH] ext4/super.c: Replace CONTIG_EXT{2,3}_FS by
	CONFIG_EXT{2,3}_FS
Date: Wed, 24 Mar 2010 17:57:34 +0100
Message-ID: <2d0a357f1003240957r21f869cft5685d2e214f47914@mail.gmail.com>
References: <2d0a357f1003240405x1178f0c6x188d30d1d311cb5@mail.gmail.com>
	 <20100324161201.GG2159@thunk.org>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54660 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab0CXQ5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 12:57:36 -0400
Received: by wwe15 with SMTP id 15so5218582wwe.19
        for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 09:57:34 -0700 (PDT)
In-Reply-To: <20100324161201.GG2159@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the fast fix - hope this goes soon into linus-tree.

(Missed a Reported-By, sorry).

--
Sedat

On Wed, Mar 24, 2010 at 5:12 PM,  <tytso@mit.edu> wrote:
> Thanks for catching this! =C2=A0This should fix it up...
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 - Ted
>
> ext4: Fix build error when EXT4_USE_FOR_EXT23 disabled
>
> Fix a stupid type (CONTIG !=3D CONFIG) and a stupid assumption that
> ext3_fs_type would always be defined.
>
> (The build failure could also happen when EXT4_USE_FOR_EXT23 is
> enabled and ext3 is built as a module.)
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =C2=A0fs/ext4/super.c | =C2=A0 11 +++++++----
> =C2=A01 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3d1a056..29c6875 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -71,7 +71,7 @@ static int ext4_freeze(struct super_block *sb);
> =C2=A0static int ext4_get_sb(struct file_system_type *fs_type, int fl=
ags,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 const char *dev_name, void *data, struct vfsmount *mnt);
>
> -#if !defined(CONTIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && d=
efined(CONFIG_EXT4_USE_FOR_EXT23)
> +#if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && d=
efined(CONFIG_EXT4_USE_FOR_EXT23)
> =C2=A0static struct file_system_type ext3_fs_type =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.owner =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=
 THIS_MODULE,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=
 "ext3",
> @@ -79,6 +79,9 @@ static struct file_system_type ext3_fs_type =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.kill_sb =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D ki=
ll_block_super,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.fs_flags =C2=A0 =C2=A0 =C2=A0 =3D FS_REQU=
IRES_DEV,
> =C2=A0};
> +#define IS_EXT3_SB(sb) ((sb)->s_bdev->bd_holder =3D=3D &ext3_fs_type=
)
> +#else
> +#define IS_EXT3_SB(sb) (0)
> =C2=A0#endif
>
> =C2=A0ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
> @@ -2550,7 +2553,7 @@ static int ext4_fill_super(struct super_block *=
sb, void *data, int silent)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * enable delayed allocation by default
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Use -o nodelalloc to turn it off
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 if (sb->s_bdev->bd_holder !=3D &ext3_fs_type)
> + =C2=A0 =C2=A0 =C2=A0 if (!IS_EXT3_SB(sb))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0set_opt(sbi->s=
_mount_opt, DELALLOC);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!parse_options((char *) data, sb, &jou=
rnal_devnum,
> @@ -4080,7 +4083,7 @@ static int ext4_get_sb(struct file_system_type =
*fs_type, int flags,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return get_sb_bdev(fs_type, flags, dev_nam=
e, data, ext4_fill_super,mnt);
> =C2=A0}
>
> -#if !defined(CONTIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && d=
efined(CONFIG_EXT4_USE_FOR_EXT23)
> +#if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && d=
efined(CONFIG_EXT4_USE_FOR_EXT23)
> =C2=A0static struct file_system_type ext2_fs_type =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.owner =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=
 THIS_MODULE,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=
 "ext2",
> @@ -4107,7 +4110,7 @@ static inline void register_as_ext2(void) { }
> =C2=A0static inline void unregister_as_ext2(void) { }
> =C2=A0#endif
>
> -#if !defined(CONTIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && d=
efined(CONFIG_EXT4_USE_FOR_EXT23)
> +#if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && d=
efined(CONFIG_EXT4_USE_FOR_EXT23)
> =C2=A0static inline void register_as_ext3(void)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int err =3D register_filesystem(&ext3_fs_t=
ype);
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
