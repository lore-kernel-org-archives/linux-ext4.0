Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749B91A9FB0
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782307818; cv=none; b=ICsj/bNNWmxAOY91waSfMPUqHyyhd1lk82epZ9jSe6N+xmx6xN8pn29bsHhZLyfhFHaKUEZUXcadlFMISouDt2eRVd2zgsTdXUH8ZNBEnQ1BW2HwukCBlkuJZ3CzHVow4iLRYU0I/z6xe8pnvbCU52g+nAYEU7aj3JZTbw4mgzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782307818; c=relaxed/simple;
	bh=x5J///5NPUcpX55tKsjGNahFZmgb6VfI1DKrdJb5DwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MnJNuA//dsgnmlbiDh9//oqZbbJMvHabvge3QHVXO5U6cyq4TSFs0/kDuNMaf/1tuHMNUSHSKPuoHpB/ho9bOF2PITNyiwqsJfdtqwIRrK218eMUcrr3CHiO8czZQNytzVW0MZ1abofL1VSHlTK0JK9tiQmJY9hwwrl2TTLp3Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IoCBCgC8; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IoCBCgC8"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e6fa36a1b6so709552a34.1
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782307816; x=1782912616; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nJMUfV0d4iL8GIoizfgvCU8470KRE9mKLUPI4sCYS14=;
        b=IoCBCgC8J/FaPjb3ZmV3dvAWFh1cGzYjQ+5K8fgyXGPNVIljDt6xT4UXEu4+cv4y/9
         DeBVwlxZMztbZL4E+e13jCkSA1IZTaJmMlCdmMHIRMpitSDY/lmLpjEtM3pF4oYITJzZ
         ABhpQmn/IAY2FgjuGE4XKCnw6sWQHVDo5MxS8IzRQHKkSSz8uBS5yLefqJwtHwUux26C
         P3Ke24y4GxblSfUQZFm53iFlm3yjnOAfAteDRVGBx0giT4F4S1zC/dqaau9JlXXI6LYk
         zN4/31Aev4CLe61zMLdaOGkSlRBQfuSa9poB6r2voQYH2Nfl3Lct6O6yPa2DwYhgDkwR
         VEpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782307816; x=1782912616;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nJMUfV0d4iL8GIoizfgvCU8470KRE9mKLUPI4sCYS14=;
        b=sRAlvy/idoNwNYQilRcupIzv/btd4huN5+LD5hvCFoGNCYKKoVRrEF53bDf9sRVWIR
         wqwMHlcR0XBoUb7P4jdLJmbbTAXVAIsaTYw1KYMnC50FiBEczc8FbEWFpjnHHimAIwDF
         bb074f79IrWGFQ4R4m1SXVvcg/FOBcDeeTqSAsqwEtAr3fpjq6mZM/qH6WbGYoJ1UtPx
         aeLDm6MvDnGdyj3nDDI18HIbi6KvxjSh7uRNLxA3jI5zYFqHSUO+4+qjYRdKSWqDcIH8
         AFowStNHuHwgZygwq4dJBk95xVX/Sws0LSX+57AcdFwvruow2gzptgwRnGl1V77H0eED
         3dEw==
X-Forwarded-Encrypted: i=1; AFNElJ9ynU9kQpPWM4049m/nnaPb2QsvR7r5J4A49K9B1Tgio/CvesJ5dt9Zlr8jzsXYSEwngUxjF45X5Aos@vger.kernel.org
X-Gm-Message-State: AOJu0YxPOhZOd0mXEv+He2/Z6qouDh8z0RgSHNo0jPf6CXQYgxcyBziN
	YFZbUhfCryBy0qJViBe//9E/GS31ZOYllYLdgBzbqq2J7H50owAipHBw
X-Gm-Gg: AfdE7cl8zntgLJQOrZ55TbDgJyzTPhu2IrqbntGeEuOK4qjlXnCG5+AXEKUHy7sFn/8
	5ikYptiM9v6UhKq7ju1E+5FaitfiLF6OxcqItyq4DOODLccbyPCooBML6YdKIvbktetXOgoVwh1
	I1vZT0jkLRfbdoay7lWC6/iXfNSZ1/KlLMC9+wtt7DKNkOQILELcUayWu9M0xWX+0/vmSfeLxfk
	xEEo2voTPkXyd7M+8gGHzRkcVtZ00ZtivO97Fyyl39J4+v50ZeFJi1sItdeNrtMJPN+FiCzVSso
	qFyG+DfWhhluch2+9c20zWJVPV9mymJcQk4lk4wsxjHL2rzRy23YKl+uO6dmFA+IdQYdgR0Tb3x
	zw4yAvzstSQt8eQVKEJLL84Q7UnKLvClfVJl0IcXRBnbqcAZSXx4x1MR5NrKDloyMk4qQ3m1QJo
	ycbiE9JwoitvWGBnctHHjCDEWIHXEaIgz6
X-Received: by 2002:a05:6830:2a0d:b0:7e7:62f:727e with SMTP id 46e09a7af769-7e986cc0cb8mr2435079a34.22.1782307816330;
        Wed, 24 Jun 2026 06:30:16 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e944008fe7sm11846550a34.6.2026.06.24.06.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 06:30:15 -0700 (PDT)
Message-ID: <7471b9cb-158a-4ed4-a1ce-95270ef38974@gmail.com>
Date: Wed, 24 Jun 2026 21:29:58 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: cancel dirty accounting for folios without buffers
To: Jan Kara <jack@suse.cz>, Zhu Jia <zhujia.zj@bytedance.com>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260623094947.7853-1-zhujia.zj@bytedance.com>
 <81ed36cc-b5c8-41cf-8b7d-16611e61e294@huaweicloud.com>
 <20260624094535.1-zhujia.zj@bytedance.com>
 <x3jm3mhgsr7zx4hvfgdvmwoqyz5vxx2fjyxy6gs6him46767f6@dkkirnw54x6x>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <x3jm3mhgsr7zx4hvfgdvmwoqyz5vxx2fjyxy6gs6him46767f6@dkkirnw54x6x>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/24/2026 8:32 PM, Jan Kara wrote:
> On Wed 24-06-26 17:52:06, Zhu Jia wrote:
>> Hi Yi,
>>
>> Thanks for taking a look.
>>
>> Yes, clearing PAGECACHE_TAG_DIRTY/TOWRITE would make the page-cache state
>> cleaner. I had a version that did this by adding a helper around
>> folio_cancel_dirty() and clearing the xarray tags after confirming the
>> folio was still the same clean page-cache entry.
>>
>> It looked like this:
>>
>> static void ext4_cancel_dirty_folio(struct address_space *mapping,
>> 				    struct folio *folio)
>> {
>> 	XA_STATE(xas, &mapping->i_pages, folio->index);
>> 	unsigned long flags;
>>
>> 	folio_cancel_dirty(folio);
>>
>> 	xas_lock_irqsave(&xas, flags);
>> 	if (xas_load(&xas) == folio && !folio_test_dirty(folio)) {
>> 		xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
>> 		xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
>> 	}
>> 	xas_unlock_irqrestore(&xas, flags);
>> }
>>
>> The reason I left the tags unchanged in this version is that I was not sure
>> whether it is appropriate for ext4 to open-code xarray tag cleanup directly.
>>
>> If you think this is the right direction, I can add the helper back and
>> send a v2.
> 
> That was a good judgement! Playing with xarray tags like this in filesystem
> code is certainly not a good thing. For now, I'd leave the xarray tags
> dangling - they will be eventually synced with reality on next writeback
> attempt. If this inconsistency of tags needs to be fixed, the fix belongs
> to the generic code (so that it can be used in other places as well).
> 
> 								Honza

Yes, I agree. Directly clearing the tag via open code is not a good
approach. However, I took a look at the !nr_to_submit branch in
ext4_bio_write_folio(), and it seems to have a similar simple handling
pattern—it directly calls __folio_start_writeback() and
folio_end_writeback(), which appears to be an elegant way to clear them.
Could we also call these two helpers just after folio_cancel_dirty()
here?

Thanks,
Yi.


