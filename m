Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F6C4D7D48
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 11:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789645716; cv=none; b=oy3f3NgenaACUmxF8O9reLY332oKLBfccEs0miYxvJWImVGe+dmK6ZrRLgOkKEAYgVd5pUOGxBqH2RdnCpg3wiYDU/PqQQcSAkT6g9W16/5+8QjOQSOemTetz6E+rm3ia2ha3yOGZ6SClIJ1yfX3T5KxjzNATvb8DqCDlvRemKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789645716; c=relaxed/simple;
	bh=40S5Rsrxf9rWkVmZASWWlCuWh4sMf9Qidfv4Hhq2I9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N+adOS7iQoWFNzE4tu8PJ8E+hcGOWhCISVtzozX8ExHjX3nnpLFQTb0GWdFdP9zNaGbmpo74pOIb8FZQRHAdzPnJQhUk1UGNWqsXZQUd+cGV+dOJHBBfrc0Ivu0svORpspClDLvop5mkPiRgSDCGBJT74FIrSm0JMZWPSnWaXNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HDbpNIpx; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HDbpNIpx"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d93ff61046so6593085ad.3
        for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 04:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789645713; x=1790250513; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0XIXiLce8oloEY4uUyIzwGoSl4i1s4G1pZ5kG8wUw3I=;
        b=HDbpNIpxrcBjqA/Chvc9mLkeMpKwsF8DsjoEjf4P9ByPYcSa0CAj8XuvTxQqcJPEkB
         8K44R7MPfB5jqamNBkOUis8qt/ibVHyCQabfYwvxdELmWLJJUIinVn2bFcri1250ipNo
         o31mQ7LBJgZPq0u2Znb0NRZIEohAQk5L/6ljujLOM14R18umYjJYCyYo4ULl+sv4UIBD
         HpnekR8lkJ98aP/K6rSKUEk7t4GvDeXqMMXk+x/otLpjahnAge60gCR4ML94s32XxiEJ
         lqlCiv9ig5FsWRQN2ycKM0LEL9niwLJYTUNh8m7K1KEAaKfaxR8/gxoWO/jjYMpLckhy
         XjSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789645713; x=1790250513;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0XIXiLce8oloEY4uUyIzwGoSl4i1s4G1pZ5kG8wUw3I=;
        b=boOcuW4tGjMPwMJtQM02qWdT1lB/UKGWaPVmqUUTtE87cNWotnhF7bGoRK96sWZhHD
         a9tBgGEncGCRGArQbFxas7ulOAsYKxCgYUKmh9Zg8lDVJ75F3fQegwiQoBEb1JjZp25N
         KojU9ApgmmhGNmiPk0Wr/gAxexW0CygI5HQnu9QoeMCHvYD7qX27Opg+GouKTx/Y97nA
         eL3l+7UQ+KG41lD/DIR6V6w4oDo+Db7QmeO1uAbQQnFPI1cyi4Yuz6TU+DsHXsJAhHw9
         kJwm9x78GFF4d8lGaGD+X5VEib2/vfe83nBdKvtAroKhJizt6tcgJd/gKPhEtlMee5YX
         TNFw==
X-Forwarded-Encrypted: i=1; AKwUvBx2ytzlqqQDaVdzI3++WGp7hr+E94J8iJiTt7QYoV8wyN+cIGRHVHH9N8BzYpF/9SJCtOY1RWyOnjrs@vger.kernel.org
X-Gm-Message-State: AFuF++mjMhBW2LusEyhWbNGa1QMjT5hNlLOsDiWIxXz+XapOLOeqBFNi
	TTsHf/nw/9ZrCHQVd+9AVyO1TRSN10hWo4yZ15YS47boKiCQufTZnvYZ
X-Gm-Gg: AYBFou0BuV46jH+0WooeoFymJOLBNe5VbaMeioNy1r+a4cacrcyZpsaK334g+hhU6sr
	EfKK8xkAviF/XCinOuAdLspGQN4oycoce51YxJ428vsEqQTWocXNjnNacnsUoEKNUbF9AWgtG4g
	svvcsjFzAUgK7bRFVxUAnfII7oqB8IhyPPSfDB7RTYEUcUo4Z7rYaH1anqhvKvX2i+7P7fcnZas
	ioXxRYRmfS2uOzgR7ypxIoW+8BspvjmqSrZX8fVkv/BZTejbNr3KtFs+FGCkvrWpQzSN88++kse
	2qtrp9/7fE8dV+YL2RiYlW2enKlMnbSGW2xbwt8mWWm4ZsSmt/MyiJ79icQ/YSrcNJnWxJu6RDG
	ai2JRK+ylevG5hipR6ylzWkTN5CMnlsrmzPGT5592O/4lLfQRVnKY1lsVH2q5uXuiEKLUBfROH2
	jRhjONuWp+LpYHF4PJ6xH5gj8NZ8uNNJ6QVuuEuHR5ee1HqBgJEEj3Ch6isN1PZcxNZoyqmI38z
	FomMQzIUONl9OPvSrE=
X-Received: by 2002:a17:902:f549:b0:2d8:d4cc:5bb1 with SMTP id d9443c01a7336-2dd8e5244bbmr129000285ad.17.1789645712939;
        Thu, 17 Sep 2026 04:48:32 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89d8e6a3sm25444085ad.7.2026.09.17.04.48.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 04:48:32 -0700 (PDT)
Message-ID: <fd49e71a-34e9-4e72-9510-1b1692bbfca3@gmail.com>
Date: Thu, 17 Sep 2026 19:48:11 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
To: Brian Foster <bfoster@redhat.com>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, ziy@nvidia.com, joannelkoong@gmail.com,
 djwong@kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-2-yi.zhang@huaweicloud.com> <aqrUGRd0JClEZNzN@bfoster>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <aqrUGRd0JClEZNzN@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/2026 1:38 AM, Brian Foster wrote:
> On Wed, Sep 16, 2026 at 05:24:48PM +0800, Zhang Yi wrote:
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
>>    truncate_inode_pages_range()
>>      truncate_inode_partial_folio()      # same_folio == true
>>        1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>        folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>        2nd split of folio2 fails / cannot lock
>>        return true                       # BUG: caller keeps default end
>>      end = 3
>>      loop truncates p0, p1, p2-3        # p3's valid tail is lost
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
>>
>> Rework the contract so the caller is told the page range to discard:
>>
>>    - Add pgoff_t *pstart and *pend out-parameters that receive the page
>>      range fully covered by [lstart, lend] after any split (or none),
>>      i.e. the pages wholly within the range and safe to discard.
>>
>>    - Adjust the ordering of the validate check when splitting folio2.
>>      folio2->index is only reliable after the reference count and lock
>>      have been successfully acquired, since it may have been split
>>      concurrently, or freed and recycled to an unrelated mapping. On any
>>      failure to obtain a reliable end position, fall back to
>>      folio->index, which is safe but leaves the sub-folios split off at
>>      the offset edge in the page cache.
>>
>>    - Rename the byte-range parameters start/end to lstart/lend to better
>>      express their semantics.
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
>>   mm/internal.h |  4 +--
>>   mm/shmem.c    | 13 +++-----
>>   mm/truncate.c | 89 ++++++++++++++++++++++++++++++++++++---------------
>>   3 files changed, 71 insertions(+), 35 deletions(-)
>>
> ...
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index b58ba940be47..bec6d881d022 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
> ...
>> @@ -259,32 +271,62 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>   		 * for shmem truncate
>>   		 */
>>   		struct folio *folio2;
>> +		pgoff_t end, aligned_end = (pos + offset + length) >>
>> +					   PAGE_SHIFT;
>>   
>> -		if (offset + length == size)
>> -			goto no_split;
>> +		if (pstart)
>> +			*pstart = round_up(pos + offset, PAGE_SIZE) >>
>> +				  PAGE_SHIFT;
>> +
>> +		if (offset + length == size) {
>> +			end = aligned_end;
>> +			goto out;
>> +		}
>>   
>>   		split_at2 = folio_page(folio,
>>   				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>>   		folio2 = page_folio(split_at2);
>>   
>> +		/*
>> +		 * folio2 may become stale due to a concurrent split or
>> +		 * freeing, so validate it before and after taking its lock.
>> +		 * If it fails, we can't get an accurate end position and fall
>> +		 * back to folio->index, which may leave sub-folios split off
>> +		 * at the offset edge in the page cache this round.
>> +		 */
>> +		end = folio->index;
>>   		if (!folio_try_get(folio2))
>> -			goto no_split;
>> -
>> -		if (!folio_test_large(folio2))
>>   			goto out;
>>   
>> +		if (folio2->mapping != folio->mapping ||
>> +		    !folio_test_large(folio2))
>> +			goto out_put;
>> +
> 
> Hi Zhang,
> 
> The only thing that sticks out to me in this version is the
> !folio_test_large() check above. If we split (or something happens) such
> that folio2 is no longer large, wouldn't it be more likely to catch it
> here and fail to update end like we do in the same check a bit further
> down after the folio lock? Maybe I'm missing something here, but it
> seems a little odd for the same condition to return two possible states
> like this. Otherwise I like the changes you've made and the rest of the
> patch LGTM.
> 
> Brian

Yes, you're right! That check should be dropped, I got myself
confused with all these complicated checks. Fortunately Jan and Zi Yan
suggested using __filemap_get_folio(), and with that I think we can
get rid of all these convoluted checks.

Thanks,
Yi.

> 
>>   		if (!folio_trylock(folio2))
>> -			goto out;
>> +			goto out_put;
>>   
>> -		/* make sure folio2 is large and does not change its mapping */
>> -		if (folio_test_large(folio2) &&
>> -		    folio2->mapping == folio->mapping)
>> -			folio_split_or_unmap(folio2, split_at2, min_order);
>> +		if (page_folio(split_at2) != folio2) {
>> +			folio_unlock(folio2);
>> +			goto out_put;
>> +		}
>> +		if (!folio_test_large(folio2)) {
>> +			end = aligned_end;
>> +			folio_unlock(folio2);
>> +			goto out_put;
>> +		}
>> +
>> +		/* Split failed: back off to the head of the straddler */
>> +		if (folio_split_or_unmap(folio2, split_at2, min_order))
>> +			end = folio2->index;
>> +		else
>> +			end = aligned_end;
>>   
>>   		folio_unlock(folio2);
>> -out:
>> +out_put:
>>   		folio_put(folio2);
>> -no_split:
>> +out:
>> +		if (pend)
>> +			*pend = end;
>>   		return true;
>>   	}
>>   	if (folio_test_dirty(folio))
>> @@ -413,11 +455,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
>>   	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
>>   	if (!IS_ERR(folio)) {
>>   		same_folio = lend < folio_next_pos(folio);
>> -		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
>> -			start = folio_next_index(folio);
>> -			if (same_folio)
>> -				end = folio->index;
>> -		}
>> +		truncate_inode_partial_folio(folio, lstart, lend, &start,
>> +					     same_folio ? &end : NULL);
>>   		folio_unlock(folio);
>>   		folio_put(folio);
>>   		folio = NULL;
>> @@ -427,8 +466,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
>>   		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
>>   						FGP_LOCK, 0);
>>   		if (!IS_ERR(folio)) {
>> -			if (!truncate_inode_partial_folio(folio, lstart, lend))
>> -				end = folio->index;
>> +			truncate_inode_partial_folio(folio, lstart, lend,
>> +						     NULL, &end);
>>   			folio_unlock(folio);
>>   			folio_put(folio);
>>   		}
>> -- 
>> 2.52.0
>>
> 

