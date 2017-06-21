From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 23/31] mbcache: make mbcache naming more generic
Date: Wed, 21 Jun 2017 11:43:18 -0600
Message-ID: <3DC421C9-456D-4A96-AE38-2F8516F62B91@dilger.ca>
References: <20170619085026.GD11837@quack2.suse.cz>
 <20170620090113.6658-1-tahsin@google.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_1EAA920F-7801-4D4A-8DEB-CB83E051FB96";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35350 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdFURnX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jun 2017 13:43:23 -0400
Received: by mail-it0-f66.google.com with SMTP id f20so1487880itb.2
        for <linux-ext4@vger.kernel.org>; Wed, 21 Jun 2017 10:43:22 -0700 (PDT)
In-Reply-To: <20170620090113.6658-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_1EAA920F-7801-4D4A-8DEB-CB83E051FB96
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 20, 2017, at 3:01 AM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> Make names more generic so that mbcache usage is not limited to
> block sharing. In a subsequent patch in the series
> ("ext4: xattr inode deduplication"), we start using the mbcache code
> for sharing xattr inodes. With that patch, old mb_cache_entry.e_block
> field could be holding either a block number or an inode number.
>=20
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> v2: updated commit title and description
>=20
> fs/ext2/xattr.c         | 18 +++++++++---------
> fs/ext4/xattr.c         | 10 +++++-----
> fs/mbcache.c            | 43 =
+++++++++++++++++++++----------------------
> include/linux/mbcache.h | 11 +++++------
> 4 files changed, 40 insertions(+), 42 deletions(-)
>=20
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index fbdb8f171893..1e5f76070580 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -493,8 +493,8 @@ bad_block:		ext2_error(sb, =
"ext2_xattr_set",
> 			 * This must happen under buffer lock for
> 			 * ext2_xattr_set2() to reliably detect modified =
block
> 			 */
> -			=
mb_cache_entry_delete_block(EXT2_SB(sb)->s_mb_cache,
> -						    hash, =
bh->b_blocknr);
> +			mb_cache_entry_delete(EXT2_SB(sb)->s_mb_cache, =
hash,
> +					      bh->b_blocknr);
>=20
> 			/* keep the buffer locked while modifying it. */
> 		} else {
> @@ -721,8 +721,8 @@ ext2_xattr_set2(struct inode *inode, struct =
buffer_head *old_bh,
> 			 * This must happen under buffer lock for
> 			 * ext2_xattr_set2() to reliably detect freed =
block
> 			 */
> -			mb_cache_entry_delete_block(ext2_mb_cache,
> -						    hash, =
old_bh->b_blocknr);
> +			mb_cache_entry_delete(ext2_mb_cache, hash,
> +					      old_bh->b_blocknr);
> 			/* Free the old block. */
> 			ea_bdebug(old_bh, "freeing");
> 			ext2_free_blocks(inode, old_bh->b_blocknr, 1);
> @@ -795,8 +795,8 @@ ext2_xattr_delete_inode(struct inode *inode)
> 		 * This must happen under buffer lock for =
ext2_xattr_set2() to
> 		 * reliably detect freed block
> 		 */
> -		=
mb_cache_entry_delete_block(EXT2_SB(inode->i_sb)->s_mb_cache,
> -					    hash, bh->b_blocknr);
> +		mb_cache_entry_delete(EXT2_SB(inode->i_sb)->s_mb_cache, =
hash,
> +				      bh->b_blocknr);
> 		ext2_free_blocks(inode, EXT2_I(inode)->i_file_acl, 1);
> 		get_bh(bh);
> 		bforget(bh);
> @@ -907,11 +907,11 @@ ext2_xattr_cache_find(struct inode *inode, =
struct ext2_xattr_header *header)
> 	while (ce) {
> 		struct buffer_head *bh;
>=20
> -		bh =3D sb_bread(inode->i_sb, ce->e_block);
> +		bh =3D sb_bread(inode->i_sb, ce->e_value);
> 		if (!bh) {
> 			ext2_error(inode->i_sb, "ext2_xattr_cache_find",
> 				"inode %ld: block %ld read error",
> -				inode->i_ino, (unsigned long) =
ce->e_block);
> +				inode->i_ino, (unsigned long) =
ce->e_value);
> 		} else {
> 			lock_buffer(bh);
> 			/*
> @@ -931,7 +931,7 @@ ext2_xattr_cache_find(struct inode *inode, struct =
ext2_xattr_header *header)
> 			} else if (le32_to_cpu(HDR(bh)->h_refcount) >
> 				   EXT2_XATTR_REFCOUNT_MAX) {
> 				ea_idebug(inode, "block %ld refcount =
%d>%d",
> -					  (unsigned long) ce->e_block,
> +					  (unsigned long) ce->e_value,
> 					  =
le32_to_cpu(HDR(bh)->h_refcount),
> 					  EXT2_XATTR_REFCOUNT_MAX);
> 			} else if (!ext2_xattr_cmp(header, HDR(bh))) {
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index c09fcffb0878..0b43e0e52e26 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -678,7 +678,7 @@ ext4_xattr_release_block(handle_t *handle, struct =
inode *inode,
> 		 * This must happen under buffer lock for
> 		 * ext4_xattr_block_set() to reliably detect freed block
> 		 */
> -		mb_cache_entry_delete_block(ext4_mb_cache, hash, =
bh->b_blocknr);
> +		mb_cache_entry_delete(ext4_mb_cache, hash, =
bh->b_blocknr);
> 		get_bh(bh);
> 		unlock_buffer(bh);
> 		ext4_free_blocks(handle, inode, bh, 0, 1,
> @@ -1115,8 +1115,8 @@ ext4_xattr_block_set(handle_t *handle, struct =
inode *inode,
> 			 * ext4_xattr_block_set() to reliably detect =
modified
> 			 * block
> 			 */
> -			mb_cache_entry_delete_block(ext4_mb_cache, hash,
> -						    bs->bh->b_blocknr);
> +			mb_cache_entry_delete(ext4_mb_cache, hash,
> +					      bs->bh->b_blocknr);
> 			ea_bdebug(bs->bh, "modifying in-place");
> 			error =3D ext4_xattr_set_entry(i, s, handle, =
inode);
> 			if (!error) {
> @@ -2238,10 +2238,10 @@ ext4_xattr_cache_find(struct inode *inode, =
struct ext4_xattr_header *header,
> 	while (ce) {
> 		struct buffer_head *bh;
>=20
> -		bh =3D sb_bread(inode->i_sb, ce->e_block);
> +		bh =3D sb_bread(inode->i_sb, ce->e_value);
> 		if (!bh) {
> 			EXT4_ERROR_INODE(inode, "block %lu read error",
> -					 (unsigned long) ce->e_block);
> +					 (unsigned long) ce->e_value);
> 		} else if (ext4_xattr_cmp(header, BHDR(bh)) =3D=3D 0) {
> 			*pce =3D ce;
> 			return bh;
> diff --git a/fs/mbcache.c b/fs/mbcache.c
> index b19be429d655..45a8d52dc991 100644
> --- a/fs/mbcache.c
> +++ b/fs/mbcache.c
> @@ -10,7 +10,7 @@
> /*
>  * Mbcache is a simple key-value store. Keys need not be unique, =
however
>  * key-value pairs are expected to be unique (we use this fact in
> - * mb_cache_entry_delete_block()).
> + * mb_cache_entry_delete()).
>  *
>  * Ext2 and ext4 use this cache for deduplication of extended =
attribute blocks.
>  * They use hash of a block contents as a key and block number as a =
value.
> @@ -62,15 +62,15 @@ static inline struct hlist_bl_head =
*mb_cache_entry_head(struct mb_cache *cache,
>  * @cache - cache where the entry should be created
>  * @mask - gfp mask with which the entry should be allocated
>  * @key - key of the entry
> - * @block - block that contains data
> - * @reusable - is the block reusable by other inodes?
> + * @value - value of the entry
> + * @reusable - is the entry reusable by others?
>  *
> - * Creates entry in @cache with key @key and records that data is =
stored in
> - * block @block. The function returns -EBUSY if entry with the same =
key
> - * and for the same block already exists in cache. Otherwise 0 is =
returned.
> + * Creates entry in @cache with key @key and value @value. The =
function returns
> + * -EBUSY if entry with the same key and value already exists in =
cache.
> + * Otherwise 0 is returned.
>  */
> int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
> -			  sector_t block, bool reusable)
> +			  u64 value, bool reusable)
> {
> 	struct mb_cache_entry *entry, *dup;
> 	struct hlist_bl_node *dup_node;
> @@ -91,12 +91,12 @@ int mb_cache_entry_create(struct mb_cache *cache, =
gfp_t mask, u32 key,
> 	/* One ref for hash, one ref returned */
> 	atomic_set(&entry->e_refcnt, 1);
> 	entry->e_key =3D key;
> -	entry->e_block =3D block;
> +	entry->e_value =3D value;
> 	entry->e_reusable =3D reusable;
> 	head =3D mb_cache_entry_head(cache, key);
> 	hlist_bl_lock(head);
> 	hlist_bl_for_each_entry(dup, dup_node, head, e_hash_list) {
> -		if (dup->e_key =3D=3D key && dup->e_block =3D=3D block) =
{
> +		if (dup->e_key =3D=3D key && dup->e_value =3D=3D value) =
{
> 			hlist_bl_unlock(head);
> 			kmem_cache_free(mb_entry_cache, entry);
> 			return -EBUSY;
> @@ -187,13 +187,13 @@ struct mb_cache_entry =
*mb_cache_entry_find_next(struct mb_cache *cache,
> EXPORT_SYMBOL(mb_cache_entry_find_next);
>=20
> /*
> - * mb_cache_entry_get - get a cache entry by block number (and key)
> + * mb_cache_entry_get - get a cache entry by value (and key)
>  * @cache - cache we work with
> - * @key - key of block number @block
> - * @block - block number
> + * @key - key
> + * @value - value
>  */
> struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 =
key,
> -					  sector_t block)
> +					  u64 value)
> {
> 	struct hlist_bl_node *node;
> 	struct hlist_bl_head *head;
> @@ -202,7 +202,7 @@ struct mb_cache_entry *mb_cache_entry_get(struct =
mb_cache *cache, u32 key,
> 	head =3D mb_cache_entry_head(cache, key);
> 	hlist_bl_lock(head);
> 	hlist_bl_for_each_entry(entry, node, head, e_hash_list) {
> -		if (entry->e_key =3D=3D key && entry->e_block =3D=3D =
block) {
> +		if (entry->e_key =3D=3D key && entry->e_value =3D=3D =
value) {
> 			atomic_inc(&entry->e_refcnt);
> 			goto out;
> 		}
> @@ -214,15 +214,14 @@ struct mb_cache_entry *mb_cache_entry_get(struct =
mb_cache *cache, u32 key,
> }
> EXPORT_SYMBOL(mb_cache_entry_get);
>=20
> -/* mb_cache_entry_delete_block - remove information about block from =
cache
> +/* mb_cache_entry_delete - remove a cache entry
>  * @cache - cache we work with
> - * @key - key of block @block
> - * @block - block number
> + * @key - key
> + * @value - value
>  *
> - * Remove entry from cache @cache with key @key with data stored in =
@block.
> + * Remove entry from cache @cache with key @key and value @value.
>  */
> -void mb_cache_entry_delete_block(struct mb_cache *cache, u32 key,
> -				 sector_t block)
> +void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 =
value)
> {
> 	struct hlist_bl_node *node;
> 	struct hlist_bl_head *head;
> @@ -231,7 +230,7 @@ void mb_cache_entry_delete_block(struct mb_cache =
*cache, u32 key,
> 	head =3D mb_cache_entry_head(cache, key);
> 	hlist_bl_lock(head);
> 	hlist_bl_for_each_entry(entry, node, head, e_hash_list) {
> -		if (entry->e_key =3D=3D key && entry->e_block =3D=3D =
block) {
> +		if (entry->e_key =3D=3D key && entry->e_value =3D=3D =
value) {
> 			/* We keep hash list reference to keep entry =
alive */
> 			hlist_bl_del_init(&entry->e_hash_list);
> 			hlist_bl_unlock(head);
> @@ -248,7 +247,7 @@ void mb_cache_entry_delete_block(struct mb_cache =
*cache, u32 key,
> 	}
> 	hlist_bl_unlock(head);
> }
> -EXPORT_SYMBOL(mb_cache_entry_delete_block);
> +EXPORT_SYMBOL(mb_cache_entry_delete);
>=20
> /* mb_cache_entry_touch - cache entry got used
>  * @cache - cache the entry belongs to
> diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
> index 86c9a8b480c5..e1bc73414983 100644
> --- a/include/linux/mbcache.h
> +++ b/include/linux/mbcache.h
> @@ -19,15 +19,15 @@ struct mb_cache_entry {
> 	u32			e_key;
> 	u32			e_referenced:1;
> 	u32			e_reusable:1;
> -	/* Block number of hashed block - stable during lifetime of the =
entry */
> -	sector_t		e_block;
> +	/* User provided value - stable during lifetime of the entry */
> +	u64			e_value;
> };
>=20
> struct mb_cache *mb_cache_create(int bucket_bits);
> void mb_cache_destroy(struct mb_cache *cache);
>=20
> int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
> -			  sector_t block, bool reusable);
> +			  u64 value, bool reusable);
> void __mb_cache_entry_free(struct mb_cache_entry *entry);
> static inline int mb_cache_entry_put(struct mb_cache *cache,
> 				     struct mb_cache_entry *entry)
> @@ -38,10 +38,9 @@ static inline int mb_cache_entry_put(struct =
mb_cache *cache,
> 	return 1;
> }
>=20
> -void mb_cache_entry_delete_block(struct mb_cache *cache, u32 key,
> -				  sector_t block);
> +void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 =
value);
> struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 =
key,
> -					  sector_t block);
> +					  u64 value);
> struct mb_cache_entry *mb_cache_entry_find_first(struct mb_cache =
*cache,
> 						 u32 key);
> struct mb_cache_entry *mb_cache_entry_find_next(struct mb_cache =
*cache,
> --
> 2.13.1.518.g3df882009-goog
>=20


Cheers, Andreas






--Apple-Mail=_1EAA920F-7801-4D4A-8DEB-CB83E051FB96
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZSrA2pIg59Q01vtYRAiWoAKCb8ttxe2iapckXhFAtR9xmjT3zNQCgwnMH
0Yl/ZkvS4h241PnM9j3hNnA=
=IMQq
-----END PGP SIGNATURE-----

--Apple-Mail=_1EAA920F-7801-4D4A-8DEB-CB83E051FB96--
