Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2728D3AC0EF;
	Wed, 20 May 2026 08:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779265145; cv=none; b=X/SnF5S3vEYD0IDNCxrxuxU4usZvpmZ4WuDc8diZC69xNYrthO3JPBs/IlcOfyJByqg+yazSJV8DLmMkifGlWti8w+lCvBYxfMaehLutmKxVc+lAA+os4DBjQUZ2wjV8ThKinKkG/ffAO4sKFOkNh7ishZKTW9cwWfARHD7eJcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779265145; c=relaxed/simple;
	bh=qlUJuifKyPHNyGOFggkzyJz0MoHxT+iKVvcrH2y9yqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bsHfjL0KOsM5ndTAWN0FlJxH1tROPEq6Aqv7OLi8tjsrQi+cLrGIeoV7dRsrhqlh+gziVlds3aWoVMQHwGZNAij+wJRfhGWbPNxFGCP2Qie7gnH1EypxU4Lo3FYYaYqYXDZWWlkAIERh13zg0rd6Az2BTzcwX0Xz3d4Nq4/8P20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gL4DG4Gt9zYQtwD;
	Wed, 20 May 2026 16:18:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A502440578;
	Wed, 20 May 2026 16:18:50 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgAHz1pobg1qDNjhCw--.5139S3;
	Wed, 20 May 2026 16:18:50 +0800 (CST)
Message-ID: <a1e84c7e-c241-44bd-8289-b8909c17b3b9@huaweicloud.com>
Date: Wed, 20 May 2026 16:18:48 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/23] ext4: do not use data=ordered mode for inodes
 using buffered iomap path
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-8-yi.zhang@huaweicloud.com>
 <agw-Wt4c4Fwevezk@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <agxmG0MhIywySPaA@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <agxmG0MhIywySPaA@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAHz1pobg1qDNjhCw--.5139S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Aw1Utw1DtrWrKFW5Ar43Jrb_yoW3GFW8pr
	WrKas8Kr4kZry7urn29FW0qr10vw45Jr47Wr17WFsFga90yF1xKFW7K3Wa9FyUtrn3G34I
	qF40y3s7uFs0yrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 5/19/2026 9:31 PM, Ojaswin Mujoo wrote:
> On Tue, May 19, 2026 at 04:11:30PM +0530, Ojaswin Mujoo wrote:
>> On Mon, May 11, 2026 at 03:23:27PM +0800, Zhang Yi wrote:
>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>
>>> The data=ordered mode introduces two fundamental conflicts with the
>>> iomap buffered write path, leading to potential deadlocks.
>>>
>>> 1) Lock ordering conflict
>>>    In the iomap writeback path, each folio is processed sequentially:
>>>    the folio lock is acquired first, followed by starting a transaction
>>>    to create block mappings. In data=ordered mode, writeback triggered
>>>    by the journal commit process may attempt to acquire a folio lock
>>>    that is already held by iomap. Meanwhile, iomap, under that same
>>>    folio lock, may start a new transaction and wait for the currently
>>>    committing transaction to finish, resulting in a deadlock.
>>
>> Right, makes sense.
>>>
>>> 2) Partial folio submission not supported
>>>    When block size is smaller than folio size, a folio may contain both
>>>    mapped and unmapped blocks. In data=ordered mode, if the journal
>>>    waits for such a folio to be written back while the regular writeback
>>>    process has already started committing it (with the writeback flag
>>>    set), mapping the remaining unmapped blocks can deadlock. This is
>>>    because the writeback flag is cleared only after the entire folio is
>>>    processed and committed.
>>
>> Okay so IIUC, if we do end up using iomap with ordered data, there are 2
>> codepaths with issues here:
>>
>> txn_commit
>>   ordered data writeback (say it goes via iomap)
>> 	  folio_lock
>> 		iomap_writeback_folio
>> 			folio_start_writeback
>> 			  iomap_writeback_range
>> 				  ext4_map_block
>> 					  txn_start
>> 						  wait for tnx commit - DEADLOCK
>>
>> Currently we avoid this by having ext4_normal_submit_inode_buffers()
>> pass can_map = 0 so journal flush makese sure not to start any txn.
>>
>> Then we have
>>
>> txn_commit                          background writeback (via iomap)
>>
>>                                     folio_lock()
>>   ordered data writeback
>> 	  folio_lock
>> 			  
>>                                 		iomap_writeback_folio
>>                                 			folio_start_writeback
>>                                 			  iomap_writeback_range
>>                                 				  ext4_map_block
>>                                 					  txn_start
>> 																						  wait for txn commit - DEADLOCK
> 
> Sorry I forget to remove tabs
> 
> this is what I meant:
> 
> txn_commit
>   ordered data writeback (say it goes via iomap)
>     folio_lock
>     iomap_writeback_folio
>       folio_start_writeback
>         iomap_writeback_range
>           ext4_map_block
>             txn_start
>               wait for tnx commit - DEADLOCK
> 
> Currently we avoid this by having ext4_normal_submit_inode_buffers()
> pass can_map = 0 so journal flush makese sure not to start any txn.

Yeah, but we can also solve this problem by adding similar tags. This
is not the most difficult part.

> 
> Then we have
> 
> txn_commit                          background writeback (via iomap)
> 
>                                     folio_lock()
>   ordered data writeback
>     folio_lock
> 
>                                     iomap_writeback_folio
>                                       folio_start_writeback
>                                         iomap_writeback_range
>                                           ext4_map_block
>                                             txn_start
>                                               wait for txn commit - DEADLOCK
> 
> 
>> 	  
>> Currently, this is taken care because we try to start the txn before
>> taking any folio locks/starting writeback, and hence we cannot deadlock.

Yeah. You are right! Actually, this deadlock scenario should essentially
belong to the first category: "Lock ordering conflict". This is not the
scenario I want to describe here. The problematic scenario is as
follows:

T0: Assume we have a folio contains four blocks, from front to back,
    they are A, B, C, D. The last block D is written in delalloc mode
    (the block is not allocated yet).

T1: The writeback process starts to write back data, set writeback flag
    on the folio, allocates block D, and adds it to transaction N's
    order list of jbd2 in JI_WAIT_DATA mode.

T2: This folio completes the writeback and clears the writeback flag.

T3: Before transaction N commit, we punch block B and C, and overwrite
    A-C,

T4: Transaction N commit and folio writeback are running concurrently.

Transaction N commit        folio writeback(iomap)

                            iomap_writeback_folio()
                             folio_start_writeback()  -- set writeback

jbd2_journal_finish_inode_data_buffers()
 __filemap_fdatawait_range()
  -- wait writeback flag to clear
                               iomap_writeback_range()
                                ext4_map_block() -- map block B and C
                                 start handle
                                  wait for transaction N commit
                                   - DEADLOCK

IOMAP does not support submitting partial folios during writeback.
Therefore, the writeback flag is cleared only after the entire folio
has been submitted. As a result, the commit of transaction N would never
wait for this flag to be cleared if we need to map some blocks in this
folio.

Currently, this is handled by ext4_bio_write_folio(), which supports
writing back partial folios. The writeback flag is only set after the
block has been mapped and before the bio is actually issued. There are
no other limitations that would block this flag from being cleared
after the I/O is completed.

>>
>> If the above description makes sense, do you think it'd be good to add
>> them to the commit message. The reason is that although these paths seem
>> obvious when we look at them a lot, it took me a good bit of time to
>> understand what deadlocks you are talking about here :p
>>
>> Having the code traces like above makes it very clear.

Indeed, these problematic cases are complicated and subtle. I also spent
some time recalling this scene. I can add these code traces in my next
iteration.

Thanks,
Yi.

>>>
>>> To support data=ordered mode, the iomap core would need two invasive
>>> changes:
>>>  - Acquire the transaction handle before locking any folio for
>>>    writeback.
>>>  - Support partial folio submission.
>>>
>>> Both changes are complicated and risk performance regressions.
>>> Therefore, we must avoid using data=ordered mode when converting to the
>>> iomap path.
>>>
>>> Currently, data=ordered mode is used in three scenarios:
>>>  - Append write
>>>  - Post-EOF partial block truncate-up followed by append write
>>>  - Online defragmentation
>>>
>>> We can address the first two without data=ordered mode:
>>>  - For append write: always allocate unwritten blocks (i.e. always
>>>    enable dioread_nolock), preserving the behavior of current
>>>    extent-type inodes.
>>>  - For post-EOF truncate-up + append write: postpone updating i_disksize
>>>    until after the zeroed partial block has been written back.
>>
>> I'm still going through how we are addressing no data=ordered so will
>> get back on this in some time.
>>
>> Thanks,
>> Ojaswin
>>
>>>
>>> Online defragmentation does not yet support iomap; this can be resolved
>>> separately in the future.
>>>
>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>> ---
>>>  fs/ext4/ext4_jbd2.h | 7 ++++++-
>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
>>> index 63d17c5201b5..26999f173870 100644
>>> --- a/fs/ext4/ext4_jbd2.h
>>> +++ b/fs/ext4/ext4_jbd2.h
>>> @@ -383,7 +383,12 @@ static inline int ext4_should_journal_data(struct inode *inode)
>>>  
>>>  static inline int ext4_should_order_data(struct inode *inode)
>>>  {
>>> -	return ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE;
>>> +	/*
>>> +	 * inodes using the iomap buffered I/O path do not use the
>>> +	 * data=ordered mode.
>>> +	 */
>>> +	return !ext4_inode_buffered_iomap(inode) &&
>>> +		(ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE);
>>>  }
>>>  
>>>  static inline int ext4_should_writeback_data(struct inode *inode)
>>> -- 
>>> 2.52.0
>>>

