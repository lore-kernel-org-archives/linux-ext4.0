Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A6C38838B;
	Wed, 23 Sep 2026 08:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152193; cv=none; b=oluhexmVL6EJwM9C6TmWSZLlo3HIcXVRStY+6zlXLRRryv0cKYW2ZfEBMYjnrCBWBs/L2VZWv2nRVs7rMGuqq7bsmkbuWOahxwaD3ECBJuHMJ0cWkAebMOhMDna5antsioC1Y/i9k3ahzE5V8KwWbE6wm6NGj4JnU902nNPt6nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152193; c=relaxed/simple;
	bh=cHaw5H27Jso4WGjJebjaDnIPz549SpzzHfZr7B+dnOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=akLg0IQ3ETXxjxm74XtzqVb6c/j7yHRCM1ieZrgjuhzPgpzIqHZN11b3UAT7dL5F1ctKa/CUscMIR6STctC011WeUOVs21nUSOWyV3x2HZTwJbxKhdtSH45PDm2pY9VEq4RumrtO1yDg7YS9hIEViMAu7c67INrOO3YZIu140g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hqVWF1Y99zYQv0M;
	Wed, 23 Sep 2026 16:29:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CC74840791;
	Wed, 23 Sep 2026 16:29:45 +0800 (CST)
Received: from [10.174.178.176] (unknown [10.174.178.176])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBHFyr4jbNqMJV0BQ--.62376S3;
	Wed, 23 Sep 2026 16:29:45 +0800 (CST)
Message-ID: <ea87901a-b1ec-4066-b81e-a1e5864b3872@huaweicloud.com>
Date: Wed, 23 Sep 2026 16:29:43 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm/truncate: fix data loss when splitting
 straddling large folios fails
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
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-4-yi.zhang@huaweicloud.com>
 <DLM0SRQ1LAMU.3Q4REHFJ7TETZ@nvidia.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <DLM0SRQ1LAMU.3Q4REHFJ7TETZ@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBHFyr4jbNqMJV0BQ--.62376S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XrW3tFykWw17CrWrKrW8Crg_yoW7Xw18pr
	Wjga9IyrWkGws2krnrZa1jqF1Yq34fXrWUJFyxG3WSkan0vr12kF1UK3W8uFWUK3s7Gw10
	qF1UZ3ZrWF1DAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jzE__UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/23/2026 1:27 AM, Zi Yan wrote:
> On Tue Sep 22, 2026 at 7:07 AM EDT, Zhang Yi wrote:
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
>> filemap_release_folio() fails on a dirty folio and folio_split() aborts
>> with -EBUSY before any split, leaving the straddler safely unsplit. The
>> bug is only reachable on paths that produce dirty large folios without
>> filesystem private data, and it was caught on the upcoming ext4 iomap
>> buffered I/O path when no ifs is attached.
>>
>> Rework the contract so the caller is told the folio range to discard:
>>
>>   - Add pgoff_t *pstart and *pend out-parameters that receive the folio
>>     range fully covered by [lstart, lend] after any split (or none),
>>     aligned inwards to min_order, i.e. the folios wholly within the
>>     range and safe to discard.
>>
>>   - Report a reliable end position to the caller. The straddler is
>>     looked up at an index aligned inwards to the mapping minimum folio
>>     order, and *pend is set to that boundary on success. If nothing
>>     covers the boundary, discarding up to it stays safe. If the
>>     straddler is locked by someone else, fall back to folio->index.
>>     This best-effort fallback may leave the in-range sub-folios to a
>>     later pass but never discards the out-of-range tail. If the
>>     straddler cannot be split, fall back to folio2->index so the caller
>>     keeps the out-of-range tail.
>>
>>   - Rename the byte-range parameters start/end to lstart/lend to better
>>     express their semantics.
>>
>> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
>> &pstart for the folio at the start edge and &pend for the folio at the
>> end edge, so the truncate loop drops exactly the fully covered pages and
>> never touches a straddling folio that still holds valid out-of-range
>> data.
>>
>> Suggested-by: Brian Foster <bfoster@redhat.com>
>> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
>> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>  mm/internal.h |  4 +--
>>  mm/shmem.c    | 13 +++-----
>>  mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
>>  3 files changed, 68 insertions(+), 37 deletions(-)
> 
> <snip>
>>
>> @@ -251,6 +264,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
> 
> Add more context:
> 
> 	if (!folio_test_large(folio))
>>  		return true;
>>  
>>  	min_order = mapping_min_folio_order(folio->mapping);
>> +	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
>>  	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
>>  	if (!folio_split_or_unmap(folio, split_at, min_order)) {
>>  		/*
>> @@ -259,34 +273,57 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>  		 * for shmem truncate
>>  		 */
>>  		struct folio *folio2;
>> -		pgoff_t end_idx;
>> +		pgoff_t end, aligned_end = round_down(pos + offset + length,
>> +						min_nrbytes) >> PAGE_SHIFT;
> 
> <snip>
> 
>> +		/* Already at the minimum order, nothing to split */
>> +		if (folio_order(folio2) == min_order)
>> +			goto out_put;
> 
> In the above, folio_test_large() is used to determine whether folio
> needs to be split or not, but here folio_order() == min_order is used.
> Should the above "if (!folio_test_large(folio))" be changed to use
> min_order check to match the check here?
> 

Yeah, this makes sense to me.

Thanks,
Yi.



