From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 03/12] e2fsck: ea_inode hash validation
Date: Mon, 26 Jun 2017 15:21:50 -0600
Message-ID: <842B76D1-7759-4FA7-85A8-1E79B72C69EE@dilger.ca>
References: <20170626134348.1240-1-tahsin@google.com>
 <20170626134348.1240-3-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_6AF5C372-61F2-43E9-B680-6252F2F8C98F";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36004 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751381AbdFZVV6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 17:21:58 -0400
Received: by mail-io0-f194.google.com with SMTP id h134so1163544iof.3
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 14:21:58 -0700 (PDT)
In-Reply-To: <20170626134348.1240-3-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6AF5C372-61F2-43E9-B680-6252F2F8C98F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 26, 2017, at 7:43 AM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> In original implementation of ea_inode feature, each xattr inode had
> a single parent. Child inode tracked the parent by storing its inode
> number in i_mtime field. Also, child's i_generation matched parent's
> i_generation.
>=20
> With deduplication support, xattr inodes can now be shared so a single
> backpointer is not sufficient to achieve strong binding. This is now
> replaced by hash validation.
>=20
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
> e2fsck/pass1.c        | 91 =
+++++++++++++++++++++++++++++++++------------------
> e2fsck/problem.c      |  5 ---
> e2fsck/problem.h      |  7 ++--
> lib/ext2fs/ext2fs.h   |  3 ++
> lib/ext2fs/ext_attr.c | 67 +++++++++++++++++++++++++++++++++++--
> 5 files changed, 128 insertions(+), 45 deletions(-)
>=20
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 1c68af8990b4..32152f3ec926 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -2439,6 +2466,16 @@ static int check_ext_attr(e2fsck_t ctx, struct =
problem_context *pctx,
> 						pctx))
> 					goto clear_extattr;
> 			}
> +
> +			hash =3D ext2fs_ext_attr_hash_entry(entry, =
block_buf +
> +							  =
entry->e_value_offs);
> +
> +			if (entry->e_hash !=3D hash) {
> +				pctx->num =3D entry->e_hash;
> +				if (fix_problem(ctx, PR_1_ATTR_HASH, =
pctx))
> +					goto clear_extattr;

Shouldn't this be "if (!fix_problem(...))" ?


> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index dad608c94fd0..8e07c10895c1 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -678,15 +678,12 @@ struct problem_context {
> /* Inode has illegal EA value inode */
> #define PR_1_ATTR_VALUE_EA_INODE		0x010083
>=20
> -/* Invalid backpointer from EA inode to parent inode */
> -#define PR_1_ATTR_INVAL_EA_INODE		0x010084
> -
> /* Parent inode has invalid EA entry. EA inode does not have
>  * EXT4_EA_INODE_FL flag. Delete EA entry? */
> -#define PR_1_ATTR_NO_EA_INODE_FL		0x010085
> +#define PR_1_ATTR_NO_EA_INODE_FL		0x010084
>=20
> /* EA inode for parent inode does not have EXT4_EA_INODE_FL flag */
> -#define PR_1_ATTR_SET_EA_INODE_FL		0x010086
> +#define PR_1_ATTR_SET_EA_INODE_FL		0x010085

It would also be OK to keep the old values, and just skip 0x10084.

> diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
> index 14d05c7e57fb..d48ab5c55270 100644
> --- a/lib/ext2fs/ext_attr.c
> +++ b/lib/ext2fs/ext_attr.c
> @@ -914,9 +955,29 @@ static errcode_t read_xattrs_from_buffer(struct =
ext2_xattr_handle *handle,
> 			void *data =3D (entry->e_value_inum !=3D 0) ?
> 					0 : value_start + =
entry->e_value_offs;
>=20
> -			hash =3D ext2fs_ext_attr_hash_entry(entry, =
data);
> -			if (entry->e_hash !=3D hash)
> -				return EXT2_ET_BAD_EA_HASH;
> +			err =3D ext2fs_ext_attr_hash_entry2(handle->fs, =
entry,
> +							  data, &hash);
> +			if (err)
> +				return err;
> +			if (entry->e_hash !=3D hash) {
> +				struct ext2_inode parent, child;
> +
> +				/* Check whether this is an old =
Lustre-style
> +				 * ea_inode reference.
> +				 */
> +				err =3D ext2fs_read_inode(handle->fs, =
handle->ino,
> +							&parent);

Rather than reading the inode again here, it would make more sense to =
pass the
parent inode from the caller.

> +				if (err)
> +					return err;
> +				err =3D ext2fs_read_inode(handle->fs,
> +							=
entry->e_value_inum,
> +							&child);
> +				if (err)
> +					return err;
> +				if (child.i_mtime !=3D handle->ino ||
> +				    child.i_generation !=3D =
parent.i_generation)
> +					return EXT2_ET_BAD_EA_HASH;
> +			}
> 		}
>=20
> 		x++;
> --
> 2.13.1.611.g7e3b11ae1-goog
>=20


Cheers, Andreas






--Apple-Mail=_6AF5C372-61F2-43E9-B680-6252F2F8C98F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZUXrvpIg59Q01vtYRAtjuAJ9UxBtF4ZDqQXS7Nq8/M+WxYc+jzgCghvOY
lqjzrxRMAC2UuzQSJCusS9k=
=Pwnd
-----END PGP SIGNATURE-----

--Apple-Mail=_6AF5C372-61F2-43E9-B680-6252F2F8C98F--
