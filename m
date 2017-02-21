From: Seongbae Son <seongbae.son@gmail.com>
Subject: [PATCH] ext4: delayed inode insertion into transaction at write()
Date: Tue, 21 Feb 2017 12:34:07 +0900
Message-ID: <20170221033407.GA1895@son-VirtualBox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 15-02-17 14:18:39, Seongbae Son wrote:
>> If a write request writes a data which is larger than 4 KB, the inode of
>> the file is updated by the write system call, and also by kworker thread.
>> This duplicated inode update causes malfunction of the EXT4 journaling
>> behavior in ordered mode.
>>
>> For example, if 6KB write(fileA) on 18KB file is performed,
>>
>> 1. The inode is updated to 20KB in the write() system call and inserted
>> into the transaction.
>> 2. After that, kworker thread allocates a new block, updates the inode to
>> 24 KB, and inserts the inode into the transaction.
>>
>> But, if fsync(fileB) is executed before kworker thread runs and system
>> crash occurs, fileA is broken. The size of fileA is 20KB, but the data
>> between 18KB and 20KB is filled with invalid one.

>Thanks for report and the patch. Do you have a testcase that reproduces the
>problem? Can you share it? With which kernel version do you see the
>corruption?  Include this information in the changelog next time please.

>I'm somewhat surprised that the file size is 20KB - ext4 uses i_disksize
>field for tracking real inode size on disk and that gets updated only when
>data is written out from flusher work (you refer to it as kworker). In
>particular ext4_da_write_end() (or generic_write_end() for that matter)
>does not update i_disksize unless the blocks underlying the data are
>already allocated (which is the case of the first 2KB written but not the
>case for the remaining 4KB). So if you can really observe increased
>i_disksize, it needs more debugging where that gets set...
>
>                                                                Honza

Thank you for replying the patch.
Yes, I can reproduce the problem. Using virtual box, I tested Linux 4.10.0-rc7
and Linux 4.10.0-rc8, and the problem occurred in both of them. I used a test
program and below is its pseudo-code.

procedure testfsync(write_volume)
   for file = file0; file <= file9; file++ do
      f[idx] = open(file, O_RDWR, O_CREATE);
      lseek(f[idx], 0, SEEK_END);
      write((f[idx], buf, write_volume);
      if file == file9
         fsync(f[idx]);
      close(f[idx]);
   end for
end procedure

The problem happened to file0,…,file8 if the blocks underlying the data are 
already allocated and system crash occurs after fsync(file9). For example, 
6KB write(file0,…,file9) on 18KB sized file or 2KB write(file0,…file9) on 26KB 
sized file is performed. The problem does not occur when a block should be 
allocated for the beginning of user data (For example, 6KB write(file0,…file9) 
on 24KB or 2KB write(file0,…file9) on 20KB). Below is the scenario to figure 
the problem out.

1.	Perform the above test program
2.	System crash (before flusher work runs)

I debugged which part changes i_disksize field in ext4_da_write_end() and it 
was ext4_update_i_disksize(). This function is performed when the blocks 
underlying the data are already allocated. The problem does not occur once 
the function is removed. But file size of file9 is not changed without the 
function when write volume is below 4KB and the blocks underlying the data are 
already allocated for the above scenario. So I keep i_disksize changed in 
ext4_da_write_end() and allow the inode not to be inserted to the transaction.
During flusher work, the inode is inserted to the transaction.

	Seongbae


>>
>> Signed-off-by: Seongbae Son <afireguy@hanyang.ac.kr>
>> ---
>>  fs/ext4/ext4.h  |  1 +
>>  fs/ext4/inode.c | 88 +++++++++++++++++++++++++++++++++++++++++++++------------
>>  2 files changed, 71 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 2163c1e..08611d9 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -392,6 +392,7 @@ struct flex_groups {
>>  #define EXT4_EXTENTS_FL                      0x00080000 /* Inode uses extents */
>>  #define EXT4_EA_INODE_FL             0x00200000 /* Inode used for large EA */
>>  #define EXT4_EOFBLOCKS_FL            0x00400000 /* Blocks allocated beyond EOF */
>> +#define      EXT4_MARK_DIRTY_FL              0x00800000 /* Inode should be marked as dirty */
>>  #define EXT4_INLINE_DATA_FL          0x10000000 /* Inode has inline data. */
>>  #define EXT4_PROJINHERIT_FL          0x20000000 /* Create with parents projid */
>>  #define EXT4_RESERVED_FL             0x80000000 /* reserved for ext4 lib */
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 88d57af..4119e47 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -1295,6 +1295,33 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
>>       return ret;
>>  }
>>
>> +/*
>> + * This function does not call mark_inode_dirty() ulike generic_write_end().
>> + * It prevents change of file size for inode from being handled by two
>> + * transactions.
>> + */
>> +int ext4_block_write_end(struct file *file, struct address_space *mapping,
>> +                loff_t pos, unsigned len, unsigned copied,
>> +                struct page *page, void *fsdata)
>> +{
>> +        struct inode *inode = mapping->host;
>> +        loff_t old_size = inode->i_size;
>> +
>> +        copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
>> +
>> +        if (pos+copied > inode->i_size) {
>> +                i_size_write(inode, pos+copied);
>> +        }
>> +
>> +        unlock_page(page);
>> +        put_page(page);
>> +
>> +        if (old_size < pos)
>> +                pagecache_isize_extended(inode, old_size, pos);
>> +
>> +        return copied;
>> +}
>> +
>>  /* For write_end() in data=journal mode */
>>  static int write_end_fn(handle_t *handle, struct buffer_head *bh)
>>  {
>> @@ -2179,6 +2206,7 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
>>  /*
>>   * mpage_process_page_bufs - submit page buffers for IO or add them to extent
>>   *
>> + * @handle - handle for journal operations
>>   * @mpd - extent of blocks for mapping
>>   * @head - the first buffer in the page
>>   * @bh - buffer we should start processing from
>> @@ -2192,12 +2220,14 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
>>   * extent to map because we cannot extend it anymore. It can also return value
>>   * < 0 in case of error during IO submission.
>>   */
>> -static int mpage_process_page_bufs(struct mpage_da_data *mpd,
>> +static int mpage_process_page_bufs(handle_t *handle,
>> +                                struct mpage_da_data *mpd,
>>                                  struct buffer_head *head,
>>                                  struct buffer_head *bh,
>>                                  ext4_lblk_t lblk)
>>  {
>>       struct inode *inode = mpd->inode;
>> +     struct ext4_inode_info *ei = EXT4_I(inode);
>>       int err;
>>       ext4_lblk_t blocks = (i_size_read(inode) + (1 << inode->i_blkbits) - 1)
>>                                                       >> inode->i_blkbits;
>> @@ -2218,6 +2248,19 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
>>               err = mpage_submit_page(mpd, head->b_page);
>>               if (err < 0)
>>                       return err;
>> +
>> +             /* If running mark_inode_dirty() was delayed by
>> +                 * write(), do it here. It is executed when
>> +                 * i_size was changed by write() and new block
>> +                 * is not allocated.
>> +                 */
>> +                if (ei->i_flags & EXT4_MARK_DIRTY_FL) {
>> +                        ext4_mark_inode_dirty(handle, inode);
>> +
>> +                     down_write(&EXT4_I(inode)->i_data_sem);
>> +                     ei->i_flags &= ~(EXT4_MARK_DIRTY_FL);
>> +                     up_write(&EXT4_I(inode)->i_data_sem);
>> +                }
>>       }
>>       return lblk < blocks;
>>  }
>> @@ -2226,6 +2269,7 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
>>   * mpage_map_buffers - update buffers corresponding to changed extent and
>>   *                  submit fully mapped pages for IO
>>   *
>> + * @handle - handle for journal operations
>>   * @mpd - description of extent to map, on return next extent to map
>>   *
>>   * Scan buffers corresponding to changed extent (we expect corresponding pages
>> @@ -2236,7 +2280,8 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
>>   * mapped, we update @map to the next extent in the last page that needs
>>   * mapping. Otherwise we submit the page for IO.
>>   */
>> -static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
>> +static int mpage_map_and_submit_buffers(handle_t *handle,
>> +                                     struct mpage_da_data *mpd)
>>  {
>>       struct pagevec pvec;
>>       int nr_pages, i;
>> @@ -2284,7 +2329,8 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
>>                                        * io_end->size as the following call
>>                                        * can submit the page for IO.
>>                                        */
>> -                                     err = mpage_process_page_bufs(mpd, head,
>> +                                     err = mpage_process_page_bufs(handle,
>> +                                                                   mpd, head,
>>                                                                     bh, lblk);
>>                                       pagevec_release(&pvec);
>>                                       if (err > 0)
>> @@ -2443,7 +2489,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>>                * Update buffer state, submit mapped pages, and get us new
>>                * extent to map
>>                */
>> -             err = mpage_map_and_submit_buffers(mpd);
>> +             err = mpage_map_and_submit_buffers(handle, mpd);
>>               if (err < 0)
>>                       goto update_disksize;
>>       } while (map->m_len);
>> @@ -2495,6 +2541,7 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
>>   * mpage_prepare_extent_to_map - find & lock contiguous range of dirty pages
>>   *                            and underlying extent to map
>>   *
>> + * @handle - handle for journal operations
>>   * @mpd - where to look for pages
>>   *
>>   * Walk dirty pages in the mapping. If they are fully mapped, submit them for
>> @@ -2509,7 +2556,8 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
>>   * unnecessary complication, it is actually inevitable in blocksize < pagesize
>>   * case as we need to track IO to all buffers underlying a page in one io_end.
>>   */
>> -static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>> +static int mpage_prepare_extent_to_map(handle_t *handle,
>> +                                    struct mpage_da_data *mpd)
>>  {
>>       struct address_space *mapping = mpd->inode->i_mapping;
>>       struct pagevec pvec;
>> @@ -2591,7 +2639,8 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>>                       lblk = ((ext4_lblk_t)page->index) <<
>>                               (PAGE_SHIFT - blkbits);
>>                       head = page_buffers(page);
>> -                     err = mpage_process_page_bufs(mpd, head, head, lblk);
>> +                     err = mpage_process_page_bufs(handle, mpd, head,
>> +                             head, lblk);
>>                       if (err <= 0)
>>                               goto out;
>>                       err = 0;
>> @@ -2752,7 +2801,7 @@ static int ext4_writepages(struct address_space *mapping,
>>               }
>>
>>               trace_ext4_da_write_pages(inode, mpd.first_page, mpd.wbc);
>> -             ret = mpage_prepare_extent_to_map(&mpd);
>> +             ret = mpage_prepare_extent_to_map(handle, &mpd);
>>               if (!ret) {
>>                       if (mpd.map.m_len)
>>                               ret = mpage_map_and_submit_extent(handle, &mpd,
>> @@ -3023,21 +3072,24 @@ static int ext4_da_write_end(struct file *file,
>>       start = pos & (PAGE_SIZE - 1);
>>       end = start + copied - 1;
>>
>> -     /*
>> -      * generic_write_end() will run mark_inode_dirty() if i_size
>> -      * changes.  So let's piggyback the i_disksize mark_inode_dirty
>> -      * into that.
>> -      */
>> +        /*
>> +         * Kworker thread will run mark_inode_dirty() if i_size changes.
>> +         * So we just change i_size and delay insert it into transaction.
>> +         */
>>       new_i_size = pos + copied;
>>       if (copied && new_i_size > EXT4_I(inode)->i_disksize) {
>>               if (ext4_has_inline_data(inode) ||
>>                   ext4_da_should_update_i_disksize(page, end)) {
>> +                     struct ext4_inode_info *ei = EXT4_I(inode);
>>                       ext4_update_i_disksize(inode, new_i_size);
>> -                     /* We need to mark inode dirty even if
>> -                      * new_i_size is less that inode->i_size
>> -                      * bu greater than i_disksize.(hint delalloc)
>> -                      */
>> -                     ext4_mark_inode_dirty(handle, inode);
>> +
>> +                     /*
>> +                         * We need to mark the inode to be inserted
>> +                         * into transaction by kworker thread later.
>> +                         */
>> +                        down_write(&EXT4_I(inode)->i_data_sem);
>> +                        ei->i_flags |= EXT4_MARK_DIRTY_FL;
>> +                        up_write(&EXT4_I(inode)->i_data_sem);
>>               }
>>       }
>>
>> @@ -3047,7 +3099,7 @@ static int ext4_da_write_end(struct file *file,
>>               ret2 = ext4_da_write_inline_data_end(inode, pos, len, copied,
>>                                                    page);
>>       else
>> -             ret2 = generic_write_end(file, mapping, pos, len, copied,
>> +             ret2 = ext4_block_write_end(file, mapping, pos, len, copied,
>>                                                       page, fsdata);
>>
>>       copied = ret2;
>> --
>> 2.7.4
>>
