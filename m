Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DB53EBF23;
	Fri, 11 Sep 2026 09:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789118805; cv=none; b=fLoOQAvjBusMuiiVJEUok+Z2cXWMItWN5np1TH64kfYo3ssb3B2CtBnYLu9tYZbC18YA3DZ97XJ1RvNO2maG67m8ytXkt3PqNT205tlpvhBeV2HK6S6M9kYxYkmGpoCAaHwM9fTC/JZvwK+GR29OWaENABTEHaaTb4xCPHtBrEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789118805; c=relaxed/simple;
	bh=2Zv+f4bhelSrSTphUvrw1UdkuGT+p2+5YSknl/De/dQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ErCYeh/L1v5p8K5RMvxaHxCcV7BL1w//xRWmh3BHPWRKX1l9gGu7F3zvgsoYlfTK9Uz4wQttOEBPv5NIMyWulUUtffR0KfZW2+oQlSBVXJaNHjU5Vu5UifKFH9C4uDrX0BTeU48rvptRIyQ2vEB/yrZLkfOl18msa9bJg7qcaqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hh8KW19gCzYQtpM;
	Fri, 11 Sep 2026 17:25:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 8DD5340574;
	Fri, 11 Sep 2026 17:26:31 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgBnUAtFyaNqHzI8Bg--.45614S3;
	Fri, 11 Sep 2026 17:26:31 +0800 (CST)
Message-ID: <4fe4a9df-7e1f-4dc5-a3db-8d2ccc4b924f@huaweicloud.com>
Date: Fri, 11 Sep 2026 17:26:28 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating straddling
 large folios
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, bfoster@redhat.com,
 joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com,
 wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
 <6F18C9FE-3599-4C6E-99F9-767BD7AC8E3B@nvidia.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <6F18C9FE-3599-4C6E-99F9-767BD7AC8E3B@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBnUAtFyaNqHzI8Bg--.45614S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWFyrZw4xKFW5GFW5Ww1xXwb_yoWrur43pF
	W2gasIyFZ7J3yvkr4vva18Xw1Fqay7Xa1UAF93G392k3Z0qr1IkFy7t3W8u398Krn7Jw10
	q3WjvFWDW3WDAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	4xRDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/10/2026 3:18 AM, Zi Yan wrote:
> On 9 Sep 2026, at 2:23, Zhang Yi wrote:
> 
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> truncate_inode_partial_folio() splits a large folio so that the caller's
>> truncate loop can drop the in-range sub-folios while keeping the
>> out-of-range tail. The first split at the punch start edge is
>> non-uniform, which leaves the sub-folio at the truncation end edge as
>> large as possible, this means it may still straddle the range, holding
>> both zeroed in-range and valid out-of-range data. The function then
>> attempts a second split at offset + length to isolate that tail.
>>
>> If the second split fails the straddling sub-folio stays merged. The
>> function returned true unconditionally on all exit paths of the success
>> block, telling the caller it was fully handled. The caller kept its
>> default end and the truncate loop truncated every sub-folio below it,
>> including the merged straddler, discarding the valid out-of-range tail.
>>
>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>> of the last page:
>>
>>   truncate_inode_pages_range()
>>     truncate_inode_partial_folio()      # same_folio == true
>>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>       folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>       2nd split of folio2 fails / cannot lock
>>       return true                       # BUG: caller keeps default end
>>     end = 3
>>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>
>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>> folio_split() in truncate operation") replaced the atomic split_folio()
>> with folio_split(), whose non-uniform split can partially split a folio
>> and leave the end edge merged.
>>
>> It has gone unnoticed because a dirty large folio normally carries the
>> filesystem's private data, for example buffer_head, so
>> filemap_release_folio() -> iomap_release_folio() returns false on a
>> dirty folio and folio_split() aborts with -EBUSY before any split,
>> leaving the straddler safely unsplit. The bug is only reachable on paths
>> that produce dirty large folios without filesystem private data, and it
>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>> attached.
> 
> Thank you for fixing it.
> 
>>
>> In addition, even when both splits succeed, data can still be lost when
>> the mapping's minimum folio order (min_order) is non-zero. folio_split()
>> stops at min_order instead of order 0, so the sub-folio containing a
>> split point stays aligned to 1 << min_order rather than to a page. The
>> original success path left start at the page-aligned head of the range
>> and set end to the exact page index of the end edge, neither of which is
>> a folio boundary in general. Either one could land inside the large
>> folio at its edge, and the truncate loop would drop that straddling
>> folio together with its valid out-of-range tail.
>>
>> For example, a 64K (order-4) folio with min_order = 2 punched from
>> offset 0 to 36K:
>>
>>   truncate_inode_pages_range()
>>     truncate_inode_partial_folio()        # same_folio == true
>>       1st split at p0 -> [p0-p3, p4-p7, p8-p15]  # non-uniform, min_order
>>       folio2 = p8-p15 # straddles: p8 in range, p9-p15 tail valid
>>       2nd split of folio2 -> [p8-p11, p12-p15]   # success
>>       end = p9                           # BUG: p9 inside [p8-p11]
>>     loop truncates ... p8-p11           # p9-p11's valid tail is lost
> 
> Should min_order > 0 fix come as a separate patch first? min_order>0
> was introduced by commit e220917fa5077 ("mm: split a folio in minimum
> folio order chunks") and it is before folio_split(). The old
> split_huge_page_to_list_to_order() can cause a similar issue?
> 

Indeed, the min_order issue is a separate problem, and we should fix
it in a separate patch.

> 
> <snip>
> 
>>     i.e. the pages wholly within the range and safe to discard. They are
>>     aligned up (pstart) and down (pend) to the mapping's minimum folio
>>     order so they always fall on a folio boundary.
> 
> Basically, to fix min_order issue alone, truncate_inode_partial_folio()
> needs to align pstart and pend to 1UL << min_order?
> 
> 

Yes, fixing the min_order issue separately amounts to aligning pstart
and pend to 1UL << min_order, so they need to be exported first.
Otherwise the same alignment would have to be done in the two callers,
truncate_inode_pages_range() / shmem_undo_range(). I can rework
truncate_inode_partial_folio() to export these two parameters first, and
then split out a separate patch for the min_order fix.

Thanks,
Yi.




