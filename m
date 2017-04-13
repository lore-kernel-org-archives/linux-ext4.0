From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 05/11] quota: Stop setting IMMUTABLE and NOATIME flags on
 quota files
Date: Wed, 12 Apr 2017 22:04:11 -0600
Message-ID: <C2EE6B0C-1AC0-4ADD-904B-D851C38D4F1A@dilger.ca>
References: <20170412072611.29017-1-jack@suse.cz>
 <20170412072611.29017-6-jack@suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_258F3EF8-93AD-48B3-AE01-ED2FA831E3F5";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36199 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdDMEER (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Apr 2017 00:04:17 -0400
Received: by mail-io0-f194.google.com with SMTP id x86so10688922ioe.3
        for <linux-ext4@vger.kernel.org>; Wed, 12 Apr 2017 21:04:16 -0700 (PDT)
In-Reply-To: <20170412072611.29017-6-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_258F3EF8-93AD-48B3-AE01-ED2FA831E3F5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 12, 2017, at 1:26 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> Currently we set IMMUTABLE and NOATIME flags on quota files to stop
> userspace from messing with them. Now that all filesystems set these
> flags in their quota_on handlers, we can stop setting the flags in
> generic quota code. This will allow filesystems to stop copying =
i_flags
> to their on-disk flags on various occasions.
>=20
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/quota/dquot.c | 19 +++++--------------
> 1 file changed, 5 insertions(+), 14 deletions(-)
>=20
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 74b489e3714d..7e94cb0ecdde 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -2188,8 +2188,7 @@ int dquot_disable(struct super_block *sb, int =
type, unsigned int flags)
> 		/* This can happen when suspending quotas on =
remount-ro... */
> 		if (toputinode[cnt] && !sb_has_quota_loaded(sb, cnt)) {
> 			inode_lock(toputinode[cnt]);
> -			toputinode[cnt]->i_flags &=3D ~(S_IMMUTABLE |
> -				  S_NOATIME | S_NOQUOTA);
> +			toputinode[cnt]->i_flags &=3D ~S_NOQUOTA;
> 			truncate_inode_pages(&toputinode[cnt]->i_data, =
0);
> 			inode_unlock(toputinode[cnt]);
> 			mark_inode_dirty_sync(toputinode[cnt]);
> @@ -2237,7 +2236,6 @@ static int vfs_load_quota_inode(struct inode =
*inode, int type, int format_id,
> 	struct super_block *sb =3D inode->i_sb;
> 	struct quota_info *dqopt =3D sb_dqopt(sb);
> 	int error;
> -	int oldflags =3D -1;
>=20
> 	if (!fmt)
> 		return -ESRCH;
> @@ -2285,9 +2283,7 @@ static int vfs_load_quota_inode(struct inode =
*inode, int type, int format_id,
> 		 * possible) Also nobody should write to the file - we =
use
> 		 * special IO operations which ignore the immutable bit. =
*/
> 		inode_lock(inode);
> -		oldflags =3D inode->i_flags & (S_NOATIME | S_IMMUTABLE |
> -					     S_NOQUOTA);
> -		inode->i_flags |=3D S_NOQUOTA | S_NOATIME | S_IMMUTABLE;
> +		inode->i_flags |=3D S_NOQUOTA;
> 		inode_unlock(inode);
> 		/*
> 		 * When S_NOQUOTA is set, remove dquot references as no =
more
> @@ -2329,14 +2325,9 @@ static int vfs_load_quota_inode(struct inode =
*inode, int type, int format_id,
> 	dqopt->files[type] =3D NULL;
> 	iput(inode);
> out_file_flags:
> -	if (oldflags !=3D -1) {
> -		inode_lock(inode);
> -		/* Set the flags back (in the case of accidental =
quotaon()
> -		 * on a wrong file we don't want to mess up the flags) =
*/
> -		inode->i_flags &=3D ~(S_NOATIME | S_NOQUOTA | =
S_IMMUTABLE);
> -		inode->i_flags |=3D oldflags;
> -		inode_unlock(inode);
> -	}
> +	inode_lock(inode);
> +	inode->i_flags &=3D ~S_NOQUOTA;
> +	inode_unlock(inode);
> out_fmt:
> 	put_quota_format(fmt);
>=20
> --
> 2.12.0
>=20


Cheers, Andreas






--Apple-Mail=_258F3EF8-93AD-48B3-AE01-ED2FA831E3F5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY7vi8pIg59Q01vtYRAs2PAJ9540HOAiyjqz6zZu+qMJKfLmIPEwCgonV8
cBZXdIrK0ytmPjMAl9r/rWM=
=jWbu
-----END PGP SIGNATURE-----

--Apple-Mail=_258F3EF8-93AD-48B3-AE01-ED2FA831E3F5--
