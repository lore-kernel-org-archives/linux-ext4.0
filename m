Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A570394793
	for <linux-ext4@vger.kernel.org>; Sat,  5 Sep 2026 09:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788601610; cv=none; b=a5GZiVInIZ2dqWyWaHkoOCRADVAg0CqYdErKm/Rsb0RpwmZ2SkVLoQFwM6XLhufMJPmL+aJSt4AWriwmIRS+dSUoUo2bdpSvTeZwX5oofDdSCHXqavId9jqCcVE64CIpOnkfXH6YOTdvznHwcQ7o5duPBZv2F0QA7HG29OAKgQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788601610; c=relaxed/simple;
	bh=5h19BVgXTOVPvynYPjJ8HF3hJ+Z8OBMbueCtZBJikjg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i5N21MtIte+FX/Za1rzlQGrfkEqzNRyN/1nJZik69U5TbhAFd+bAY6yjRRnx8HqIFYa8g33nJFrzJKI42EWx9j3kRz5BTia7NaXJcSoayYWMHS9kRHy0PU/nsU6mIAXoacsbM1wpKXRBMlW3sn43MpNjgyB3IrTwxyOfbTOT38M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s/zw0coH; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s/zw0coH"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-85339ed040aso1498206b3a.1
        for <linux-ext4@vger.kernel.org>; Sat, 05 Sep 2026 02:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788601603; x=1789206403; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EVsaUIOp3MDMERy1aS0TYMZktXDl9me/fb4JSc3XU3A=;
        b=s/zw0coHGIN8o74uyZhz/SZYweoJ37ZBznyBXkPQoYSMqaRAByZVjaZNzOWi1yyPOy
         H+HPd2Gi1OYudsu1UcfhYeauxNa72Ysk8KOK1g/Yu/vmQ2kDY83xkOf+v70SQkd1Iuj2
         +FsTOUbHyxr1KKv4i4olz2xv6YiOG4IQKgFVdlAo+umakRG921v7xY7k8ACyacP8THtL
         g8qveOCARKPP9vvqh9ODV/VkIi6M0409NJjlz+xk+1mVRTHTcsWyOILKhWWw7M/DQJA+
         XngGTNc/mlhuFYMuV9TjL/aCzyU6s/PutBI9uk7gGmyCucupzAxrOQHP8XUakhGY1Usp
         FYDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788601603; x=1789206403;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EVsaUIOp3MDMERy1aS0TYMZktXDl9me/fb4JSc3XU3A=;
        b=etlmuEhMS8MOSAVKOM+vRShOSRlVh27iIEYlQonA9CVlb2HI9adTETGuFJO6cHz2hE
         96T37Cv7ecQnWRMlMDDhfyYDJkLeLuv8p30S2R88539APhjH4O446qH4Sq/EO9G9dU9Q
         TUTrXxdmUJuESF1OJ69LZ/XKlAmH2TaUfypPunIdGQ4A8EBQSl32ztz4u7Lri7gQ6HHO
         BE1GKPMXb90W7hTcl5dq7hke1fDIgEXoTOJxYFU4OeiCKsKZ/Tvd8jn4Q1rHrMlVNlcU
         rAgg1ZiMuafpSFLSCPKR+HDmBykNByW2tK4EzHjZJHCCeDqZ2uQoM46MfZzFEHdXpDcj
         qkDw==
X-Forwarded-Encrypted: i=1; AKwUvBzbmTJGQU3tL1fusVTVl9RX3fOIV63B1XfCsfkTjS+DydzYLgG+XnDg5dI/aRU8lrRIanJ544EO2ky8@vger.kernel.org
X-Gm-Message-State: AFuF++lTbPA4giM/PdfPn2Xd/0flgjTP1ZJME8TqMhfhj5SgG5e/vSeM
	AZG1CfOcUD1eA4QR5jYEZ6QO7y90Lu9psalaNzICyLsFyuqNEWsiL5nz
X-Gm-Gg: AYBFou2xU2qlXPhk+p8Ha7FaFYRxfYzTtRhBRVo0iWwyXa3R9QxgbdhcrBeAFg5waI4
	urb0J7Ak6+QWU/B/E8gg6JH/lYmqInDT/BfraRNMoW8JdYLjuWGaAuD04Wx6nkTUN1ERz2o401T
	ulNg3Cj1fm0c2CIotsexzpHk37V4ZstTV14oRAFmDNpdgk6/ycjn0cVIxNbseccmK8IugkCmscE
	A6YkyYNwV+dCiZ4FewpizvUWZBBOJsx6od/hl+xo+kFWfacXfkpf02G4SS/igpOn6/gro8Ev3vP
	vgDMACEA2vX4SrzEphvR/XERNuXXDQAaR/7jLZGQh+BIgjIA8WbQtN522PTr1teYyHENiMCNcYz
	wjVco9hXG70qz3B58DxRpvX436aU8B45of5GKlMHTn4IVADQP3DRayuO921bIVDqDzIVZlL6yUR
	vg+5WtUD/cS+4MZM5fMqGg8NEn+YD0hNhiziTDMECWcox+qx9C23InxcgF48zb/oA2MYgTukROW
	FQ25/tdyA==
X-Received: by 2002:a05:6a00:2187:b0:845:e440:d0ca with SMTP id d2e1a72fcca58-86166ac231bmr15412724b3a.8.1788601603461;
        Sat, 05 Sep 2026 02:46:43 -0700 (PDT)
Received: from [192.168.0.104] ([115.192.217.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc45c62012bsm1419875a12.4.2026.09.05.02.46.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 02:46:43 -0700 (PDT)
Message-ID: <5555e6c7-5167-45ab-b1f0-f9a589d67f07@gmail.com>
Date: Sat, 5 Sep 2026 17:46:32 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, ziy@nvidia.com, bfoster@redhat.com,
 djwong@kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com,
 Zhang Yi <yi.zhang@huaweicloud.com>
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
 <CAJnrk1ZLzNQxrSLQx7TsLK89QC_=9cDfoDcyKNBNde0CiDGoNg@mail.gmail.com>
 <4e498938-f21b-4d75-b789-8a615aba877a@huaweicloud.com>
 <CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/5/2026 1:33 AM, Joanne Koong wrote:
> On Thu, Sep 3, 2026 at 11:27 PM Zhang Yi <yi.zhang@huaweicloud.com> wrote:
>>
>> On 9/4/2026 3:01 AM, Joanne Koong wrote:
>>>>          /*
>>>> @@ -259,6 +265,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>>>                   * for shmem truncate
>>>>                   */
>>>>                  struct folio *folio2;
>>>> +               bool tail_isolated = true;
>>>> +
>>>> +               if (end)
>>>> +                       *end = (pos + offset + length) >> PAGE_SHIFT;
>>>
>>> If I'm understanding it correctly, based on how
>>> truncate_inode_pages_range() uses the end value (eg the "while (index
>>> < end)" loop condition and the find_get_entries(..., end - 1, ...)),
>>> end needs to point to the start of the folio if the tail folio from
>>> the split is a large folio, in order to exclude that folio from then
>>> being truncated. But with the (pos + offset + length) >> PAGE_SHIFT
>>> calculation here, does that result in some cases in it pointing to the
>>> middle of a large folio? Maybe some logic is needed to make sure that
>>> it points to the start?
>>>
>>
>> Hi Joanne,
>>
>> Thanks for your careful review! I don't think that case can actually
>> occur. Let me walk through the scenarios where the
>> (pos + offset + length) >> PAGE_SHIFT calculation is kept as the final
>> end value:
> 
> Hi Yi,
> 
> Thanks for your reply and for walking through the logic and explaining it.
> 
>>
>> 1) offset + length == size:
>>     The truncate range aligns exactly with the folio boundary, so
>>     (pos + offset + length) >> PAGE_SHIFT points to the start of the next
>>     folio, not the middle of one.
>>
>> 2) !folio_try_get(folio2):
>>     The folio at that position has already been freed or is being freed,
>>     so there is no folio in the page cache at that location. The
>>     subsequent find_get_entries() won't find anything there.
>>
>> 3) !folio_test_large(folio2):
>>     folio2 is no longer large, likely split to order-0 by a concurrent
>>     operation. For an order-0 folio, the page index and folio index are
>>     the same, so the calculation is correct.
>>
>> 4) folio2 becomes stale:
>>     The same to case 2), folio2 is removed from the address space, so
>>     there is no large folio straddling the boundary that needs
>>     protection. The caller won't get folio from here through
>>     find_get_entries(). Using the page index is safe here.
>>
>> If a large folio straddles the boundary at (offset + length), we will
>> successfully get a reference via folio_try_get(folio2) and
>> folio_test_large(folio2) will be true. In that case, if the split fails
>> (cannot lock or split operation fails), we set tail_isolated to false
>> and set *end = folio2->index to point to the start of that large folio
>> since tail_isolated.
> 
> The case I have in mind is the case where the 2nd split succeeds
> (returns 0) and tail_isolated will not be set to false, and *end still
> gets returned back to the caller as the original "(pos + offset +
> length) >> PAGE_SHIFT" calculation. I don't think it's guaranteed that
> the split will create a folio that starts at that page.
> 
> The example I'm thinking about is a 64k folio being truncated at
> offset 0 to 36k on a 16k blocksize filesystem with 4k pages:
> *end = (pos + offset + length) >> PAGE_SHIFT = 36k >> PAGE_SHIFT = page index 9
> start: [0 - 15]
> after 1st split: [0 - 3] [4 - 7] [8 - 15]
> split_at2 = 36k / PAGE_SIZE = 9
> 2nd split will try splitting [8 - 15] at split_at2
> after 2nd split: [8 - 11] [12 - 15]
> 
> in the truncate_inode_pages_range() logic, start = 0, end = 9, so
> find_get_entries(..., end - 1 (= 8) ...) returns the [8 - 11] folio
> and truncate_inode_folio() will drop all 4 of those pages (including
> 36k to 48k which might have dirty data).
> 
> Do you think this makes sense or am I missing something?
> 

Ha, indeed, thanks for pointing this out.  The second split only
isolates the tail when the boundary is min_order-aligned, otherwise
the straddler still remains and the valid tail gets dropped.  So this
problem is not only triggered when the second split fails and I've
reproduced this scenario. :)

>>
>> The page index from this setting is only kept when no large folio exists
>> at the boundary, which makes it safe to use. What is particularly
>> noteworthy is that for cases 2 and 4 above, aside from setting it to
>> (pos + offset + length) >> PAGE_SHIFT, there does not seem to be any
>> better alternative.
> 
> I think if we just rounded down *end by the min order (eg *end =
> round_down((pos + offset + length) >> PAGE_SHIFT, 1UL << min_order);),
> that would ensure end is always on a folio boundary and can't be
> inside a folio.
> 

Yeah, rounding *end down to a min_order boundary looks good to me.
I'll update the patch accordingly.

Thanks,
Yi.
