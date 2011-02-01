From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: Fix clear_buffer_dirty() call for mblk_io_submit writepages
 path
Date: Mon, 31 Jan 2011 22:21:56 -0600
Message-ID: <4D478A64.7070108@redhat.com>
References: <AANLkTi=Mzjqoo_QWNLSjhS5CKt9JdTQB6iHEWp_NPuw_@mail.gmail.com> <AANLkTikk-ngjGfWDwryPtMdQ6+660YC3ScpXTHLkKx_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab1BAEWB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Jan 2011 23:22:01 -0500
In-Reply-To: <AANLkTikk-ngjGfWDwryPtMdQ6+660YC3ScpXTHLkKx_A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/31/11 6:15 PM, Curt Wohlgemuth wrote:
> Sorry:  I forgot to mention that I tested this on 2.6.37 under KVM
> with the postgresql script specified by Ted in
> 1449032be17abb69116dbc393f67ceb8bd034f92 -- without this commit, and
> hence by default using the multiblock writepages submittal code.
> 
> Without the patch, I'd hit the corruption problem about 50-70% of the
> time.  With the patch, I executed the script > 100 times with no
> corruption seen.

Can you resubmit with a changelog that indicates it's actually a corruption
fix?  Maybe even in the summary.  That is important information to have
for the commit...

-Eric

> Curt
> 
> On Mon, Jan 31, 2011 at 12:44 PM, Curt Wohlgemuth <curtw@google.com> wrote:
>> The ext4 code path to bundle multiple pages for writeback in
>> ext4_bio_write_page() had a bug:  we should be clearing buffer head dirty
>> flags before we submit the bio, not in the completion routine.
>>
>> Also don't deference the bio in ext4_end_bio() after the bio_put() call.
>>
>> (I also added a blank line in ext4_bio_write_page(), 'cause my eyes
>> constantly confused the complex 'for' conditions from the first statement
>> in the block.)
>>
>> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
>>
>> ---
>>
>> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
>> index 6e0e99b..c3d490f 100644
>> --- a/fs/ext4/page-io.c
>> +++ b/fs/ext4/page-io.c
>> @@ -193,6 +193,7 @@ static void ext4_end_bio(struct bio *bio, int error)
>>        struct inode *inode;
>>        unsigned long flags;
>>        int i;
>> +       sector_t bi_sector = bio->bi_sector;
>>
>>        BUG_ON(!io_end);
>>        bio->bi_private = NULL;
>> @@ -210,9 +211,7 @@ static void ext4_end_bio(struct bio *bio, int error)
>>                if (error)
>>                        SetPageError(page);
>>                BUG_ON(!head);
>> -               if (head->b_size == PAGE_CACHE_SIZE)
>> -                       clear_buffer_dirty(head);
>> -               else {
>> +               if (head->b_size != PAGE_CACHE_SIZE) {
>>                        loff_t offset;
>>                        loff_t io_end_offset = io_end->offset + io_end->size;
>>
>> @@ -224,7 +223,6 @@ static void ext4_end_bio(struct bio *bio, int error)
>>                                        if (error)
>>                                                buffer_io_error(bh);
>>
>> -                                       clear_buffer_dirty(bh);
>>                                }
>>                                if (buffer_delay(bh))
>>                                        partial_write = 1;
>> @@ -260,7 +258,7 @@ static void ext4_end_bio(struct bio *bio, int error)
>>                             (unsigned long long) io_end->offset,
>>                             (long) io_end->size,
>>                             (unsigned long long)
>> -                            bio->bi_sector >> (inode->i_blkbits - 9));
>> +                            bi_sector >> (inode->i_blkbits - 9));
>>        }
>>
>>        /* Add the io_end to per-inode completed io list*/
>> @@ -383,6 +381,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
>>
>>        blocksize = 1 << inode->i_blkbits;
>>
>> +       BUG_ON(!PageLocked(page));
>>        BUG_ON(PageWriteback(page));
>>        set_page_writeback(page);
>>        ClearPageError(page);
>> @@ -400,12 +399,14 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
>>        for (bh = head = page_buffers(page), block_start = 0;
>>             bh != head || !block_start;
>>             block_start = block_end, bh = bh->b_this_page) {
>> +
>>                block_end = block_start + blocksize;
>>                if (block_start >= len) {
>>                        clear_buffer_dirty(bh);
>>                        set_buffer_uptodate(bh);
>>                        continue;
>>                }
>> +               clear_buffer_dirty(bh);
>>                ret = io_submit_add_bh(io, io_page, inode, wbc, bh);
>>                if (ret) {
>>                        /*
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

