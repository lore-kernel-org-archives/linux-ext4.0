From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 10/11] ext4: Remove unnecessary quota functions
Date: Tue, 20 Jan 2009 13:41:54 -0800
Message-ID: <1232487714.6464.15.camel@mingming-laptop>
References: <yes> <1232129299-22018-1-git-send-email-jack@suse.cz>
	 <1232129299-22018-2-git-send-email-jack@suse.cz>
	 <1232129299-22018-3-git-send-email-jack@suse.cz>
	 <1232129299-22018-4-git-send-email-jack@suse.cz>
	 <1232129299-22018-5-git-send-email-jack@suse.cz>
	 <1232129299-22018-6-git-send-email-jack@suse.cz>
	 <1232129299-22018-7-git-send-email-jack@suse.cz>
	 <1232129299-22018-8-git-send-email-jack@suse.cz>
	 <1232129299-22018-9-git-send-email-jack@suse.cz>
	 <1232129299-22018-10-git-send-email-jack@suse.cz>
	 <1232129299-22018-11-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1232129299-22018-11-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


=E5=9C=A8 2009-01-16=E4=BA=94=E7=9A=84 19:08 +0100=EF=BC=8CJan Kara=E5=86=
=99=E9=81=93=EF=BC=9A
> ext4_dquot_initialize() and ext4_dquot_drop() is no longer
> needed because of modified quota locking.
>=20
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed_by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/super.c |   44 ++------------------------------------------
>  1 files changed, 2 insertions(+), 42 deletions(-)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e5f06a5..f0785fd 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -926,8 +926,6 @@ static int bdev_try_to_free_page(struct super_blo=
ck *sb, struct page *page, gfp_
>  #define QTYPE2NAME(t) ((t) =3D=3D USRQUOTA ? "user" : "group")
>  #define QTYPE2MOPT(on, t) ((t) =3D=3D USRQUOTA?((on)##USRJQUOTA):((o=
n)##GRPJQUOTA))
>=20
> -static int ext4_dquot_initialize(struct inode *inode, int type);
> -static int ext4_dquot_drop(struct inode *inode);
>  static int ext4_write_dquot(struct dquot *dquot);
>  static int ext4_acquire_dquot(struct dquot *dquot);
>  static int ext4_release_dquot(struct dquot *dquot);
> @@ -942,8 +940,8 @@ static ssize_t ext4_quota_write(struct super_bloc=
k *sb, int type,
>  				const char *data, size_t len, loff_t off);
>=20
>  static struct dquot_operations ext4_quota_operations =3D {
> -	.initialize	=3D ext4_dquot_initialize,
> -	.drop		=3D ext4_dquot_drop,
> +	.initialize	=3D dquot_initialize,
> +	.drop		=3D dquot_drop,
>  	.alloc_space	=3D dquot_alloc_space,
>  	.alloc_inode	=3D dquot_alloc_inode,
>  	.free_space	=3D dquot_free_space,
> @@ -3378,44 +3376,6 @@ static inline struct inode *dquot_to_inode(str=
uct dquot *dquot)
>  	return sb_dqopt(dquot->dq_sb)->files[dquot->dq_type];
>  }
>=20
> -static int ext4_dquot_initialize(struct inode *inode, int type)
> -{
> -	handle_t *handle;
> -	int ret, err;
> -
> -	/* We may create quota structure so we need to reserve enough block=
s */
> -	handle =3D ext4_journal_start(inode, 2*EXT4_QUOTA_INIT_BLOCKS(inode=
->i_sb));
> -	if (IS_ERR(handle))
> -		return PTR_ERR(handle);
> -	ret =3D dquot_initialize(inode, type);
> -	err =3D ext4_journal_stop(handle);
> -	if (!ret)
> -		ret =3D err;
> -	return ret;
> -}
> -
> -static int ext4_dquot_drop(struct inode *inode)
> -{
> -	handle_t *handle;
> -	int ret, err;
> -
> -	/* We may delete quota structure so we need to reserve enough block=
s */
> -	handle =3D ext4_journal_start(inode, 2*EXT4_QUOTA_DEL_BLOCKS(inode-=
>i_sb));
> -	if (IS_ERR(handle)) {
> -		/*
> -		 * We call dquot_drop() anyway to at least release references
> -		 * to quota structures so that umount does not hang.
> -		 */
> -		dquot_drop(inode);
> -		return PTR_ERR(handle);
> -	}
> -	ret =3D dquot_drop(inode);
> -	err =3D ext4_journal_stop(handle);
> -	if (!ret)
> -		ret =3D err;
> -	return ret;
> -}
> -
>  static int ext4_write_dquot(struct dquot *dquot)
>  {
>  	int ret, err;

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
