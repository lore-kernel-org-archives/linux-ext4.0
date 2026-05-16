Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291267E0E8
	for <linux-ext4@vger.kernel.org>; Sat, 16 May 2026 01:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778894763; cv=none; b=JmX3kewFHg0nP/3OLKY6D8pLqr+M7VFMK3VSBIPWfImH82GZ1GrNtN6WVlGp7YTzvgjJJuP+DJnoeQJIXS0YsRhtux6URosTKXUbMxlmvAbitDEncehYHytWaPU2v+nkq9fcNLoeExMg/mnD3HzBSDeJFlyuZR5rFZTPjuGY1Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778894763; c=relaxed/simple;
	bh=MEZ68kwKCC8EHqZj2zj3xswrag63f6k9ANsxd/vD/BE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GjIBIub5gXOH/aRdAsH+fdDawRcdwp/lf+a+HKDeByltfljWev6ma015wYC3ub60DYeDthlOlOGYZipwjDb4DlC5Wd0/V+9V4HPxcD1gTsADQLXj3iMBPoCYSZeydD+Z8Ri+QuC7Bl0rYNfg6o0gc0+P7djH4VgOwdPDL17zaqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FHLjzJ0f; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHLjzJ0f"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b788a98557so2789245ad.2
        for <linux-ext4@vger.kernel.org>; Fri, 15 May 2026 18:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778894761; x=1779499561; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EFPC/Xcl2WFN8rwI0P0COPsYNbJtWPXKF5O2rhC1GJk=;
        b=FHLjzJ0fvrQwB3SDt37Eds9Ct6zwHKv5Z+23xfBOVp8stlmCc0hPMUw7vPVMcSEijn
         O1c4mBdP5Wonc5rPf9KIAevdNTSigi7qUYNQEfdIc/UbVlS8QeWrHrSJ+jOcT8qPyzKK
         xL22FfHA+N2CQM+9t6lENqn4ljKzgZe1cDmHRy6fkAdx0BNd3dQ8GQryLGEx7iV7EmRX
         MqWwMpyXO0/XjruF6BysENcWH5Z7c7CFpVFbzjn2oEilzrEiOtsyKYx0tbyfVHDCgieg
         rP2NtX9Z6OVkyJ39l/MpmVdkxM5OQ6ItNPO6NROiCj+s/MhAzd0j5pl5xmWbA5kImmWF
         A9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778894761; x=1779499561;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EFPC/Xcl2WFN8rwI0P0COPsYNbJtWPXKF5O2rhC1GJk=;
        b=FOjckXeJsOAT0bXJutb1ZEDwAuqwoBJOc8fqsbpe7dAny9w8uaj9GPgJ7DTb+cqZNV
         BSPKPir1ayoe7a5zDMWiDlvCneffzzU/pLq+usvCXWWzMPcUfYAn2toUZArdoWJiqh2C
         ng3WbNIXfPxP8qXwCHBk9rm0qH4iFFBwV2RO+v0qrA/tY5hsT++pIZyFeRmFItJQNC9H
         h87yLtIToCJWDMMstM5Edvo7E0/43lfT70NhSKPHoCUdM4L9RFQL5JWsoSeRYjQ56Tva
         u/rqnCnZKBFCnq8sw9jraZ5GkeHY8/o8X7SsfyiNGeFv6W4NZAofAWBd8QXjq+yIBQar
         pxmg==
X-Forwarded-Encrypted: i=1; AFNElJ9bfYaoJxf0SzlEvRkapjcwvXQCaAFj56picE/L3aUhHbONP/ynrzPmHG6v8Ck/ILyP+j+0hCJFWagZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6PRqdom/rwW0TNCoR5sTzogiU3IxwDTCC5TChZhI5a632YtQ3
	mYxN5PIC9qK8UKOhK8UNZiJNOsvPP6kgqFQJ8+10ZtCxqa/MayTmft1flpWjKl5xuOo=
X-Gm-Gg: Acq92OFUNYMo1egCzTkfo6O/5qAIxFvL5N3cGDMhZPrkry3a21FDm057J+gfMlZZq8r
	hAZA7fZEQdPAWTyIJPwOVuGXA9C1mpCfBbNpxypWNAx0AXgiDhhnJUGj0G46E7jhoGFHrqTfQTs
	qN/3b1OBuJwXpqkoDm1vgcFVq5WW2D3DgMVjpkUw/jDr9Zuh1r+SLaWorxnSs+7X3w3gvfjU5FG
	G9I40eAH7SrcZvpDWTafNgqciQ/NNAqV71kOIXzLUf6rD+m54AFq8WXD1deoioAMUlXIE6mrMUs
	QUJxDWIXkFYB80g/S35QCBotqBTeqecpZWVIMolLyg0mLBCxwEXdQfKeQetAkKxTWWVlGNv9Nuu
	tkPtkpmYT+f5q5BOy4a06hI6Ya1su8J9A5/TZlhL9JUaC/MZbanh6wdL6v7msPDOhUbFzjFBgLl
	BTN+GD2JuEx3/3vAZvNSPa9HX0XUN5+UsFEV0HxQ+DlYFVFCdLM5a3Zh/8mWZlzKhaTfWHMadpz
	Lcyvlhty1PX
X-Received: by 2002:a17:902:c406:b0:2b7:a1ff:b239 with SMTP id d9443c01a7336-2bd7e847effmr71079255ad.14.1778894761379;
        Fri, 15 May 2026 18:26:01 -0700 (PDT)
Received: from ?IPV6:240e:390:a90:65b1:e178:1161:7933:b819? ([240e:390:a90:65b1:e178:1161:7933:b819])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5c2631basm68606755ad.34.2026.05.15.18.25.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 18:26:01 -0700 (PDT)
Message-ID: <e1baee3e-a90b-4004-9d5e-ba7b9d6791fc@gmail.com>
Date: Sat, 16 May 2026 09:25:56 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] iomap: fix out-of-bounds bitmap_set() with
 zero-length range
To: "Darrick J. Wong" <djwong@kernel.org>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, brauner@kernel.org, hch@infradead.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260514062955.1183976-1-yi.zhang@huaweicloud.com>
 <20260514062955.1183976-5-yi.zhang@huaweicloud.com>
 <20260514181053.GB9555@frogsfrogsfrogs>
 <827c4380-4251-40af-bc14-207111736464@huaweicloud.com>
 <20260515173047.GC9555@frogsfrogsfrogs>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260515173047.GC9555@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/2026 1:30 AM, Darrick J. Wong wrote:
> On Fri, May 15, 2026 at 09:50:08AM +0800, Zhang Yi wrote:
>> On 5/15/2026 2:10 AM, Darrick J. Wong wrote:
>>> On Thu, May 14, 2026 at 02:29:55PM +0800, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> ifs_set_range_dirty() and ifs_set_range_uptodate() compute last_blk
>>>> as (off + len - 1) >> i_blkbits.  When off is 0 and len is 0, the
>>>> unsigned subtraction underflows to SIZE_MAX, producing a huge
>>>> last_blk and nr_blks value that causes bitmap_set() to write far
>>>> beyond the ifs->state allocation.
>>>>
>>>> Regarding ifs_set_range_uptodate(), it is temporarily safe because len
>>>> cannot be passed in as 0. However, for ifs_set_range_dirty() this is
>>>> reachable from __iomap_write_end(): when copy_folio_from_iter_atomic()
>>>> returns 0 (e.g. user buffer fault) and the folio is already uptodate,
>>>> the guard at the top of __iomap_write_end() does not trigger because
>>>> !folio_test_uptodate() is false, and iomap_set_range_dirty() is called
>>>> with copied == 0.
>>>>
>>>> Add a !len guard to both functions before the computation, so that a
>>>> zero-length range is a no-op.
>>>>
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>> ---
>>>>   fs/iomap/buffered-io.c | 23 +++++++++++++++--------
>>>>   1 file changed, 15 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>>>> index 27ab33edbdee..6fe5f7e998fd 100644
>>>> --- a/fs/iomap/buffered-io.c
>>>> +++ b/fs/iomap/buffered-io.c
>>>> @@ -67,11 +67,14 @@ static bool ifs_set_range_uptodate(struct folio *folio,
>>>>   		struct iomap_folio_state *ifs, size_t off, size_t len)
>>>>   {
>>>>   	struct inode *inode = folio->mapping->host;
>>>> -	unsigned int first_blk = off >> inode->i_blkbits;
>>>> -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
>>>> -	unsigned int nr_blks = last_blk - first_blk + 1;
>>>> +	unsigned int first_blk, last_blk;
>>>>   
>>>> -	bitmap_set(ifs->state, first_blk, nr_blks);
>>>> +	if (!len)
>>>> +		return true;
>>>> +
>>>> +	first_blk = off >> inode->i_blkbits;
>>>> +	last_blk = (off + len - 1) >> inode->i_blkbits;
>>>> +	bitmap_set(ifs->state, first_blk, last_blk - first_blk + 1);
>>>>   	return ifs_is_fully_uptodate(folio, ifs);
>>>>   }
>>>>   
>>>> @@ -203,13 +206,17 @@ static void ifs_set_range_dirty(struct folio *folio,
>>>>   {
>>>>   	struct inode *inode = folio->mapping->host;
>>>>   	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
>>>> -	unsigned int first_blk = (off >> inode->i_blkbits);
>>>> -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
>>>> -	unsigned int nr_blks = last_blk - first_blk + 1;
>>>> +	unsigned int first_blk, last_blk;
>>>>   	unsigned long flags;
>>>>   
>>>> +	if (!len)
>>>> +		return;
>>>> +
>>>> +	first_blk = off >> inode->i_blkbits;
>>>> +	last_blk = (off + len - 1) >> inode->i_blkbits;
>>>>   	spin_lock_irqsave(&ifs->state_lock, flags);
>>>> -	bitmap_set(ifs->state, first_blk + blks_per_folio, nr_blks);
>>>> +	bitmap_set(ifs->state, first_blk + blks_per_folio,
>>>> +		   last_blk - first_blk + 1);
>>>
>>> I'm curious about the inconsistency in the computations between
>>> ifs_clear_range_dirty and ifs_set_range_dirty now.  In the function that
>>> clears dirty bits, off/len are rounded inwards:
>>>
>>> 	unsigned int first_blk = round_up(off, i_blocksize(inode)) >>
>>> 				 inode->i_blkbits;
>>> 	unsigned int last_blk = (off + len) >> inode->i_blkbits;
>>> 	unsigned long flags;
>>>
>>> 	if (first_blk >= last_blk)
>>> 		return;
>>>
>>> 	spin_lock_irqsave(&ifs->state_lock, flags);
>>> 	bitmap_clear(ifs->state, first_blk + blks_per_folio,
>>> 		     last_blk - first_blk);
>>>
>>> but here we're still rounding outwards:
>>>
>>> 	if (!len)
>>> 		return;
>>>
>>> 	first_blk = off >> inode->i_blkbits;
>>> 	last_blk = (off + len - 1) >> inode->i_blkbits;
>>> 	spin_lock_irqsave(&ifs->state_lock, flags);
>>> 	bitmap_set(ifs->state, first_blk + blks_per_folio,
>>> 		   last_blk - first_blk + 1);
>>>
>>> That doesn't quite sound right to me without an explanation in the code,
>>> which currently lacks one.  I *think* the reason for the discrepancy is
>>> that if we want to dirty part of an fsblock, we need to mark the whole
>>> block dirty in the ifs so that all the blocks get written out; but when
>>> we're clearing dirty bits, we want to leave an fsblock dirty if we only
>>> wrote back part of that fsblock.  Does that sound right?
>>>
>>> --D
>>>
>>
>> Yes, that's right. The primary purpose of clearing the dirty bit is for
>> invalidating a partial folio(e.g., when punching hole). Only when a full
>> fsblock has been invalidated can its corresponding dirty bit be cleared.
>> Write-back operations never seem to write back only part of a fsblock.
>>
>> I can add comments for them in my next iteration.
> 
> Sounds good, thank you.
> 
> (Does this patch also need a fixes tag like Joanne asked?)

Yeah, I will add it as well.

Thanks,
Yi.

> 
> --D
> 
>> Thanks,
>> Yi.
>>
>>
>>

