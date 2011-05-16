From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] ext4 : Add missing posix_acl_release() in
 ext4_xattr_set_acl() in error path.
Date: Mon, 16 May 2011 17:44:26 +0200
Message-ID: <20110516154426.GH5344@quack.suse.cz>
References: <BANLkTin4PDgtZUHgrPnQbg_0+dN6_Fj_Gg@mail.gmail.com>
 <20110511161808.GK5057@quack.suse.cz>
 <BANLkTimEOXs9yzws73kZ669YKLVhr6eAmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57548 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab1EPPos (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 11:44:48 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTimEOXs9yzws73kZ669YKLVhr6eAmw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 12-05-11 19:19:29, Manish Katiyar wrote:
> On Wed, May 11, 2011 at 9:18 AM, Jan Kara <jack@suse.cz> wrote:
> > On Sun 24-04-11 17:18:02, Manish Katiyar wrote:
> >> This patch fixes the following.
> >>
> >> a) Incase journal transaction allocation fails due to ENOMEM don't=
 call
> >> ext4_std_error() since it will remount the fs as readonly and logs=
 the
> >> message in kernel log.
> >> b) Call posix_acl_release() incase journal allocation fails in cas=
e of
> >> error paths.
> >>
> >>
> >> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> >> ---
> >> =A0fs/ext4/acl.c | =A0 =A07 ++++---
> >> =A01 files changed, 4 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> >> index 21eacd7..0c98710 100644
> >> --- a/fs/ext4/acl.c
> >> +++ b/fs/ext4/acl.c
> >> @@ -354,7 +354,6 @@ ext4_acl_chmod(struct inode *inode)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_D=
ATA_TRANS_BLOCKS(inode->i_sb));
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(handle)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(hand=
le);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_std_error(inode->i_=
sb, error);
> > =A0The changelog speaks only about ENOMEM but you actually remove t=
he
> > message completely (so it won't catch EIO or similar errors). I thi=
nk you
> > should just condition ext4_std_error() with if (error !=3D ENOMEM).
>=20
> Hi Jan,
>=20
> Thanks for your response. Here is the updated patch.
>=20
> ---------------------------------------------------------------------=
------------------------------------------------
> a) Incase journal transaction allocation fails due to ENOMEM don't ca=
ll
> ext4_std_error() since it will remount the fs as readonly and logs th=
e
> message in kernel log.
>=20
> b) Call posix_acl_release() incase journal allocation fails in case
> of error paths.
  This patch looks OK now. You can add:
Acked-by: Jan Kara <jack@suse.cz>

									Honza
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ext4/acl.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index 21eacd7..93dc9a6 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -354,7 +354,8 @@ ext4_acl_chmod(struct inode *inode)
>  				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
>  		if (IS_ERR(handle)) {
>  			error =3D PTR_ERR(handle);
> -			ext4_std_error(inode->i_sb, error);
> +			if (error !=3D -ENOMEM)
> +				ext4_std_error(inode->i_sb, error);
>  			goto out;
>  		}
>  		error =3D ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, clone);
> @@ -450,8 +451,10 @@ ext4_xattr_set_acl(struct dentry *dentry, const
> char *name, const void *value,
>=20
>  retry:
>  	handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->=
i_sb));
> -	if (IS_ERR(handle))
> -		return PTR_ERR(handle);
> +	if (IS_ERR(handle)) {
> +		error =3D PTR_ERR(handle);
> +		goto release_and_out;
> +	}
>  	error =3D ext4_set_acl(handle, inode, type, acl);
>  	ext4_journal_stop(handle);
>  	if (error =3D=3D -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &r=
etries))
> --=20
> 1.7.4.1
>=20
>=20
> --=20
> Thanks -
> Manish
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
