From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] ext4: add ext4_iget_normal() which is to be used for dir tree lookups
Date: Sun, 5 Oct 2014 20:52:38 -0600
Message-ID: <CCC111D5-362C-40B5-B19C-24C4E66BD963@dilger.ca>
References: <20141005001239.GD27150@sli.dy.fi> <1412563682-5720-1-git-send-email-tytso@mit.edu> <1412563682-5720-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_5033A1F2-D0E4-46C3-8023-A7AA8762B798"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62325 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaJFCwV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Oct 2014 22:52:21 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so2517391pdi.5
        for <linux-ext4@vger.kernel.org>; Sun, 05 Oct 2014 19:52:20 -0700 (PDT)
In-Reply-To: <1412563682-5720-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_5033A1F2-D0E4-46C3-8023-A7AA8762B798
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 5, 2014, at 8:48 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> If there is a corrupted file system which has directory entries that
> point at reserved, metadata inodes, prohibit them from being used by
> treating them the same way we treat Boot Loader inodes --- that is,
> mark them to be bad inodes.  This prohibits them from being opened,
> deleted, or modified via chmod, chown, utimes, etc.
>=20
> In particular, this prevents a corrupted file system which has a
> directory entry which points at the journal inode from being deleted
> and being released, after which point Much Hilarity Ensues.

Wouldn't it be safer to change "ext4_iget()" to have these checks,=20
and add an "ext4_iget_special()" or "ext4_iget_reserved()" for use
in the few places that are opening reserved inodes?  That would
probably be safer for the future.

Cheers, Andreas

> Reported-by: Sami Liedes <sami.liedes@iki.fi>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> fs/ext4/ext4.h  |  1 +
> fs/ext4/inode.c | 10 ++++++++++
> fs/ext4/namei.c |  4 ++--
> fs/ext4/super.c |  2 +-
> 4 files changed, 14 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1eb5b7b..012e89b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2109,6 +2109,7 @@ int do_journal_get_write_access(handle_t =
*handle,
> #define CONVERT_INLINE_DATA	 2
>=20
> extern struct inode *ext4_iget(struct super_block *, unsigned long);
> +extern struct inode *ext4_iget_normal(struct super_block *, unsigned =
long);
> extern int  ext4_write_inode(struct inode *, struct writeback_control =
*);
> extern int  ext4_setattr(struct dentry *, struct iattr *);
> extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 59983b2..437622c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4104,6 +4104,16 @@ bad_inode:
> 	return ERR_PTR(ret);
> }
>=20
> +struct inode *ext4_iget_normal(struct super_block *sb, unsigned long =
ino)
> +{
> +	struct inode *ret_inode =3D ext4_iget(sb, ino);
> +
> +	if (ret_inode && !IS_ERR(ret_inode) &&
> +	    ino < EXT4_FIRST_INO(sb) && ino !=3D EXT4_ROOT_INO)
> +		make_bad_inode(ret_inode);
> +	return ret_inode;
> +}
> +
> static int ext4_inode_blocks_set(handle_t *handle,
> 				struct ext4_inode *raw_inode,
> 				struct ext4_inode_info *ei)
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a2a9d40..7037ecf 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1417,7 +1417,7 @@ static struct dentry *ext4_lookup(struct inode =
*dir, struct dentry *dentry, unsi
> 					 dentry);
> 			return ERR_PTR(-EIO);
> 		}
> -		inode =3D ext4_iget(dir->i_sb, ino);
> +		inode =3D ext4_iget_normal(dir->i_sb, ino);
> 		if (inode =3D=3D ERR_PTR(-ESTALE)) {
> 			EXT4_ERROR_INODE(dir,
> 					 "deleted inode referenced: %u",
> @@ -1450,7 +1450,7 @@ struct dentry *ext4_get_parent(struct dentry =
*child)
> 		return ERR_PTR(-EIO);
> 	}
>=20
> -	return d_obtain_alias(ext4_iget(child->d_inode->i_sb, ino));
> +	return d_obtain_alias(ext4_iget_normal(child->d_inode->i_sb, =
ino));
> }
>=20
> /*
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 1070d6e..a0811cc 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1001,7 +1001,7 @@ static struct inode *ext4_nfs_get_inode(struct =
super_block *sb,
> 	 * Currently we don't know the generation for parent directory, =
so
> 	 * a generation of 0 means "accept any"
> 	 */
> -	inode =3D ext4_iget(sb, ino);
> +	inode =3D ext4_iget_normal(sb, ino);
> 	if (IS_ERR(inode))
> 		return ERR_CAST(inode);
> 	if (generation && inode->i_generation !=3D generation) {
> --=20
> 2.1.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_5033A1F2-D0E4-46C3-8023-A7AA8762B798
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVDID9nKl2rkXzB/gAQJKhRAAkwZqFLPhp4o61FRJKPoo1PRTHZ5JmJtM
nmC4KobWlrBadjfG9i//bLPPvDJ7jG6tE05qroTla2STFodPknn11/L2dmWmYCnx
nx8Qd+ZoSyg2DeVdTMiTX7N5kejV7Kut/8riT711ql9sjjbya36RFSsLy/xxaH0I
azK3efNK6Jegb0/9aokY0+BlKRW3fqQhaWJfc6kSqa4TDIPqOS4+KqYwxBzDEQ4I
aTckQr5S3YfgRk1hS+ZpTFztOgPHLQSp4YbJbdnuqxvPnnmeoHF5Drns14Phle3P
yNoUBCdcePKOS9Hv8jZsnjeDmX6Cmo84F9+9DgXIYeEfewSGsXCWKcK80ZdNefI9
YnHOaYPftVDVSRoGWCPzGYf7HqgKyoNs6hoyKY5+IYrV5eeLYr2Wc1RzQbWUZAj2
3XgHvUtLI2LzaL40evvkaAlHPiTDgKp9bVGCaE81QPW/vEtio7f46ObN8Ru6X9jK
9icG30wsBUZ1vu5q9xATnM1Euhw2rFH9kreXGNciimOochIGpmbqn6sc7DALakVe
qRuWTrW+vHxYH8fmzwNvjS/7ixyDq1872hFNtyiy5+lJXuiqlBuyzEnl2ED0Y4kP
T4j5SjgWSxQiJtkHA6p9PQcik6Tk4U5TczeX9xOjr3xTBZBO89XGmfpltD7v7Q6u
RulkZWpa1To=
=bvn/
-----END PGP SIGNATURE-----

--Apple-Mail=_5033A1F2-D0E4-46C3-8023-A7AA8762B798--
