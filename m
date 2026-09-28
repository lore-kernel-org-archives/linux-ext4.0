Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21FD2E8B83;
	Mon, 28 Sep 2026 12:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790599598; cv=none; b=flXKW2gvzitiaCT+MKv6vCo6yefF/dcUiH7DpbxORQHxtMp0wiNOx1atv/nbg1fF+YzL9PQ+VACOngAEHZRwLkjcHBzDR7UeoiiejmB5CokJwfWoggrsXWylMDvzne0buR+DE1CkOh0sIyA1VQwreVudi561x0nefkB3nUmzINA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790599598; c=relaxed/simple;
	bh=4hCYLJkTGUQETROtL5OWvDslbHodh0mVKtdF088gnQE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WIcTAM19PgSPupxsnA2UCMtemIJ7bt9A14yulN6Uo46CfRYp11xPdYpETn9c3yQr2rQ3y9tQb+M6m6Gvxnf3XBEXXgu0P2LUPd9Agx2Mi1Hi/SNZsQBEsLiwyPvDc0s+gmmcqnGDEWPL45nrHMRrhfQEs+Fq48xxx1ugPzHbPkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4htgyr20FMzKHMRh;
	Mon, 28 Sep 2026 20:45:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 53AC5406C2;
	Mon, 28 Sep 2026 20:46:30 +0800 (CST)
Received: from [10.174.178.176] (unknown [10.174.178.176])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXdCekYbpqBR0ACA--.8279S3;
	Mon, 28 Sep 2026 20:46:30 +0800 (CST)
Message-ID: <168ab288-39d2-48e5-9b2d-59441102c728@huaweicloud.com>
Date: Mon, 28 Sep 2026 20:46:28 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] mm/truncate: align truncation boundaries to
 mapping minimum folio order
To: sashiko-reviews@lists.linux.dev, linux-mm@kvack.org
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 linux-ext4@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
 <20260928120833.3440834-2-yi.zhang@huaweicloud.com>
 <20260928123136.2D6891F000FF@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260928123136.2D6891F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBXdCekYbpqBR0ACA--.8279S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFy3CFykKrWUGr1UZFy7Wrg_yoW5JF1UpF
	WDXFWruw48Ww4xuFy093WDAr1fWa48Kay5AF1xK393Jwn3WwnF9r4Utay0gw4Iqr4xAF10
	yF1jyr9rWr4jvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFIxCjY7AvzIIF6xkI1cIj4wC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUIl
	1vDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/28/2026 8:31 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] mm: integer overflow in round_up() during truncation causes complete file data loss
> --

As mentioned in the cover litter,  this is a pre-existing issue related
to the file system that needs to be addressed separately.

Thanks,
Yi.

> 
> commit 583804d300760dcf60e3ec5aab6503a560ad3e7e
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> mm/truncate: align truncation boundaries to mapping minimum folio order
> 
> When the mapping has a non-zero minimum folio order, this patch changes
> folio_split() in truncate_inode_partial_folio() to stop at min_order instead
> of order 0. It also aligns both start and end to the mapping minimum folio
> order so they always fall on a folio boundary, preventing valid out-of-range
> tails from being dropped.
> 
> Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com/
> 
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index b58ba940be474..8a28f4a212677 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
> [ ... ]
>> @@ -395,6 +397,10 @@ void truncate_inode_pages_range(struct address_space *mapping,
>>  	else
>>  		end = (lend + 1) >> PAGE_SHIFT;
>>  
>> +	start = round_up(start, min_nrpages);
> 
> [Severity: Critical]
> Could this round_up() result in an integer overflow that changes a very large
> start index to 0 on 32-bit architectures?
> 
> When an unprivileged user issues fallocate(PUNCH_HOLE) or truncate at an offset
> near ULONG_MAX << PAGE_SHIFT (e.g., 16TB on 32-bit systems) on a filesystem with
> min_nrpages > 1 (like ext4 with large folio/iomap), start approaches
> ULONG_MAX (e.g., 0xFFFFFFFF on 32-bit x86).
> 
> The macro round_up(start, min_nrpages) performs 32-bit arithmetic. With
> start approaching 0xFFFFFFFF, start + min_nrpages - 1 can overflow to a value
> less than min_nrpages, causing round_up to evaluate to 0.
> 
> This would corrupt the start index to 0 in truncate_inode_pages_range(), and
> the subsequent loop would unintentionally truncate the entire page cache from
> index 0 to end, causing complete data loss of unwritten data.
> 
>> +	if (end != (pgoff_t)-1)
>> +		end = round_down(end, min_nrpages);
>> +
>>  	folio_batch_init(&fbatch);
>>  	index = start;
>>  	while (index < end && find_lock_entries(mapping, &index, end - 1,
> 

