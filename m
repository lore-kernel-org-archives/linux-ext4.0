Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A3126FD97
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 00:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791593733; cv=none; b=YdIHCJBRqiSQUAFTMeUil9uyZPJBmrt46uz2X0/rh66xQ8eZsSDjsOd3QPrUVu5AHZu0Ex2bdRbYoQsQIGJ+BFY+rXimyCy/Adf8nZpGKC6tK6RxF6rrRowMOvdfMO5JXf/7Yjg8BFdf7MO6bwbAmM6mi8QvAcznn804BSZ6YHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791593733; c=relaxed/simple;
	bh=0jYbb/yhRRq8TpdEyhqaIgEEwDVeZQgf0q3aDSLfxbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lqPTviqGWJwKU6QrAmOUWkhcFOJVLaTKiXOHRWWU3f8hRLQih82I6ovlRHLTr3lcvk1F21WPx6sV+WDpROXvTFm2XYfM3zpUN3q3UenMJiIKSdz76MkiMq4j/xwRYn7lmd/EiY4UGDTXh1VPcLMtutchAA9WdMhV2BG5Tt3nBC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hqu3hIdu; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hqu3hIdu"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc52c1b8286so98191a12.1
        for <linux-ext4@vger.kernel.org>; Fri, 09 Oct 2026 17:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791593730; x=1792198530; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O3WY6TRIz4TsQZ9reS0WsRTDwlNOMeXFQmMZEMPkOS4=;
        b=Hqu3hIduZLOe6mQelfKjkg3/ttVFLKnV6TU324nadPoc1fmOtPw2vkiyOE4TLfDz/l
         Fmv9KRJ/9nnc5J+M/e4y9vmCZVB8sD88z2TkrldZTSyDUCOkXF9yt+FS9qqkRs4uast7
         Y1CnRRhoOHX456Vjv96lN4IbUjV4QhtbxJAYxTHQ7pkV76R5og2Vm3NOAg8x9FHfOxcc
         lKJvX5e3p65OwZQpZaxxEUhxrFou1gqgL5H1HBqRIe7N9d6xaZDnbqfzUBJKceFkCndG
         Dsqr5F0Zc2672p3rhSBv6wcR6OI1KqagrpgST8w2Bx/P81ogWNKUFDDNs5ytPC/2MCZq
         f2vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791593730; x=1792198530;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O3WY6TRIz4TsQZ9reS0WsRTDwlNOMeXFQmMZEMPkOS4=;
        b=2USlnexIaIa5ZRFOBUXdsfn//69h5JZTqv8eusAkC5G7oliFUnDUwaTV5Q6awVirJW
         gvTd1GMt4rmxGkSdZVGverpW4WqtHpLvkRQKKEE+OmEilv1qCHgkuJ1LoEw4qVSDPGmO
         31L/adROYymqT+iJaz7CX2f9wD7yIRqJ/6yhnMhSWvWFGWfreeJf4JU3UTB1ViWQOaUg
         JB8wsav6b/Moi1UIdNnE0Y3+q0EEDOEN7s60F/AwWd+9QyX+hIO3cl3vRpsNon7V6RFz
         6/EPwxqyWgRMjkfydOmQYTd3AiKJpewkZpKY9MTtfeiYn5p2krKuN4Za1v4eaSbvG/Xm
         FXkA==
X-Forwarded-Encrypted: i=1; AKwUvBzr5j+xkpLuRAmh2QDpgF0c1W3vj5wi42yDkuzr2N/HZuTswp4FuHPgizo0iEwiMWrl57Ji4Gm29Dn9@vger.kernel.org
X-Gm-Message-State: AFq9FYJTIhSAT/Gb+4zpta8f2jng7xiiIjwYs68Da/IX5ZW2LUhfCdsy
	L10lXnq9ZurPgQ+kP3gG/UojGBS/L33fipXrt13Fof9s/vuTxp/5mOyZa7uY1OWlm0Y=
X-Gm-Gg: AYBFou306Z5hko9SI1QX+T9s42em3m3qoDDeIYQRGqLu5gT9Vkay6naId9pKZBeeCAE
	krMUxi/q4Qu4j1rIZ+i+HQGP+gwzBlK6wsfNFAN1Gz5gyXfh+/yHZFJ+TFpj/bIWyXddsqE/kQd
	78XsLwrJTvxnvq+MSQIubBliTGTYqqx8wEvC5EECz1M5fiqDL4ynA1qVA+UXysVjgQf+Xszgfi7
	cTF2MzDNm2yE6StHkHTtY9+HhegkUxm6s6TO6yx5EUG5sD8SpmdXscDq2hfxjsC9G8jhNZpsszM
	FKCDwpXPpuBqoZyXdsFliPjpX1akQ/zE2Za4tnPHQ2AjaT/EwuJly5yUoHzp7MEq6RepvoK+23B
	lDBzwvGHeu68OqcqSSVPkv7dImdhS7zPWlQ1hrk7phUPKYHGxDzlnseJYZuLqbSSfkR5D6+D8Fs
	qbR5LjjvBWrmPwpkf+Q5wKU3I+5DKb2T4HnCYyD5EnyTeiE34sFSylxPrYNCP3vGLbZoseEBO4R
	yTtqPCS2FhjpCBJtTg=
X-Received: by 2002:a05:6a21:6e91:b0:3e1:84a4:3441 with SMTP id adf61e73a8af0-3e184a43789mr90031637.48.1791593730410;
        Fri, 09 Oct 2026 17:55:30 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e3f5acsm1769490a12.22.2026.10.09.17.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 17:55:29 -0700 (PDT)
Message-ID: <ec0668cc-cc3f-4e7e-88ac-d5bb64c56c47@gmail.com>
Date: Sat, 10 Oct 2026 08:55:23 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/31] ext4: skip block allocation for holes in the
 data submission path
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-9-yi.zhang@huaweicloud.com>
 <sashiko-outbox-165289@kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <sashiko-outbox-165289@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/2026 6:58 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] ext4: silent data loss in atomic extent conversion due to unhandled 0 return

Yeah, this is a pre-existing issue in
ext4_convert_unwritten_extents_atomic(), and Ojaswin had already pointed
this out, he will address this separately.

Thanks,
Yi.

> --
> 
> commit d986a085e4ae32e7076239e912abb3b6e2e97038
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: skip block allocation for holes in the data submission path
> 
> When ext4_map_blocks() is called from the data submission path and I/O
> end extent conversion path, it should not allocate blocks if the lookup
> returns a hole. This patch prepares for the buffered iomap writeback
> conversion by filtering out holes and bailing out with an error.
> 
>>      In the ioend extent conversion path, holes are also not expected because
>>      we should wait for folio writeback before punching hole. If one is
>>      encountered, it likely indicates a failure in the concurrency
>>      protection, so ext4_map_blocks() returns zero, and we keep warning and
>>      bail out with -EINVAL to surface the failure rather than continuing
>>      conversion on torn data. Atomic writes in
>>      ext4_convert_unwritten_extents_atomic() already bail out similarly.
> 
> [Severity: High]
> The commit message states that ext4_convert_unwritten_extents_atomic()
> "already bails out similarly" (presumably with an error code like -EINVAL)
> when ext4_map_blocks() returns 0 for a hole.
> 
> However, looking at ext4_convert_unwritten_extents_atomic() in
> fs/ext4/extents.c, it breaks the loop when ret is 0, and returns 0 (success):
> 
> fs/ext4/extents.c:ext4_convert_unwritten_extents_atomic() {
>      ...
> 	while (ret >= 0 && ret < max_blocks) {
> 		map.m_lblk += ret;
> 		map.m_len = (max_blocks -= ret);
> 		ret = ext4_map_blocks(handle, inode, &map, flags);
> 		...
> 		if (ret <= 0)
> 			break;
> 	}
>      ...
> 	if (ret <= 0 || ret2)
> 		ext4_warning(inode->i_sb, ...);
> 
> 	return ret > 0 ? ret2 : ret;
> }
> 
> If ret is 0, the expression ret > 0 ? ret2 : ret evaluates to 0.
> 
> Could this cause a regression where the unwritten extent conversion fails
> due to encountering a hole, but the direct I/O layer is told it succeeded,
> leaving unwritten extents on disk that will return zeroes on subsequent
> reads?
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 6b0489cbb1319..778cf539f6df2 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> 
> [ ... ]
> 
>> @@ -830,6 +830,13 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>>   				map->m_flags |= EXT4_MAP_MAPPED;
>>   			goto out;
>>   		}
>> +	} else if (retval == 0) {
>> +		/*
>> +		 * Do not allocate blocks for holes in the context of
>> +		 * data submission path.
>> +		 */
>> +		if (!map->m_flags && (flags & EXT4_GET_BLOCKS_IO_SUBMIT))
>> +			goto out;
>>   	}
>>   
>>   	if (!handle) {
> 

