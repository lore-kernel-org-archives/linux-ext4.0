Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8FC38AC7F;
	Thu, 26 Mar 2026 11:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774524506; cv=none; b=Ismiz0tHmSrP3XImbhRpGahFZrG1c4RqYDHwcoekza/yeqypIe2c7jbjYGkDWcCk1f5k97MjpPq35sqoTPPE7+pcSzIS7DUsMaZYo5n8kfrZJjNYckfQGQgnW3QcgX4hgvSpOaQp4qV6zh0zUnhYWP6J14CvQL1Dv3A00WAI9nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774524506; c=relaxed/simple;
	bh=DxIaFV1+ajfUv/NX5Haw9UtXGbylkKr0bLug7vtIfVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FDYyJMZqZkiSUYJOoJ/1l1mDj8CGVUCbW2GurWBaG7eG+XmICORmzZMT1YfFp6TTKIXtZqjUQABY2jnrHwWUuGMyjFnCTAcX13NBn7xF0ltFC6z379vqET5b2s0OsPFG34vuMjWQo4FrkDV8yHFWR4MxHicUvLwY4nXK+Hd3018=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fhLd26sD3zYQtys;
	Thu, 26 Mar 2026 19:09:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id E077A40591;
	Thu, 26 Mar 2026 19:09:22 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgC3utrhE8VpDK8mCQ--.8375S3;
	Thu, 26 Mar 2026 19:09:22 +0800 (CST)
Message-ID: <51472d04-507b-4797-80ca-5f8b50eb9d3d@huaweicloud.com>
Date: Thu, 26 Mar 2026 19:09:20 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/1] ext4: fail fast on repeated metadata reads after IO
 failure
To: Diangang Li <lidiangang@bytedance.com>, Zhang Yi <yizhang089@gmail.com>,
 Andreas Dilger <adilger@dilger.ca>, Diangang Li <diangangli@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, changfengnan@bytedance.com
References: <20260325093349.630193-1-diangangli@gmail.com>
 <20260325093349.630193-2-diangangli@gmail.com>
 <B53E253C-F314-4376-BD9D-58867FC8D3F6@dilger.ca>
 <c6f4b982-c6e4-4f77-a16d-0c381c1e25f0@bytedance.com>
 <e5c657e6-ffbd-4327-adaf-ae52cb50b96d@gmail.com>
 <aa1f5bb1-ffa0-4c85-a228-730593bd4ed0@bytedance.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <aa1f5bb1-ffa0-4c85-a228-730593bd4ed0@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgC3utrhE8VpDK8mCQ--.8375S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAw43uw1xJw1fuF4fZF17trb_yoWrWw47pr
	WSka17Kr4Dt34SvrsFvw1xtay8tw12yFWYqrn5Gr13Aas09r1SqFyxtayY9FW7Ars7K3Wj
	vr40q3srXr15AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 3/26/2026 3:42 PM, Diangang Li wrote:
> Hi, Yi,
> 
> Thanks. Yes, for existing metadata blocks ext4 is read-modify-write, so 
> without a successful read (Uptodate) there is no write path to update 
> that block.
> 
> In the case we're seeing, the read keeps failing (repeated I/O errors on 
> the same LBA), so the write never has a chance to run either. Given 
> that, would it make sense (as Fengnan suggested) to treat persistent 
> media errors (e.g. MEDIUM ERROR / IO ERROR) as non-retryable at the 
> filesystem level, i.e. keep failing fast for that block? That would 
> avoid the BH_Lock thundering herd and prevent hung tasks.
> 

FYI, AFAICT, while this approach makes sense in theory, it actually
faces challenges in fault recovery. This is because these error codes
are not always reliable (especially BLK_STS_IOERR). In some scenarios
where reliability requirements are not very high, customers might not
immediately notice these errors due to transient faults on some storage
devices(such as some network storage scenarios), and these errors might
resolve themselves after a certain period of time. However, after this,
we have to perform some heavy-weight operations, such as stopping
services and remounting the file system, to recover our services. I
believe there will definitely be customers who will complain about
this.

Thanks,
Yi.

> Thanks,
> Diangang
> 
> On 3/25/26 10:27 PM, Zhang Yi wrote:
>> Hi, Diangang,
>>
>> On 3/25/2026 7:13 PM, Diangang Li wrote:
>>> Hi Andreas,
>>>
>>> BH_Read_EIO is cleared on successful read or write.
>>
>> I think what Andreas means is, since you modified the ext4_read_bh() 
>> interface, if the bh to be read already has the Read_EIO flag set, then 
>> subsequent read operations through this interface will directly return 
>> failure without issuing a read I/O. At the same time, because its state 
>> is also not uptodate, for an existing block, a write request will not be 
>> issued either. How can we clear this Read_EIO flag? IIRC, relying solely 
>> on ext4_read_bh_nowait() doesn't seem sufficient to achieve this.
>>
>> Thanks,
>> Yi.
>>
>>>
>>> In practice bad blocks are typically repaired/remapped on write, so we
>>> expect recovery after a successful rewrite. If the block is never
>>> rewritten, repeatedly issuing the same failing read does not help.
>>>
>>> We clear the flag on successful reads so the buffer can recover
>>> immediately if the error was transient. Since read-ahead reads are not
>>> blocked, a later successful read-ahead will clear the flag and allow
>>> subsequent synchronous readers to proceed normally.
>>>
>>> Best,
>>> Diangang
>>>
>>> On 3/25/26 6:15 PM, Andreas Dilger wrote:
>>>> On Mar 25, 2026, at 03:33, Diangang Li <diangangli@gmail.com> wrote:
>>>>>
>>>>> From: Diangang Li <lidiangang@bytedance.com>
>>>>>
>>>>> ext4 metadata reads serialize on BH_Lock (lock_buffer). If the read 
>>>>> fails,
>>>>> the buffer remains !Uptodate. With concurrent callers, each waiter can
>>>>> retry the same failing read after the previous holder drops BH_Lock. 
>>>>> This
>>>>> amplifies device retry latency and may trigger hung tasks.
>>>>>
>>>>> In the normal read path the block driver already performs its own 
>>>>> retries.
>>>>> Once the retries keep failing, re-submitting the same metadata read 
>>>>> from
>>>>> the filesystem just amplifies the latency by serializing waiters on
>>>>> BH_Lock.
>>>>>
>>>>> Remember read failures on buffer_head and fail fast for ext4 
>>>>> metadata reads
>>>>> once a buffer has already failed to read. Clear the flag on successful
>>>>> read/write completion so the buffer can recover. ext4 read-ahead uses
>>>>> ext4_read_bh_nowait(), so it does not set the failure flag and remains
>>>>> best-effort.
>>>>
>>>> Not that the patch is bad, but if the BH_Read_EIO flag is set on a 
>>>> buffer
>>>> and it prevents other tasks from reading that block again, how would the
>>>> buffer ever become Uptodate to clear the flag?  There isn't enough state
>>>> in a 1-bit flag to have any kind of expiry and later retry.
>>>>
>>>> Cheers, Andreas
>>>
>>
> 
> 

