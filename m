From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: fix reading new encrypted symlinks on no-journal filesystems
Date: Thu, 17 Nov 2016 19:20:24 -0700
Message-ID: <2FD4E662-B708-4C34-B1FC-8D42083322A2@dilger.ca>
References: <1479318627-143193-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_9568027F-E8DD-46F2-B20A-4DB98D662D65"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34891 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750855AbcKRCUF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2016 21:20:05 -0500
Received: by mail-it0-f66.google.com with SMTP id b123so1330431itb.2
        for <linux-ext4@vger.kernel.org>; Thu, 17 Nov 2016 18:20:04 -0800 (PST)
In-Reply-To: <1479318627-143193-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_9568027F-E8DD-46F2-B20A-4DB98D662D65
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 16, 2016, at 10:50 AM, Eric Biggers <ebiggers@google.com> wrote:
>=20
> On a filesystem with no journal, a symlink longer than about 32
> characters (exact length depending on padding for encryption) could =
not
> be followed or read immediately after being created in an encrypted
> directory.  This happened because when the symlink data went through =
the
> delayed allocation path instead of the journaling path, the symlink =
was
> incorrectly detected as a "fast" symlink rather than a "slow" symlink
> until its data was written out.

IMHO, this again exposes an issue that we've seen with "fast" vs. "slow"
symlink detection several times in the past whenever there is a data =
block
allocated for a fast symlink (e.g. when xattrs were allowed on =
symlinks).

int ext4_inode_is_fast_symlink(struct inode *inode)
{
        int ea_blocks =3D EXT4_I(inode)->i_file_acl ?
                EXT4_CLUSTER_SIZE(inode->i_sb) >> 9 : 0;

        if (ext4_has_inline_data(inode))
                return 0;

        return (S_ISLNK(inode->i_mode) && inode->i_blocks - ea_blocks =3D=3D=
 0);
}

Instead of depending on the i_blocks count to detect slow symlinks, we
should just check the i_size < EXT4_N_BLOCKS * 4 (or <=3D, need to =
verify).
I believe this has always been true for fast symlinks, so it should be
OK to make this change.  That will isolate us from future changes that
may add block allocations to symlinks.

Cheers, Andreas

> To fix this, use different inode operations for fast and slow =
encrypted
> symlinks.  This parallels how fast and slow unencrypted symlinks use
> different inode operations.
>=20
> I did not fix this by updating ext4_inode_is_fast_symlink() to account
> for delayed allocation because there didn't seem to be a good way to =
do
> that in a race-free way.  i_data_sem would need to be acquired to =
avoid
> racing with ext4_da_update_reserve_space() updating
> i_reserved_data_blocks and i_blocks, but i_data_sem did not seem
> appropriate to take from the context of ext4_inode_is_fast_symlink().
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> fs/ext4/ext4.h    |  1 +
> fs/ext4/inode.c   | 28 +++++++++++++++++++---------
> fs/ext4/namei.c   | 10 +++++++---
> fs/ext4/symlink.c | 28 +++++++++++++++++++++++++---
> 4 files changed, 52 insertions(+), 15 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 53d6d46..a0096af 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3087,6 +3087,7 @@ extern int ext4_mpage_readpages(struct =
address_space *mapping,
>=20
> /* symlink.c */
> extern const struct inode_operations =
ext4_encrypted_symlink_inode_operations;
> +extern const struct inode_operations =
ext4_encrypted_fast_symlink_inode_operations;
> extern const struct inode_operations ext4_symlink_inode_operations;
> extern const struct inode_operations =
ext4_fast_symlink_inode_operations;
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b1b4c85..be9e369 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -144,6 +144,9 @@ static int ext4_meta_trans_blocks(struct inode =
*inode, int lblocks,
>=20
> /*
>  * Test whether an inode is a fast symlink.
> + *
> + * Careful: the result may be incorrect if the symlink was just =
created and is
> + * pending delayed allocation (only possible on no-journal =
filesystems).
>  */
> int ext4_inode_is_fast_symlink(struct inode *inode)
> {
> @@ -4646,16 +4649,23 @@ struct inode *ext4_iget(struct super_block =
*sb, unsigned long ino)
> 		inode->i_op =3D &ext4_dir_inode_operations;
> 		inode->i_fop =3D &ext4_dir_operations;
> 	} else if (S_ISLNK(inode->i_mode)) {
> -		if (ext4_encrypted_inode(inode)) {
> -			inode->i_op =3D =
&ext4_encrypted_symlink_inode_operations;
> -			ext4_set_aops(inode);
> -		} else if (ext4_inode_is_fast_symlink(inode)) {
> -			inode->i_link =3D (char *)ei->i_data;
> -			inode->i_op =3D =
&ext4_fast_symlink_inode_operations;
> -			nd_terminate_link(ei->i_data, inode->i_size,
> -				sizeof(ei->i_data) - 1);
> +		if (ext4_inode_is_fast_symlink(inode)) {
> +			if (ext4_encrypted_inode(inode)) {
> +				inode->i_op =3D
> +				  =
&ext4_encrypted_fast_symlink_inode_operations;
> +			} else {
> +				inode->i_op =3D
> +					=
&ext4_fast_symlink_inode_operations;
> +				inode->i_link =3D (char *)ei->i_data;
> +				nd_terminate_link(ei->i_data, =
inode->i_size,
> +						  sizeof(ei->i_data) - =
1);
> +			}
> 		} else {
> -			inode->i_op =3D &ext4_symlink_inode_operations;
> +			if (ext4_encrypted_inode(inode))
> +				inode->i_op =3D
> +				       =
&ext4_encrypted_symlink_inode_operations;
> +			else
> +				inode->i_op =3D =
&ext4_symlink_inode_operations;
> 			ext4_set_aops(inode);
> 		}
> 		inode_nohighmem(inode);
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index eadba91..acf1786 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3148,11 +3148,12 @@ static int ext4_symlink(struct inode *dir,
> 			goto err_drop_inode;
> 		sd->len =3D cpu_to_le16(ostr.len);
> 		disk_link.name =3D (char *) sd;
> -		inode->i_op =3D =
&ext4_encrypted_symlink_inode_operations;
> 	}
>=20
> 	if ((disk_link.len > EXT4_N_BLOCKS * 4)) {
> -		if (!encryption_required)
> +		if (encryption_required)
> +			inode->i_op =3D =
&ext4_encrypted_symlink_inode_operations;
> +		else
> 			inode->i_op =3D &ext4_symlink_inode_operations;
> 		inode_nohighmem(inode);
> 		ext4_set_aops(inode);
> @@ -3194,7 +3195,10 @@ static int ext4_symlink(struct inode *dir,
> 	} else {
> 		/* clear the extent format for fast symlink */
> 		ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
> -		if (!encryption_required) {
> +		if (encryption_required) {
> +			inode->i_op =3D
> +				=
&ext4_encrypted_fast_symlink_inode_operations;
> +		} else {
> 			inode->i_op =3D =
&ext4_fast_symlink_inode_operations;
> 			inode->i_link =3D (char =
*)&EXT4_I(inode)->i_data;
> 		}
> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index 557b3b0..684bb78 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -24,7 +24,8 @@
>=20
> static const char *ext4_encrypted_get_link(struct dentry *dentry,
> 					   struct inode *inode,
> -					   struct delayed_call *done)
> +					   struct delayed_call *done,
> +					   bool fast)
> {
> 	struct page *cpage =3D NULL;
> 	char *caddr, *paddr =3D NULL;
> @@ -40,7 +41,7 @@ static const char *ext4_encrypted_get_link(struct =
dentry *dentry,
> 	if (res)
> 		return ERR_PTR(res);
>=20
> -	if (ext4_inode_is_fast_symlink(inode)) {
> +	if (fast) {
> 		caddr =3D (char *) EXT4_I(inode)->i_data;
> 		max_size =3D sizeof(EXT4_I(inode)->i_data);
> 	} else {
> @@ -82,9 +83,30 @@ static const char *ext4_encrypted_get_link(struct =
dentry *dentry,
> 	return ERR_PTR(res);
> }
>=20
> +static const char *ext4_encrypted_get_link_slow(struct dentry =
*dentry,
> +						struct inode *inode,
> +						struct delayed_call =
*done)
> +{
> +	return ext4_encrypted_get_link(dentry, inode, done, false);
> +}
> +
> +static const char *ext4_encrypted_get_link_fast(struct dentry =
*dentry,
> +						struct inode *inode,
> +						struct delayed_call =
*done)
> +{
> +	return ext4_encrypted_get_link(dentry, inode, done, true);
> +}
> +
> const struct inode_operations ext4_encrypted_symlink_inode_operations =
=3D {
> 	.readlink	=3D generic_readlink,
> -	.get_link	=3D ext4_encrypted_get_link,
> +	.get_link	=3D ext4_encrypted_get_link_slow,
> +	.setattr	=3D ext4_setattr,
> +	.listxattr	=3D ext4_listxattr,
> +};
> +
> +const struct inode_operations =
ext4_encrypted_fast_symlink_inode_operations =3D {
> +	.readlink	=3D generic_readlink,
> +	.get_link	=3D ext4_encrypted_get_link_fast,
> 	.setattr	=3D ext4_setattr,
> 	.listxattr	=3D ext4_listxattr,
> };
> --
> 2.8.0.rc3.226.g39d4020
>=20


Cheers, Andreas






--Apple-Mail=_9568027F-E8DD-46F2-B20A-4DB98D662D65
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWC5laHKl2rkXzB/gAQgbjA/6A0LZOnrSkjK8ZzGbyUDq38WdJsgkEEpi
jg1bNJ2fQBDiOABSBkwgqz8H+NoaOC4lbyX7Bkqz7J6C0uBbIRhsa7Ah4RWy5aOf
Yga8p+L8ZwPQ0MbYM7nuv7+yPI8HrOoKX+M4NjbEtvcwSmiBVmqSRov+KVnrPdDY
BBqoCXKnAXZTQ8N5RXloOwrN2EB+z1iq3WI/2zvZuxTOgoUfB2dgCNIoDBx41oXX
5VevUvus4cmVARUcNXN1izdJprgmUPwvFW+9tKKlI1SuPKEhjrJK8p31U1md+8/J
Fn79O/CcMHUmVNzoyCnJCWmH/EE9kEIplfSyohvecckiT5+6MV3p7DEnjupsq6ID
DDq8r+IjVL7fKu/4zkxuQHrG8kv4P8dNrTDD7Cj3HaFlrNbQP9bf6UXbI6E0bdL2
CxFtaoPHM+wkOHdVBIaOjhSqkeaEuYhheu3fSG/ZDzeyjKWfraj3eDLTv4zDa4wT
bKFpRrcoC2ol2vr4OfwoT5ajOmyRFoE3xELIKwmaepAkGUbu5MjG0/CbiVMu4eoI
EgK2cZTgFgdHbn9LVAQE0hSGqXcjHtO+oIzwQDoz+iUSXJhoika6WevpTHo1UtQB
vlbT+iObjInCn68EH/doI+I2w6H2OJX/IQVyVBQQglRZzNdUVweH/O6830EX0/oc
Xws3RQ2a8Sc=
=PPyv
-----END PGP SIGNATURE-----

--Apple-Mail=_9568027F-E8DD-46F2-B20A-4DB98D662D65--
