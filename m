Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC4937FF53;
	Wed,  3 Jun 2026 01:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780451054; cv=none; b=a8AHhAi4kJajRqfPfqF2v095UEnz6K/lDMSYKZ1gJOxuxLpTAuXbIkuaVm5aRtjuM+idPkhGO5sXLNwLkG+gYNaGt04Hlg/7cVOAjFhBjCA0pXgzAdkGLT+nhn/6QXOsFmslUT63HeGTuFssXlV98TfNI8A4UrRUO5Sz7pjbZKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780451054; c=relaxed/simple;
	bh=L/ekwo7GKsnru2+zPvQaLMNVVjcMgUe8qQK2MWwSs2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hLLHdDUgXkrh4ENROueDlmMY2Il9JIuYRN3dhfVMHUrtUu0Zzz0GNhju9GmcMPz2hzSOUS0wUpUuULSeXuduZotyN4QRzWKxrOYc5OmQ7XgWFbgDA9Ymdy0F6MmhRVWPtEzfDOr50uBmNBGYR8pcrR5ttaxcs4H7S+FC028Xj0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gVVph5z4bzKHMNy;
	Wed,  3 Jun 2026 09:43:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id F1FE64056D;
	Wed,  3 Jun 2026 09:44:05 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgAndzzkhh9qJLKxAQ--.52545S3;
	Wed, 03 Jun 2026 09:44:05 +0800 (CST)
Message-ID: <d6e493d3-8f9e-49c0-b36c-536ef6120011@huaweicloud.com>
Date: Wed, 3 Jun 2026 09:44:04 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/23] ext4: implement buffered write path using iomap
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-9-yi.zhang@huaweicloud.com>
 <ahXUBgoivo5CFl39@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <83e36f9c-aeb1-40d4-9265-fd22120a7fa9@huaweicloud.com>
 <ah6q3bx27P1wptTg@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <ah6q3bx27P1wptTg@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAndzzkhh9qJLKxAQ--.52545S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW5Jw1rXw4fuFyktFyrZwb_yoW8KF43pr
	ZYk3W7tr4kGr1rXFs29F1xWF40k3WfXr47Xr45Xr12vFn0kFySqFW7tF1UuFykKrs3t3Wj
	qrWUZryxZ3yjyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	0PfPUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/2/2026 6:05 PM, Ojaswin Mujoo wrote:
> On Fri, May 29, 2026 at 05:13:55PM +0800, Zhang Yi wrote:
>> Hi, Ojaswin!
>>
>> On 5/27/2026 1:10 AM, Ojaswin Mujoo wrote:
>>> On Mon, May 11, 2026 at 03:23:28PM +0800, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> Introduce two new iomap_ops instances for ext4 buffered writes:
>>>>
>>>>  - ext4_iomap_buffered_da_write_ops: for delayed allocation mode, using
>>>>    ext4_da_map_blocks() to map delalloc extents.
>>>>  - ext4_iomap_buffered_write_ops: for non-delayed allocation mode, using
>>>>    ext4_iomap_get_blocks() to directly allocate blocks.
>>>>
>>>> Also add ext4_iomap_valid() for the iomap infrastructure to check extent
>>>> validity.
>>>>
>>>> Key changes and considerations:
>>>>
>>>>  - Unwritten extents for new blocks (dioread_nolock always on)
>>>>    Since data=ordered mode is not used to prevent stale data exposure in
>>>>    the non-delayed allocation path, new blocks are always allocated as
>>>>    unwritten extents.
>>>
>>> Okay makes sense.
>>>
>>>>
>>>>  - Short write and write failure handling
>>>>    a. Delalloc path: On short write or failure, the stale delalloc range
>>>>       must be dropped and its space reservation released. Otherwise, a
>>>>       clean folio may cover leftover delalloc extents, causing
>>>>       inaccurate space reservation accounting.
>>>
>>> Hmm, okay so in the usual buffer head path, seems like during a short
>>> write we still zero the new buffers we couldn't write and keep it dirty
>>> (folio_zero_new_buffers()). This way they are still written back and
>>> the delalloc reservations are used up.
>>>
>>
>> In fact, in the normal buffer head path, writeback does not consume
>> delalloc reservations. Instead, the reservations are retained until the
>> inode is released or the area is written again using delalloc. This is
>> because i_size is not updated during short writes. Therefore, when a
>> zeroed dirty folio is written back, no block mapping is created for it.
>> For details, please see the lblk >= blocks judgment in
>> mpage_process_page_bufs().
> 
> Oh okay I see, I'm not very clear on the code path but what about a case
> where i_size is beyond the short write range.
> 

Yeah, You're right. When i_size extends beyond the short write range,
the delalloc reservation will be consumed during writeback.

Thanks,
Yi.



