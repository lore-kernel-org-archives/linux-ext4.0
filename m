Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B128C30F927;
	Thu,  8 Oct 2026 12:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791462182; cv=none; b=hkohf8pWqdpfEv7Eb3K5U8LyCxTLfOH4Mbw4u/n8LRS/XK8nHPwzYAaVuabHZ0voJ+hDANVrS7JhlhNKMYvNcQ9hK2IxUMKvOKVicoZpawU31h1CRP2fAJ0bhncxo1BAKJ9Q9DiohnH+p+ECoJNMFeZ+WgeqiRK/N9Ek4ufWEqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791462182; c=relaxed/simple;
	bh=xCDvQ//2b1BtuXutYOzhAaOKYSvY9mcOTgVMBo2ZLxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i6Kma6pR3UF/zvkBYxK6SmM+FFkEHGzV1av6UaDlqoWRrOUofroLKnODv0UuJvX8TSOre+h6ExLhlSFCjV4AKor0qr27I3FWGxG5s3poPd7IB3t9eK0SCERQOVCrlAv44Ucx8xv1w//G2GnzITuvN4G4uPpCSdsBfEGC1k/CEgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j0pyj4q5HzKHMsq;
	Thu,  8 Oct 2026 20:22:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 17C2D40993;
	Thu,  8 Oct 2026 20:22:56 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgC31Ccei8dqFEvpDA--.29777S3;
	Thu, 08 Oct 2026 20:22:55 +0800 (CST)
Message-ID: <a02e884b-f280-486e-9a1c-298a778dc9f5@huaweicloud.com>
Date: Thu, 8 Oct 2026 20:22:54 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 22/31] ext4: submit and wait for pending disksize-grow
 I/O on writeback
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zhang Yi <yizhang089@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 chengzhihao1@huawei.com, yangerkun@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-23-yi.zhang@huaweicloud.com>
 <asNnFY8N3NJwucWe@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <08dfc1dc-adc6-41ed-aaa5-7af7836f71c7@gmail.com>
 <asdfG0W0iy0QytRn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <asdfG0W0iy0QytRn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgC31Ccei8dqFEvpDA--.29777S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtr45Zw18AFyrKFWxWF1fXrb_yoWxuFy8pr
	W5KF15CF4DXry7Cr4Sqw12qrn3t34xtr47Xry3Wa1UZr90yFy7KFW0gFy3uFy8Crs3C3y2
	vF4j9ryxCr1YyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	bAw3UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/8/2026 5:15 PM, Ojaswin Mujoo wrote:
> On Thu, Oct 08, 2026 at 04:53:24PM +0800, Zhang Yi wrote:
>> On 10/5/2026 5:00 PM, Ojaswin Mujoo wrote:
>>> On Thu, Sep 03, 2026 at 08:35:34PM +0800, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> When the current writeback pass begins beyond the disksize-grow-pending
>>>> zeroed EOF block, the ioend worker would otherwise have to wait for the
>>>> pending EOF block to complete before it can advance i_disksize.
>>>> Otherwise the old EOF block could be exposed as stale data once
>>>> i_disksize advances past it.
>>>>
>>>> Therefore, introduce the ioend mechanism for the pending range, tag
>>>> ioends that cover the pending zeroed EOF block which straddles
>>>> i_disksize with EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO in
>>>> ext4_iomap_writeback_submit(), and clear the bit and wake up all waiters
>>>> in ext4_iomap_end_bio() when such an ioend completes.
>>>>
>>>> Clearing EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO does not depend on whether
>>>> the disksize grow I/O succeeds. That is, even if the I/O fails, we still
>>>> allow subsequent writes in the range to update i_disksize. This is
>>>> consistent with the previous behavior, and we rely on data_err=abort to
>>>> prevent metadata updates when data write failures occur.
>>>>
>>>> In order to avoid the ioend that passes the pending range waiting for a
>>>> long time, proactively submit the pending range first in
>>>> ext4_iomap_writepages() so it completes in parallel with the rest of the
>>>> writeback.
>>>>
>>>> Note that the handling of discarding the zeroed EOF folio will be
>>>> processed later, otherwise the bit will be set forever.
>>>> EXT4_STATE_DISKSIZE_GROW_PENDING will be set after everthing is done.
>>>>
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>> ---
>>>>   fs/ext4/ext4.h    |  6 ++++++
>>>>   fs/ext4/inode.c   | 53 ++++++++++++++++++++++++++++++++++++++++++++++-
>>>>   fs/ext4/page-io.c | 40 +++++++++++++++++++++++++++++++++++
>>>>   3 files changed, 98 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>>> index 1c3d736fb700..089dbd39c5c2 100644
>>>> --- a/fs/ext4/ext4.h
>>>> +++ b/fs/ext4/ext4.h
>>>> @@ -3986,6 +3986,12 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>>>>   			     __u64 len, __u64 *moved_len);
>>>>   /* page-io.c */
>>>> +/*
>>>> + * The I/O range covers the zeroed EOF block that straddles i_disksize
>>>> + * and will advance it upon completion.
>>>> + */
>>>> +#define EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO	1UL
>>>> +
>>>>   extern int __init ext4_init_pageio(void);
>>>>   extern void ext4_exit_pageio(void);
>>>>   extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>> index 05dd4ee805fb..4239be5a769f 100644
>>>> --- a/fs/ext4/inode.c
>>>> +++ b/fs/ext4/inode.c
>>>> @@ -4366,7 +4366,10 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>>>>   				       int error)
>>>>   {
>>>>   	struct iomap_ioend *ioend = wpc->wb_ctx;
>>>> -	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
>>>> +	struct inode *inode = ioend->io_inode;
>>>> +	struct ext4_inode_info *ei = EXT4_I(inode);
>>>> +	unsigned int blocksize = i_blocksize(inode);
>>>> +	loff_t pstart, plen;
>>>>   	/*
>>>>   	 * After I/O completion, a worker needs to be scheduled when:
>>>> @@ -4379,6 +4382,21 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>>>>   	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
>>>>   		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>>>> +	/*
>>>> +	 * Mark the I/O as DISKSIZE_GROW_IO by setting io_private to
>>>> +	 * EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO if it covers the pending range.
>>>> +	 * Such I/O will allow or trigger i_disksize advancement in the
>>>> +	 * ioend worker.
>>>> +	 */
>>>> +	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
>>>> +	if (plen &&
>>>> +	    round_down(ioend->io_offset, blocksize) <= pstart &&
>>>> +	    round_up(ioend->io_offset + ioend->io_size, blocksize) >=
>>>> +			pstart + plen) {
>>>> +		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>>>> +		ioend->io_private = (void *)EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO;
>>>> +	}
>>>> +
>>>>   	/*
>>>>   	 * ext4_iomap_end_bio() always defers endio processing, disable
>>>>   	 * generic BIO in task to avoid double deferral since we will use
>>>> @@ -4398,6 +4416,33 @@ static const struct iomap_writeback_ops ext4_writeback_ops = {
>>>>   	.writeback_submit = ext4_iomap_writeback_submit,
>>>>   };
>>>> +/*
>>>> + * If the current writeback range begins after the pending zeroed EOF
>>>> + * block range which straddles i_disksize, issue a separate writeback to
>>>> + * flush it first, so as to avoid prolonged waiting.
>>>> + */
>>>> +static void ext4_iomap_wb_submit_zeroed_eof(struct inode *inode,
>>>> +					    struct writeback_control *wbc)
>>>> +{
>>>> +	struct address_space *mapping = inode->i_mapping;
>>>> +	loff_t pstart, plen, range_start;
>>>> +
>>>> +	if (wbc->range_cyclic)
>>>> +		range_start = (loff_t)mapping->writeback_index << PAGE_SHIFT;
>>>> +	else
>>>> +		range_start = wbc->range_start;
>>>> +
>>>> +	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
>>>> +	if (!plen || range_start < pstart + plen)
>>>> +		return;
>>> Hi Zhang,
>>>
>>> Maybe we can check here if pstart lies withing the same folio as the
>>> writeback range, then we don't need an explicit flush as we will anyways
>>> flush out the whole folio. We can check against the
>>> mapping_min_folio_nrbytes perhaps.
>>>
>>
>> Hi Ojaswin,
>>
>> Thank you for the suggestion. IIUC, do you mean to change it somewhat
>> like the following:
>>
>>       if (!plen ||
>>           round_down(range_start, mapping_min_folio_nrbytes(mapping)) <
>>                      pstart + plen)
>>               return;
> 
> Hi Zhang, yep exactly, it's a small optimization for bs < ps on machines
> like powerpc or arm16/64 which have larger page sizes. 
> 
> Regards,
> ojaswin
>>

Sure, I can fold this optimization into my next iteration.

Thanks,
Yi.

>> The benefit is that it covers the case of blocksize < PAGE_SIZE, where
>> the pending range occupies only part of the folio and range_start lands
>> in the middle or later part of that same folio. It does not help when
>> the pending range happens to be in a large folio, though, because
>> mapping_min_folio_nrbytes() is only a lower bound on the folio size.
>> That said, the pending range is the old EOF of the file and it is
>> unaligned, so that folio can more likely to be a single page than a
>> large one.
>>
>> Or do you want it to be very precise, able to know exactly the size of
>> the folio containing the pending range and its positional relationship
>> with the writeback range? If the latter, that would require an exact
>> folio lookup, which seems a bit expensive and perhaps over-optimization
>> to me.
>>
>> Thanks,
>> Yi.
>>

