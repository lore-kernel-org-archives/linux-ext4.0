From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: fast symlink test should not rely on i_blocks
Date: Wed, 28 Jun 2017 10:53:31 -0600
Message-ID: <1E96A392-4BE6-4078-B708-5C8C33C52654@dilger.ca>
References: <20170628003455.12748-1-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_9CDB6213-C704-4B57-B341-62816FAE8A4B";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170628003455.12748-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_9CDB6213-C704-4B57-B341-62816FAE8A4B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jun 27, 2017, at 6:34 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> ext4_inode_info->i_data is the storage area for 4 types of data:
>=20
>  a) Extents data
>  b) Inline data
>  c) Block map
>  d) Fast symlink data (symlink length < 60)
>=20
> Extents data case is positively identified by EXT4_INODE_EXTENTS flag.
> Inline data case is also obvious because of EXT4_INODE_INLINE_DATA
> flag.
>=20
> Distinguishing c) and d) however requires additional logic. This
> currently relies on i_blocks count. After subtracting external xattr
> block from i_blocks, if it is greater than 0 then we know that some
> data blocks exist, so there must be a block map.
>=20
> This logic got broken after ea_inode feature was added. That feature
> charges the data blocks of external xattr inodes to the referencing
> inode and so adds them to the i_blocks. To fix this, we could subtract
> ea_inode blocks by iterating through all xattr entries and then check
> whether remaining i_blocks count is zero. Besides being complicated,
> this won't change the fact that the current way of distinguishing
> between c) and d) is fragile.
>=20
> The alternative solution is to test whether i_size is less than 60 to
> determine fast symlink case. ext4_symlink() uses the same test to =
decide
> whether to store the symlink in i_data. There is one caveat to address
> before this can work though.
>=20
> If an inode's i_nlink is zero during eviction, its i_size is set to
> zero and its data is truncated. If system crashes before inode is =
removed
> from the orphan list, next boot orphan cleanup may find the inode with
> zero i_size. So, a symlink that had its data stored in a block may now
> appear to be a fast symlink. The solution used in this patch is to =
treat
> i_size =3D 0 as a non-fast symlink case. A zero sized symlink is not =
legal
> so the only time this can happen is the mentioned scenario. This is =
also
> logically correct because a i_size =3D 0 symlink has no data stored in
> i_data.
>=20
> Fixes: 74c5bfa651af ("ext4: xattr inode deduplication")
>=20
> Suggested-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

The unfortunate bit is that this makes the inode impossible to undelete, =
but
I don't think that is a huge concern for symlinks.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/inode.c | 20 +++++++++++++-------
> 1 file changed, 13 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index daed9b38362a..3c600f02673f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -144,16 +144,12 @@ static int ext4_meta_trans_blocks(struct inode =
*inode, int lblocks,
>=20
> /*
>  * Test whether an inode is a fast symlink.
> + * A fast symlink has its symlink data stored in =
ext4_inode_info->i_data.
>  */
> int ext4_inode_is_fast_symlink(struct inode *inode)
> {
> -        int ea_blocks =3D EXT4_I(inode)->i_file_acl ?
> -		EXT4_CLUSTER_SIZE(inode->i_sb) >> 9 : 0;
> -
> -	if (ext4_has_inline_data(inode))
> -		return 0;
> -
> -	return (S_ISLNK(inode->i_mode) && inode->i_blocks - ea_blocks =3D=3D=
 0);
> +	return S_ISLNK(inode->i_mode) && inode->i_size &&
> +	       (inode->i_size < EXT4_N_BLOCKS * 4);
> }
>=20
> /*
> @@ -261,6 +257,16 @@ void ext4_evict_inode(struct inode *inode)
>=20
> 	if (IS_SYNC(inode))
> 		ext4_handle_sync(handle);
> +
> +	/*
> +	 * Set inode->i_size to 0 before calling ext4_truncate(). We =
need
> +	 * special handling of symlinks here because i_size is used to
> +	 * determine whether ext4_inode_info->i_data contains symlink =
data or
> +	 * block mappings. Setting i_size to 0 will remove its fast =
symlink
> +	 * status. Erase i_data so that it becomes a valid empty block =
map.
> +	 */
> +	if (ext4_inode_is_fast_symlink(inode))
> +		memset(EXT4_I(inode)->i_data, 0, =
sizeof(EXT4_I(inode)->i_data));
> 	inode->i_size =3D 0;
> 	err =3D ext4_mark_inode_dirty(handle, inode);
> 	if (err) {
> --
> 2.13.2.725.g09c95d1e9-goog
>=20


Cheers, Andreas






--Apple-Mail=_9CDB6213-C704-4B57-B341-62816FAE8A4B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZU98MpIg59Q01vtYRAgJUAJ4jgO9WcJ1yscjJKa635PQunjdWagCfXnPE
neMyTs0Un2+FlG0J0aadWnE=
=Tiud
-----END PGP SIGNATURE-----

--Apple-Mail=_9CDB6213-C704-4B57-B341-62816FAE8A4B--
