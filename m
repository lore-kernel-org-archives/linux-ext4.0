Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500E038F62F;
	Wed, 14 Oct 2026 03:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791949027; cv=none; b=KrrTpUotbdOUH9PLiEWljH7oYVXhKS1B1cfHXheRX2+Znkz9v7gntNbHLKabtbcRLZHhJXFt3H9f6CZVOmiNatZMHSbKhc/MgHBJoDp3lQrU/tKW2k8QGIE2Tg+RgWUZQmmfBjxsSccK7/aS7q8/jp3n4+27deuhkXONjLf4bbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791949027; c=relaxed/simple;
	bh=s8jVTQylDkNWXL49FPTl4Ii851QxbEMfXh14B5Lt/JY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=icxzqhRPC44zzUnBYSM+q6TTFaGkLXa8umBQCIen6U4MWG4Occygh4tunLcUBrVn4knp2CnxA0K9mqWfH5+neOhIQ0QKUTJTT3vd/N6T1/uQEUXBS2HLemAQU+qubML4q6F9yivyptMpGEaXAeYpy0y6nJyG0aol45t19GEizbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j4H146C1yzYQtlm;
	Wed, 14 Oct 2026 11:36:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2B9C4407F5;
	Wed, 14 Oct 2026 11:37:01 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgB3tfTb+M5qCyd6AQ--.22305S3;
	Wed, 14 Oct 2026 11:37:00 +0800 (CST)
Message-ID: <4e9df882-6379-4118-9dbf-c8f3fcb75058@huaweicloud.com>
Date: Wed, 14 Oct 2026 11:36:58 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: complete dropbehind writeback in task context
To: Tal Zussman <tz2294@columbia.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Taotao Chen <chentaotao@didiglobal.com>,
 Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
 <cwlno6baljswazb7izeue7yh4qjwbs6ktfj3jgnhdh5zyfp72c@xpar52ae3uej>
 <ef6d0df9-c71a-4b42-bde2-efc4477306ed@columbia.edu>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <ef6d0df9-c71a-4b42-bde2-efc4477306ed@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgB3tfTb+M5qCyd6AQ--.22305S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXr13tw18AFyDKFW5tF4ruFg_yoWrZw1xpF
	y5K3WFkF48JasakwnrtF1IqF1FyrWkCr17WryftrWjvF1DtwnIgFZxK3Wj9F1UCrs7WFW2
	vFWrJrW3Z3WYy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/14/2026 1:32 AM, Tal Zussman wrote:
> On 10/13/26 8:47 AM, Jan Kara wrote:
>> On Mon 12-10-26 14:04:37, Tal Zussman wrote:
>>> ext4_end_bio() ends writeback directly from bio completion, which
>>> usually runs in interrupt context, unless the io_end has unwritten
>>> extents to convert and is completed from ext4's workqueue.
>>> folio_end_dropbehind() only invalidates the folios of an RWF_DONTCACHE
>>> write when it runs in task context, and silently skips them otherwise.
>>> So on ext4, dontcache writes that overwrite blocks that are already
>>> written, or that allocate blocks without unwritten extents, leave their
>>> folios in the page cache. Dropping them was best effort so far, as there
>>> was no way to get task context from bio completion.
>>>
>>> Use the task-context bio completion infrastructure instead: set
>>> BIO_COMPLETE_IN_TASK on bios that carry dropbehind folios in
>>> io_submit_add_bh(), so that bio_endio() runs their completion from a
>>> worker. ext4's iomap buffered I/O path already gets this from iomap, so
>>> only the buffer_head based writeback is affected. Skip the flag when the
>>> io_end already has unwritten extents, as ext4 then defers the completion
>>> itself. A later extent can still make the io_end unwritten after an
>>> earlier bio was built. That bio's completion is then deferred twice,
>>> which is not optimal, but harmless.
>>>
>>> This changes behavior only for bios that carry dropbehind folios: their
>>> completion now runs from a worker instead of in interrupt context.
>>>
>>> On the unpatched kernel a dontcache overwrite of already-written blocks,
>>> or a dontcache write into a new file on a dioread_lock mount, leaves
>>> every folio in the page cache (16384/16384 for a 64M file). With the
>>> patch, none remain in the page cache. A dontcache write into a new file
>>> with unwritten extents already drops its folios on both kernels, as
>>> expected, and a plain write keeps them.
>>>
>>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>>
>> I guess this is OK as a short term fix but having two different offloading
>> mechanisms for IO completion is just asking for trouble and we should use
>> BIO_COMPLETE_IN_TASK when unwritten extent conversion is needed as well.
>> But for this fix feel free to add:
>>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>>
> 

Ha, I also noticed this issue in the buffer_head path when I was adding
the iomap path earlier. I was planned to start addressing the generic
bio completion converting work across both writeback paths after the
current stage of work wraps up, so thanks for fixing this one separately!

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>


> Thanks! Agreed on the above. I saw that there was a TODO added in
> ext4_iomap_writeback_submit() from the new iomap conversion series to
> "switch all defer handlers to the generic bio complete in task framework",
> so I assumed that'll be taken care of as part of the ongoing conversion.
> 

Yes, Jan discussed this optimization direction with me previously. Next,
I'll try to remove ext4's own deferred workqueue and migrate the work
into the generic flow.

Thanks,
Yi.

> - Tal
> 
>> 								Honza
>>
>>> ---
>>>  fs/ext4/page-io.c | 10 ++++++++++
>>>  1 file changed, 10 insertions(+)
>>>
>>> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
>>> index 734d856a6d47..e556598ce9e1 100644
>>> --- a/fs/ext4/page-io.c
>>> +++ b/fs/ext4/page-io.c
>>> @@ -458,6 +458,16 @@ static void io_submit_add_bh(struct ext4_io_submit *io,
>>>  		io_submit_init_bio(io, inode, folio, bh);
>>>  	if (!bio_add_folio(io->io_bio, folio, bh->b_size, bh_offset(bh)))
>>>  		goto submit_and_retry;
>>> +
>>> +	/*
>>> +	 * Dropbehind folios can only be invalidated in task context. An
>>> +	 * io_end with unwritten extents is completed from ext4's workqueue
>>> +	 * anyway, so only ask the block layer to defer the others.
>>> +	 */
>>> +	if (folio_test_dropbehind(folio) &&
>>> +	    !(io->io_end->flag & EXT4_IO_END_UNWRITTEN))
>>> +		bio_set_flag(io->io_bio, BIO_COMPLETE_IN_TASK);
>>> +
>>>  	wbc_account_cgroup_owner(io->io_wbc, folio, bh->b_size);
>>>  	io->io_next_block++;
>>>  }
>>>
>>> ---
>>> base-commit: 35aefefd7aba0801bab635b11943f932626be3b2
>>> change-id: 20260924-ext4-dontcache-complete-in-task-2340ed5f3114
>>>
>>> Best regards,
>>> --  
>>> Tal Zussman <tz2294@columbia.edu>
>>>
>> -- 
>> Jan Kara <jack@suse.com>
>> SUSE Labs, CR
>>
> 
> 

