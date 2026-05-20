Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5BB1AE877;
	Wed, 20 May 2026 01:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779238899; cv=none; b=eSWhKth0+pMgvQ3wBjEJ1TFHfrEt3j2RKF8GYqCK0rXHGWwAON6saasxtNig7vBGm2MLtNd4nD5vei2U1xSl5qpR/STCJ6ezPfE44PfdyImixbDoQnFKKIjb+CIAB4o6YvV13KhH/GsR0q1G001YxDC4PfQ9w/UG/VXaXmyN1N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779238899; c=relaxed/simple;
	bh=hc0ocdWHFBjwfz2drl7X12usLEv0WkOGMnXHKx3omb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BpEeHrK1mdzTLIVlJgn80lCYHarrwbY45gAYzqDkpYA4GQ2JQ2lbg4iu47Hah/R61PrS+XSDxv/4TBZcpiNAYwxzZurInypfDxpFSdQUhOIIiWjVCiUT6zV1mghVqMmLYTIK0g+3ftMc52EnO0rS5tEjbrulyf2SCiTfugh0zYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gKtWd3MlyzYQv80;
	Wed, 20 May 2026 09:00:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 09D3A4056B;
	Wed, 20 May 2026 09:01:29 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgBHD1vlBw1qEKO8Cw--.60090S3;
	Wed, 20 May 2026 09:01:26 +0800 (CST)
Message-ID: <fb303a0a-9697-4dc2-8c75-0227f9407347@huaweicloud.com>
Date: Wed, 20 May 2026 09:01:24 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: do not install PMD mappings when handling a COW
 fault
To: William Kucharski <william.kucharski@linux.dev>
Cc: linux-mm@kvack.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, david@redhat.com, yi.zhang@huawei.com,
 karol.wachowski@linux.intel.com, wangkefeng.wang@huawei.com,
 yangerkun@huawei.com, liuyongqiang13@huawei.com
References: <20251024102237.3332200-1-yi.zhang@huaweicloud.com>
 <a3c8038a-43e9-4427-92dd-8fed619001e8@huaweicloud.com>
 <2381B9B8-FD4D-48FE-BBF3-00D3455A8197@linux.dev>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <2381B9B8-FD4D-48FE-BBF3-00D3455A8197@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHD1vlBw1qEKO8Cw--.60090S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXrW7KryfWr13tr1fZrWrKrg_yoW5KF4Dpa
	yxG3WayFWxXFnFyr1IgwsYkryjv3yxGF4jgFyxGryjkFn0yFn3ZrWDWa15C34Dur48AF4r
	ArWjg3sruF4jv37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 5/19/2026 5:02 PM, William Kucharski wrote:
> 
> 
>> On May 19, 2026, at 02:36, Zhang Yi <yi.zhang@huaweicloud.com> wrote:
>>
>> Gentle ping – could anyone take this patch?
>>
>> Thanks,
>> Yi.
> 
> Could you update the comment to clarify why you shouldn't install PMD mappings
> while doing CoW rather than just state it should never be done?

OK, will do.

Thanks,
Yi.

> 
>>
>> On 10/24/2025 6:22 PM, Zhang Yi wrote:
>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>
>>> When pinning a page with FOLL_LONGTERM in a CoW VMA and a PMD-aligned
>>> (2MB on x86) large folio follow_page_mask() failed to obtain a valid
>>> anonymous page, resulting in an infinite loop issue. The specific
>>> triggering process is as follows:
>>>
>>> 1. User call mmap with a 2MB size in MAP_PRIVATE mode for a file that
>>>   has a 2MB large folio installed in the page cache.
>>>
>>>   addr = mmap(NULL, 2*1024*1024, PROT_READ, MAP_PRIVATE, file_fd, 0);
>>>
>>> 2. The kernel driver pass this mapped address to pin_user_pages_fast()
>>>   in FOLL_LONGTERM mode.
>>>
>>>   pin_user_pages_fast(addr, 512, FOLL_LONGTERM, pages);
>>>
>>>  ->  pin_user_pages_fast()
>>>  |   gup_fast_fallback()
>>>  |    __gup_longterm_locked()
>>>  |     __get_user_pages_locked()
>>>  |      __get_user_pages()
>>>  |       follow_page_mask()
>>>  |        follow_p4d_mask()
>>>  |         follow_pud_mask()
>>>  |          follow_pmd_mask() //pmd_leaf(pmdval) is true because the
>>>  |                            //huge PMD is installed. This is normal
>>>  |                            //in the first round, but it shouldn't
>>>  |                            //happen in the second round.
>>>  |           follow_huge_pmd() //require an anonymous page
>>>  |            return -EMLINK;
>>>  |   faultin_page()
>>>  |    handle_mm_fault()
>>>  |     wp_huge_pmd() //remove PMD and fall back to PTE
>>>  |     handle_pte_fault()
>>>  |      do_pte_missing()
>>>  |       do_fault()
>>>  |        do_read_fault() //FAULT_FLAG_WRITE is not set
>>>  |         finish_fault()
>>>  |          do_set_pmd() //install a huge PMD again, this is wrong!!!
>>>  |      do_wp_page() //create private anonymous pages
>>>  <-    goto retry;
>>>
>>> Due to an incorrectly large PMD set in do_read_fault(),
>>> follow_pmd_mask() always returns -EMLINK, causing an infinite loop.
>>>
>>> David pointed out that we can preallocate a page table and remap the PMD
>>> to be mapped by a PTE table in wp_huge_pmd() in the future. But now we
>>> can avoid this issue by not installing PMD mappings when handling a COW
>>> and unshare fault in do_set_pmd().
>>>
>>> Fixes: a7f226604170 ("mm/gup: trigger FAULT_FLAG_UNSHARE when R/O-pinning a possibly shared anonymous page")
>>> Reported-by: Karol Wachowski <karol.wachowski@linux.intel.com>
>>> Closes: https://lore.kernel.org/linux-ext4/844e5cd4-462e-4b88-b3b5-816465a3b7e3@linux.intel.com/
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>> ---
>>> mm/memory.c | 5 +++++
>>> 1 file changed, 5 insertions(+)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 0ba4f6b71847..0748a31367df 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -5212,6 +5212,11 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>>> if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
>>> return ret;
>>>
>>> + /* We're about to trigger CoW, so never map it through a PMD. */
>>> + if (is_cow_mapping(vma->vm_flags) &&
>>> +    (vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)))
>>> + return ret;
>>> +
>>> if (folio_order(folio) != HPAGE_PMD_ORDER)
>>> return ret;
>>> page = &folio->page;
>>
>>

