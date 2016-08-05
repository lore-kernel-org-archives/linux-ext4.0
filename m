From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] mm/block: convert rw_page users to bio op use
Date: Fri, 5 Aug 2016 15:27:42 -0600
Message-ID: <086d37e1-a366-46a8-eeff-82817317d62b@kernel.dk>
References: <1470331056-796-1-git-send-email-mchristi@redhat.com>
 <20160805075756.GA28577@infradead.org>
 <10142950-64f9-4054-55c7-82f0758d2099@kernel.dk>
 <cefe120a-a0de-e459-01e6-6d913d60de2b@kernel.dk>
 <57A4D54F.4080307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	david@fromorbit.com, minchan@kernel.org, ngupta@vflare.org,
	vishal.l.verma@intel.com
To: Mike Christie <mchristi@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36064 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1949742AbcHEV1q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Aug 2016 17:27:46 -0400
Received: by mail-pf0-f175.google.com with SMTP id h186so100300880pfg.3
        for <linux-ext4@vger.kernel.org>; Fri, 05 Aug 2016 14:27:45 -0700 (PDT)
In-Reply-To: <57A4D54F.4080307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/05/2016 12:05 PM, Mike Christie wrote:
> On 08/05/2016 09:09 AM, Jens Axboe wrote:
>> On 08/05/2016 07:52 AM, Jens Axboe wrote:
>>> On 08/05/2016 01:57 AM, Christoph Hellwig wrote:
>>>>>
>>>>> The rw_page users were not converted to use bio/req ops. As a result
>>>>> bdev_write_page is not passing down REQ_OP_WRITE and the IOs will
>>>>> be sent down as reads.
>>>>
>>>> Can we just get rid of REQ_OP_WRITE enum for the ->rw_page interface
>>>> and pass a 'bool write'?  If not I'd prefer to avoid using op_is_write
>>>> as much as possible - it's a confusing interface if we really want
>>>> to do a switch on read vs write vs invalid.
>>>
>>> That's a really good point, especially since the op_flags was dropped as
>>> well. I'll cook that up.
>>
>> How about something like this? We don't bleed into the non-core bits
>> anymore, so we can move those back under CONFIG_BLOCK too.
>>
>> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
>> index 3439b28cce8b..0c76d4016eeb 100644
>> --- a/drivers/block/brd.c
>> +++ b/drivers/block/brd.c
>> @@ -300,20 +300,20 @@ static void copy_from_brd(void *dst, struct brd_device *brd,
>>   * Process a single bvec of a bio.
>>   */
>>  static int brd_do_bvec(struct brd_device *brd, struct page *page,
>> -            unsigned int len, unsigned int off, int op,
>> +            unsigned int len, unsigned int off, bool is_write,
>>              sector_t sector)
>>  {
>>      void *mem;
>>      int err = 0;
>>
>> -    if (op_is_write(op)) {
>> +    if (is_write) {
>>          err = copy_to_brd_setup(brd, sector, len);
>>          if (err)
>>              goto out;
>>      }
>>
>>      mem = kmap_atomic(page);
>> -    if (!op_is_write(op)) {
>> +    if (!is_write) {
>>          copy_from_brd(mem + off, brd, sector, len);
>>          flush_dcache_page(page);
>>      } else {
>> @@ -350,8 +350,8 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
>>          unsigned int len = bvec.bv_len;
>>          int err;
>>
>> -        err = brd_do_bvec(brd, bvec.bv_page, len,
>> -                    bvec.bv_offset, bio_op(bio), sector);
>> +        err = brd_do_bvec(brd, bvec.bv_page, len, bvec.bv_offset,
>> +                    op_is_write(bio_op(bio)), sector);
>>          if (err)
>>              goto io_error;
>>          sector += len >> SECTOR_SHIFT;
>> @@ -366,11 +366,11 @@ io_error:
>>  }
>>
>>  static int brd_rw_page(struct block_device *bdev, sector_t sector,
>> -               struct page *page, int op)
>> +               struct page *page, bool is_write)
>>  {
>>      struct brd_device *brd = bdev->bd_disk->private_data;
>> -    int err = brd_do_bvec(brd, page, PAGE_SIZE, 0, op, sector);
>> -    page_endio(page, op, err);
>> +    int err = brd_do_bvec(brd, page, PAGE_SIZE, 0, is_write, sector);
>> +    page_endio(page, is_write, err);
>>      return err;
>>  }
>>
>> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
>> index ca29649c4b08..04365b17ee67 100644
>> --- a/drivers/block/zram/zram_drv.c
>> +++ b/drivers/block/zram/zram_drv.c
>> @@ -843,15 +843,16 @@ static void zram_bio_discard(struct zram *zram, u32 index,
>>  }
>>
>>  static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
>> -            int offset, int op)
>> +            int offset, bool is_write)
>>  {
>>      unsigned long start_time = jiffies;
>> +    int rw_acct = is_write ? REQ_OP_WRITE : REQ_OP_READ;
>>      int ret;
>>
>> -    generic_start_io_acct(op, bvec->bv_len >> SECTOR_SHIFT,
>> +    generic_start_io_acct(rw_acct, bvec->bv_len >> SECTOR_SHIFT,
>>              &zram->disk->part0);
>>
>> -    if (!op_is_write(op)) {
>> +    if (!is_write) {
>>          atomic64_inc(&zram->stats.num_reads);
>>          ret = zram_bvec_read(zram, bvec, index, offset);
>>      } else {
>> @@ -859,10 +860,10 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
>>          ret = zram_bvec_write(zram, bvec, index, offset);
>>      }
>>
>> -    generic_end_io_acct(op, &zram->disk->part0, start_time);
>> +    generic_end_io_acct(rw_acct, &zram->disk->part0, start_time);
>>
>>      if (unlikely(ret)) {
>> -        if (!op_is_write(op))
>> +        if (!is_write)
>>              atomic64_inc(&zram->stats.failed_reads);
>>          else
>>              atomic64_inc(&zram->stats.failed_writes);
>> @@ -903,17 +904,17 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
>>              bv.bv_offset = bvec.bv_offset;
>>
>>              if (zram_bvec_rw(zram, &bv, index, offset,
>> -                     bio_op(bio)) < 0)
>> +                     op_is_write(bio_op(bio))) < 0)
>>                  goto out;
>>
>>              bv.bv_len = bvec.bv_len - max_transfer_size;
>>              bv.bv_offset += max_transfer_size;
>>              if (zram_bvec_rw(zram, &bv, index + 1, 0,
>> -                     bio_op(bio)) < 0)
>> +                     op_is_write(bio_op(bio))) < 0)
>>                  goto out;
>>          } else
>>              if (zram_bvec_rw(zram, &bvec, index, offset,
>> -                     bio_op(bio)) < 0)
>> +                     op_is_write(bio_op(bio))) < 0)
>>                  goto out;
>>
>>          update_position(&index, &offset, &bvec);
>> @@ -970,7 +971,7 @@ static void zram_slot_free_notify(struct block_device *bdev,
>>  }
>>
>>  static int zram_rw_page(struct block_device *bdev, sector_t sector,
>> -               struct page *page, int op)
>> +               struct page *page, bool is_write)
>>  {
>>      int offset, err = -EIO;
>>      u32 index;
>> @@ -994,7 +995,7 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
>>      bv.bv_len = PAGE_SIZE;
>>      bv.bv_offset = 0;
>>
>> -    err = zram_bvec_rw(zram, &bv, index, offset, op);
>> +    err = zram_bvec_rw(zram, &bv, index, offset, is_write);
>>  put_zram:
>>      zram_meta_put(zram);
>>  out:
>> @@ -1007,7 +1008,7 @@ out:
>>       * (e.g., SetPageError, set_page_dirty and extra works).
>>       */
>>      if (err == 0)
>> -        page_endio(page, op, 0);
>> +        page_endio(page, is_write, 0);
>>      return err;
>>  }
>>
>> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
>> index 7cf3bdfaf809..88e91666f145 100644
>> --- a/drivers/nvdimm/btt.c
>> +++ b/drivers/nvdimm/btt.c
>> @@ -1133,11 +1133,11 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
>>
>>  static int btt_do_bvec(struct btt *btt, struct bio_integrity_payload *bip,
>>              struct page *page, unsigned int len, unsigned int off,
>> -            int op, sector_t sector)
>> +            bool is_write, sector_t sector)
>>  {
>>      int ret;
>>
>> -    if (!op_is_write(op)) {
>> +    if (!is_write) {
>>          ret = btt_read_pg(btt, bip, page, off, sector, len);
>>          flush_dcache_page(page);
>>      } else {
>> @@ -1180,7 +1180,7 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
>>          BUG_ON(len % btt->sector_size);
>>
>>          err = btt_do_bvec(btt, bip, bvec.bv_page, len, bvec.bv_offset,
>> -                  bio_op(bio), iter.bi_sector);
>> +                  op_is_write(bio_op(bio)), iter.bi_sector);
>>          if (err) {
>>              dev_info(&btt->nd_btt->dev,
>>                      "io error in %s sector %lld, len %d,\n",
>> @@ -1200,12 +1200,12 @@ out:
>>  }
>>
>>  static int btt_rw_page(struct block_device *bdev, sector_t sector,
>> -        struct page *page, int op)
>> +        struct page *page, bool is_write)
>>  {
>>      struct btt *btt = bdev->bd_disk->private_data;
>>
>> -    btt_do_bvec(btt, NULL, page, PAGE_SIZE, 0, op, sector);
>> -    page_endio(page, op, 0);
>> +    btt_do_bvec(btt, NULL, page, PAGE_SIZE, 0, is_write, sector);
>> +    page_endio(page, is_write, 0);
>>      return 0;
>>  }
>>
>> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
>> index d64d92481c1d..20bae50c231d 100644
>> --- a/drivers/nvdimm/pmem.c
>> +++ b/drivers/nvdimm/pmem.c
>> @@ -67,7 +67,7 @@ static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
>>  }
>>
>>  static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
>> -            unsigned int len, unsigned int off, int op,
>> +            unsigned int len, unsigned int off, bool is_write,
>>              sector_t sector)
>>  {
>>      int rc = 0;
>> @@ -79,7 +79,7 @@ static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
>>      if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
>>          bad_pmem = true;
>>
>> -    if (!op_is_write(op)) {
>> +    if (!is_write) {
>>          if (unlikely(bad_pmem))
>>              rc = -EIO;
>>          else {
>> @@ -134,7 +134,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
>>      do_acct = nd_iostat_start(bio, &start);
>>      bio_for_each_segment(bvec, bio, iter) {
>>          rc = pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len,
>> -                bvec.bv_offset, bio_op(bio),
>> +                bvec.bv_offset, op_is_write(bio_op(bio)),
>>                  iter.bi_sector);
>>          if (rc) {
>>              bio->bi_error = rc;
>> @@ -152,12 +152,12 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
>>  }
>>
>>  static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>> -               struct page *page, int op)
>> +               struct page *page, bool is_write)
>>  {
>>      struct pmem_device *pmem = bdev->bd_queue->queuedata;
>>      int rc;
>>
>> -    rc = pmem_do_bvec(pmem, page, PAGE_SIZE, 0, op, sector);
>> +    rc = pmem_do_bvec(pmem, page, PAGE_SIZE, 0, is_write, sector);
>>
>>      /*
>>       * The ->rw_page interface is subtle and tricky.  The core
>> @@ -166,7 +166,7 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>>       * caused by double completion.
>>       */
>>      if (rc == 0)
>> -        page_endio(page, op, 0);
>> +        page_endio(page, is_write, 0);
>>
>>      return rc;
>>  }
>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>> index d402899ba135..c3cdde87cc8c 100644
>> --- a/fs/block_dev.c
>> +++ b/fs/block_dev.c
>> @@ -416,8 +416,7 @@ int bdev_read_page(struct block_device *bdev, sector_t sector,
>>      result = blk_queue_enter(bdev->bd_queue, false);
>>      if (result)
>>          return result;
>> -    result = ops->rw_page(bdev, sector + get_start_sect(bdev), page,
>> -                  REQ_OP_READ);
>> +    result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, false);
>>      blk_queue_exit(bdev->bd_queue);
>>      return result;
>>  }
>> @@ -455,8 +454,7 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
>>          return result;
>>
>>      set_page_writeback(page);
>> -    result = ops->rw_page(bdev, sector + get_start_sect(bdev), page,
>> -                  REQ_OP_WRITE);
>> +    result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, true);
>>      if (result)
>>          end_page_writeback(page);
>>      else
>> diff --git a/fs/mpage.c b/fs/mpage.c
>> index 7a09c55b4bd0..d2413af0823a 100644
>> --- a/fs/mpage.c
>> +++ b/fs/mpage.c
>> @@ -50,7 +50,7 @@ static void mpage_end_io(struct bio *bio)
>>
>>      bio_for_each_segment_all(bv, bio, i) {
>>          struct page *page = bv->bv_page;
>> -        page_endio(page, bio_op(bio), bio->bi_error);
>> +        page_endio(page, op_is_write(bio_op(bio)), bio->bi_error);
>>      }
>>
>>      bio_put(bio);
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 14b28ff2caf8..f254eb264924 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -18,17 +18,6 @@ struct cgroup_subsys_state;
>>  typedef void (bio_end_io_t) (struct bio *);
>>  typedef void (bio_destructor_t) (struct bio *);
>>
>> -enum req_op {
>> -    REQ_OP_READ,
>> -    REQ_OP_WRITE,
>> -    REQ_OP_DISCARD,        /* request to discard sectors */
>> -    REQ_OP_SECURE_ERASE,    /* request to securely erase sectors */
>> -    REQ_OP_WRITE_SAME,    /* write same block many times */
>> -    REQ_OP_FLUSH,        /* request for cache flush */
>> -};
>> -
>> -#define REQ_OP_BITS 3
>> -
>>  #ifdef CONFIG_BLOCK
>>  /*
>>   * main unit of I/O for the block layer and lower layers (ie drivers and
>> @@ -239,6 +228,17 @@ enum rq_flag_bits {
>>  #define REQ_HASHED        (1ULL << __REQ_HASHED)
>>  #define REQ_MQ_INFLIGHT        (1ULL << __REQ_MQ_INFLIGHT)
>>
>> +enum req_op {
>> +    REQ_OP_READ,
>> +    REQ_OP_WRITE,
>> +    REQ_OP_DISCARD,        /* request to discard sectors */
>> +    REQ_OP_SECURE_ERASE,    /* request to securely erase sectors */
>> +    REQ_OP_WRITE_SAME,    /* write same block many times */
>> +    REQ_OP_FLUSH,        /* request for cache flush */
>> +};
>> +
>> +#define REQ_OP_BITS 3
>> +
>>  typedef unsigned int blk_qc_t;
>>  #define BLK_QC_T_NONE    -1U
>>  #define BLK_QC_T_SHIFT    16
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index ccd68c0d01de..2c210b6a7bcf 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -1672,7 +1672,7 @@ struct blk_dax_ctl {
>>  struct block_device_operations {
>>      int (*open) (struct block_device *, fmode_t);
>>      void (*release) (struct gendisk *, fmode_t);
>> -    int (*rw_page)(struct block_device *, sector_t, struct page *, int op);
>> +    int (*rw_page)(struct block_device *, sector_t, struct page *, bool);
>>      int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
>>      int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
>>      long (*direct_access)(struct block_device *, sector_t, void **, pfn_t *,
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 498255e6914e..f3f0b4c8e8ac 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -2480,13 +2480,12 @@ extern void init_special_inode(struct inode *, umode_t, dev_t);
>>  extern void make_bad_inode(struct inode *);
>>  extern bool is_bad_inode(struct inode *);
>>
>> +#ifdef CONFIG_BLOCK
>>  static inline bool op_is_write(unsigned int op)
>>  {
>>      return op == REQ_OP_READ ? false : true;
>>  }
>>
>> -#ifdef CONFIG_BLOCK
>> -
>>  /*
>>   * return data direction, READ or WRITE
>>   */
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index 45786374abbd..66a1260b33de 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -510,7 +510,7 @@ static inline void wait_on_page_writeback(struct page *page)
>>  extern void end_page_writeback(struct page *page);
>>  void wait_for_stable_page(struct page *page);
>>
>> -void page_endio(struct page *page, int op, int err);
>> +void page_endio(struct page *page, bool is_write, int err);
>>
>>  /*
>>   * Add an arbitrary waiter to a page's wait queue
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index daef091d4c50..8a287dfc5372 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -887,9 +887,9 @@ EXPORT_SYMBOL(end_page_writeback);
>>   * After completing I/O on a page, call this routine to update the page
>>   * flags appropriately
>>   */
>> -void page_endio(struct page *page, int op, int err)
>> +void page_endio(struct page *page, bool is_write, int err)
>>  {
>> -    if (!op_is_write(op)) {
>> +    if (!is_write) {
>>          if (!err) {
>>              SetPageUptodate(page);
>>          } else {
>>
>
> Looks ok to me. Also tested all the patches in the linus2 branch
> and verified it fixed the rw_page related hang for me.
>
> Reviewed-by: Mike Christie <mchristi@redhat.com>

Great, thanks Mike. I'll add that, I'm going to rebase it with the 
bio_opf branch anyway.

-- 
Jens Axboe

