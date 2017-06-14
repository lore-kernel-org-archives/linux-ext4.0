From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v4 27/28] ext4: xattr inode deduplication
Date: Wed, 14 Jun 2017 17:26:26 -0600
Message-ID: <6E41DA31-A524-4E0E-BD0B-5C994399BBC6@dilger.ca>
References: <20170602233511.23173-1-tahsin@google.com>
 <20170614143459.22359-1-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_7E1D999A-B98A-41C7-A621-130BCE33F739";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33733 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbdFNX0b (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Jun 2017 19:26:31 -0400
Received: by mail-it0-f67.google.com with SMTP id l6so283371iti.0
        for <linux-ext4@vger.kernel.org>; Wed, 14 Jun 2017 16:26:31 -0700 (PDT)
In-Reply-To: <20170614143459.22359-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_7E1D999A-B98A-41C7-A621-130BCE33F739
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

[reduced CC list to linux-ext4]

On Jun 14, 2017, at 8:34 AM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> Ext4 now supports xattr values that are up to 64k in size (vfs limit).
> Large xattr values are stored in external inodes each one holding a
> single value. Once written the data blocks of these inodes are =
immutable.
>=20
> The real world use cases are expected to have a lot of value =
duplication
> such as inherited acls etc. To reduce data duplication on disk, this =
patch
> implements a deduplicator that allows sharing of xattr inodes.
>=20
> The deduplication is based on an in-memory hash lookup that is a best
> effort sharing scheme. When a xattr inode is read from disk (i.e.
> getxattr() call), its crc32c hash is added to a hash table. Before
> creating a new xattr inode for a value being set, the hash table is
> checked to see if an existing inode holds an identical value. If such =
an
> inode is found, the ref count on that inode is incremented. On value
> removal the ref count is decremented and if it reaches zero the inode =
is
> deleted.
>=20
> The quota charging for such inodes is manually managed. Every =
reference
> holder is charged the full size as if there was no sharing happening.
> This is consistent with how xattr blocks are also charged.
>=20
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
> v4:
> - eliminated xattr entry in the xattr inode to avoid complexity and
>   recursion in xattr update path. Now the ref count and hash are =
stored
>   in i_[c/m/a]time.tv_sec fields.
> - some clean up in ext4_xattr_set_entry() to reduce code duplication =
and
>   complexity
>=20
> v3:
> - use s_csum_seed for hash calculations when available
> - return error on stored vs calculated hash mismatch
>=20
> v2:
> - make dependency on crc32c dynamic
> - update ext4_has_metadata_csum() and ext4_has_group_desc_csum() so =
that
>   they do not misinterpret existence of EXT4_SB(sb)->s_chksum_driver
>=20
> fs/ext4/acl.c   |    5 +-
> fs/ext4/ext4.h  |   22 +-
> fs/ext4/inode.c |    9 +-
> fs/ext4/super.c |   25 +-
> fs/ext4/xattr.c | 1000 =
+++++++++++++++++++++++++++++++++++++++++--------------
> fs/ext4/xattr.h |   17 +-
> fs/mbcache.c    |    9 +-
> 7 files changed, 806 insertions(+), 281 deletions(-)
>=20
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index b02a23ec92ca..9fcd29e21dc7 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4067,6 +4075,15 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 		goto failed_mount_wq;
> 	}
>=20
> +	if (ext4_has_feature_ea_inode(sb)) {
> +		sbi->s_ea_inode_cache =3D ext4_xattr_create_cache();
> +		if (!sbi->s_ea_inode_cache) {
> +			ext4_msg(sb, KERN_ERR,
> +				 "Failed to create an =
s_ea_inode_cache");
> +			goto failed_mount_wq;
> +		}
> +	}

It would be preferable to allow a mount option like "no_mbcache" to =
disable
the use of shared xattrs.  In the Lustre case at least, there will never =
be
shared large xattrs, and we've had a bunch of performance issues with =
mbcache
due to lock contention among many server threads doing concurrent =
lookups and
inserting many thousands of unique entries into the cache.

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index abc7d5f84e5f..2f9bcafd9aed 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -280,6 +283,34 @@ ext4_xattr_find_entry(struct ext4_xattr_entry =
**pentry, int name_index,
> 	return cmp ? -ENODATA : 0;
> }
>=20
> +static u32
> +ext4_xattr_inode_hash(struct ext4_sb_info *sbi, const void *buffer, =
size_t size)
> +{
> +	return ext4_chksum(sbi, sbi->s_csum_seed ?: ~0, buffer, size);
> +}

This should follow the existing convention of always using s_csum_seed =
to seed
the checksum, and change ext4_fill_super() to initialize s_csum_seed to =
~0 if
ext4_has_metadata_csum() is false, or always use the same value =
regardless of
whether ext4_has_metadata_csum() is set or not.

> +static u64 ext4_xattr_inode_get_ref(struct inode *ea_inode)
> +{
> +	return ((u64)ea_inode->i_ctime.tv_sec << 32) |
> +	       ((u32)ea_inode->i_mtime.tv_sec);
> +}

If it really necessary to have more than 2^32 references on a single =
shared
inode then it would be better to avoid the re-use of i_mtime, which =
breaks
the backref for unshared xattrs, and using i_size isn't enough of a =
guarantee
that this is the correct parent inode in case of on-disk corruption.

If you think that > 2^32 references to a single xattr is really needed, =
you
can use i_ctime_extra, since this will almost certainly only be used on =
ext4
filesystems with 256-byte or larger inodes.  It is highly unlikely that =
there
are filesystems with multi-billions of shared xattrs that are =
ext2-formatted.

This allows for a period of transition between existing single-user =
xattr inodes
(which use i_mtime for the parent back-ref) and the shared xattr inodes, =
instead
of requiring a full e2fsck when upgrading from an older version of xattr =
inodes
to a new kernel, and then doing the same if there is a need to downgrade =
again.

> +static void ext4_xattr_inode_set_ref(struct inode *ea_inode, u64 =
ref_count)
> +{
> +	ea_inode->i_ctime.tv_sec =3D (u32)(ref_count >> 32);
> +	ea_inode->i_mtime.tv_sec =3D (u32)ref_count;
> +}
> +
> +static u32 ext4_xattr_inode_get_hash(struct inode *ea_inode)
> +{
> +	return (u32)ea_inode->i_atime.tv_sec;
> +}
> +
> +static void ext4_xattr_inode_set_hash(struct inode *ea_inode, u32 =
hash)
> +{
> +	ea_inode->i_atime.tv_sec =3D hash;
> +}
> +
> /*
>  * Read the EA value from an inode.
>  */
> @@ -298,13 +331,24 @@ static int ext4_xattr_inode_read(struct inode =
*ea_inode, void *buf, size_t size)
> 		if (!bh)
> 			return -EFSCORRUPTED;
>=20
> -		memcpy(buf, bh->b_data, csize);
> +		memcpy(copy_pos, bh->b_data, csize);
> 		brelse(bh);
>=20
> -		buf +=3D csize;
> +		copy_pos +=3D csize;
> 		block +=3D 1;
> 		copied +=3D csize;
> 	}
> +
> +	calc_hash =3D ext4_xattr_inode_hash(EXT4_SB(ea_inode->i_sb), =
buf, size);
> +
> +	/* Verify stored hash matches calculated hash. */
> +	stored_hash =3D ext4_xattr_inode_get_hash(ea_inode);
> +	if (calc_hash !=3D stored_hash) {
> +		ext4_warning_inode(ea_inode,
> +			"EA inode calc_hash=3D%#x does not match =
stored_hash=3D%#x",
> +			calc_hash, stored_hash);
> +		return -EFSCORRUPTED;
> +	}

Should this be contingent on ext4_has_metadata_csum() feature being =
enabled, or
alternately check if EXT4_XATTR_INODE_GET_PARENT() and i_generation =
match before
returning an error.  This will allow a smooth transition from existing =
filesystems
that do not store the hash, but have only a single-use xattr inode with =
a parent
backref.

> @@ -329,14 +373,6 @@ static int ext4_xattr_inode_iget(struct inode =
*parent, unsigned long ea_ino,
> 		goto error;
> 	}
>=20
> -	if (EXT4_XATTR_INODE_GET_PARENT(inode) !=3D parent->i_ino ||
> -	    inode->i_generation !=3D parent->i_generation) {
> -		ext4_error(parent->i_sb, "Backpointer from EA inode %lu =
"
> -			   "to parent is invalid.", ea_ino);
> -		err =3D -EINVAL;
> -		goto error;
> -	}

This check here should be moved up to ext4_xattr_inode_read().

> +static int __ext4_xattr_set_credits(struct super_block *sb,

> +				    struct buffer_head *block_bh,
> +				    size_t value_len)
> +{
> +	int credits;
> +	int blocks;
> +
> +	/*
> +	 * 1) Owner inode update
> +	 * 2) Ref count update on old xattr block
> +	 * 3) new xattr block
> +	 * 4) block bitmap update for new xattr block
> +	 * 5) group descriptor for new xattr block
> +	 */
> +	credits =3D 5;
> +
> +	/* We are done if ea_inode feature is not enabled. */
> +	if (!ext4_has_feature_ea_inode(sb))
> +		return credits;
> +
> +	/* New ea_inode, inode map, block bitmap, group descriptor. */
> +	credits +=3D 4;
> +
> +	/* Data blocks. */
> +	blocks =3D (value_len + sb->s_blocksize - 1) >> =
sb->s_blocksize_bits;
> +
> +	/* Indirection block. */
> +	blocks +=3D 1;

Strictly speaking, this is only needed "if (blocks > EXT4_NDIR_BLOCKS)".

> +
> +	/* Block bitmap and group descriptor updates for each block. */
> +	credits +=3D blocks * 2;
> +
> +	/* Blocks themselves. */
> +	credits +=3D blocks;
> +
> +	/* Dereference ea_inode holding old xattr value.
> +	 * Old ea_inode, inode map, block bitmap, group descriptor.
> +	 */
> +	credits +=3D 4;
> +
> +	/* Data blocks for old ea_inode. */
> +	blocks =3D XATTR_SIZE_MAX >> sb->s_blocksize_bits;
> +
> +	/* Indirection block for old ea_inode. */
> +	blocks +=3D 1;
> +
> +	/* Block bitmap and group descriptor updates for each block. */
> +	credits +=3D blocks * 2;
> +
> +	/* Quota updates. */
> +	credits +=3D EXT4_MAXQUOTAS_TRANS_BLOCKS(sb);
> +
> +	/* We may need to clone the existing xattr block in which case =
we need
> +	 * to increment ref counts for existing ea_inodes referenced by =
it.
> +	 */

Just to clarify here, in the case of cloning an existing xattr block, =
are the
refcounts being _incremented_ or _decremented_ on the existing =
ea_inodes?  I'm
trying to figure out if we really need to have credits for both old and =
new
xattr inodes, as well as these additional credits.  Since this is =
reserving
about 110 blocks for every setxattr, this can add significant pressure =
on the
journal if there are lots of threads creating files and/or setting =
xattrs.

> +	if (block_bh) {
> +		struct ext4_xattr_entry *entry =3D BFIRST(block_bh);
> +
> +		for (; !IS_LAST_ENTRY(entry); entry =3D =
EXT4_XATTR_NEXT(entry))
> +			if (entry->e_value_inum)
> +				/* Ref count update on ea_inode. */
> +				credits +=3D 1;
> +	}
> +	return credits;
> +}
>=20
> @@ -965,67 +1257,121 @@ static struct inode =
*ext4_xattr_inode_create(handle_t	+static struct inode *
> +ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
> +			    size_t value_len, u32 hash)
> {
> +	struct inode *ea_inode;
> +	struct mb_cache_entry *ce;
> +	struct mb_cache *ea_inode_cache =3D EA_INODE_CACHE(inode);
> +	void *ea_data =3D NULL;
> 	int err;

This function should just return NULL if ea_inode_cache is NULL (e.g. in
the case of "no_mbcache" mount option).

> +	ce =3D mb_cache_entry_find_first(ea_inode_cache, hash);
> +	while (ce) {
> +		ea_inode =3D ext4_iget(inode->i_sb, ce->e_value);
> +		if (IS_ERR(ea_inode)) {
> +			ea_inode =3D NULL;
> +			goto next;
> +		}
>=20
> +		if (is_bad_inode(ea_inode) ||
> +		    !(EXT4_I(ea_inode)->i_flags & EXT4_EA_INODE_FL) ||
> +		    i_size_read(ea_inode) !=3D value_len)
> +			goto next;
>=20
> +		if (!ea_data)
> +			ea_data =3D ext4_kvmalloc(value_len, GFP_NOFS);
> +
> +		if (!ea_data) {
> +			iput(ea_inode);
> +			return NULL;
> +		}
> +
> +		err =3D ext4_xattr_inode_read(ea_inode, ea_data, =
value_len);
> +		if (unlikely(err))
> +			goto next;
> +
> +		if (!memcmp(value, ea_data, value_len)) {
> +			mb_cache_entry_touch(ea_inode_cache, ce);
> +			mb_cache_entry_put(ea_inode_cache, ce);
> +			kvfree(ea_data);
> +			return ea_inode;
> +		}
> +next:
> +		iput(ea_inode);
> +		ce =3D mb_cache_entry_find_next(ea_inode_cache, ce);
> +	}
> +	kvfree(ea_data);
> +	return NULL;
> }
>=20
> /*
>  * Add value of the EA in an inode.
>  */
> -static int ext4_xattr_inode_set(handle_t *handle, struct inode =
*inode,
> -				unsigned long *ea_ino, const void =
*value,
> -				size_t value_len)
> +static int ext4_xattr_inode_lookup_create(handle_t *handle, struct =
inode *inode,
> +					  const void *value, size_t =
value_len,
> +					  struct inode **ret_inode)
> {
> 	struct inode *ea_inode;
> +	u32 hash;
> 	int err;
>=20
> +	hash =3D ext4_xattr_inode_hash(EXT4_SB(inode->i_sb), value, =
value_len);
> +	ea_inode =3D ext4_xattr_inode_cache_find(inode, value, =
value_len, hash);
> +	if (ea_inode) {
> +		err =3D ext4_xattr_inode_inc_ref(handle, ea_inode);
> +		if (err) {
> +			iput(ea_inode);
> +			return err;
> +		}
> +
> +		*ret_inode =3D ea_inode;
> +		return 0;
> +	}
> +
> 	/* Create an inode for the EA value */
> -	ea_inode =3D ext4_xattr_inode_create(handle, inode);
> +	ea_inode =3D ext4_xattr_inode_create(handle, inode, hash);
> 	if (IS_ERR(ea_inode))
> 		return PTR_ERR(ea_inode);
>=20
> 	err =3D ext4_xattr_inode_write(handle, ea_inode, value, =
value_len);
> -	if (err)
> -		clear_nlink(ea_inode);
> -	else
> -		*ea_ino =3D ea_inode->i_ino;
> +	if (err) {
> +		ext4_xattr_inode_dec_ref(handle, ea_inode);
> +		iput(ea_inode);
> +		return err;
> +	}
>=20
> -	iput(ea_inode);
> +	mb_cache_entry_create(EA_INODE_CACHE(inode), GFP_NOFS, hash,
> +			      ea_inode->i_ino, true /* reusable */);

Should skip mb_cache if EA_INODE_CACHE(inode) is NULL, or have a wrapper
like ext4_xattr_inode_cache_insert() to match =
ext4_xattr_inode_cache_find()
that does the same.

Cheers, Andreas






--Apple-Mail=_7E1D999A-B98A-41C7-A621-130BCE33F739
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZQcYjpIg59Q01vtYRAtrbAKCh0bkZui18ZcwSnDWhTsyGEMmVewCgkVfK
igQJPZbKhT9lsr9Z5bmpc44=
=Krsz
-----END PGP SIGNATURE-----

--Apple-Mail=_7E1D999A-B98A-41C7-A621-130BCE33F739--
