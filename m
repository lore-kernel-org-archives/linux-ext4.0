Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1E93E95AE
	for <linux-ext4@vger.kernel.org>; Mon,  7 Sep 2026 03:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788751629; cv=none; b=llkjIyE+KfARyKNSbIWcJB2akteOV7aA5gLd4pLVxn3IQbPTSVRDU8ZNmhGATz5iK/pw7sRwQIMH9D6Gye3kp33ycemUMsiCzeU5zWIS3tGiCUo26koS+gIlg4sPk+1IqG65qDHzChNbUCQZSU8VqiCO28n/Xbi852cS4PnYZgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788751629; c=relaxed/simple;
	bh=yk2USMN6xn7rtSobYMSh6D8SwjA1pdVYQpd+ejOF9u0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G1SlvrVW30QkGj0KjI9qedsSx/odQfEpayTgUVWZb8crFFKiRL5YYNe/oSK6RXF221K24dMGVp2q0pbOxZdfWxtDFAsJ/rO+tWy1D3rL3dsDM35e8N4Htc+faxU8GCTjfrfUVs+NoM76KWiN1A1B6fkCUc52a8p9HYYYbh7i52w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LkdJw/go; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LkdJw/go"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8525efa7274so1901744b3a.2
        for <linux-ext4@vger.kernel.org>; Sun, 06 Sep 2026 20:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788751627; x=1789356427; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K26RqE9msRMaYisynjOqHw8QIY6pFVDP0+pz+DXoGQ4=;
        b=LkdJw/goSp42DKJ5rU/XC4sH1ImNWM2aZWJNSmJWDG62TCVK8A25c+FgIyBK8Da9RA
         6mcbv7s7oslSTxUFeR3AsfT8mD3s1GU0LUVvx1JeROKfFC0OofDgSdfmSM9VcAIZ0uTh
         SbigjRB1/4/bQ0h3oq426YO7SCX3H8VyhUHKAo3Zmhetn2kb769qpKN0ksGZzQNSePBg
         ZmFrhlw8nvY7Ut8Qj08zhchB1/mTmCEth7phm7BS1R3t9DGEvSTlHgT1XGah++lmLeR1
         bCoxnkcYICvNHoIxmy6j2IxSJMEkc9zAISZIaJ2Y73zdUe6NWeflbHd09nTOj7/mmyFG
         Mtbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788751627; x=1789356427;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K26RqE9msRMaYisynjOqHw8QIY6pFVDP0+pz+DXoGQ4=;
        b=neQI4AfTJmQk12TMibXGsXrjsb/4JF7MkiHymLzPkfAbwksPZCVVUL3ivK7EViYQCq
         dsZMIQ9D6XTKSCrSMPg5zBqamuSVJjOn5DuR8eaNte2uKGNGI3dL3JXlBOH42D5Ullmw
         rurPrTNG4XepENnUjnDHg4nLU2aJiXn8jd6QIwRdmUJUdQ3e/YJvOoC2DYL0Mmh1Eely
         oBCIWlA1PeT7u6sZlLANw1+rz0PHTAE/2MUgSLOjW/EHqbhVjKbcK0YjCa0Vwd1U1LGl
         IGP2CHooiFVSGWT9jJ/mWl+tRtfRgmvr81qlbOJc7EWiDmLU9oIJEAEe/v3sRSmL6q7Q
         Q1+A==
X-Forwarded-Encrypted: i=1; AKwUvBycht67PdLhfbiMNlIb550Zn+UHqlTnupSBlZ0T9febzAkaJCZauFzV7JpqR0ybs2UXCcsReG6EDtvK@vger.kernel.org
X-Gm-Message-State: AFuF++lnc4sY8OlH3BAxeibjHGKH3DLCVnnHr4vt/gcifyqD3hWHsLdN
	Pubhy8VRNUi3yyNPGsyDhau8ad1EBxLSPJp7pNTdga2xJvAeA0JDVgbZ
X-Gm-Gg: AYBFou2/Ka5JYkmrBOZ6cET+D07jpuAE3bUrnb9d/0yi9iyRHM+ZD7o87nNOWrajEuH
	YkxdC0WD5+fmA/z9a8kXVgocpsOz2VmAZvmxtq0vUGvLtKu8Iu7Wi99au4s5AIpeoYVuAtCTe5h
	OQKiApwj4uwE9FmkQa3outCTWnUYPi5329ZTQg/JNPI2nSOpDpzltfdDmEzkMF2CN1iiazv2nb/
	/MhDjMEU0fkMY8cEzNNXz0ROhqKnrxUP3wOF9dJby2D1A0aVzPNkVjTZt0AkDNt74dvqQSKwFCD
	Oti/HttQkw1zZ3fM+tFYTU5g9kwaV8E4pliU4l7qjZzuqILX3UxQ7vVjWrJd+uocE+IkxSOZ7Rv
	FCVrkOJ2ExqIKR7au2VDz9SFNOH78tXqGqUcCPU8gzDkKram4LP7Xsqig3cOX7cXavqshPKUvtA
	LESY0SgW6nShH1/Vu8lcGi1KCKaHX09+PvKDHpmtedrVbY7vJxh0qgnyG6Cy1taCb1Y3UZABWfC
	M5N5krF2i2L4ncvoxU=
X-Received: by 2002:a05:6a00:1151:b0:85d:84a5:b7bb with SMTP id d2e1a72fcca58-86168d8c2fdmr27300269b3a.18.1788751626985;
        Sun, 06 Sep 2026 20:27:06 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-861527382f0sm3732954b3a.24.2026.09.06.20.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Sep 2026 20:27:06 -0700 (PDT)
Message-ID: <9974bf2a-606b-432d-95ac-2f05f3fa9953@gmail.com>
Date: Mon, 7 Sep 2026 11:26:49 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
To: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-ext4@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hughd@google.com,
 baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
 bfoster@redhat.com, djwong@kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com, Joanne Koong <joannelkoong@gmail.com>,
 Zhang Yi <yi.zhang@huaweicloud.com>
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
 <DL6S5JLBHSAB.1RL17ESZ1EK10@nvidia.com>
 <4e166a3d-9012-45ab-a011-0e0ad54143d5@gmail.com>
 <DL7E27LHUEXZ.3B86XR1QN6PP5@nvidia.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <DL7E27LHUEXZ.3B86XR1QN6PP5@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/5/2026 8:41 PM, Zi Yan wrote:
> On Sat Sep 5, 2026 at 5:15 AM EDT, Zhang Yi wrote:
>> On 9/5/2026 3:31 AM, Zi Yan wrote:
>>> On Thu Sep 3, 2026 at 7:50 AM EDT, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> truncate_inode_partial_folio() splits a large folio so that the caller's
>>>> truncate loop can drop the in-range sub-folios while keeping the
>>>> out-of-range tail. The first split at the punch start edge is
>>>> non-uniform, which leaves the sub-folio at the truncation end edge as
>>>> large as possible, this means it may still straddle the range, holding
>>>> both zeroed in-range and valid out-of-range data. The function then
>>>> attempts a second split at offset + length to isolate that tail.
>>>>
>>>> If the second split fails the straddling sub-folio stays merged. The
>>>> function returned true unconditionally on all exit paths of the success
>>>> block, telling the caller it was fully handled. The caller kept its
>>>> default end and the truncate loop truncated every sub-folio below it,
>>>> including the merged straddler, discarding the valid out-of-range tail.
>>>>
>>>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>>>> of the last page:
>>>>
>>>>     truncate_inode_pages_range()
>>>>       truncate_inode_partial_folio()      # same_folio == true
>>>>         1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>>>         folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>>>         2nd split of folio2 fails / cannot lock
>>>>         return true                       # BUG: caller keeps default end
>>>>       end = 3
>>>>       loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>>>
>>>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>>>> folio_split() in truncate operation") replaced the atomic split_folio()
>>>> with folio_split(), whose non-uniform split can partially split a folio
>>>> and leave the end edge merged.
>>>>
>>>> It has gone unnoticed because a dirty large folio normally carries the
>>>> filesystem's private data, for example buffer_head, so
>>>> filemap_release_folio() -> iomap_release_folio() returns false on a
>>>> dirty folio and folio_split() aborts with -EBUSY before any split,
>>>> leaving the straddler safely unsplit. The bug is only reachable on paths
>>>> that produce dirty large folios without filesystem private data, and it
>>>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>>>> attached.
>>>
>>> Thank you for the analysis.
>>>
>>>>
>>>> Rework the contract so the caller is told where to stop instead of
>>>> silently truncating the straddler:
>>>>
>>>>     - Return true only when a split occurred, false otherwise. This
>>>>       clarifies the existing confusing return value semantics.
>>>
>>> Should we do "return false" for not split case as a minmal fix first?
>>>
>>> Something like below. A second patch can optimize on top of it. Let me
>>> know if I miss anything.
>>>
>>> BTW, Claude also mentioned that if min_order > 0 and end is not aligned
>>> to 1UL << min_order, there could be some issue. So
>>>
>>> ret = !folio_split_or_unmap(folio2, split_at2, min_order);
>>>
>>> should be
>>>
>>> unsigned long idx2 = PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE;
>>>
>>> ret = !folio_split_or_unmap(folio2, split_at2, min_order) &&
>>> IS_ALIGNED(idx2, 1UL << min_order);
>>>
>>> ?
>>>
>>
>> Hi Zi Yan,
>>
>> Thanks for the minimal fix. I agree with the core observation — the
>> tail is only really isolated when the second split and the boundary
>> alignment both cooperate.  However, I'd like to point out a trade-off:
>> the "return false to make the caller skip the folio" mechanism leads
>> to an incorrect 'start' in truncate_inode_pages_range() and over-keeps
>> the in-range sub-folios.
>>
>> The problem is that the false return value was designed for the case
>> where the folio is unsplit.  Look at the caller:
>>
>>           if (!truncate_inode_partial_folio(folio, lstart, lend)) {
>>                   start = folio_next_index(folio);
>>                   if (same_folio)
>>                           end = folio->index;
>>           }
>>
>> start = folio_next_index(folio); end = folio->index only makes sense
>> when folio is still the whole folio.  But after the first split
>> succeeds, the caller's folio reference has already been transferred to
>> the sub-folio containing split_at, so folio is no longer the whole
>> folio.
>>
>> Concretely, take the commit's example: a 4-page order-2 folio
>> [p0 p1 p2 p3], punched from offset 0 into the middle of p3,
>> min_order == 0:
>>
>>           [p0 p1 p2 p3]  --1st split @p0-->  [p0] [p1] [p2-p3]
>>           folio now points to [p0]
>>           folio2 = [p2-p3]              # p2 zeroed, p3 tail valid
>>           2nd split of [p2-p3] fails    # e.g. -EBUSY, or can't lock
>> 		
>> With your fix, ret becomes false, so the caller runs:
>>
>>           start = folio_next_index([p0]) = 1;
>>           end   = folio->index          = 0;
>>
>> The truncate loop then does while (index < end) -> 1 < 0 -> nothing,
>> and [p0] and [p1] are left in the page cache, even though they are
>> fully inside the punched range and should have been dropped.
>>
>> To be fair, this will not lead to any data-corruption problem because
>> p0 and p1 are already zeroed.  So as a minimal fix to stop the data
>> loss, it is acceptable.  But it still leaves the in-range sub-folios
>> behind and wastes memory, which somewhat reduces the benefit of
>> splitting the folio. So I don't think change the return value alone can
>> solve this problem.
>>
>> What do you think?
>>
> 
> Understood.
> 
> Alternatives are changing folio_split() to make sure folio2 is split.
>  From weakest guarantee to strongest guarantee:
> 
> 1. make folio_split() return with folio2 locked: but others can still
> put a ref on folio2 to fail the subsequent folio2 split.
> 
> 2. make folio_split() accept two split_at, folio_split() does both folio
> and folio2 split internally: but if folio2 split require an xa_node and
> the allocation fails, folio2 split can still fail.
> 
> 3. make folio_split() accept two split_at and preallocate two xa_node
> upfront: this should guarantee folio_split() to either split both folio
> and folio2 or split nothing, but it specializes folio_split() for
> truncate.
> 

I'm afraid even guaranteeing a successful folio2 split is not enough
here. As Joanne pointed out [1], when min_order is not 0, even if folio2
is successfully split and returns true, the folio remains a large folio.
In the outer loop, 'end' still cannot point to the head of the split
folio2, so the entire folio is still incorrectly dropped as a whole,
losing the valid data at the tail.

[1] 
https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com/

> I guess for now it might be better to make truncate to handle the
> folio2-not-split situation.
> 

Yeah, agree.

Thanks,
Yi.
