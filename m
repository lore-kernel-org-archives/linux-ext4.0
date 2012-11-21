From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 1/2] ext4: Prevent race while walking extent tree
Date: Wed, 21 Nov 2012 18:50:51 +0800
Message-ID: <CA+a=Yy5VpN+7LiBmubQue-iwhAgccWXJBL_=MA+3HrFDTYp4sg@mail.gmail.com>
References: <1353423460-12178-1-git-send-email-lczerner@redhat.com>
 <1353423460-12178-2-git-send-email-lczerner@redhat.com> <CA+a=Yy5fQvo9GSi-Smua3gGZtVtBUYHGs1v+Wtt2EZ1QHWu=hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com, tytso@mit.edu,
	dmonakhov@openvz.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47356 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2KUKvN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2012 05:51:13 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2585079lbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2012 02:51:11 -0800 (PST)
In-Reply-To: <CA+a=Yy5fQvo9GSi-Smua3gGZtVtBUYHGs1v+Wtt2EZ1QHWu=hQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 21, 2012 at 6:46 PM, Peng Tao <bergwolf@gmail.com> wrote:
> On Tue, Nov 20, 2012 at 10:57 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>> Currently ext4_ext_walk_space() only takes i_data_sem for read when
>> searching for the extent at given block with ext4_ext_find_extent().
>> Then it drops the lock and the extent tree can be changed at will.
>> However later on we're searching for the 'next' extent, but the extent
>> tree might already have changed, so the information might not be
>> accurate.
>>
>> In fact we can hit BUG_ON(end <= start) if the extent got inserted into
>> the tree after the one we found and before the block we were searching
>> for. This has been reproduced by running xfstests 225 in loop on s390x
>> architecture, but theoretically we could hit this on any other
>> architecture as well, but probably not as often.
>>
>> Moreover the extent currently in delayed allocation might be allocated
>> after we search the extent tree and before we search extent status tree
>> delayed buffers resulting in those delayed buffers being completely
>> missed, even though completely written and allocated.
>>
>> We fix all those problems in several steps:
>>
>>  1. remove unnecessary callback indirection
>>  2. rename functions
>>         ext4_ext_walk_space -> ext4_fill_fiemap_extents
>>         ext4_ext_fiemap_cb -> ext4_find_delayed_extent
>>  3. move fiemap_fill_next_extent() into ext4_fill_fiemap_extents()
>>  4. hold the i_data_sem for:
>>         ext4_ext_find_extent()
>>         ext4_ext_next_allocated_block()
>>         ext4_find_delayed_extent()
>>  5. call fiemap_fill_next_extent after releasing the i_data_sem
>>  6. move path reinitialization into the critical section.
>>
> The whole patch looks good to me. Just a few comments bellow.
>
>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>> ---
>>  fs/ext4/ext4_extents.h |   14 ------
>>  fs/ext4/extents.c      |  121 ++++++++++++++++++++++++++----------------------
>>  2 files changed, 65 insertions(+), 70 deletions(-)
>>
>> diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
>> index 603bb11..173b6c5 100644
>> --- a/fs/ext4/ext4_extents.h
>> +++ b/fs/ext4/ext4_extents.h
>> @@ -144,20 +144,6 @@ struct ext4_ext_path {
>>   */
>>
>>  /*
>> - * to be called by ext4_ext_walk_space()
>> - * negative retcode - error
>> - * positive retcode - signal for ext4_ext_walk_space(), see below
>> - * callback must return valid extent (passed or newly created)
>> - */
>> -typedef int (*ext_prepare_callback)(struct inode *, ext4_lblk_t,
>> -                                       struct ext4_ext_cache *,
>> -                                       struct ext4_extent *, void *);
>> -
>> -#define EXT_CONTINUE   0
>> -#define EXT_BREAK      1
>> -#define EXT_REPEAT     2
>> -
>> -/*
>>   * Maximum number of logical blocks in a file; ext4_extent's ee_block is
>>   * __le32.
>>   */
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index d3dd618..c7e3b58 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -109,6 +109,9 @@ static int ext4_split_extent_at(handle_t *handle,
>>                              int split_flag,
>>                              int flags);
>>
>> +static int ext4_find_delayed_extent(struct inode *inode,
>> +                                   struct ext4_ext_cache *newex);
>> +
>>  static int ext4_ext_truncate_extend_restart(handle_t *handle,
>>                                             struct inode *inode,
>>                                             int needed)
>> @@ -1959,27 +1962,35 @@ cleanup:
>>         return err;
>>  }
>>
>> -static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
>> -                              ext4_lblk_t num, ext_prepare_callback func,
>> -                              void *cbdata)
>> +static int ext4_fill_fiemap_extents(struct inode *inode,
>> +                                   ext4_lblk_t block, ext4_lblk_t num,
>> +                                   struct fiemap_extent_info *fieinfo)
>>  {
>>         struct ext4_ext_path *path = NULL;
>>         struct ext4_ext_cache cbex;
>>         struct ext4_extent *ex;
>> -       ext4_lblk_t next, start = 0, end = 0;
>> +       ext4_lblk_t next, next_del, start = 0, end = 0;
>>         ext4_lblk_t last = block + num;
>> -       int depth, exists, err = 0;
>> +       int exists, depth = 0, err = 0;
>> +       unsigned int flags = 0;
>> +       unsigned char blksize_bits = inode->i_sb->s_blocksize_bits;
>>
>> -       BUG_ON(func == NULL);
>>         BUG_ON(inode == NULL);
> The BUG_ON() doesn't make any sense. The inode pointer is already used
> in ext4_fiemap() multiple times.
>
>>
>>         while (block < last && block != EXT_MAX_BLOCKS) {
>>                 num = last - block;
>>                 /* find extent for this block */
>>                 down_read(&EXT4_I(inode)->i_data_sem);
>> +
>> +               if (path && ext_depth(inode) != depth) {
>> +                       /* depth was changed. we have to realloc path */
>> +                       kfree(path);
>> +                       path = NULL;
>> +               }
>> +
>>                 path = ext4_ext_find_extent(inode, block, path);
>> -               up_read(&EXT4_I(inode)->i_data_sem);
>>                 if (IS_ERR(path)) {
>> +                       up_read(&EXT4_I(inode)->i_data_sem);
>>                         err = PTR_ERR(path);
>>                         path = NULL;
>>                         break;
>> @@ -1987,13 +1998,16 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
>>
>>                 depth = ext_depth(inode);
>>                 if (unlikely(path[depth].p_hdr == NULL)) {
>> +                       up_read(&EXT4_I(inode)->i_data_sem);
>>                         EXT4_ERROR_INODE(inode, "path[%d].p_hdr == NULL", depth);
>>                         err = -EIO;
>>                         break;
>>                 }
>>                 ex = path[depth].p_ext;
>>                 next = ext4_ext_next_allocated_block(path);
>> +               ext4_ext_drop_refs(path);
>>
>> +               flags = 0;
>>                 exists = 0;
>>                 if (!ex) {
>>                         /* there is no extent yet, so try to allocate
>> @@ -2037,30 +2051,49 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
>>                         cbex.ec_block = le32_to_cpu(ex->ee_block);
>>                         cbex.ec_len = ext4_ext_get_actual_len(ex);
>>                         cbex.ec_start = ext4_ext_pblock(ex);
>> +                       if (ext4_ext_is_uninitialized(ex))
>> +                               flags |= FIEMAP_EXTENT_UNWRITTEN;
>>                 }
>>
>> +               next_del = ext4_find_delayed_extent(inode, &cbex);
> May be a line of comment is better here? I was wondering why
> ext4_find_delayed_extent() is called for (!exists) case as well. And
s/!exist/exist
sorry for the typo...

> suddenly I realized that it is to check for the last extent in file
> which will report to user.
>
>> +               if (next_del) {
> Need to check EXT_MAX_BLOCKS as well? It seems possible when
> cbex->ec_start is nonzero and no delayed extent found.
>
>> +                       exists = 1;
>> +                       flags |= FIEMAP_EXTENT_DELALLOC;
>> +               }
>> +               up_read(&EXT4_I(inode)->i_data_sem);
>> +
>>                 if (unlikely(cbex.ec_len == 0)) {
>>                         EXT4_ERROR_INODE(inode, "cbex.ec_len == 0");
>>                         err = -EIO;
>>                         break;
>>                 }
>> -               err = func(inode, next, &cbex, ex, cbdata);
>> -               ext4_ext_drop_refs(path);
>>
>> -               if (err < 0)
>> -                       break;
>> -
>> -               if (err == EXT_REPEAT)
>> -                       continue;
>> -               else if (err == EXT_BREAK) {
>> -                       err = 0;
>> -                       break;
>> +               /* This is possible iff next == next_del == EXT_MAX_BLOCKS */
>> +               if (next == next_del) {
>> +                       flags |= FIEMAP_EXTENT_LAST;
>> +                       if (unlikely(next_del != EXT_MAX_BLOCKS ||
>> +                                    next != EXT_MAX_BLOCKS)) {
>> +                               EXT4_ERROR_INODE(inode,
>> +                                                "next extent == %u, next "
>> +                                                "delalloc extent = %u",
>> +                                                next, next_del);
>> +                               err = -EIO;
>> +                               break;
>> +                       }
>>                 }
>>
>> -               if (ext_depth(inode) != depth) {
>> -                       /* depth was changed. we have to realloc path */
>> -                       kfree(path);
>> -                       path = NULL;
>> +               if (exists) {
>> +                       err = fiemap_fill_next_extent(fieinfo,
>> +                               (__u64)cbex.ec_block << blksize_bits,
>> +                               (__u64)cbex.ec_start << blksize_bits,
>> +                               (__u64)cbex.ec_len << blksize_bits,
>> +                               flags);
>> +                       if (err < 0)
>> +                               break;
>> +                       if (err == 1) {
>> +                               err = 0;
>> +                               break;
>> +                       }
>>                 }
>>
>>                 block = cbex.ec_block + cbex.ec_len;
>> @@ -4493,26 +4526,19 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
>>  }
>>
>>  /*
>> - * Callback function called for each extent to gather FIEMAP information.
>> + * Find delayed extent at newex->ec_start update newex accordingly and
>> + * return start of next delayed extent, or return zero if no delayed
>> + * extent found.
> + return EXT_MAX_BLOCKS when newex->ec_start is 0 and no delayed extent found.
>
>>   */
>> -static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t next,
>> -                      struct ext4_ext_cache *newex, struct ext4_extent *ex,
>> -                      void *data)
>> +static int ext4_find_delayed_extent(struct inode *inode,
>> +                                   struct ext4_ext_cache *newex)
>>  {
>>         struct extent_status es;
>> -       __u64   logical;
>> -       __u64   physical;
>> -       __u64   length;
>> -       __u32   flags = 0;
>>         ext4_lblk_t next_del;
>> -       int             ret = 0;
>> -       struct fiemap_extent_info *fieinfo = data;
>> -       unsigned char blksize_bits;
>>
>>         es.start = newex->ec_block;
>>         next_del = ext4_es_find_extent(inode, &es);
> Theoritically it is impossible, but given that this can be called when
> extent is already found, it feels safer to add a check
> if (next_del != EXT_MAX_BLOCKS && nexex->ec_start != 0)
> report errors and return 0 here, to detect finding the same range in
> both extent tree and extent status tree. What do you think? If it is
> already done somewhere in the extent status code, pls just ignore me
> :)
>
> Thanks,
> Tao
>
>>
>> -       next = min(next_del, next);
>>         if (newex->ec_start == 0) {
>>                 /*
>>                  * No extent in extent-tree contains block @newex->ec_start,
>> @@ -4520,37 +4546,19 @@ static int ext4_ext_fiemap_cb(struct inode *inode, ext4_lblk_t next,
>>                  */
>>                 if (es.len == 0)
>>                         /* A hole found. */
>> -                       return EXT_CONTINUE;
>> +                       return 0;
>>
>>                 if (es.start > newex->ec_block) {
>>                         /* A hole found. */
>>                         newex->ec_len = min(es.start - newex->ec_block,
>>                                             newex->ec_len);
>> -                       return EXT_CONTINUE;
>> +                       return 0;
>>                 }
>>
>> -               flags |= FIEMAP_EXTENT_DELALLOC;
>>                 newex->ec_len = es.start + es.len - newex->ec_block;
>>         }
>>
>> -       if (ex && ext4_ext_is_uninitialized(ex))
>> -               flags |= FIEMAP_EXTENT_UNWRITTEN;
>> -
>> -       if (next == EXT_MAX_BLOCKS)
>> -               flags |= FIEMAP_EXTENT_LAST;
>> -
>> -       blksize_bits = inode->i_sb->s_blocksize_bits;
>> -       logical = (__u64)newex->ec_block << blksize_bits;
>> -       physical = (__u64)newex->ec_start << blksize_bits;
>> -       length =   (__u64)newex->ec_len << blksize_bits;
>> -
>> -       ret = fiemap_fill_next_extent(fieinfo, logical, physical,
>> -                                       length, flags);
>> -       if (ret < 0)
>> -               return ret;
>> -       if (ret == 1)
>> -               return EXT_BREAK;
>> -       return EXT_CONTINUE;
>> +       return next_del;
>>  }
>>  /* fiemap flags we can handle specified here */
>>  #define EXT4_FIEMAP_FLAGS      (FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
>> @@ -4772,6 +4780,7 @@ out_mutex:
>>         mutex_unlock(&inode->i_mutex);
>>         return err;
>>  }
>> +
>>  int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>                 __u64 start, __u64 len)
>>  {
>> @@ -4802,8 +4811,8 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>>                  * Walk the extent tree gathering extent information.
>>                  * ext4_ext_fiemap_cb will push extents back to user.
>>                  */
>> -               error = ext4_ext_walk_space(inode, start_blk, len_blks,
>> -                                         ext4_ext_fiemap_cb, fieinfo);
>> +               error = ext4_fill_fiemap_extents(inode, start_blk,
>> +                                                len_blks, fieinfo);
>>         }
>>
>>         return error;
>> --
>> 1.7.7.6
>>



-- 
Thanks,
Tao
