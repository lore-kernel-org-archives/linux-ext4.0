From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 1/2] ext4, project: expand inode extra size if possible
Date: Wed, 5 Jul 2017 10:31:02 -0600
Message-ID: <987151C3-9E9D-4ACD-84BB-B9DC33C08822@dilger.ca>
References: <20170704074210.77918-1-wshilong@ddn.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_B4650650-F7EF-4589-82C2-2702098D2751";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, Li Xi <lixi@ddn.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>, miaoxie@huawei.com,
        wshilong@ddn.com, Shuichi Ihara <sihara@ddn.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:33373 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751858AbdGEQ3w (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jul 2017 12:29:52 -0400
Received: by mail-it0-f65.google.com with SMTP id 188so14475374itx.0
        for <linux-ext4@vger.kernel.org>; Wed, 05 Jul 2017 09:29:52 -0700 (PDT)
In-Reply-To: <20170704074210.77918-1-wshilong@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_B4650650-F7EF-4589-82C2-2702098D2751
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 4, 2017, at 1:42 AM, Wang Shilong <wangshilong1991@gmail.com> =
wrote:
>=20
> when upgrading from old format, try to set project id
> to old file first time, it will return EOVERFLOW, but if
> that file is dirtied(touch etc), changing project id will
> be allowed, this might be confusing for users, we could
> try to expand @i_extra_iszie here too.
>=20
> Reported-by: zhangyi(F) <yi.zhang@huawei.com>
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> v1->v2:
> ext4_expand_extra_isize should be invoked after =
ext4_reserve_inode_write
> ---
> fs/ext4/ext4.h  |  3 +++
> fs/ext4/inode.c |  8 ++++----
> fs/ext4/ioctl.c | 17 +++++++++++++++--
> 3 files changed, 22 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3219154..640f006 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2453,6 +2453,9 @@ int ext4_walk_page_buffers(handle_t *handle,
> 			   int *partial,
> 			   int (*fn)(handle_t *handle,
> 				     struct buffer_head *bh));
> +int ext4_expand_extra_isize(struct inode *inode,
> +			    unsigned int new_extra_isize,
> +			    struct ext4_iloc iloc, handle_t *handle);
> int do_journal_get_write_access(handle_t *handle,
> 				struct buffer_head *bh);
> #define FALL_BACK_TO_NONDELALLOC 1
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5cf82d0..9d07554 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5632,10 +5632,10 @@ ext4_reserve_inode_write(handle_t *handle, =
struct inode *inode,
>  * Expand an inode by new_extra_isize bytes.
>  * Returns 0 on success or negative error number on failure.
>  */
> -static int ext4_expand_extra_isize(struct inode *inode,
> -				   unsigned int new_extra_isize,
> -				   struct ext4_iloc iloc,
> -				   handle_t *handle)
> +int ext4_expand_extra_isize(struct inode *inode,
> +			    unsigned int new_extra_isize,
> +			    struct ext4_iloc iloc,
> +			    handle_t *handle)
> {
> 	struct ext4_inode *raw_inode;
> 	struct ext4_xattr_ibody_header *header;
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 0c21e22..d413008 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -319,6 +319,7 @@ static int ext4_ioctl_setproject(struct file =
*filp, __u32 projid)
> 	struct ext4_iloc iloc;
> 	struct ext4_inode *raw_inode;
> 	struct dquot *transfer_to[MAXQUOTAS] =3D { };
> +	bool need_expand =3D false;
>=20
> 	if (!ext4_has_feature_project(sb)) {
> 		if (projid !=3D EXT4_DEF_PROJID)
> @@ -350,7 +351,10 @@ static int ext4_ioctl_setproject(struct file =
*filp, __u32 projid)
> 		goto out_unlock;
>=20
> 	raw_inode =3D ext4_raw_inode(&iloc);
> -	if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
> +	if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid) &&
> +	    !ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
> +		need_expand =3D true;
> +	} else if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
> 		err =3D -EOVERFLOW;
> 		brelse(iloc.bh);
> 		goto out_unlock;
> @@ -361,7 +365,8 @@ static int ext4_ioctl_setproject(struct file =
*filp, __u32 projid)
>=20
> 	handle =3D ext4_journal_start(inode, EXT4_HT_QUOTA,
> 		EXT4_QUOTA_INIT_BLOCKS(sb) +
> -		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
> +		EXT4_QUOTA_DEL_BLOCKS(sb) + 3 +
> +		need_expand ? EXT4_DATA_TRANS_BLOCKS(sb) : 0);
> 	if (IS_ERR(handle)) {
> 		err =3D PTR_ERR(handle);
> 		goto out_unlock;
> @@ -371,6 +376,14 @@ static int ext4_ioctl_setproject(struct file =
*filp, __u32 projid)
> 	if (err)
> 		goto out_stop;
>=20
> +	if (need_expand) {
> +		err =3D ext4_expand_extra_isize(inode,
> +				      EXT4_SB(sb)->s_want_extra_isize,
> +				      iloc, handle);
> +		if (err)
> +			goto out_stop;
> +	}
> +
> 	transfer_to[PRJQUOTA] =3D dqget(sb, make_kqid_projid(kprojid));
> 	if (!IS_ERR(transfer_to[PRJQUOTA])) {
> 		err =3D __dquot_transfer(inode, transfer_to);
> --
> 2.9.3
>=20


Cheers, Andreas






--Apple-Mail=_B4650650-F7EF-4589-82C2-2702098D2751
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZXRRGpIg59Q01vtYRAiitAJ99v4nJeP0HdGsGZSBINaUZZQPAQACgib0N
DC3F12XsROXzKPv/Pf56/zU=
=pn4A
-----END PGP SIGNATURE-----

--Apple-Mail=_B4650650-F7EF-4589-82C2-2702098D2751--
