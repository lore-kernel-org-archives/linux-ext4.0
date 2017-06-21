From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 32/32] ext4: add nombcache mount option
Date: Wed, 21 Jun 2017 15:02:49 -0600
Message-ID: <B63F04AF-ED74-4A05-BA5A-160A97C61106@dilger.ca>
References: <20170620091435.13560-1-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_1C8959A3-E391-437E-919B-9C8AD21DD534";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170620091435.13560-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_1C8959A3-E391-437E-919B-9C8AD21DD534
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 20, 2017, at 3:14 AM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> The main purpose of mb cache is to achieve deduplication in
> extended attributes. In use cases where opportunity for deduplication
> is unlikely, it only adds overhead.
>=20
> Add a mount option to explicitly turn off mb cache.
>=20
> Suggested-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
> fs/ext4/ext4.h  |  1 +
> fs/ext4/super.c | 33 ++++++++++++++++++++++-----------
> fs/ext4/xattr.c | 55 =
++++++++++++++++++++++++++++++++++++-------------------
> 3 files changed, 59 insertions(+), 30 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 59e9488c4876..21aca1f87187 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1149,6 +1149,7 @@ struct ext4_inode_info {
> #define EXT4_MOUNT_DIOREAD_NOLOCK	0x400000 /* Enable support for =
dio read nolocking */
> #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
> #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal =
Async Commit */
> +#define EXT4_MOUNT_NO_MBCACHE		0x2000000 /* No mbcache =
usage */

We've been using 0x00001 for EXT4_MOUNT_NO_MBCACHE.

> #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
> #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data =
write */
> #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity =
checking */
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 4b15bf674d45..4262a1b9b5b2 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1336,7 +1336,7 @@ enum {
> 	Opt_inode_readahead_blks, Opt_journal_ioprio,
> 	Opt_dioread_nolock, Opt_dioread_lock,
> 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
> -	Opt_max_dir_size_kb, Opt_nojournal_checksum,
> +	Opt_max_dir_size_kb, Opt_nojournal_checksum, Opt_nombcache,
> };
>=20
> static const match_table_t tokens =3D {
> @@ -1419,6 +1419,7 @@ static const match_table_t tokens =3D {
> 	{Opt_noinit_itable, "noinit_itable"},
> 	{Opt_max_dir_size_kb, "max_dir_size_kb=3D%u"},
> 	{Opt_test_dummy_encryption, "test_dummy_encryption"},
> +	{Opt_nombcache, "nombcache"},

For compatibility, please also add:

	{Opt_nombcache, "no_mbcache"},

> 	{Opt_removed, "check=3Dnone"},	/* mount option from ext2/3 */
> 	{Opt_removed, "nocheck"},	/* mount option from ext2/3 */
> 	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
> @@ -1626,6 +1627,7 @@ static const struct mount_opts {
> 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
> 	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
> 	{Opt_test_dummy_encryption, 0, MOPT_GTE0},
> +	{Opt_nombcache, EXT4_MOUNT_NO_MBCACHE, MOPT_SET},
> 	{Opt_err, 0, 0}
> };
>=20
> @@ -4080,19 +4082,22 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 	sbi->s_journal->j_commit_callback =3D =
ext4_journal_commit_callback;
>=20
> no_journal:
> -	sbi->s_mb_cache =3D ext4_xattr_create_cache();
> -	if (!sbi->s_mb_cache) {
> -		ext4_msg(sb, KERN_ERR, "Failed to create an mb_cache");
> -		goto failed_mount_wq;
> -	}
> -
> -	if (ext4_has_feature_ea_inode(sb)) {
> -		sbi->s_ea_inode_cache =3D ext4_xattr_create_cache();
> -		if (!sbi->s_ea_inode_cache) {
> +	if (!test_opt(sb, NO_MBCACHE)) {
> +		sbi->s_mb_cache =3D ext4_xattr_create_cache();

Should be named "s_mb_ea_block_cache" or similar?

> +		if (!sbi->s_mb_cache) {
> 			ext4_msg(sb, KERN_ERR,
> -				 "Failed to create an =
s_ea_inode_cache");
> +				 "Failed to create xattr block =
mb_cache");
> 			goto failed_mount_wq;
> 		}
> +
> +		if (ext4_has_feature_ea_inode(sb)) {
> +			sbi->s_ea_inode_cache =3D =
ext4_xattr_create_cache();

Should be named "s_mb_ea_inode_cache", or alternately use =
"s_ea_block_cache"
above?

> +			if (!sbi->s_ea_inode_cache) {
> +				ext4_msg(sb, KERN_ERR,
> +					 "Failed to create ea_inode =
mb_cache");
> +				goto failed_mount_wq;
> +			}
> +		}
> 	}
>=20
> 	if ((DUMMY_ENCRYPTION_ENABLED(sbi) || =
ext4_has_feature_encrypt(sb)) &&
> @@ -4989,6 +4994,12 @@ static int ext4_remount(struct super_block *sb, =
int *flags,
> 		}
> 	}
>=20
> +	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & =
EXT4_MOUNT_NO_MBCACHE) {
> +		ext4_msg(sb, KERN_ERR, "can't enable nombcache during =
remount");
> +		err =3D -EINVAL;
> +		goto restore_opts;
> +	}

It appears that this restriction also applies to enabling mbcache during
remount as well, so the message should be updated?  In particular, if
NO_MBCACHE is currently set but isn't passed during the remount then =
this
will always cause the remount to fail.  That makes it harder for users =
to
just run something like "mount -o remount,ro".

It seems we are a bit inconsistent with how we handle changing mount =
options.
In some cases, if an option is set to be enabled but cannot be, it is =
actually
ignored (e.g. DAX, JOURNAL_CHECKSUM).  In other cases this returns an =
error.

In this case it is probably easiest to just ignore the change to this =
option,
as is done with JOURNAL_CHECKSUM and DAX.

> 	if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT4_MOUNT_DAX) =
{
> 		ext4_msg(sb, KERN_WARNING, "warning: refusing change of =
"
> 			"dax flag with busy inodes while remounting");
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 9d1b600dc827..65ead540c684 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c

> @@ -1200,11 +1206,13 @@ ext4_xattr_release_block(handle_t *handle,
> 		if (ref =3D=3D EXT4_XATTR_REFCOUNT_MAX - 1) {
> 			struct mb_cache_entry *ce;

This could go inside the "if (ext4_mb_cache)" block.

> -			ce =3D mb_cache_entry_get(ext4_mb_cache, hash,
> -						bh->b_blocknr);
> -			if (ce) {
> -				ce->e_reusable =3D 1;
> -				mb_cache_entry_put(ext4_mb_cache, ce);
> +			if (ext4_mb_cache) {
> +				ce =3D mb_cache_entry_get(ext4_mb_cache, =
hash,
> +							bh->b_blocknr);
> +				if (ce) {
> +					ce->e_reusable =3D 1;
> +					=
mb_cache_entry_put(ext4_mb_cache, ce);
> +				}
> 			}
> 		}


Cheers, Andreas






--Apple-Mail=_1C8959A3-E391-437E-919B-9C8AD21DD534
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZSt77pIg59Q01vtYRAsGXAKCQEPMO/hC9AhOyqmrb8L8xO9eWCQCdE2JG
NyFez2yiR3nl4R6KECDZ8FE=
=WY31
-----END PGP SIGNATURE-----

--Apple-Mail=_1C8959A3-E391-437E-919B-9C8AD21DD534--
