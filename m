From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v5 27/28] ext4: xattr inode deduplication
Date: Wed, 21 Jun 2017 11:42:03 -0600
Message-ID: <1C9CBEE2-E701-4A0B-A468-4637E569E925@dilger.ca>
References: <6E41DA31-A524-4E0E-BD0B-5C994399BBC6@dilger.ca>
 <20170620090721.12480-1-tahsin@google.com>
 <CAAeU0aOVQvcEFRoDsjjJoUAjA+iB9xrcwFXyq39arZOQ1i6WOA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_0078ED28-3664-4B77-BC1F-5A2BA59095B9";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAeU0aOVQvcEFRoDsjjJoUAjA+iB9xrcwFXyq39arZOQ1i6WOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_0078ED28-3664-4B77-BC1F-5A2BA59095B9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 20, 2017, at 3:49 AM, Tahsin Erdogan <tahsin@google.com> wrote:
>=20
> Thanks Andreas for the feedback. Please see my responses below:
>=20
>> It would be preferable to allow a mount option like "no_mbcache" to =
disable
>> the use of shared xattrs.  In the Lustre case at least, there will =
never be
>> shared large xattrs, and we've had a bunch of performance issues with =
mbcache
>> due to lock contention among many server threads doing concurrent =
lookups and
>> inserting many thousands of unique entries into the cache.
>=20
> I have put nombcache mount option in a separate patch ("[PATCH 32/32]
> ext4: add nombcache mount option"). I have named it nombcache instead
> of no_mbcache to be consistent with other no* options. Let me know if
> you prefer no_mbcache as the option name.

Tashin, we are already using the "no_mbcache" option name, so would =
prefer
to keep that working.  It would be OK to accept both option names to =
mean
the same thing, and only document the "nombcache" option.

>> This should follow the existing convention of always using =
s_csum_seed to seed
>> the checksum, and change ext4_fill_super() to initialize s_csum_seed =
to ~0 if
>> ext4_has_metadata_csum() is false, or always use the same value =
regardless of
>> whether ext4_has_metadata_csum() is set or not.
>=20
> Done.
>=20
>> If it really necessary to have more than 2^32 references on a single =
shared
>> inode then it would be better to avoid the re-use of i_mtime, which =
breaks
>> the backref for unshared xattrs, and using i_size isn't enough of a =
guarantee
>> that this is the correct parent inode in case of on-disk corruption.
>=20
> I have now moved the lower 32bits of ref count from i_mtime to =
l_i_version.
>=20
>> Should this be contingent on ext4_has_metadata_csum() feature being =
enabled, or
>> alternately check if EXT4_XATTR_INODE_GET_PARENT() and i_generation =
match before
>> returning an error.  This will allow a smooth transition from =
existing filesystems
>> that do not store the hash, but have only a single-use xattr inode =
with a parent
>> backref.
>=20
> I updated hash validation to fallback to parent backref check for
> backward compatibility.

Great, thanks.

>>> +     /* Indirection block. */
>>> +     blocks +=3D 1;
>>=20
>> Strictly speaking, this is only needed "if (blocks > =
EXT4_NDIR_BLOCKS)".
>=20
> Ack. I didn't think it was worth going through exact calculation in
> this case, let me know if you see value in doing that.
> I also updated the comment to mention extents.

This one credit isn't a huge deal.  In general, the number of credits =
reserved
can affect performance if they get too large, especially if there are a =
large
number of threads active, since this will cause premature journal =
flushing and
reduce the number of shared blocks written in the same transaction.

>>> +     /* We may need to clone the existing xattr block in which case =
we need
>>> +      * to increment ref counts for existing ea_inodes referenced =
by it.
>>> +      */
>>=20
>> Just to clarify here, in the case of cloning an existing xattr block, =
are the
>> refcounts being _incremented_ or _decremented_ on the existing =
ea_inodes?  I'm
>> trying to figure out if we really need to have credits for both old =
and new
>> xattr inodes, as well as these additional credits.  Since this is =
reserving
>> about 110 blocks for every setxattr, this can add significant =
pressure on the
>> journal if there are lots of threads creating files and/or setting =
xattrs.
>=20
> Cloning causes incrementing xattr inode references.
>=20
>>> +ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
>>> +                         size_t value_len, u32 hash)
>>> {
>>> +     struct inode *ea_inode;
>>> +     struct mb_cache_entry *ce;
>>> +     struct mb_cache *ea_inode_cache =3D EA_INODE_CACHE(inode);
>>> +     void *ea_data =3D NULL;
>>>      int err;
>>=20
>> This function should just return NULL if ea_inode_cache is NULL (e.g. =
in
>> the case of "no_mbcache" mount option).
>=20
> Done in later patch ("[PATCH 32/32] ext4: add nombcache mount option")
>=20
>> Should skip mb_cache if EA_INODE_CACHE(inode) is NULL, or have a =
wrapper
>> like ext4_xattr_inode_cache_insert() to match =
ext4_xattr_inode_cache_find()
>> that does the same.
>=20
> Added skip in patch ("[PATCH 32/32] ext4: add nombcache mount option")

Thanks, I'm just going to go through those patches.

Cheers, Andreas

> On Tue, Jun 20, 2017 at 2:07 AM, Tahsin Erdogan <tahsin@google.com> =
wrote:
>> Ext4 now supports xattr values that are up to 64k in size (vfs =
limit).
>> Large xattr values are stored in external inodes each one holding a
>> single value. Once written the data blocks of these inodes are =
immutable.
>>=20
>> The real world use cases are expected to have a lot of value =
duplication
>> such as inherited acls etc. To reduce data duplication on disk, this =
patch
>> implements a deduplicator that allows sharing of xattr inodes.
>>=20
>> The deduplication is based on an in-memory hash lookup that is a best
>> effort sharing scheme. When a xattr inode is read from disk (i.e.
>> getxattr() call), its crc32c hash is added to a hash table. Before
>> creating a new xattr inode for a value being set, the hash table is
>> checked to see if an existing inode holds an identical value. If such =
an
>> inode is found, the ref count on that inode is incremented. On value
>> removal the ref count is decremented and if it reaches zero the inode =
is
>> deleted.
>>=20
>> The quota charging for such inodes is manually managed. Every =
reference
>> holder is charged the full size as if there was no sharing happening.
>> This is consistent with how xattr blocks are also charged.
>>=20
>> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
>> ---
>> v5:
>> - made ext4_meta_trans_blocks() static again since there are no
>>   remaining users outside of inode.c
>> - initialize sbi->s_csum_seed when ea_inode feature is enabled
>> - use l_i_version to hold lower 32 bits of the xattr ref count.
>>   This avoids clashes with old implementations which use i_mtime.
>>   Since l_i_version is not available in HURD_COMPAT mode, fail mount
>>   request when both ea_inode feature and HURD_COMPAT are set.
>> - when hash validation fails, fall back to old implementation
>>   which has a backref to parent.
>> - fixed checkpatch.pl warning about using unsigned alone
>>=20
>> v4:
>> - eliminated xattr entry in the xattr inode to avoid complexity and
>>   recursion in xattr update path. Now the ref count and hash are =
stored
>>   in i_[c/m/a]time.tv_sec fields.
>> - some clean up in ext4_xattr_set_entry() to reduce code duplication =
and
>>   complexity
>>=20
>> v3:
>> - use s_csum_seed for hash calculations when available
>> - return error on stored vs calculated hash mismatch
>>=20
>> v2:
>> - make dependency on crc32c dynamic
>> - update ext4_has_metadata_csum() and ext4_has_group_desc_csum() so =
that
>>   they do not misinterpret existence of EXT4_SB(sb)->s_chksum_driver
>>=20
>> fs/ext4/acl.c   |    5 +-
>> fs/ext4/ext4.h  |   23 +-
>> fs/ext4/inode.c |   13 +-
>> fs/ext4/super.c |   37 +-
>> fs/ext4/xattr.c | 1038 =
+++++++++++++++++++++++++++++++++++++++++--------------
>> fs/ext4/xattr.h |   17 +-
>> fs/mbcache.c    |    9 +-
>> 7 files changed, 848 insertions(+), 294 deletions(-)
>>=20
>> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
>> index 74f7ac539e00..8db03e5c78bc 100644
>> --- a/fs/ext4/acl.c
>> +++ b/fs/ext4/acl.c
>> @@ -238,7 +238,10 @@ ext4_set_acl(struct inode *inode, struct =
posix_acl *acl, int type)
>>        if (error)
>>                return error;
>> retry:
>> -       credits =3D ext4_xattr_set_credits(inode, acl_size);
>> +       error =3D ext4_xattr_set_credits(inode, acl_size, &credits);
>> +       if (error)
>> +               return error;
>> +
>>        handle =3D ext4_journal_start(inode, EXT4_HT_XATTR, credits);
>>        if (IS_ERR(handle))
>>                return PTR_ERR(handle);
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index d79d8d7bee88..59e9488c4876 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1517,6 +1517,7 @@ struct ext4_sb_info {
>>        long s_es_nr_inode;
>>        struct ext4_es_stats s_es_stats;
>>        struct mb_cache *s_mb_cache;
>> +       struct mb_cache *s_ea_inode_cache;
>>        spinlock_t s_es_lock ____cacheline_aligned_in_smp;
>>=20
>>        /* Ratelimit ext4 messages. */
>> @@ -2099,7 +2100,11 @@ static inline struct ext4_inode =
*ext4_raw_inode(struct ext4_iloc *iloc)
>>        return (struct ext4_inode *) (iloc->bh->b_data + =
iloc->offset);
>> }
>>=20
>> -#define ext4_is_quota_file(inode) IS_NOQUOTA(inode)
>> +static inline bool ext4_is_quota_file(struct inode *inode)
>> +{
>> +       return IS_NOQUOTA(inode) &&
>> +              !(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL);
>> +}
>>=20
>> /*
>>  * This structure is stuffed into the struct file's private_data =
field
>> @@ -2482,7 +2487,6 @@ extern int ext4_truncate_restart_trans(handle_t =
*, struct inode *, int nblocks);
>> extern void ext4_set_inode_flags(struct inode *);
>> extern int ext4_alloc_da_blocks(struct inode *inode);
>> extern void ext4_set_aops(struct inode *inode);
>> -extern int ext4_meta_trans_blocks(struct inode *, int nrblocks, int =
chunk);
>> extern int ext4_writepage_trans_blocks(struct inode *);
>> extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
>> extern int ext4_zero_partial_blocks(handle_t *handle, struct inode =
*inode,
>> @@ -2709,19 +2713,20 @@ extern void ext4_group_desc_csum_set(struct =
super_block *sb, __u32 group,
>> extern int ext4_register_li_request(struct super_block *sb,
>>                                    ext4_group_t first_not_zeroed);
>>=20
>> -static inline int ext4_has_group_desc_csum(struct super_block *sb)
>> -{
>> -       return ext4_has_feature_gdt_csum(sb) ||
>> -              EXT4_SB(sb)->s_chksum_driver !=3D NULL;
>> -}
>> -
>> static inline int ext4_has_metadata_csum(struct super_block *sb)
>> {
>>        WARN_ON_ONCE(ext4_has_feature_metadata_csum(sb) &&
>>                     !EXT4_SB(sb)->s_chksum_driver);
>>=20
>> -       return (EXT4_SB(sb)->s_chksum_driver !=3D NULL);
>> +       return ext4_has_feature_metadata_csum(sb) &&
>> +              (EXT4_SB(sb)->s_chksum_driver !=3D NULL);
>> }
>> +
>> +static inline int ext4_has_group_desc_csum(struct super_block *sb)
>> +{
>> +       return ext4_has_feature_gdt_csum(sb) || =
ext4_has_metadata_csum(sb);
>> +}
>> +
>> static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block =
*es)
>> {
>>        return ((ext4_fsblk_t)le32_to_cpu(es->s_blocks_count_hi) << =
32) |
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index cd007f9757d1..ea95bd9eab81 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -139,6 +139,8 @@ static void ext4_invalidatepage(struct page =
*page, unsigned int offset,
>>                                unsigned int length);
>> static int __ext4_journalled_writepage(struct page *page, unsigned =
int len);
>> static int ext4_bh_delay_or_unwritten(handle_t *handle, struct =
buffer_head *bh);
>> +static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
>> +                                 int pextents);
>>=20
>> /*
>>  * Test whether an inode is a fast symlink.
>> @@ -4843,8 +4845,15 @@ struct inode *ext4_iget(struct super_block =
*sb, unsigned long ino)
>>        }
>>        brelse(iloc.bh);
>>        ext4_set_inode_flags(inode);
>> -       if (ei->i_flags & EXT4_EA_INODE_FL)
>> +
>> +       if (ei->i_flags & EXT4_EA_INODE_FL) {
>>                ext4_xattr_inode_set_class(inode);
>> +
>> +               inode_lock(inode);
>> +               inode->i_flags |=3D S_NOQUOTA;
>> +               inode_unlock(inode);
>> +       }
>> +
>>        unlock_new_inode(inode);
>>        return inode;
>>=20
>> @@ -5503,7 +5512,7 @@ static int ext4_index_trans_blocks(struct inode =
*inode, int lblocks,
>>  *
>>  * Also account for superblock, inode, quota and xattr blocks
>>  */
>> -int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
>> +static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
>>                                  int pextents)
>> {
>>        ext4_group_t groups, ngroups =3D =
ext4_get_groups_count(inode->i_sb);
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index b02a23ec92ca..2bfacd737bb6 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -927,6 +927,10 @@ static void ext4_put_super(struct super_block =
*sb)
>>                invalidate_bdev(sbi->journal_bdev);
>>                ext4_blkdev_remove(sbi);
>>        }
>> +       if (sbi->s_ea_inode_cache) {
>> +               ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
>> +               sbi->s_ea_inode_cache =3D NULL;
>> +       }
>>        if (sbi->s_mb_cache) {
>>                ext4_xattr_destroy_cache(sbi->s_mb_cache);
>>                sbi->s_mb_cache =3D NULL;
>> @@ -1178,7 +1182,10 @@ static int ext4_set_context(struct inode =
*inode, const void *ctx, size_t len,
>>        if (res)
>>                return res;
>> retry:
>> -       credits =3D ext4_xattr_set_credits(inode, len);
>> +       res =3D ext4_xattr_set_credits(inode, len, &credits);
>> +       if (res)
>> +               return res;
>> +
>>        handle =3D ext4_journal_start(inode, EXT4_HT_MISC, credits);
>>        if (IS_ERR(handle))
>>                return PTR_ERR(handle);
>> @@ -3445,7 +3452,8 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>>        }
>>=20
>>        /* Load the checksum driver */
>> -       if (ext4_has_feature_metadata_csum(sb)) {
>> +       if (ext4_has_feature_metadata_csum(sb) ||
>> +           ext4_has_feature_ea_inode(sb)) {
>>                sbi->s_chksum_driver =3D crypto_alloc_shash("crc32c", =
0, 0);
>>                if (IS_ERR(sbi->s_chksum_driver)) {
>>                        ext4_msg(sb, KERN_ERR, "Cannot load crc32c =
driver.");
>> @@ -3467,7 +3475,7 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>>        /* Precompute checksum seed for all metadata */
>>        if (ext4_has_feature_csum_seed(sb))
>>                sbi->s_csum_seed =3D le32_to_cpu(es->s_checksum_seed);
>> -       else if (ext4_has_metadata_csum(sb))
>> +       else if (ext4_has_metadata_csum(sb) || =
ext4_has_feature_ea_inode(sb))
>>                sbi->s_csum_seed =3D ext4_chksum(sbi, ~0, es->s_uuid,
>>                                               sizeof(es->s_uuid));
>>=20
>> @@ -3597,6 +3605,16 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>>                                 "The Hurd can't support 64-bit file =
systems");
>>                        goto failed_mount;
>>                }
>> +
>> +               /*
>> +                * ea_inode feature uses l_i_version field which is =
not
>> +                * available in HURD_COMPAT mode.
>> +                */
>> +               if (ext4_has_feature_ea_inode(sb)) {
>> +                       ext4_msg(sb, KERN_ERR,
>> +                                "ea_inode feature is not supported =
for Hurd");
>> +                       goto failed_mount;
>> +               }
>>        }
>>=20
>>        if (IS_EXT2_SB(sb)) {
>> @@ -4067,6 +4085,15 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>>                goto failed_mount_wq;
>>        }
>>=20
>> +       if (ext4_has_feature_ea_inode(sb)) {
>> +               sbi->s_ea_inode_cache =3D ext4_xattr_create_cache();
>> +               if (!sbi->s_ea_inode_cache) {
>> +                       ext4_msg(sb, KERN_ERR,
>> +                                "Failed to create an =
s_ea_inode_cache");
>> +                       goto failed_mount_wq;
>> +               }
>> +       }
>> +
>>        if ((DUMMY_ENCRYPTION_ENABLED(sbi) || =
ext4_has_feature_encrypt(sb)) &&
>>            (blocksize !=3D PAGE_SIZE)) {
>>                ext4_msg(sb, KERN_ERR,
>> @@ -4296,6 +4323,10 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>>        if (EXT4_SB(sb)->rsv_conversion_wq)
>>                destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
>> failed_mount_wq:
>> +       if (sbi->s_ea_inode_cache) {
>> +               ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
>> +               sbi->s_ea_inode_cache =3D NULL;
>> +       }
>>        if (sbi->s_mb_cache) {
>>                ext4_xattr_destroy_cache(sbi->s_mb_cache);
>>                sbi->s_mb_cache =3D NULL;
>> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
>> index 0484df8dadd1..d7e60358ec91 100644
>> --- a/fs/ext4/xattr.c
>> +++ b/fs/ext4/xattr.c
>> @@ -108,6 +108,9 @@ const struct xattr_handler *ext4_xattr_handlers[] =
=3D {
>> #define EXT4_GET_MB_CACHE(inode)       (((struct ext4_sb_info *) \
>>                                inode->i_sb->s_fs_info)->s_mb_cache)
>>=20
>> +#define EA_INODE_CACHE(inode)  (((struct ext4_sb_info *) \
>> +                               =
inode->i_sb->s_fs_info)->s_ea_inode_cache)
>> +
>> static int
>> ext4_expand_inode_array(struct ext4_xattr_inode_array =
**ea_inode_array,
>>                        struct inode *inode);
>> @@ -280,15 +283,44 @@ ext4_xattr_find_entry(struct ext4_xattr_entry =
**pentry, int name_index,
>>        return cmp ? -ENODATA : 0;
>> }
>>=20
>> +static u32
>> +ext4_xattr_inode_hash(struct ext4_sb_info *sbi, const void *buffer, =
size_t size)
>> +{
>> +       return ext4_chksum(sbi, sbi->s_csum_seed, buffer, size);
>> +}
>> +
>> +static u64 ext4_xattr_inode_get_ref(struct inode *ea_inode)
>> +{
>> +       return ((u64)ea_inode->i_ctime.tv_sec << 32) |
>> +              ((u32)ea_inode->i_version);
>> +}
>> +
>> +static void ext4_xattr_inode_set_ref(struct inode *ea_inode, u64 =
ref_count)
>> +{
>> +       ea_inode->i_ctime.tv_sec =3D (u32)(ref_count >> 32);
>> +       ea_inode->i_version =3D (u32)ref_count;
>> +}
>> +
>> +static u32 ext4_xattr_inode_get_hash(struct inode *ea_inode)
>> +{
>> +       return (u32)ea_inode->i_atime.tv_sec;
>> +}
>> +
>> +static void ext4_xattr_inode_set_hash(struct inode *ea_inode, u32 =
hash)
>> +{
>> +       ea_inode->i_atime.tv_sec =3D hash;
>> +}
>> +
>> /*
>>  * Read the EA value from an inode.
>>  */
>> static int ext4_xattr_inode_read(struct inode *ea_inode, void *buf, =
size_t size)
>> {
>>        unsigned long block =3D 0;
>> -       struct buffer_head *bh =3D NULL;
>> +       struct buffer_head *bh;
>>        int blocksize =3D ea_inode->i_sb->s_blocksize;
>>        size_t csize, copied =3D 0;
>> +       void *copy_pos =3D buf;
>>=20
>>        while (copied < size) {
>>                csize =3D (size - copied) > blocksize ? blocksize : =
size - copied;
>> @@ -298,10 +330,10 @@ static int ext4_xattr_inode_read(struct inode =
*ea_inode, void *buf, size_t size)
>>                if (!bh)
>>                        return -EFSCORRUPTED;
>>=20
>> -               memcpy(buf, bh->b_data, csize);
>> +               memcpy(copy_pos, bh->b_data, csize);
>>                brelse(bh);
>>=20
>> -               buf +=3D csize;
>> +               copy_pos +=3D csize;
>>                block +=3D 1;
>>                copied +=3D csize;
>>        }
>> @@ -317,29 +349,24 @@ static int ext4_xattr_inode_iget(struct inode =
*parent, unsigned long ea_ino,
>>        inode =3D ext4_iget(parent->i_sb, ea_ino);
>>        if (IS_ERR(inode)) {
>>                err =3D PTR_ERR(inode);
>> -               ext4_error(parent->i_sb, "error while reading EA =
inode %lu "
>> -                          "err=3D%d", ea_ino, err);
>> +               ext4_error(parent->i_sb,
>> +                          "error while reading EA inode %lu err=3D%d",=
 ea_ino,
>> +                          err);
>>                return err;
>>        }
>>=20
>>        if (is_bad_inode(inode)) {
>> -               ext4_error(parent->i_sb, "error while reading EA =
inode %lu "
>> -                          "is_bad_inode", ea_ino);
>> +               ext4_error(parent->i_sb,
>> +                          "error while reading EA inode %lu =
is_bad_inode",
>> +                          ea_ino);
>>                err =3D -EIO;
>>                goto error;
>>        }
>>=20
>> -       if (EXT4_XATTR_INODE_GET_PARENT(inode) !=3D parent->i_ino ||
>> -           inode->i_generation !=3D parent->i_generation) {
>> -               ext4_error(parent->i_sb, "Backpointer from EA inode =
%lu "
>> -                          "to parent is invalid.", ea_ino);
>> -               err =3D -EINVAL;
>> -               goto error;
>> -       }
>> -
>>        if (!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)) {
>> -               ext4_error(parent->i_sb, "EA inode %lu does not have =
"
>> -                          "EXT4_EA_INODE_FL flag set.\n", ea_ino);
>> +               ext4_error(parent->i_sb,
>> +                          "EA inode %lu does not have =
EXT4_EA_INODE_FL flag",
>> +                           ea_ino);
>>                err =3D -EINVAL;
>>                goto error;
>>        }
>> @@ -351,6 +378,20 @@ static int ext4_xattr_inode_iget(struct inode =
*parent, unsigned long ea_ino,
>>        return err;
>> }
>>=20
>> +static int
>> +ext4_xattr_inode_verify_hash(struct inode *ea_inode, void *buffer, =
size_t size)
>> +{
>> +       u32 hash;
>> +
>> +       /* Verify stored hash matches calculated hash. */
>> +       hash =3D ext4_xattr_inode_hash(EXT4_SB(ea_inode->i_sb), =
buffer, size);
>> +       if (hash !=3D ext4_xattr_inode_get_hash(ea_inode))
>> +               return -EFSCORRUPTED;
>> +       return 0;
>> +}
>> +
>> +#define EXT4_XATTR_INODE_GET_PARENT(inode) =
((__u32)(inode)->i_mtime.tv_sec)
>> +
>> /*
>>  * Read the value from the EA inode.
>>  */
>> @@ -358,17 +399,53 @@ static int
>> ext4_xattr_inode_get(struct inode *inode, unsigned long ea_ino, void =
*buffer,
>>                     size_t size)
>> {
>> +       struct mb_cache *ea_inode_cache =3D EA_INODE_CACHE(inode);
>>        struct inode *ea_inode;
>> -       int ret;
>> +       int err;
>>=20
>> -       ret =3D ext4_xattr_inode_iget(inode, ea_ino, &ea_inode);
>> -       if (ret)
>> -               return ret;
>> +       err =3D ext4_xattr_inode_iget(inode, ea_ino, &ea_inode);
>> +       if (err) {
>> +               ea_inode =3D NULL;
>> +               goto out;
>> +       }
>>=20
>> -       ret =3D ext4_xattr_inode_read(ea_inode, buffer, size);
>> -       iput(ea_inode);
>> +       if (i_size_read(ea_inode) !=3D size) {
>> +               ext4_warning_inode(ea_inode,
>> +                                  "ea_inode file size=3D%llu entry =
size=3D%zu",
>> +                                  i_size_read(ea_inode), size);
>> +               err =3D -EFSCORRUPTED;
>> +               goto out;
>> +       }
>>=20
>> -       return ret;
>> +       err =3D ext4_xattr_inode_read(ea_inode, buffer, size);
>> +       if (err)
>> +               goto out;
>> +
>> +       err =3D ext4_xattr_inode_verify_hash(ea_inode, buffer, size);
>> +       /*
>> +        * Compatibility check for old Lustre ea_inode =
implementation. Old
>> +        * version does not have hash validation, but it has a =
backpointer
>> +        * from ea_inode to the parent inode.
>> +        */
>> +       if (err =3D=3D -EFSCORRUPTED) {
>> +               if (EXT4_XATTR_INODE_GET_PARENT(ea_inode) !=3D =
inode->i_ino ||
>> +                   ea_inode->i_generation !=3D inode->i_generation) =
{
>> +                       ext4_warning_inode(ea_inode,
>> +                                          "EA inode hash validation =
failed");
>> +                       goto out;
>> +               }
>> +               /* Do not add ea_inode to the cache. */
>> +               ea_inode_cache =3D NULL;
>> +       } else if (err)
>> +               goto out;
>> +
>> +       if (ea_inode_cache)
>> +               mb_cache_entry_create(ea_inode_cache, GFP_NOFS,
>> +                                     =
ext4_xattr_inode_get_hash(ea_inode),
>> +                                     ea_inode->i_ino, true /* =
reusable */);
>> +out:
>> +       iput(ea_inode);
>> +       return err;
>> }
>>=20
>> static int
>> @@ -657,6 +734,101 @@ static void =
ext4_xattr_update_super_block(handle_t *handle,
>>        }
>> }
>>=20
>> +static inline size_t round_up_cluster(struct inode *inode, size_t =
length)
>> +{
>> +       struct super_block *sb =3D inode->i_sb;
>> +       size_t cluster_size =3D 1 << (EXT4_SB(sb)->s_cluster_bits +
>> +                                   inode->i_blkbits);
>> +       size_t mask =3D ~(cluster_size - 1);
>> +
>> +       return (length + cluster_size - 1) & mask;
>> +}
>> +
>> +static int ext4_xattr_inode_alloc_quota(struct inode *inode, size_t =
len)
>> +{
>> +       int err;
>> +
>> +       err =3D dquot_alloc_inode(inode);
>> +       if (err)
>> +               return err;
>> +       err =3D dquot_alloc_space_nodirty(inode, =
round_up_cluster(inode, len));
>> +       if (err)
>> +               dquot_free_inode(inode);
>> +       return err;
>> +}
>> +
>> +static void ext4_xattr_inode_free_quota(struct inode *inode, size_t =
len)
>> +{
>> +       dquot_free_space_nodirty(inode, round_up_cluster(inode, =
len));
>> +       dquot_free_inode(inode);
>> +}
>> +
>> +static int __ext4_xattr_set_credits(struct super_block *sb,
>> +                                   struct buffer_head *block_bh,
>> +                                   size_t value_len)
>> +{
>> +       int credits;
>> +       int blocks;
>> +
>> +       /*
>> +        * 1) Owner inode update
>> +        * 2) Ref count update on old xattr block
>> +        * 3) new xattr block
>> +        * 4) block bitmap update for new xattr block
>> +        * 5) group descriptor for new xattr block
>> +        */
>> +       credits =3D 5;
>> +
>> +       /* We are done if ea_inode feature is not enabled. */
>> +       if (!ext4_has_feature_ea_inode(sb))
>> +               return credits;
>> +
>> +       /* New ea_inode, inode map, block bitmap, group descriptor. =
*/
>> +       credits +=3D 4;
>> +
>> +       /* Data blocks. */
>> +       blocks =3D (value_len + sb->s_blocksize - 1) >> =
sb->s_blocksize_bits;
>> +
>> +       /* Indirection block or one level of extent tree. */
>> +       blocks +=3D 1;
>> +
>> +       /* Block bitmap and group descriptor updates for each block. =
*/
>> +       credits +=3D blocks * 2;
>> +
>> +       /* Blocks themselves. */
>> +       credits +=3D blocks;
>> +
>> +       /* Dereference ea_inode holding old xattr value.
>> +        * Old ea_inode, inode map, block bitmap, group descriptor.
>> +        */
>> +       credits +=3D 4;
>> +
>> +       /* Data blocks for old ea_inode. */
>> +       blocks =3D XATTR_SIZE_MAX >> sb->s_blocksize_bits;
>> +
>> +       /* Indirection block or one level of extent tree for old =
ea_inode. */
>> +       blocks +=3D 1;
>> +
>> +       /* Block bitmap and group descriptor updates for each block. =
*/
>> +       credits +=3D blocks * 2;
>> +
>> +       /* Quota updates. */
>> +       credits +=3D EXT4_MAXQUOTAS_TRANS_BLOCKS(sb);
>> +
>> +       /* We may need to clone the existing xattr block in which =
case we need
>> +        * to increment ref counts for existing ea_inodes referenced =
by it.
>> +        */
>> +       if (block_bh) {
>> +               struct ext4_xattr_entry *entry =3D BFIRST(block_bh);
>> +
>> +               for (; !IS_LAST_ENTRY(entry); entry =3D =
EXT4_XATTR_NEXT(entry))
>> +                       if (entry->e_value_inum)
>> +                               /* Ref count update on ea_inode. */
>> +                               credits +=3D 1;
>> +       }
>> +       return credits;
>> +}
>> +
>> static int ext4_xattr_ensure_credits(handle_t *handle, struct inode =
*inode,
>>                                     int credits, struct buffer_head =
*bh,
>>                                     bool dirty, bool block_csum)
>> @@ -706,12 +878,140 @@ static int ext4_xattr_ensure_credits(handle_t =
*handle, struct inode *inode,
>>        return 0;
>> }
>>=20
>> +static int ext4_xattr_inode_update_ref(handle_t *handle, struct =
inode *ea_inode,
>> +                                      int ref_change)
>> +{
>> +       struct mb_cache *ea_inode_cache =3D EA_INODE_CACHE(ea_inode);
>> +       struct ext4_iloc iloc;
>> +       s64 ref_count;
>> +       u32 hash;
>> +       int ret;
>> +
>> +       inode_lock(ea_inode);
>> +
>> +       ret =3D ext4_reserve_inode_write(handle, ea_inode, &iloc);
>> +       if (ret) {
>> +               iloc.bh =3D NULL;
>> +               goto out;
>> +       }
>> +
>> +       ref_count =3D ext4_xattr_inode_get_ref(ea_inode);
>> +       ref_count +=3D ref_change;
>> +       ext4_xattr_inode_set_ref(ea_inode, ref_count);
>> +
>> +       if (ref_change > 0) {
>> +               WARN_ONCE(ref_count <=3D 0, "EA inode %lu =
ref_count=3D%lld",
>> +                         ea_inode->i_ino, ref_count);
>> +
>> +               if (ref_count =3D=3D 1) {
>> +                       WARN_ONCE(ea_inode->i_nlink, "EA inode %lu =
i_nlink=3D%u",
>> +                                 ea_inode->i_ino, =
ea_inode->i_nlink);
>> +
>> +                       set_nlink(ea_inode, 1);
>> +                       ext4_orphan_del(handle, ea_inode);
>> +
>> +                       hash =3D ext4_xattr_inode_get_hash(ea_inode);
>> +                       mb_cache_entry_create(ea_inode_cache, =
GFP_NOFS, hash,
>> +                                             ea_inode->i_ino,
>> +                                             true /* reusable */);
>> +               }
>> +       } else {
>> +               WARN_ONCE(ref_count < 0, "EA inode %lu =
ref_count=3D%lld",
>> +                         ea_inode->i_ino, ref_count);
>> +
>> +               if (ref_count =3D=3D 0) {
>> +                       WARN_ONCE(ea_inode->i_nlink !=3D 1,
>> +                                 "EA inode %lu i_nlink=3D%u",
>> +                                 ea_inode->i_ino, =
ea_inode->i_nlink);
>> +
>> +                       clear_nlink(ea_inode);
>> +                       ext4_orphan_add(handle, ea_inode);
>> +
>> +                       hash =3D ext4_xattr_inode_get_hash(ea_inode);
>> +                       mb_cache_entry_delete(ea_inode_cache, hash,
>> +                                             ea_inode->i_ino);
>> +               }
>> +       }
>> +
>> +       ret =3D ext4_mark_iloc_dirty(handle, ea_inode, &iloc);
>> +       iloc.bh =3D NULL;
>> +       if (ret)
>> +               ext4_warning_inode(ea_inode,
>> +                                  "ext4_mark_iloc_dirty() failed =
ret=3D%d", ret);
>> +out:
>> +       brelse(iloc.bh);
>> +       inode_unlock(ea_inode);
>> +       return ret;
>> +}
>> +
>> +static int ext4_xattr_inode_inc_ref(handle_t *handle, struct inode =
*ea_inode)
>> +{
>> +       return ext4_xattr_inode_update_ref(handle, ea_inode, 1);
>> +}
>> +
>> +static int ext4_xattr_inode_dec_ref(handle_t *handle, struct inode =
*ea_inode)
>> +{
>> +       return ext4_xattr_inode_update_ref(handle, ea_inode, -1);
>> +}
>> +
>> +static int ext4_xattr_inode_inc_ref_all(handle_t *handle, struct =
inode *parent,
>> +                                       struct ext4_xattr_entry =
*first)
>> +{
>> +       struct inode *ea_inode;
>> +       struct ext4_xattr_entry *entry;
>> +       struct ext4_xattr_entry *failed_entry;
>> +       unsigned int ea_ino;
>> +       int err, saved_err;
>> +
>> +       for (entry =3D first; !IS_LAST_ENTRY(entry);
>> +            entry =3D EXT4_XATTR_NEXT(entry)) {
>> +               if (!entry->e_value_inum)
>> +                       continue;
>> +               ea_ino =3D le32_to_cpu(entry->e_value_inum);
>> +               err =3D ext4_xattr_inode_iget(parent, ea_ino, =
&ea_inode);
>> +               if (err)
>> +                       goto cleanup;
>> +               err =3D ext4_xattr_inode_inc_ref(handle, ea_inode);
>> +               if (err) {
>> +                       ext4_warning_inode(ea_inode, "inc ref error =
%d", err);
>> +                       iput(ea_inode);
>> +                       goto cleanup;
>> +               }
>> +               iput(ea_inode);
>> +       }
>> +       return 0;
>> +
>> +cleanup:
>> +       saved_err =3D err;
>> +       failed_entry =3D entry;
>> +
>> +       for (entry =3D first; entry !=3D failed_entry;
>> +            entry =3D EXT4_XATTR_NEXT(entry)) {
>> +               if (!entry->e_value_inum)
>> +                       continue;
>> +               ea_ino =3D le32_to_cpu(entry->e_value_inum);
>> +               err =3D ext4_xattr_inode_iget(parent, ea_ino, =
&ea_inode);
>> +               if (err) {
>> +                       ext4_warning(parent->i_sb,
>> +                                    "cleanup ea_ino %u iget error =
%d", ea_ino,
>> +                                    err);
>> +                       continue;
>> +               }
>> +               err =3D ext4_xattr_inode_dec_ref(handle, ea_inode);
>> +               if (err)
>> +                       ext4_warning_inode(ea_inode, "cleanup dec ref =
error %d",
>> +                                          err);
>> +               iput(ea_inode);
>> +       }
>> +       return saved_err;
>> +}
>> +
>> static void
>> -ext4_xattr_inode_remove_all(handle_t *handle, struct inode *parent,
>> -                           struct buffer_head *bh,
>> -                           struct ext4_xattr_entry *first, bool =
block_csum,
>> -                           struct ext4_xattr_inode_array =
**ea_inode_array,
>> -                           int extra_credits)
>> +ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
>> +                            struct buffer_head *bh,
>> +                            struct ext4_xattr_entry *first, bool =
block_csum,
>> +                            struct ext4_xattr_inode_array =
**ea_inode_array,
>> +                            int extra_credits, bool skip_quota)
>> {
>>        struct inode *ea_inode;
>>        struct ext4_xattr_entry *entry;
>> @@ -748,10 +1048,16 @@ ext4_xattr_inode_remove_all(handle_t *handle, =
struct inode *parent,
>>                        continue;
>>                }
>>=20
>> -               inode_lock(ea_inode);
>> -               clear_nlink(ea_inode);
>> -               ext4_orphan_add(handle, ea_inode);
>> -               inode_unlock(ea_inode);
>> +               err =3D ext4_xattr_inode_dec_ref(handle, ea_inode);
>> +               if (err) {
>> +                       ext4_warning_inode(ea_inode, "ea_inode dec =
ref err=3D%d",
>> +                                          err);
>> +                       continue;
>> +               }
>> +
>> +               if (!skip_quota)
>> +                       ext4_xattr_inode_free_quota(parent,
>> +                                             =
le32_to_cpu(entry->e_value_size));
>>=20
>>                /*
>>                 * Forget about ea_inode within the same transaction =
that
>> @@ -785,7 +1091,9 @@ ext4_xattr_inode_remove_all(handle_t *handle, =
struct inode *parent,
>>  */
>> static void
>> ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>> -                        struct buffer_head *bh)
>> +                        struct buffer_head *bh,
>> +                        struct ext4_xattr_inode_array =
**ea_inode_array,
>> +                        int extra_credits)
>> {
>>        struct mb_cache *ext4_mb_cache =3D EXT4_GET_MB_CACHE(inode);
>>        u32 hash, ref;
>> @@ -808,6 +1116,14 @@ ext4_xattr_release_block(handle_t *handle, =
struct inode *inode,
>>                mb_cache_entry_delete(ext4_mb_cache, hash, =
bh->b_blocknr);
>>                get_bh(bh);
>>                unlock_buffer(bh);
>> +
>> +               if (ext4_has_feature_ea_inode(inode->i_sb))
>> +                       ext4_xattr_inode_dec_ref_all(handle, inode, =
bh,
>> +                                                    BFIRST(bh),
>> +                                                    true /* =
block_csum */,
>> +                                                    ea_inode_array,
>> +                                                    extra_credits,
>> +                                                    true /* =
skip_quota */);
>>                ext4_free_blocks(handle, inode, bh, 0, 1,
>>                                 EXT4_FREE_BLOCKS_METADATA |
>>                                 EXT4_FREE_BLOCKS_FORGET);
>> @@ -879,8 +1195,8 @@ static int ext4_xattr_inode_write(handle_t =
*handle, struct inode *ea_inode,
>> {
>>        struct buffer_head *bh =3D NULL;
>>        unsigned long block =3D 0;
>> -       unsigned blocksize =3D ea_inode->i_sb->s_blocksize;
>> -       unsigned max_blocks =3D (bufsize + blocksize - 1) >> =
ea_inode->i_blkbits;
>> +       int blocksize =3D ea_inode->i_sb->s_blocksize;
>> +       int max_blocks =3D (bufsize + blocksize - 1) >> =
ea_inode->i_blkbits;
>>        int csize, wsize =3D 0;
>>        int ret =3D 0;
>>        int retries =3D 0;
>> @@ -948,7 +1264,7 @@ static int ext4_xattr_inode_write(handle_t =
*handle, struct inode *ea_inode,
>>  * Create an inode to store the value of a large EA.
>>  */
>> static struct inode *ext4_xattr_inode_create(handle_t *handle,
>> -                                            struct inode *inode)
>> +                                            struct inode *inode, u32 =
hash)
>> {
>>        struct inode *ea_inode =3D NULL;
>>        uid_t owner[2] =3D { i_uid_read(inode), i_gid_read(inode) };
>> @@ -966,67 +1282,115 @@ static struct inode =
*ext4_xattr_inode_create(handle_t *handle,
>>                ea_inode->i_fop =3D &ext4_file_operations;
>>                ext4_set_aops(ea_inode);
>>                ext4_xattr_inode_set_class(ea_inode);
>> -               ea_inode->i_generation =3D inode->i_generation;
>> -               EXT4_I(ea_inode)->i_flags |=3D EXT4_EA_INODE_FL;
>> -
>> -               /*
>> -                * A back-pointer from EA inode to parent inode will =
be useful
>> -                * for e2fsck.
>> -                */
>> -               EXT4_XATTR_INODE_SET_PARENT(ea_inode, inode->i_ino);
>>                unlock_new_inode(ea_inode);
>> -               err =3D ext4_inode_attach_jinode(ea_inode);
>> +               ext4_xattr_inode_set_ref(ea_inode, 1);
>> +               ext4_xattr_inode_set_hash(ea_inode, hash);
>> +               err =3D ext4_mark_inode_dirty(handle, ea_inode);
>> +               if (!err)
>> +                       err =3D ext4_inode_attach_jinode(ea_inode);
>>                if (err) {
>>                        iput(ea_inode);
>>                        return ERR_PTR(err);
>>                }
>> +
>> +               /*
>> +                * Xattr inodes are shared therefore quota charging =
is performed
>> +                * at a higher level.
>> +                */
>> +               dquot_free_inode(ea_inode);
>> +               dquot_drop(ea_inode);
>> +               inode_lock(ea_inode);
>> +               ea_inode->i_flags |=3D S_NOQUOTA;
>> +               inode_unlock(ea_inode);
>>        }
>>=20
>>        return ea_inode;
>> }
>>=20
>> -/*
>> - * Unlink the inode storing the value of the EA.
>> - */
>> -int ext4_xattr_inode_unlink(struct inode *inode, unsigned long =
ea_ino)
>> +static struct inode *
>> +ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
>> +                           size_t value_len, u32 hash)
>> {
>> -       struct inode *ea_inode =3D NULL;
>> -       int err;
>> +       struct inode *ea_inode;
>> +       struct mb_cache_entry *ce;
>> +       struct mb_cache *ea_inode_cache =3D EA_INODE_CACHE(inode);
>> +       void *ea_data;
>>=20
>> -       err =3D ext4_xattr_inode_iget(inode, ea_ino, &ea_inode);
>> -       if (err)
>> -               return err;
>> +       ce =3D mb_cache_entry_find_first(ea_inode_cache, hash);
>> +       if (!ce)
>> +               return NULL;
>>=20
>> -       clear_nlink(ea_inode);
>> -       iput(ea_inode);
>> +       ea_data =3D ext4_kvmalloc(value_len, GFP_NOFS);
>> +       if (!ea_data) {
>> +               mb_cache_entry_put(ea_inode_cache, ce);
>> +               return NULL;
>> +       }
>>=20
>> -       return 0;
>> +       while (ce) {
>> +               ea_inode =3D ext4_iget(inode->i_sb, ce->e_value);
>> +               if (!IS_ERR(ea_inode) &&
>> +                   !is_bad_inode(ea_inode) &&
>> +                   (EXT4_I(ea_inode)->i_flags & EXT4_EA_INODE_FL) &&
>> +                   i_size_read(ea_inode) =3D=3D value_len &&
>> +                   !ext4_xattr_inode_read(ea_inode, ea_data, =
value_len) &&
>> +                   !ext4_xattr_inode_verify_hash(ea_inode, ea_data,
>> +                                                 value_len) &&
>> +                   !memcmp(value, ea_data, value_len)) {
>> +                       mb_cache_entry_touch(ea_inode_cache, ce);
>> +                       mb_cache_entry_put(ea_inode_cache, ce);
>> +                       kvfree(ea_data);
>> +                       return ea_inode;
>> +               }
>> +
>> +               if (!IS_ERR(ea_inode))
>> +                       iput(ea_inode);
>> +               ce =3D mb_cache_entry_find_next(ea_inode_cache, ce);
>> +       }
>> +       kvfree(ea_data);
>> +       return NULL;
>> }
>>=20
>> /*
>>  * Add value of the EA in an inode.
>>  */
>> -static int ext4_xattr_inode_set(handle_t *handle, struct inode =
*inode,
>> -                               unsigned long *ea_ino, const void =
*value,
>> -                               size_t value_len)
>> +static int ext4_xattr_inode_lookup_create(handle_t *handle, struct =
inode *inode,
>> +                                         const void *value, size_t =
value_len,
>> +                                         struct inode **ret_inode)
>> {
>>        struct inode *ea_inode;
>> +       u32 hash;
>>        int err;
>>=20
>> +       hash =3D ext4_xattr_inode_hash(EXT4_SB(inode->i_sb), value, =
value_len);
>> +       ea_inode =3D ext4_xattr_inode_cache_find(inode, value, =
value_len, hash);
>> +       if (ea_inode) {
>> +               err =3D ext4_xattr_inode_inc_ref(handle, ea_inode);
>> +               if (err) {
>> +                       iput(ea_inode);
>> +                       return err;
>> +               }
>> +
>> +               *ret_inode =3D ea_inode;
>> +               return 0;
>> +       }
>> +
>>        /* Create an inode for the EA value */
>> -       ea_inode =3D ext4_xattr_inode_create(handle, inode);
>> +       ea_inode =3D ext4_xattr_inode_create(handle, inode, hash);
>>        if (IS_ERR(ea_inode))
>>                return PTR_ERR(ea_inode);
>>=20
>>        err =3D ext4_xattr_inode_write(handle, ea_inode, value, =
value_len);
>> -       if (err)
>> -               clear_nlink(ea_inode);
>> -       else
>> -               *ea_ino =3D ea_inode->i_ino;
>> +       if (err) {
>> +               ext4_xattr_inode_dec_ref(handle, ea_inode);
>> +               iput(ea_inode);
>> +               return err;
>> +       }
>>=20
>> -       iput(ea_inode);
>> +       mb_cache_entry_create(EA_INODE_CACHE(inode), GFP_NOFS, hash,
>> +                             ea_inode->i_ino, true /* reusable */);
>>=20
>> -       return err;
>> +       *ret_inode =3D ea_inode;
>> +       return 0;
>> }
>>=20
>> static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
>> @@ -1034,9 +1398,37 @@ static int ext4_xattr_set_entry(struct =
ext4_xattr_info *i,
>>                                handle_t *handle, struct inode *inode)
>> {
>>        struct ext4_xattr_entry *last;
>> -       size_t free, min_offs =3D s->end - s->base, name_len =3D =
strlen(i->name);
>> +       struct ext4_xattr_entry *here =3D s->here;
>> +       size_t min_offs =3D s->end - s->base, name_len =3D =
strlen(i->name);
>>        int in_inode =3D i->in_inode;
>> -       int rc;
>> +       struct inode *old_ea_inode =3D NULL;
>> +       struct inode *new_ea_inode =3D NULL;
>> +       size_t old_size, new_size;
>> +       int ret;
>> +
>> +       /* Space used by old and new values. */
>> +       old_size =3D (!s->not_found && !here->e_value_inum) ?
>> +                       =
EXT4_XATTR_SIZE(le32_to_cpu(here->e_value_size)) : 0;
>> +       new_size =3D (i->value && !in_inode) ? =
EXT4_XATTR_SIZE(i->value_len) : 0;
>> +
>> +       /*
>> +        * Optimization for the simple case when old and new values =
have the
>> +        * same padded sizes. Not applicable if external inodes are =
involved.
>> +        */
>> +       if (new_size && new_size =3D=3D old_size) {
>> +               size_t offs =3D le16_to_cpu(here->e_value_offs);
>> +               void *val =3D s->base + offs;
>> +
>> +               here->e_value_size =3D cpu_to_le32(i->value_len);
>> +               if (i->value =3D=3D EXT4_ZERO_XATTR_VALUE) {
>> +                       memset(val, 0, new_size);
>> +               } else {
>> +                       memcpy(val, i->value, i->value_len);
>> +                       /* Clear padding bytes. */
>> +                       memset(val + i->value_len, 0, new_size - =
i->value_len);
>> +               }
>> +               return 0;
>> +       }
>>=20
>>        /* Compute min_offs and last. */
>>        last =3D s->first;
>> @@ -1047,122 +1439,148 @@ static int ext4_xattr_set_entry(struct =
ext4_xattr_info *i,
>>                                min_offs =3D offs;
>>                }
>>        }
>> -       free =3D min_offs - ((void *)last - s->base) - sizeof(__u32);
>> -       if (!s->not_found) {
>> -               if (!in_inode &&
>> -                   !s->here->e_value_inum && s->here->e_value_size) =
{
>> -                       size_t size =3D =
le32_to_cpu(s->here->e_value_size);
>> -                       free +=3D EXT4_XATTR_SIZE(size);
>> -               }
>> -               free +=3D EXT4_XATTR_LEN(name_len);
>> -       }
>> +
>> +       /* Check whether we have enough space. */
>>        if (i->value) {
>> -               size_t value_len =3D EXT4_XATTR_SIZE(i->value_len);
>> +               size_t free;
>>=20
>> -               if (in_inode)
>> -                       value_len =3D 0;
>> +               free =3D min_offs - ((void *)last - s->base) - =
sizeof(__u32);
>> +               if (!s->not_found)
>> +                       free +=3D EXT4_XATTR_LEN(name_len) + =
old_size;
>>=20
>> -               if (free < EXT4_XATTR_LEN(name_len) + value_len)
>> -                       return -ENOSPC;
>> +               if (free < EXT4_XATTR_LEN(name_len) + new_size) {
>> +                       ret =3D -ENOSPC;
>> +                       goto out;
>> +               }
>>        }
>>=20
>> -       if (i->value && s->not_found) {
>> -               /* Insert the new name. */
>> -               size_t size =3D EXT4_XATTR_LEN(name_len);
>> -               size_t rest =3D (void *)last - (void *)s->here + =
sizeof(__u32);
>> -               memmove((void *)s->here + size, s->here, rest);
>> -               memset(s->here, 0, size);
>> -               s->here->e_name_index =3D i->name_index;
>> -               s->here->e_name_len =3D name_len;
>> -               memcpy(s->here->e_name, i->name, name_len);
>> -       } else {
>> -               if (!s->here->e_value_inum && s->here->e_value_size =
&&
>> -                   s->here->e_value_offs > 0) {
>> -                       void *first_val =3D s->base + min_offs;
>> -                       size_t offs =3D =
le16_to_cpu(s->here->e_value_offs);
>> -                       void *val =3D s->base + offs;
>> -                       size_t size =3D EXT4_XATTR_SIZE(
>> -                               le32_to_cpu(s->here->e_value_size));
>> -
>> -                       if (i->value && size =3D=3D =
EXT4_XATTR_SIZE(i->value_len)) {
>> -                               /* The old and the new value have the =
same
>> -                                  size. Just replace. */
>> -                               s->here->e_value_size =3D
>> -                                       cpu_to_le32(i->value_len);
>> -                               if (i->value =3D=3D =
EXT4_ZERO_XATTR_VALUE) {
>> -                                       memset(val, 0, size);
>> -                               } else {
>> -                                       /* Clear pad bytes first. */
>> -                                       memset(val + size - =
EXT4_XATTR_PAD, 0,
>> -                                              EXT4_XATTR_PAD);
>> -                                       memcpy(val, i->value, =
i->value_len);
>> -                               }
>> -                               return 0;
>> -                       }
>> +       /*
>> +        * Getting access to old and new ea inodes is subject to =
failures.
>> +        * Finish that work before doing any modifications to the =
xattr data.
>> +        */
>> +       if (!s->not_found && here->e_value_inum) {
>> +               ret =3D ext4_xattr_inode_iget(inode,
>> +                                           =
le32_to_cpu(here->e_value_inum),
>> +                                           &old_ea_inode);
>> +               if (ret) {
>> +                       old_ea_inode =3D NULL;
>> +                       goto out;
>> +               }
>> +       }
>> +       if (i->value && in_inode) {
>> +               WARN_ON_ONCE(!i->value_len);
>>=20
>> -                       /* Remove the old value. */
>> -                       memmove(first_val + size, first_val, val - =
first_val);
>> -                       memset(first_val, 0, size);
>> -                       s->here->e_value_size =3D 0;
>> -                       s->here->e_value_offs =3D 0;
>> -                       min_offs +=3D size;
>> -
>> -                       /* Adjust all value offsets. */
>> -                       last =3D s->first;
>> -                       while (!IS_LAST_ENTRY(last)) {
>> -                               size_t o =3D =
le16_to_cpu(last->e_value_offs);
>> -                               if (!last->e_value_inum &&
>> -                                   last->e_value_size && o < offs)
>> -                                       last->e_value_offs =3D
>> -                                               cpu_to_le16(o + =
size);
>> -                               last =3D EXT4_XATTR_NEXT(last);
>> -                       }
>> +               ret =3D ext4_xattr_inode_alloc_quota(inode, =
i->value_len);
>> +               if (ret)
>> +                       goto out;
>> +
>> +               ret =3D ext4_xattr_inode_lookup_create(handle, inode, =
i->value,
>> +                                                    i->value_len,
>> +                                                    &new_ea_inode);
>> +               if (ret) {
>> +                       new_ea_inode =3D NULL;
>> +                       ext4_xattr_inode_free_quota(inode, =
i->value_len);
>> +                       goto out;
>>                }
>> -               if (s->here->e_value_inum) {
>> -                       ext4_xattr_inode_unlink(inode,
>> -                                           =
le32_to_cpu(s->here->e_value_inum));
>> -                       s->here->e_value_inum =3D 0;
>> +       }
>> +
>> +       if (old_ea_inode) {
>> +               /* We are ready to release ref count on the =
old_ea_inode. */
>> +               ret =3D ext4_xattr_inode_dec_ref(handle, =
old_ea_inode);
>> +               if (ret) {
>> +                       /* Release newly required ref count on =
new_ea_inode. */
>> +                       if (new_ea_inode) {
>> +                               int err;
>> +
>> +                               err =3D =
ext4_xattr_inode_dec_ref(handle,
>> +                                                              =
new_ea_inode);
>> +                               if (err)
>> +                                       =
ext4_warning_inode(new_ea_inode,
>> +                                                 "dec ref =
new_ea_inode err=3D%d",
>> +                                                 err);
>> +                               ext4_xattr_inode_free_quota(inode,
>> +                                                           =
i->value_len);
>> +                       }
>> +                       goto out;
>>                }
>> -               if (!i->value) {
>> -                       /* Remove the old name. */
>> -                       size_t size =3D EXT4_XATTR_LEN(name_len);
>> -                       last =3D ENTRY((void *)last - size);
>> -                       memmove(s->here, (void *)s->here + size,
>> -                               (void *)last - (void *)s->here + =
sizeof(__u32));
>> -                       memset(last, 0, size);
>> +
>> +               ext4_xattr_inode_free_quota(inode,
>> +                                           =
le32_to_cpu(here->e_value_size));
>> +       }
>> +
>> +       /* No failures allowed past this point. */
>> +
>> +       if (!s->not_found && here->e_value_offs) {
>> +               /* Remove the old value. */
>> +               void *first_val =3D s->base + min_offs;
>> +               size_t offs =3D le16_to_cpu(here->e_value_offs);
>> +               void *val =3D s->base + offs;
>> +
>> +               memmove(first_val + old_size, first_val, val - =
first_val);
>> +               memset(first_val, 0, old_size);
>> +               min_offs +=3D old_size;
>> +
>> +               /* Adjust all value offsets. */
>> +               last =3D s->first;
>> +               while (!IS_LAST_ENTRY(last)) {
>> +                       size_t o =3D le16_to_cpu(last->e_value_offs);
>> +
>> +                       if (!last->e_value_inum &&
>> +                           last->e_value_size && o < offs)
>> +                               last->e_value_offs =3D cpu_to_le16(o =
+ old_size);
>> +                       last =3D EXT4_XATTR_NEXT(last);
>>                }
>>        }
>>=20
>> +       if (!i->value) {
>> +               /* Remove old name. */
>> +               size_t size =3D EXT4_XATTR_LEN(name_len);
>> +
>> +               last =3D ENTRY((void *)last - size);
>> +               memmove(here, (void *)here + size,
>> +                       (void *)last - (void *)here + sizeof(__u32));
>> +               memset(last, 0, size);
>> +       } else if (s->not_found) {
>> +               /* Insert new name. */
>> +               size_t size =3D EXT4_XATTR_LEN(name_len);
>> +               size_t rest =3D (void *)last - (void *)here + =
sizeof(__u32);
>> +
>> +               memmove((void *)here + size, here, rest);
>> +               memset(here, 0, size);
>> +               here->e_name_index =3D i->name_index;
>> +               here->e_name_len =3D name_len;
>> +               memcpy(here->e_name, i->name, name_len);
>> +       } else {
>> +               /* This is an update, reset value info. */
>> +               here->e_value_inum =3D 0;
>> +               here->e_value_offs =3D 0;
>> +               here->e_value_size =3D 0;
>> +       }
>> +
>>        if (i->value) {
>> -               /* Insert the new value. */
>> +               /* Insert new value. */
>>                if (in_inode) {
>> -                       unsigned long ea_ino =3D
>> -                               le32_to_cpu(s->here->e_value_inum);
>> -                       rc =3D ext4_xattr_inode_set(handle, inode, =
&ea_ino,
>> -                                                 i->value, =
i->value_len);
>> -                       if (rc)
>> -                               goto out;
>> -                       s->here->e_value_inum =3D =
cpu_to_le32(ea_ino);
>> -                       s->here->e_value_offs =3D 0;
>> +                       here->e_value_inum =3D =
cpu_to_le32(new_ea_inode->i_ino);
>>                } else if (i->value_len) {
>> -                       size_t size =3D =
EXT4_XATTR_SIZE(i->value_len);
>> -                       void *val =3D s->base + min_offs - size;
>> -                       s->here->e_value_offs =3D =
cpu_to_le16(min_offs - size);
>> -                       s->here->e_value_inum =3D 0;
>> +                       void *val =3D s->base + min_offs - new_size;
>> +
>> +                       here->e_value_offs =3D cpu_to_le16(min_offs - =
new_size);
>>                        if (i->value =3D=3D EXT4_ZERO_XATTR_VALUE) {
>> -                               memset(val, 0, size);
>> +                               memset(val, 0, new_size);
>>                        } else {
>> -                               /* Clear the pad bytes first. */
>> -                               memset(val + size - EXT4_XATTR_PAD, =
0,
>> -                                      EXT4_XATTR_PAD);
>>                                memcpy(val, i->value, i->value_len);
>> +                               /* Clear padding bytes. */
>> +                               memset(val + i->value_len, 0,
>> +                                      new_size - i->value_len);
>>                        }
>>                }
>> -               s->here->e_value_size =3D cpu_to_le32(i->value_len);
>> +               here->e_value_size =3D cpu_to_le32(i->value_len);
>>        }
>> -
>> +       ret =3D 0;
>> out:
>> -       return rc;
>> +       iput(old_ea_inode);
>> +       iput(new_ea_inode);
>> +       return ret;
>> }
>>=20
>> struct ext4_xattr_block_find {
>> @@ -1224,6 +1642,8 @@ ext4_xattr_block_set(handle_t *handle, struct =
inode *inode,
>>        struct mb_cache_entry *ce =3D NULL;
>>        int error =3D 0;
>>        struct mb_cache *ext4_mb_cache =3D EXT4_GET_MB_CACHE(inode);
>> +       struct inode *ea_inode =3D NULL;
>> +       size_t old_ea_inode_size =3D 0;
>>=20
>> #define header(x) ((struct ext4_xattr_header *)(x))
>>=20
>> @@ -1278,6 +1698,24 @@ ext4_xattr_block_set(handle_t *handle, struct =
inode *inode,
>>                        header(s->base)->h_refcount =3D =
cpu_to_le32(1);
>>                        s->here =3D ENTRY(s->base + offset);
>>                        s->end =3D s->base + bs->bh->b_size;
>> +
>> +                       /*
>> +                        * If existing entry points to an xattr =
inode, we need
>> +                        * to prevent ext4_xattr_set_entry() from =
decrementing
>> +                        * ref count on it because the reference =
belongs to the
>> +                        * original block. In this case, make the =
entry look
>> +                        * like it has an empty value.
>> +                        */
>> +                       if (!s->not_found && s->here->e_value_inum) {
>> +                               /*
>> +                                * Defer quota free call for previous =
inode
>> +                                * until success is guaranteed.
>> +                                */
>> +                               old_ea_inode_size =3D le32_to_cpu(
>> +                                                       =
s->here->e_value_size);
>> +                               s->here->e_value_inum =3D 0;
>> +                               s->here->e_value_size =3D 0;
>> +                       }
>>                }
>>        } else {
>>                /* Allocate a buffer where we construct the new block. =
*/
>> @@ -1299,6 +1737,24 @@ ext4_xattr_block_set(handle_t *handle, struct =
inode *inode,
>>                goto bad_block;
>>        if (error)
>>                goto cleanup;
>> +
>> +       if (i->value && s->here->e_value_inum) {
>> +               unsigned int ea_ino;
>> +
>> +               /*
>> +                * A ref count on ea_inode has been taken as part of =
the call to
>> +                * ext4_xattr_set_entry() above. We would like to =
drop this
>> +                * extra ref but we have to wait until the xattr =
block is
>> +                * initialized and has its own ref count on the =
ea_inode.
>> +                */
>> +               ea_ino =3D le32_to_cpu(s->here->e_value_inum);
>> +               error =3D ext4_xattr_inode_iget(inode, ea_ino, =
&ea_inode);
>> +               if (error) {
>> +                       ea_inode =3D NULL;
>> +                       goto cleanup;
>> +               }
>> +       }
>> +
>>        if (!IS_LAST_ENTRY(s->first))
>>                ext4_xattr_rehash(header(s->base), s->here);
>>=20
>> @@ -1409,6 +1865,22 @@ ext4_xattr_block_set(handle_t *handle, struct =
inode *inode,
>>                                                 =
EXT4_FREE_BLOCKS_METADATA);
>>                                goto cleanup;
>>                        }
>> +                       error =3D =
ext4_xattr_inode_inc_ref_all(handle, inode,
>> +                                                     =
ENTRY(header(s->base)+1));
>> +                       if (error)
>> +                               goto getblk_failed;
>> +                       if (ea_inode) {
>> +                               /* Drop the extra ref on ea_inode. */
>> +                               error =3D =
ext4_xattr_inode_dec_ref(handle,
>> +                                                                =
ea_inode);
>> +                               if (error)
>> +                                       ext4_warning_inode(ea_inode,
>> +                                                          "dec ref =
error=3D%d",
>> +                                                          error);
>> +                               iput(ea_inode);
>> +                               ea_inode =3D NULL;
>> +                       }
>> +
>>                        lock_buffer(new_bh);
>>                        error =3D =
ext4_journal_get_create_access(handle, new_bh);
>>                        if (error) {
>> @@ -1428,15 +1900,38 @@ ext4_xattr_block_set(handle_t *handle, struct =
inode *inode,
>>                }
>>        }
>>=20
>> +       if (old_ea_inode_size)
>> +               ext4_xattr_inode_free_quota(inode, =
old_ea_inode_size);
>> +
>>        /* Update the inode. */
>>        EXT4_I(inode)->i_file_acl =3D new_bh ? new_bh->b_blocknr : 0;
>>=20
>>        /* Drop the previous xattr block. */
>> -       if (bs->bh && bs->bh !=3D new_bh)
>> -               ext4_xattr_release_block(handle, inode, bs->bh);
>> +       if (bs->bh && bs->bh !=3D new_bh) {
>> +               struct ext4_xattr_inode_array *ea_inode_array =3D =
NULL;
>> +
>> +               ext4_xattr_release_block(handle, inode, bs->bh,
>> +                                        &ea_inode_array,
>> +                                        0 /* extra_credits */);
>> +               ext4_xattr_inode_array_free(ea_inode_array);
>> +       }
>>        error =3D 0;
>>=20
>> cleanup:
>> +       if (ea_inode) {
>> +               int error2;
>> +
>> +               error2 =3D ext4_xattr_inode_dec_ref(handle, =
ea_inode);
>> +               if (error2)
>> +                       ext4_warning_inode(ea_inode, "dec ref =
error=3D%d",
>> +                                          error2);
>> +
>> +               /* If there was an error, revert the quota charge. */
>> +               if (error)
>> +                       ext4_xattr_inode_free_quota(inode,
>> +                                                   =
i_size_read(ea_inode));
>> +               iput(ea_inode);
>> +       }
>>        if (ce)
>>                mb_cache_entry_put(ext4_mb_cache, ce);
>>        brelse(new_bh);
>> @@ -1561,6 +2056,22 @@ static int ext4_xattr_value_same(struct =
ext4_xattr_search *s,
>>        return !memcmp(value, i->value, i->value_len);
>> }
>>=20
>> +static struct buffer_head *ext4_xattr_get_block(struct inode *inode)
>> +{
>> +       struct buffer_head *bh;
>> +       int error;
>> +
>> +       if (!EXT4_I(inode)->i_file_acl)
>> +               return NULL;
>> +       bh =3D sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
>> +       if (!bh)
>> +               return ERR_PTR(-EIO);
>> +       error =3D ext4_xattr_check_block(inode, bh);
>> +       if (error)
>> +               return ERR_PTR(error);
>> +       return bh;
>> +}
>> +
>> /*
>>  * ext4_xattr_set_handle()
>>  *
>> @@ -1603,9 +2114,18 @@ ext4_xattr_set_handle(handle_t *handle, struct =
inode *inode, int name_index,
>>=20
>>        /* Check journal credits under write lock. */
>>        if (ext4_handle_valid(handle)) {
>> +               struct buffer_head *bh;
>>                int credits;
>>=20
>> -               credits =3D ext4_xattr_set_credits(inode, value_len);
>> +               bh =3D ext4_xattr_get_block(inode);
>> +               if (IS_ERR(bh)) {
>> +                       error =3D PTR_ERR(bh);
>> +                       goto cleanup;
>> +               }
>> +
>> +               credits =3D __ext4_xattr_set_credits(inode->i_sb, bh, =
value_len);
>> +               brelse(bh);
>> +
>>                if (!ext4_handle_has_enough_credits(handle, credits)) =
{
>>                        error =3D -ENOSPC;
>>                        goto cleanup;
>> @@ -1641,6 +2161,7 @@ ext4_xattr_set_handle(handle_t *handle, struct =
inode *inode, int name_index,
>>                if (flags & XATTR_CREATE)
>>                        goto cleanup;
>>        }
>> +
>>        if (!value) {
>>                if (!is.s.not_found)
>>                        error =3D ext4_xattr_ibody_set(handle, inode, =
&i, &is);
>> @@ -1709,34 +2230,29 @@ ext4_xattr_set_handle(handle_t *handle, =
struct inode *inode, int name_index,
>>        return error;
>> }
>>=20
>> -int ext4_xattr_set_credits(struct inode *inode, size_t value_len)
>> +int ext4_xattr_set_credits(struct inode *inode, size_t value_len, =
int *credits)
>> {
>> -       struct super_block *sb =3D inode->i_sb;
>> -       int credits;
>> -
>> -       if (!EXT4_SB(sb)->s_journal)
>> -               return 0;
>> +       struct buffer_head *bh;
>> +       int err;
>>=20
>> -       credits =3D EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
>> +       *credits =3D 0;
>>=20
>> -       /*
>> -        * In case of inline data, we may push out the data to a =
block,
>> -        * so we need to reserve credits for this eventuality
>> -        */
>> -       if (ext4_has_inline_data(inode))
>> -               credits +=3D ext4_writepage_trans_blocks(inode) + 1;
>> -
>> -       if (ext4_has_feature_ea_inode(sb)) {
>> -               int nrblocks =3D (value_len + sb->s_blocksize - 1) >>
>> -                                       sb->s_blocksize_bits;
>> +       if (!EXT4_SB(inode->i_sb)->s_journal)
>> +               return 0;
>>=20
>> -               /* For new inode */
>> -               credits +=3D EXT4_SINGLEDATA_TRANS_BLOCKS(sb) + 3;
>> +       down_read(&EXT4_I(inode)->xattr_sem);
>>=20
>> -               /* For data blocks of EA inode */
>> -               credits +=3D ext4_meta_trans_blocks(inode, nrblocks, =
0);
>> +       bh =3D ext4_xattr_get_block(inode);
>> +       if (IS_ERR(bh)) {
>> +               err =3D PTR_ERR(bh);
>> +       } else {
>> +               *credits =3D __ext4_xattr_set_credits(inode->i_sb, =
bh, value_len);
>> +               brelse(bh);
>> +               err =3D 0;
>>        }
>> -       return credits;
>> +
>> +       up_read(&EXT4_I(inode)->xattr_sem);
>> +       return err;
>> }
>>=20
>> /*
>> @@ -1761,7 +2277,10 @@ ext4_xattr_set(struct inode *inode, int =
name_index, const char *name,
>>                return error;
>>=20
>> retry:
>> -       credits =3D ext4_xattr_set_credits(inode, value_len);
>> +       error =3D ext4_xattr_set_credits(inode, value_len, &credits);
>> +       if (error)
>> +               return error;
>> +
>>        handle =3D ext4_journal_start(inode, EXT4_HT_XATTR, credits);
>>        if (IS_ERR(handle)) {
>>                error =3D PTR_ERR(handle);
>> @@ -2067,10 +2586,10 @@ int ext4_expand_extra_isize_ea(struct inode =
*inode, int new_extra_isize,
>>        return error;
>> }
>>=20
>> -
>> #define EIA_INCR 16 /* must be 2^n */
>> #define EIA_MASK (EIA_INCR - 1)
>> -/* Add the large xattr @inode into @ea_inode_array for later =
deletion.
>> +
>> +/* Add the large xattr @inode into @ea_inode_array for deferred =
iput().
>>  * If @ea_inode_array is new or full it will be grown and the old
>>  * contents copied over.
>>  */
>> @@ -2115,21 +2634,19 @@ ext4_expand_inode_array(struct =
ext4_xattr_inode_array **ea_inode_array,
>>  * ext4_xattr_delete_inode()
>>  *
>>  * Free extended attribute resources associated with this inode. =
Traverse
>> - * all entries and unlink any xattr inodes associated with this =
inode. This
>> - * is called immediately before an inode is freed. We have exclusive
>> - * access to the inode. If an orphan inode is deleted it will also =
delete any
>> - * xattr block and all xattr inodes. They are checked by =
ext4_xattr_inode_iget()
>> - * to ensure they belong to the parent inode and were not deleted =
already.
>> + * all entries and decrement reference on any xattr inodes =
associated with this
>> + * inode. This is called immediately before an inode is freed. We =
have exclusive
>> + * access to the inode. If an orphan inode is deleted it will also =
release its
>> + * references on xattr block and xattr inodes.
>>  */
>> -int
>> -ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>> -                       struct ext4_xattr_inode_array =
**ea_inode_array,
>> -                       int extra_credits)
>> +int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
>> +                           struct ext4_xattr_inode_array =
**ea_inode_array,
>> +                           int extra_credits)
>> {
>>        struct buffer_head *bh =3D NULL;
>>        struct ext4_xattr_ibody_header *header;
>> -       struct ext4_inode *raw_inode;
>>        struct ext4_iloc iloc =3D { .bh =3D NULL };
>> +       struct ext4_xattr_entry *entry;
>>        int error;
>>=20
>>        error =3D ext4_xattr_ensure_credits(handle, inode, =
extra_credits,
>> @@ -2141,66 +2658,71 @@ ext4_xattr_delete_inode(handle_t *handle, =
struct inode *inode,
>>                goto cleanup;
>>        }
>>=20
>> -       if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
>> -               goto delete_external_ea;
>> +       if (ext4_has_feature_ea_inode(inode->i_sb) &&
>> +           ext4_test_inode_state(inode, EXT4_STATE_XATTR)) {
>>=20
>> -       error =3D ext4_get_inode_loc(inode, &iloc);
>> -       if (error)
>> -               goto cleanup;
>> -
>> -       error =3D ext4_journal_get_write_access(handle, iloc.bh);
>> -       if (error)
>> -               goto cleanup;
>> +               error =3D ext4_get_inode_loc(inode, &iloc);
>> +               if (error) {
>> +                       EXT4_ERROR_INODE(inode, "inode loc (error =
%d)", error);
>> +                       goto cleanup;
>> +               }
>>=20
>> -       raw_inode =3D ext4_raw_inode(&iloc);
>> -       header =3D IHDR(inode, raw_inode);
>> -       ext4_xattr_inode_remove_all(handle, inode, iloc.bh, =
IFIRST(header),
>> -                                   false /* block_csum */, =
ea_inode_array,
>> -                                   extra_credits);
>> +               error =3D ext4_journal_get_write_access(handle, =
iloc.bh);
>> +               if (error) {
>> +                       EXT4_ERROR_INODE(inode, "write access (error =
%d)",
>> +                                        error);
>> +                       goto cleanup;
>> +               }
>>=20
>> -delete_external_ea:
>> -       if (!EXT4_I(inode)->i_file_acl) {
>> -               error =3D 0;
>> -               goto cleanup;
>> -       }
>> -       bh =3D sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
>> -       if (!bh) {
>> -               EXT4_ERROR_INODE(inode, "block %llu read error",
>> -                                EXT4_I(inode)->i_file_acl);
>> -               error =3D -EIO;
>> -               goto cleanup;
>> -       }
>> -       if (BHDR(bh)->h_magic !=3D cpu_to_le32(EXT4_XATTR_MAGIC) ||
>> -           BHDR(bh)->h_blocks !=3D cpu_to_le32(1)) {
>> -               EXT4_ERROR_INODE(inode, "bad block %llu",
>> -                                EXT4_I(inode)->i_file_acl);
>> -               error =3D -EFSCORRUPTED;
>> -               goto cleanup;
>> +               header =3D IHDR(inode, ext4_raw_inode(&iloc));
>> +               if (header->h_magic =3D=3D =
cpu_to_le32(EXT4_XATTR_MAGIC))
>> +                       ext4_xattr_inode_dec_ref_all(handle, inode, =
iloc.bh,
>> +                                                    IFIRST(header),
>> +                                                    false /* =
block_csum */,
>> +                                                    ea_inode_array,
>> +                                                    extra_credits,
>> +                                                    false /* =
skip_quota */);
>>        }
>>=20
>> -       if (ext4_has_feature_ea_inode(inode->i_sb)) {
>> -               error =3D ext4_journal_get_write_access(handle, bh);
>> -               if (error) {
>> -                       EXT4_ERROR_INODE(inode, "write access %llu",
>> +       if (EXT4_I(inode)->i_file_acl) {
>> +               bh =3D sb_bread(inode->i_sb, =
EXT4_I(inode)->i_file_acl);
>> +               if (!bh) {
>> +                       EXT4_ERROR_INODE(inode, "block %llu read =
error",
>>                                         EXT4_I(inode)->i_file_acl);
>> +                       error =3D -EIO;
>> +                       goto cleanup;
>> +               }
>> +               error =3D ext4_xattr_check_block(inode, bh);
>> +               if (error) {
>> +                       EXT4_ERROR_INODE(inode, "bad block %llu =
(error %d)",
>> +                                        EXT4_I(inode)->i_file_acl, =
error);
>>                        goto cleanup;
>>                }
>> -               ext4_xattr_inode_remove_all(handle, inode, bh,
>> -                                           BFIRST(bh),
>> -                                           true /* block_csum */,
>> -                                           ea_inode_array,
>> -                                           extra_credits);
>> -       }
>>=20
>> -       ext4_xattr_release_block(handle, inode, bh);
>> -       /* Update i_file_acl within the same transaction that =
releases block. */
>> -       EXT4_I(inode)->i_file_acl =3D 0;
>> -       error =3D ext4_mark_inode_dirty(handle, inode);
>> -       if (error) {
>> -               EXT4_ERROR_INODE(inode, "mark inode dirty (error =
%d)",
>> -                                error);
>> -               goto cleanup;
>> +               if (ext4_has_feature_ea_inode(inode->i_sb)) {
>> +                       for (entry =3D BFIRST(bh); =
!IS_LAST_ENTRY(entry);
>> +                            entry =3D EXT4_XATTR_NEXT(entry))
>> +                               if (entry->e_value_inum)
>> +                                       =
ext4_xattr_inode_free_quota(inode,
>> +                                             =
le32_to_cpu(entry->e_value_size));
>> +
>> +               }
>> +
>> +               ext4_xattr_release_block(handle, inode, bh, =
ea_inode_array,
>> +                                        extra_credits);
>> +               /*
>> +                * Update i_file_acl value in the same transaction =
that releases
>> +                * block.
>> +                */
>> +               EXT4_I(inode)->i_file_acl =3D 0;
>> +               error =3D ext4_mark_inode_dirty(handle, inode);
>> +               if (error) {
>> +                       EXT4_ERROR_INODE(inode, "mark inode dirty =
(error %d)",
>> +                                        error);
>> +                       goto cleanup;
>> +               }
>>        }
>> +       error =3D 0;
>> cleanup:
>>        brelse(iloc.bh);
>>        brelse(bh);
>> @@ -2209,17 +2731,13 @@ ext4_xattr_delete_inode(handle_t *handle, =
struct inode *inode,
>>=20
>> void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array =
*ea_inode_array)
>> {
>> -       struct inode    *ea_inode;
>> -       int             idx =3D 0;
>> +       int idx;
>>=20
>>        if (ea_inode_array =3D=3D NULL)
>>                return;
>>=20
>> -       for (; idx < ea_inode_array->count; ++idx) {
>> -               ea_inode =3D ea_inode_array->inodes[idx];
>> -               clear_nlink(ea_inode);
>> -               iput(ea_inode);
>> -       }
>> +       for (idx =3D 0; idx < ea_inode_array->count; ++idx)
>> +               iput(ea_inode_array->inodes[idx]);
>>        kfree(ea_inode_array);
>> }
>>=20
>> diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
>> index b2005a2716d9..67616cb9a059 100644
>> --- a/fs/ext4/xattr.h
>> +++ b/fs/ext4/xattr.h
>> @@ -69,19 +69,6 @@ struct ext4_xattr_entry {
>>                EXT4_I(inode)->i_extra_isize))
>> #define IFIRST(hdr) ((struct ext4_xattr_entry *)((hdr)+1))
>>=20
>> -/*
>> - * Link EA inode back to parent one using i_mtime field.
>> - * Extra integer type conversion added to ignore higher
>> - * bits in i_mtime.tv_sec which might be set by ext4_get()
>> - */
>> -#define EXT4_XATTR_INODE_SET_PARENT(inode, inum)      \
>> -do {                                                  \
>> -      (inode)->i_mtime.tv_sec =3D inum;                 \
>> -} while(0)
>> -
>> -#define EXT4_XATTR_INODE_GET_PARENT(inode)            \
>> -((__u32)(inode)->i_mtime.tv_sec)
>> -
>> /*
>>  * The minimum size of EA value when you start storing it in an =
external inode
>>  * size of block - size of header - size of 1 entry - 4 null bytes
>> @@ -165,9 +152,9 @@ extern ssize_t ext4_listxattr(struct dentry *, =
char *, size_t);
>> extern int ext4_xattr_get(struct inode *, int, const char *, void *, =
size_t);
>> extern int ext4_xattr_set(struct inode *, int, const char *, const =
void *, size_t, int);
>> extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, =
const char *, const void *, size_t, int);
>> -extern int ext4_xattr_set_credits(struct inode *inode, size_t =
value_len);
>> +extern int ext4_xattr_set_credits(struct inode *inode, size_t =
value_len,
>> +                                 int *credits);
>>=20
>> -extern int ext4_xattr_inode_unlink(struct inode *inode, unsigned =
long ea_ino);
>> extern int ext4_xattr_delete_inode(handle_t *handle, struct inode =
*inode,
>>                                   struct ext4_xattr_inode_array =
**array,
>>                                   int extra_credits);
>> diff --git a/fs/mbcache.c b/fs/mbcache.c
>> index 45a8d52dc991..d818fd236787 100644
>> --- a/fs/mbcache.c
>> +++ b/fs/mbcache.c
>> @@ -13,10 +13,11 @@
>>  * mb_cache_entry_delete()).
>>  *
>>  * Ext2 and ext4 use this cache for deduplication of extended =
attribute blocks.
>> - * They use hash of a block contents as a key and block number as a =
value.
>> - * That's why keys need not be unique (different xattr blocks may =
end up having
>> - * the same hash). However block number always uniquely identifies a =
cache
>> - * entry.
>> + * Ext4 also uses it for deduplication of xattr values stored in =
inodes.
>> + * They use hash of data as a key and provide a value that may =
represent a
>> + * block or inode number. That's why keys need not be unique (hash =
of different
>> + * data may be the same). However user provided value always =
uniquely
>> + * identifies a cache entry.
>>  *
>>  * We provide functions for creation and removal of entries, search =
by key,
>>  * and a special "delete entry with given key-value pair" operation. =
Fixed
>> --
>> 2.13.1.518.g3df882009-goog
>>=20


Cheers, Andreas






--Apple-Mail=_0078ED28-3664-4B77-BC1F-5A2BA59095B9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZSq/upIg59Q01vtYRAqjOAJ9r6ZNnTXVP6USI3dNbuTYfxDgCTwCgqMg+
tRS2UTEt59zsS0H16QgRrWk=
=o6MU
-----END PGP SIGNATURE-----

--Apple-Mail=_0078ED28-3664-4B77-BC1F-5A2BA59095B9--
