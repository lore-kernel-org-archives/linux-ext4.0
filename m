Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431CC2AD37
	for <linux-ext4@vger.kernel.org>; Sat,  5 Sep 2026 09:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788599753; cv=none; b=nTTAC+wEKY2ufn1Q9noGqB+rjLlvhRjr/I1q455b7CvXd3bFmiY3DsFW2x+ob/2P/K7odZ2rllCIkD/KbGjZEWIKlVQwWXEJCNDbT0ubUGAMmXh+kG0F9bK5/r+cyh8w6+rb6QhRKVfpxvuN3rT0yjE/uZ1OXwXe9yb2hJ7e0Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788599753; c=relaxed/simple;
	bh=I17MN1cjrjhAf4Z1mZ/cZRutoo1DCddKqycdm0lxff4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZS4YwcVbk1DyyjDxSvF51cGOouXFpfoq2yJPSjOV2FpeW3dPE8Hf1R346iVLxZpT0eXe77uyop3bu/geAkJQ8ayVFHLt3DTQAQ4Qa7UpL2dw+sP0V/MjWyzfgJtFUK0IsXtXaDJmZ/ejli2rEvRDPKGXB2/WjlwU2C7Yaer4wfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LGXGZjNX; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LGXGZjNX"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-395cf2535acso2119339a91.1
        for <linux-ext4@vger.kernel.org>; Sat, 05 Sep 2026 02:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788599752; x=1789204552; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OkNrlvb6cnD9CuTqAczKwPY041LfREd/gnUIybiJ3Io=;
        b=LGXGZjNX0extL8MT2bzgbN3eMsPbgoOc/uAGl3OyAT4z8yYyNQQc7FWji2Rq29Xat4
         oGR47WCPb4JC4rWXUEHzxouuqSNkHOux51VFL2Lt5CmkPL3Ly/zPPiCa5D5rLpqNVsRq
         d5MPFATsXAbU6otblR7jXg717ENaXFXXY/mYp4JcJJhkXDT8cgwmgo3J5aiNxDVXY9eD
         NTolsWEK+ZNFdRWFx5hXnIanbqt1Hg0Uf7QPYjA3VtRnXjOWYTD4BsGfgyKP0KLA8qUM
         u1zyyvphMHx9s/LQ7MtZG7TnsLM1SMQf5wvlRn8Uo+gwWgc33T32Lv9bT0BYEs7H14lX
         F4Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788599752; x=1789204552;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OkNrlvb6cnD9CuTqAczKwPY041LfREd/gnUIybiJ3Io=;
        b=oIG9jAEY03+lbw5lTFdjsFTqYL/EveAWD9EHk+oXp3GLPPaW9NbcNq1DegomHHBKXW
         toulmOAqHysuQhmsWFPSOwRIq1y9krxjO8eYFLB+S844R7fDkK0j7fvB1xnUgsZyVGpE
         c3YFdMhPXCGRdzaPOztCLKTwicz3e+TFyiHFM+bWsFYxcBI6Yd4r0oLSinUF3CxwHkEE
         +qC61cRkNr4Qwk1c64cedUzKa+WBZWPIOFQKSSib3Q67emK9uy6s6tEUYsQQNOByw2rf
         4n+vnRz0YgTfQ0R8ZRAXy0YdV+XKCveKSm4y8VxsBf070bVVNWPX6uWsEKnzQjECnl3B
         vmUA==
X-Forwarded-Encrypted: i=1; AKwUvBxAZepaNkD+db/N4WmiL3WfmoseBdcm8qe3HK4mOku0qfLLAoIZ7x6tbN5MstU8hm7kcjKj5pz4ECPG@vger.kernel.org
X-Gm-Message-State: AFuF++l99TtgReBPzJ1FWZOm9KMf6NDPvuORIuFyrtUdiThrDBq13HE7
	WOT0Kmo8ovpk1PGp2OFB36K6DYiEuywVuhJPWMzKI/NNVjN8q96mmVyW
X-Gm-Gg: AYBFou10PIDP0mHpQ5gRsWNZgRT8BpuaUCXQmnqxw3kRWT9oa6YnsCS6K3afc9aGgG9
	oP4yE6P6Y+o5ktAsnTBgephIa5GWSRqUE0KwP8zah6rvoO79uHytTUxZs07VzTHIoLHcutYD/3P
	8k+/YNi1m03eSnEwf8PesFf3Iqa6DvQ4x0Y94o8krCuJ+xXMiP1DMTt3WEPFXofRM0AYutgTw4A
	vZI0/wAj8+ar8dOhO1tBLAFWT4Dz/wLIhwBkqYI83yZBq3fAAPtFixArz1Euhuo2XLzy1U25r/E
	GT20OeWu5dejKIyLljQVSfmFIt8KolKLdoNtbwk5Bg6sV5uJg3foabIGhWU/1iflKm+QTcDifKW
	pzvnrRJ0NfnN0L2T05LaK9ZUvYyVSYKqTwmwJtguxFm3p3dv56aMZX10ieZcGvOUoWjJpuCNtKh
	/mnt/jmr+s3W2XAzgNpn6epzHfMuuIlF0569GFV18+zUC+STVaSbmHBnQDCaHR8y4//a0Yx8wDf
	bRpG7wa
X-Received: by 2002:a17:90b:3a0f:b0:395:8124:ac53 with SMTP id 98e67ed59e1d1-39b27c49335mr8504502a91.6.1788599751607;
        Sat, 05 Sep 2026 02:15:51 -0700 (PDT)
Received: from [192.168.0.104] ([115.192.217.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08ca63b3sm15197402a91.11.2026.09.05.02.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 02:15:50 -0700 (PDT)
Message-ID: <4e166a3d-9012-45ab-a011-0e0ad54143d5@gmail.com>
Date: Sat, 5 Sep 2026 17:15:20 +0800
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
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <DL6S5JLBHSAB.1RL17ESZ1EK10@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/5/2026 3:31 AM, Zi Yan wrote:
> On Thu Sep 3, 2026 at 7:50 AM EDT, Zhang Yi wrote:
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
> 
> Thank you for the analysis.
> 
>>
>> Rework the contract so the caller is told where to stop instead of
>> silently truncating the straddler:
>>
>>    - Return true only when a split occurred, false otherwise. This
>>      clarifies the existing confusing return value semantics.
> 
> Should we do "return false" for not split case as a minmal fix first?
> 
> Something like below. A second patch can optimize on top of it. Let me
> know if I miss anything.
> 
> BTW, Claude also mentioned that if min_order > 0 and end is not aligned
> to 1UL << min_order, there could be some issue. So
> 
> ret = !folio_split_or_unmap(folio2, split_at2, min_order);
> 
> should be
> 
> unsigned long idx2 = PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE;
> 
> ret = !folio_split_or_unmap(folio2, split_at2, min_order) &&
> IS_ALIGNED(idx2, 1UL << min_order);
> 
> ?
> 

Hi Zi Yan,

Thanks for the minimal fix. I agree with the core observation — the
tail is only really isolated when the second split and the boundary
alignment both cooperate.  However, I'd like to point out a trade-off:
the "return false to make the caller skip the folio" mechanism leads
to an incorrect 'start' in truncate_inode_pages_range() and over-keeps
the in-range sub-folios.

The problem is that the false return value was designed for the case
where the folio is unsplit.  Look at the caller:

         if (!truncate_inode_partial_folio(folio, lstart, lend)) {
                 start = folio_next_index(folio);
                 if (same_folio)
                         end = folio->index;
         }

start = folio_next_index(folio); end = folio->index only makes sense
when folio is still the whole folio.  But after the first split
succeeds, the caller's folio reference has already been transferred to
the sub-folio containing split_at, so folio is no longer the whole
folio.

Concretely, take the commit's example: a 4-page order-2 folio
[p0 p1 p2 p3], punched from offset 0 into the middle of p3,
min_order == 0:

         [p0 p1 p2 p3]  --1st split @p0-->  [p0] [p1] [p2-p3]
         folio now points to [p0]
         folio2 = [p2-p3]              # p2 zeroed, p3 tail valid
         2nd split of [p2-p3] fails    # e.g. -EBUSY, or can't lock
		
With your fix, ret becomes false, so the caller runs:

         start = folio_next_index([p0]) = 1;
         end   = folio->index          = 0;

The truncate loop then does while (index < end) -> 1 < 0 -> nothing,
and [p0] and [p1] are left in the page cache, even though they are
fully inside the punched range and should have been dropped.

To be fair, this will not lead to any data-corruption problem because
p0 and p1 are already zeroed.  So as a minimal fix to stop the data
loss, it is acceptable.  But it still leaves the in-range sub-folios
behind and wastes memory, which somewhat reduces the benefit of
splitting the folio. So I don't think change the return value alone can
solve this problem.

What do you think?

Thanks,
Yi.

>  From 564fd753071be9d59d9e45e4609a812bb81f778a Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Fri, 4 Sep 2026 15:25:06 -0400
> Subject: [PATCH] fix unsuccessful folio2 split
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/truncate.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be474..2c575f5e61889 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -259,6 +259,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>   		 * for shmem truncate
>   		 */
>   		struct folio *folio2;
> +		bool ret = true;
>   
>   		if (offset + length == size)
>   			goto no_split;
> @@ -273,19 +274,23 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>   		if (!folio_test_large(folio2))
>   			goto out;
>   
> -		if (!folio_trylock(folio2))
> +		if (!folio_trylock(folio2)) {
> +			ret = false;
>   			goto out;
> +		}
>   
>   		/* make sure folio2 is large and does not change its mapping */
>   		if (folio_test_large(folio2) &&
>   		    folio2->mapping == folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> +			ret = !folio_split_or_unmap(folio2, split_at2, min_order);
> +		else
> +			ret = false;
>   
>   		folio_unlock(folio2);
>   out:
>   		folio_put(folio2);
>   no_split:
> -		return true;
> +		return ret;
>   	}
>   	if (folio_test_dirty(folio))
>   		return false;

