From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Remove ext4 xattr mbcache to fix CPU lockup when using ceph #107301
Date: Fri, 20 Nov 2015 18:08:15 -0700
Message-ID: <DD9C7131-404D-4873-A240-349F4E34E2BD@dilger.ca>
References: <1448012628.1905.253.camel@guerby.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sage@redhat.com" <sage@redhat.com>,
	Abaakouk Mehdi <sileht@sileht.net>,
	Loic Dachary <loic@dachary.org>
To: Laurent GUERBY <laurent@guerby.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33035 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759651AbbKUBIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Nov 2015 20:08:17 -0500
Received: by pabfh17 with SMTP id fh17so135963563pab.0
        for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2015 17:08:17 -0800 (PST)
In-Reply-To: <1448012628.1905.253.camel@guerby.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 20, 2015, at 02:43, Laurent GUERBY <laurent@guerby.net> wrote:
> 
> Hi,
> 
> This is a followup on the discussions here:
> https://bugzilla.kernel.org/show_bug.cgi?id=107301

Nak. 

I'm definitely not in favor of deleting mbcache entirely, just having the
mount option to disable it in cases where it is known not to be useful,
such as Ceph or Lustre backing stores that never have shared xattrs.

In some cases mbcache can be useful, since it allows sharing xattrs
between inodes. 

I thought you would update our patch to add the mount option to disable
mbcache?

Cheers, Andreas

> The patch in comment 6 has been extensively tested on 11 ubuntu 14.04
> with kernel 3.19 machines of our ceph cluster for about 10 days of heavy
> ext4 xattr use without issue, without the patch same machines would
> freeze every 4 to 24 hours depending on core count. The patch below is a
> mechanical upgrade against the current linux tree, only the super.c
> first hunk did not apply and was fixed by hand, kernel with defconfig
> did build cleanly.
> 
> It would be great to have a working cache but it's not easy to do and
> leaving the current code isn't nice to many ext4 xattr users out there
> since their machine will at some point lockup: for us it worked for
> about one year then we got suddenly lockup hell probably after some
> limit was hit. 
> 
> The Lustre developpers have a patch to add a mount option to do the
> mbcache removal as they had the same issue.
> 
> I assume maintainers of older kernels will consider backporting this
> patch as well if it is accepted in current as the issue is present since
> the beginning.
> 
> In case my mailer corrupts it the patch is here:
> 
> http://guerby.org/ftp/remove-ext4-mbcache-current.patch
> 
> Cc: Jan Kara <jack@suse.com>
> Cc: Ted Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Signed-off-by: Laurent GUERBY <laurent@guerby.net>
> ---
> 
> --- linux/fs/ext4/ext4.h.orig    2015-11-20 09:32:30.995575644 +0100
> +++ linux/fs/ext4/ext4.h    2015-11-20 09:37:53.880915440 +0100
> @@ -1371,7 +1371,6 @@ struct ext4_sb_info {
>    struct list_head s_es_list;    /* List of inodes with reclaimable extents */
>    long s_es_nr_inode;
>    struct ext4_es_stats s_es_stats;
> -    struct mb_cache *s_mb_cache;
>    spinlock_t s_es_lock ____cacheline_aligned_in_smp;
> 
>    /* Ratelimit ext4 messages. */
> --- linux/fs/ext4/super.c.orig    2015-11-20 09:32:31.007575695 +0100
> +++ linux/fs/ext4/super.c    2015-11-20 09:39:11.373229371 +0100
> @@ -55,7 +55,6 @@
> 
> static struct ext4_lazy_init *ext4_li_info;
> static struct mutex ext4_li_mtx;
> -static int ext4_mballoc_ready;
> static struct ratelimit_state ext4_mount_msg_ratelimit;
> 
> static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
> @@ -857,10 +856,6 @@ static void ext4_put_super(struct super_
>        invalidate_bdev(sbi->journal_bdev);
>        ext4_blkdev_remove(sbi);
>    }
> -    if (sbi->s_mb_cache) {
> -        ext4_xattr_destroy_cache(sbi->s_mb_cache);
> -        sbi->s_mb_cache = NULL;
> -    }
>    if (sbi->s_mmp_tsk)
>        kthread_stop(sbi->s_mmp_tsk);
>    sb->s_fs_info = NULL;
> @@ -3754,13 +3749,6 @@ static int ext4_fill_super(struct super_
>    sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
> 
> no_journal:
> -    if (ext4_mballoc_ready) {
> -        sbi->s_mb_cache = ext4_xattr_create_cache(sb->s_id);
> -        if (!sbi->s_mb_cache) {
> -            ext4_msg(sb, KERN_ERR, "Failed to create an mb_cache");
> -            goto failed_mount_wq;
> -        }
> -    }
> 
>    if ((DUMMY_ENCRYPTION_ENABLED(sbi) || ext4_has_feature_encrypt(sb)) &&
>        (blocksize != PAGE_CACHE_SIZE)) {
> @@ -5267,8 +5255,6 @@ static int __init ext4_init_fs(void)
>    err = ext4_init_mballoc();
>    if (err)
>        goto out2;
> -    else
> -        ext4_mballoc_ready = 1;
>    err = init_inodecache();
>    if (err)
>        goto out1;
> @@ -5284,7 +5270,6 @@ out:
>    unregister_as_ext3();
>    destroy_inodecache();
> out1:
> -    ext4_mballoc_ready = 0;
>    ext4_exit_mballoc();
> out2:
>    ext4_exit_sysfs();
> --- linux/fs/ext4/xattr.h.orig    2015-11-20 09:32:31.007575695 +0100
> +++ linux/fs/ext4/xattr.h    2015-11-20 09:37:53.884915457 +0100
> @@ -124,9 +124,6 @@ extern int ext4_xattr_ibody_inline_set(h
>                       struct ext4_xattr_info *i,
>                       struct ext4_xattr_ibody_find *is);
> 
> -extern struct mb_cache *ext4_xattr_create_cache(char *name);
> -extern void ext4_xattr_destroy_cache(struct mb_cache *);
> -
> #ifdef CONFIG_EXT4_FS_SECURITY
> extern int ext4_init_security(handle_t *handle, struct inode *inode,
>                  struct inode *dir, const struct qstr *qstr);
> --- linux/fs/ext4/xattr.c.orig    2015-11-20 09:32:31.007575695 +0100
> +++ linux/fs/ext4/xattr.c    2015-11-20 09:37:53.884915457 +0100
> @@ -53,7 +53,6 @@
> #include <linux/init.h>
> #include <linux/fs.h>
> #include <linux/slab.h>
> -#include <linux/mbcache.h>
> #include <linux/quotaops.h>
> #include "ext4_jbd2.h"
> #include "ext4.h"
> @@ -80,10 +79,6 @@
> # define ea_bdebug(bh, fmt, ...)    no_printk(fmt, ##__VA_ARGS__)
> #endif
> 
> -static void ext4_xattr_cache_insert(struct mb_cache *, struct buffer_head *);
> -static struct buffer_head *ext4_xattr_cache_find(struct inode *,
> -                         struct ext4_xattr_header *,
> -                         struct mb_cache_entry **);
> static void ext4_xattr_rehash(struct ext4_xattr_header *,
>                  struct ext4_xattr_entry *);
> static int ext4_xattr_list(struct dentry *dentry, char *buffer,
> @@ -114,9 +109,6 @@ const struct xattr_handler *ext4_xattr_h
>    NULL
> };
> 
> -#define EXT4_GET_MB_CACHE(inode)    (((struct ext4_sb_info *) \
> -                inode->i_sb->s_fs_info)->s_mb_cache)
> -
> static __le32 ext4_xattr_block_csum(struct inode *inode,
>                    sector_t block_nr,
>                    struct ext4_xattr_header *hdr)
> @@ -278,7 +270,6 @@ ext4_xattr_block_get(struct inode *inode
>    struct ext4_xattr_entry *entry;
>    size_t size;
>    int error;
> -    struct mb_cache *ext4_mb_cache = EXT4_GET_MB_CACHE(inode);
> 
>    ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
>          name_index, name, buffer, (long)buffer_size);
> @@ -300,7 +291,6 @@ bad_block:
>        error = -EFSCORRUPTED;
>        goto cleanup;
>    }
> -    ext4_xattr_cache_insert(ext4_mb_cache, bh);
>    entry = BFIRST(bh);
>    error = ext4_xattr_find_entry(&entry, name_index, name, bh->b_size, 1);
>    if (error == -EFSCORRUPTED)
> @@ -425,7 +415,6 @@ ext4_xattr_block_list(struct dentry *den
>    struct inode *inode = d_inode(dentry);
>    struct buffer_head *bh = NULL;
>    int error;
> -    struct mb_cache *ext4_mb_cache = EXT4_GET_MB_CACHE(inode);
> 
>    ea_idebug(inode, "buffer=%p, buffer_size=%ld",
>          buffer, (long)buffer_size);
> @@ -447,7 +436,6 @@ ext4_xattr_block_list(struct dentry *den
>        error = -EFSCORRUPTED;
>        goto cleanup;
>    }
> -    ext4_xattr_cache_insert(ext4_mb_cache, bh);
>    error = ext4_xattr_list_entries(dentry, BFIRST(bh), buffer, buffer_size);
> 
> cleanup:
> @@ -542,11 +530,8 @@ static void
> ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>             struct buffer_head *bh)
> {
> -    struct mb_cache_entry *ce = NULL;
>    int error = 0;
> -    struct mb_cache *ext4_mb_cache = EXT4_GET_MB_CACHE(inode);
> 
> -    ce = mb_cache_entry_get(ext4_mb_cache, bh->b_bdev, bh->b_blocknr);
>    BUFFER_TRACE(bh, "get_write_access");
>    error = ext4_journal_get_write_access(handle, bh);
>    if (error)
> @@ -555,8 +540,6 @@ ext4_xattr_release_block(handle_t *handl
>    lock_buffer(bh);
>    if (BHDR(bh)->h_refcount == cpu_to_le32(1)) {
>        ea_bdebug(bh, "refcount now=0; freeing");
> -        if (ce)
> -            mb_cache_entry_free(ce);
>        get_bh(bh);
>        unlock_buffer(bh);
>        ext4_free_blocks(handle, inode, bh, 0, 1,
> @@ -564,8 +547,6 @@ ext4_xattr_release_block(handle_t *handl
>                 EXT4_FREE_BLOCKS_FORGET);
>    } else {
>        le32_add_cpu(&BHDR(bh)->h_refcount, -1);
> -        if (ce)
> -            mb_cache_entry_release(ce);
>        /*
>         * Beware of this ugliness: Releasing of xattr block references
>         * from different inodes can race and so we have to protect
> @@ -778,17 +759,13 @@ ext4_xattr_block_set(handle_t *handle, s
>    struct super_block *sb = inode->i_sb;
>    struct buffer_head *new_bh = NULL;
>    struct ext4_xattr_search *s = &bs->s;
> -    struct mb_cache_entry *ce = NULL;
>    int error = 0;
> -    struct mb_cache *ext4_mb_cache = EXT4_GET_MB_CACHE(inode);
> 
> #define header(x) ((struct ext4_xattr_header *)(x))
> 
>    if (i->value && i->value_len > sb->s_blocksize)
>        return -ENOSPC;
>    if (s->base) {
> -        ce = mb_cache_entry_get(ext4_mb_cache, bs->bh->b_bdev,
> -                    bs->bh->b_blocknr);
>        BUFFER_TRACE(bs->bh, "get_write_access");
>        error = ext4_journal_get_write_access(handle, bs->bh);
>        if (error)
> @@ -796,18 +773,12 @@ ext4_xattr_block_set(handle_t *handle, s
>        lock_buffer(bs->bh);
> 
>        if (header(s->base)->h_refcount == cpu_to_le32(1)) {
> -            if (ce) {
> -                mb_cache_entry_free(ce);
> -                ce = NULL;
> -            }
>            ea_bdebug(bs->bh, "modifying in-place");
>            error = ext4_xattr_set_entry(i, s);
>            if (!error) {
>                if (!IS_LAST_ENTRY(s->first))
>                    ext4_xattr_rehash(header(s->base),
>                              s->here);
> -                ext4_xattr_cache_insert(ext4_mb_cache,
> -                    bs->bh);
>            }
>            unlock_buffer(bs->bh);
>            if (error == -EFSCORRUPTED)
> @@ -823,10 +794,6 @@ ext4_xattr_block_set(handle_t *handle, s
>            int offset = (char *)s->here - bs->bh->b_data;
> 
>            unlock_buffer(bs->bh);
> -            if (ce) {
> -                mb_cache_entry_release(ce);
> -                ce = NULL;
> -            }
>            ea_bdebug(bs->bh, "cloning");
>            s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
>            error = -ENOMEM;
> @@ -863,37 +830,7 @@ ext4_xattr_block_set(handle_t *handle, s
> 
> inserted:
>    if (!IS_LAST_ENTRY(s->first)) {
> -        new_bh = ext4_xattr_cache_find(inode, header(s->base), &ce);
> -        if (new_bh) {
> -            /* We found an identical block in the cache. */
> -            if (new_bh == bs->bh)
> -                ea_bdebug(new_bh, "keeping");
> -            else {
> -                /* The old block is released after updating
> -                   the inode. */
> -                error = dquot_alloc_block(inode,
> -                        EXT4_C2B(EXT4_SB(sb), 1));
> -                if (error)
> -                    goto cleanup;
> -                BUFFER_TRACE(new_bh, "get_write_access");
> -                error = ext4_journal_get_write_access(handle,
> -                                      new_bh);
> -                if (error)
> -                    goto cleanup_dquot;
> -                lock_buffer(new_bh);
> -                le32_add_cpu(&BHDR(new_bh)->h_refcount, 1);
> -                ea_bdebug(new_bh, "reusing; refcount now=%d",
> -                    le32_to_cpu(BHDR(new_bh)->h_refcount));
> -                unlock_buffer(new_bh);
> -                error = ext4_handle_dirty_xattr_block(handle,
> -                                      inode,
> -                                      new_bh);
> -                if (error)
> -                    goto cleanup_dquot;
> -            }
> -            mb_cache_entry_release(ce);
> -            ce = NULL;
> -        } else if (bs->bh && s->base == bs->bh->b_data) {
> +        if (bs->bh && s->base == bs->bh->b_data) {
>            /* We were modifying this block in-place. */
>            ea_bdebug(bs->bh, "keeping this block");
>            new_bh = bs->bh;
> @@ -938,7 +875,6 @@ getblk_failed:
>            memcpy(new_bh->b_data, s->base, new_bh->b_size);
>            set_buffer_uptodate(new_bh);
>            unlock_buffer(new_bh);
> -            ext4_xattr_cache_insert(ext4_mb_cache, new_bh);
>            error = ext4_handle_dirty_xattr_block(handle,
>                                  inode, new_bh);
>            if (error)
> @@ -955,8 +891,6 @@ getblk_failed:
>    error = 0;
> 
> cleanup:
> -    if (ce)
> -        mb_cache_entry_release(ce);
>    brelse(new_bh);
>    if (!(bs->bh && s->base == bs->bh->b_data))
>        kfree(s->base);
> @@ -1516,41 +1450,9 @@ cleanup:
> void
> ext4_xattr_put_super(struct super_block *sb)
> {
> -    mb_cache_shrink(sb->s_bdev);
> +    return;
> }
> 
> -/*
> - * ext4_xattr_cache_insert()
> - *
> - * Create a new entry in the extended attribute cache, and insert
> - * it unless such an entry is already in the cache.
> - *
> - * Returns 0, or a negative error number on failure.
> - */
> -static void
> -ext4_xattr_cache_insert(struct mb_cache *ext4_mb_cache, struct buffer_head *bh)
> -{
> -    __u32 hash = le32_to_cpu(BHDR(bh)->h_hash);
> -    struct mb_cache_entry *ce;
> -    int error;
> -
> -    ce = mb_cache_entry_alloc(ext4_mb_cache, GFP_NOFS);
> -    if (!ce) {
> -        ea_bdebug(bh, "out of memory");
> -        return;
> -    }
> -    error = mb_cache_entry_insert(ce, bh->b_bdev, bh->b_blocknr, hash);
> -    if (error) {
> -        mb_cache_entry_free(ce);
> -        if (error == -EBUSY) {
> -            ea_bdebug(bh, "already in cache");
> -            error = 0;
> -        }
> -    } else {
> -        ea_bdebug(bh, "inserting [%x]", (int)hash);
> -        mb_cache_entry_release(ce);
> -    }
> -}
> 
> /*
>  * ext4_xattr_cmp()
> @@ -1592,55 +1494,6 @@ ext4_xattr_cmp(struct ext4_xattr_header
>    return 0;
> }
> 
> -/*
> - * ext4_xattr_cache_find()
> - *
> - * Find an identical extended attribute block.
> - *
> - * Returns a pointer to the block found, or NULL if such a block was
> - * not found or an error occurred.
> - */
> -static struct buffer_head *
> -ext4_xattr_cache_find(struct inode *inode, struct ext4_xattr_header *header,
> -              struct mb_cache_entry **pce)
> -{
> -    __u32 hash = le32_to_cpu(header->h_hash);
> -    struct mb_cache_entry *ce;
> -    struct mb_cache *ext4_mb_cache = EXT4_GET_MB_CACHE(inode);
> -
> -    if (!header->h_hash)
> -        return NULL;  /* never share */
> -    ea_idebug(inode, "looking for cached blocks [%x]", (int)hash);
> -again:
> -    ce = mb_cache_entry_find_first(ext4_mb_cache, inode->i_sb->s_bdev,
> -                       hash);
> -    while (ce) {
> -        struct buffer_head *bh;
> -
> -        if (IS_ERR(ce)) {
> -            if (PTR_ERR(ce) == -EAGAIN)
> -                goto again;
> -            break;
> -        }
> -        bh = sb_bread(inode->i_sb, ce->e_block);
> -        if (!bh) {
> -            EXT4_ERROR_INODE(inode, "block %lu read error",
> -                     (unsigned long) ce->e_block);
> -        } else if (le32_to_cpu(BHDR(bh)->h_refcount) >=
> -                EXT4_XATTR_REFCOUNT_MAX) {
> -            ea_idebug(inode, "block %lu refcount %d>=%d",
> -                  (unsigned long) ce->e_block,
> -                  le32_to_cpu(BHDR(bh)->h_refcount),
> -                      EXT4_XATTR_REFCOUNT_MAX);
> -        } else if (ext4_xattr_cmp(header, BHDR(bh)) == 0) {
> -            *pce = ce;
> -            return bh;
> -        }
> -        brelse(bh);
> -        ce = mb_cache_entry_find_next(ce, inode->i_sb->s_bdev, hash);
> -    }
> -    return NULL;
> -}
> 
> #define NAME_HASH_SHIFT 5
> #define VALUE_HASH_SHIFT 16
> @@ -1709,18 +1562,3 @@ static void ext4_xattr_rehash(struct ext
> }
> 
> #undef BLOCK_HASH_SHIFT
> -
> -#define    HASH_BUCKET_BITS    10
> -
> -struct mb_cache *
> -ext4_xattr_create_cache(char *name)
> -{
> -    return mb_cache_create(name, HASH_BUCKET_BITS);
> -}
> -
> -void ext4_xattr_destroy_cache(struct mb_cache *cache)
> -{
> -    if (cache)
> -        mb_cache_destroy(cache);
> -}
> -
> 
> 
