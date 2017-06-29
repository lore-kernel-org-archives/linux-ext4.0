From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] ext4: have ext4_xattr_set_handle() allocate journal
 credits
Date: Thu, 29 Jun 2017 17:25:47 -0600
Message-ID: <18BC3861-631F-4C45-9043-14E92B3D7922@dilger.ca>
References: <20170629005029.13302-1-tahsin@google.com>
 <20170629030618.5101-1-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DF2C3136-0CE7-440D-9B15-1B234FEF36EE";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170629030618.5101-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_DF2C3136-0CE7-440D-9B15-1B234FEF36EE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 28, 2017, at 9:06 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> Currently, callers of ext4_xattr_set_handle() are expected to allocate
> journal credits for setting extended attributes. =
ext4_xattr_set_credits()
> helps them figure out necessary credits. ext4_xattr_set_handle()
> performs a sufficient credits check before starting data updates.
>=20
> This model works fine for callers that start the transaction handle
> themselves, such as ext4_xattr_set(). Other callers like =
ext4_set_context()
> and __ext4_set_acl() use transaction handles that were started by =
outer
> scopes so for this to work properly we would have to involve outer =
scope
> callers to incorporate xattr credits.
>=20
> Also, existing sufficient credits check in ext4_xattr_set_handle()
> ignores the fact that allocated credits may have been intended for
> operations other than setting extended attributes. So in theory
> ext4_xattr_set_handle() may finish successfully but have also depleted
> the journal credits that were supposed to be used by other operations
> afterwards.
>=20
> In this patch, responsibility of allocating journal credits is moved =
to
> ext4_xattr_set_handle(). It tries to extend the journal credits as
> needed or will restart the transaction handle if extend doesn't work.

One problem with this approach is that restarting the transaction handle =
will
make the xattr update non-atomic, which could be a real problem for some
workloads.  For example, ACLs or SELinux or fscrypt xattrs being added =
in
a separate transaction from file creation, or being modified (delete in =
a
separate transaction from add) and then lost completely if the system =
crashes
before the second transaction is committed.

It isn't clear to me why using the current helper function to precompute =
the
required transaction credits doesn't get this right in the first place?  =
It
would just need to add the xattr credits to the original journal handle?



This brings up a potential area for improvement in ext4, namely that =
instead
of having all of the callers precompute the number of transaction =
credits, it
would be possible to declare operations (e.g. ext4_declare_create(),
ext4_declare_setxattr(), ext4_declare_add_entry(), ext4_declare_write())
and then have helpers that will compute these values (possibly dependent =
on
the specific inode being modified) and the caller just adds up the =
various
credits returned for each operation.  The ext4_declare_create() function =
would
gain subsidiary calls to ext4_declare_setxattr() that depend on on =
filesystem
features enabled and/or the parent directory, so that the caller doesn't =
need
to know all of the details.

That is probably larger than what is needed for this particular patch, =
but
something to consider as this code gets increasingly complex.

Cheers, Andreas

> Fixes: 021264a98d700e8 ("ext4: improve journal credit handling in set =
xattr paths")
>=20
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
> v2: Allocate 1 journal credit in ext4_set_acl() and ext4_set_context() =
for modifying
>    inode outside ext4_xattr_set_handle() call.
>=20
> fs/ext4/acl.c   | 14 +++++++-------
> fs/ext4/super.c | 13 +++++++------
> fs/ext4/xattr.c | 39 +++++++--------------------------------
> fs/ext4/xattr.h |  2 --
> 4 files changed, 21 insertions(+), 47 deletions(-)
>=20
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index 8db03e5c78bc..6a4c2b831699 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -231,18 +231,18 @@ int
> ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> {
> 	handle_t *handle;
> -	int error, credits, retries =3D 0;
> -	size_t acl_size =3D acl ? ext4_acl_size(acl->a_count) : 0;
> +	int error, retries =3D 0;
>=20
> 	error =3D dquot_initialize(inode);
> 	if (error)
> 		return error;
> retry:
> -	error =3D ext4_xattr_set_credits(inode, acl_size, &credits);
> -	if (error)
> -		return error;
> -
> -	handle =3D ext4_journal_start(inode, EXT4_HT_XATTR, credits);
> +	/*
> +	 * Allocate 1 journal credit to allow __ext4_set_acl() update =
inode
> +	 * before calling ext4_xattr_set_handle(). Extended attribute =
related
> +	 * credits are allocated by ext4_xattr_set_handle() itself.
> +	 */
> +	handle =3D ext4_journal_start(inode, EXT4_HT_XATTR, 1 /* credits =
*/);
> 	if (IS_ERR(handle))
> 		return PTR_ERR(handle);
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 56c971807df5..74036c382b63 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1150,7 +1150,7 @@ static int ext4_set_context(struct inode *inode, =
const void *ctx, size_t len,
> 							void *fs_data)
> {
> 	handle_t *handle =3D fs_data;
> -	int res, res2, credits, retries =3D 0;
> +	int res, res2, retries =3D 0;
>=20
> 	/*
> 	 * Encrypting the root directory is not allowed because e2fsck =
expects
> @@ -1194,11 +1194,12 @@ static int ext4_set_context(struct inode =
*inode, const void *ctx, size_t len,
> 	if (res)
> 		return res;
> retry:
> -	res =3D ext4_xattr_set_credits(inode, len, &credits);
> -	if (res)
> -		return res;
> -
> -	handle =3D ext4_journal_start(inode, EXT4_HT_MISC, credits);
> +	/*
> +	 * Allocate 1 journal credit for ext4_mark_inode_dirty() call in =
this
> +	 * function. Extended attribute related credits are allocated by
> +	 * ext4_xattr_set_handle() itself.
> +	 */
> +	handle =3D ext4_journal_start(inode, EXT4_HT_MISC, 1 /* credits =
*/);
> 	if (IS_ERR(handle))
> 		return PTR_ERR(handle);
>=20
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 062756b4e6d8..6b909804aa5e 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2253,7 +2253,11 @@ ext4_xattr_set_handle(handle_t *handle, struct =
inode *inode, int name_index,
> 		credits =3D __ext4_xattr_set_credits(inode->i_sb, bh, =
value_len);
> 		brelse(bh);
>=20
> -		if (!ext4_handle_has_enough_credits(handle, credits)) {
> +		if (ext4_xattr_ensure_credits(
> +					handle, inode,
> +					handle->h_buffer_credits + =
credits,
> +					NULL /* bh */, false /* dirty =
*/,
> +					false /* block_csum */)) {
> 			error =3D -ENOSPC;
> 			goto cleanup;
> 		}
> @@ -2357,31 +2361,6 @@ ext4_xattr_set_handle(handle_t *handle, struct =
inode *inode, int name_index,
> 	return error;
> }
>=20
> -int ext4_xattr_set_credits(struct inode *inode, size_t value_len, int =
*credits)
> -{
> -	struct buffer_head *bh;
> -	int err;
> -
> -	*credits =3D 0;
> -
> -	if (!EXT4_SB(inode->i_sb)->s_journal)
> -		return 0;
> -
> -	down_read(&EXT4_I(inode)->xattr_sem);
> -
> -	bh =3D ext4_xattr_get_block(inode);
> -	if (IS_ERR(bh)) {
> -		err =3D PTR_ERR(bh);
> -	} else {
> -		*credits =3D __ext4_xattr_set_credits(inode->i_sb, bh, =
value_len);
> -		brelse(bh);
> -		err =3D 0;
> -	}
> -
> -	up_read(&EXT4_I(inode)->xattr_sem);
> -	return err;
> -}
> -
> /*
>  * ext4_xattr_set()
>  *
> @@ -2397,18 +2376,14 @@ ext4_xattr_set(struct inode *inode, int =
name_index, const char *name,
> 	handle_t *handle;
> 	struct super_block *sb =3D inode->i_sb;
> 	int error, retries =3D 0;
> -	int credits;
>=20
> 	error =3D dquot_initialize(inode);
> 	if (error)
> 		return error;
>=20
> retry:
> -	error =3D ext4_xattr_set_credits(inode, value_len, &credits);
> -	if (error)
> -		return error;
> -
> -	handle =3D ext4_journal_start(inode, EXT4_HT_XATTR, credits);
> +	/* ext4_xattr_set_handle() allocates journal credits if =
necessary. */
> +	handle =3D ext4_journal_start(inode, EXT4_HT_XATTR, 0 /* credits =
*/);
> 	if (IS_ERR(handle)) {
> 		error =3D PTR_ERR(handle);
> 	} else {
> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
> index 26119a67c8c3..f81cee5c21cc 100644
> --- a/fs/ext4/xattr.h
> +++ b/fs/ext4/xattr.h
> @@ -152,8 +152,6 @@ extern ssize_t ext4_listxattr(struct dentry *, =
char *, size_t);
> extern int ext4_xattr_get(struct inode *, int, const char *, void *, =
size_t);
> extern int ext4_xattr_set(struct inode *, int, const char *, const =
void *, size_t, int);
> extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, =
const char *, const void *, size_t, int);
> -extern int ext4_xattr_set_credits(struct inode *inode, size_t =
value_len,
> -				  int *credits);
>=20
> extern int ext4_xattr_delete_inode(handle_t *handle, struct inode =
*inode,
> 				   struct ext4_xattr_inode_array =
**array,
> --
> 2.13.2.725.g09c95d1e9-goog
>=20


Cheers, Andreas






--Apple-Mail=_DF2C3136-0CE7-440D-9B15-1B234FEF36EE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZVYx9pIg59Q01vtYRAkw7AJ9Napmy282pjc3Ki+2Hgp+3f7Gt2wCdHLS7
vf3PCBusidszjeX9sP/z4DA=
=qVjP
-----END PGP SIGNATURE-----

--Apple-Mail=_DF2C3136-0CE7-440D-9B15-1B234FEF36EE--
