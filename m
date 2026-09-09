Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B280D3DAAA0
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 07:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788938012; cv=none; b=Wz57Q/lkE0xljZg50NKMf5M3BYoqtPgrN99sbI4bAlHbzwti3WVolo4ACCUyVVGm6rsYfl3VQbcrx96vyCy8nM2ON5i56ahB7X+hChtr+8HPza4SWxM6dt0Zo3KlAtY+XkERizuROku0+RuDR96HT5P4ndyI6rly2YhOB1e6S2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788938012; c=relaxed/simple;
	bh=LTVFBw1hSJ6M2PAwj04DsQmmsRYrojmmHyvl7FB056o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UAxUHKDMnr43JPVh6AKByayiRF6ef/AGDefNJdRaLr0f6I3ryeAFZtNBGPrdVF54w91qTprUfv1cjYBf2UUneQIm2uA3gGuYMH/TLTlhoXZd4p4OiaZ8VCB6JqDRgSJkdj9ggzKdVEow7y+XbASjogu3yu8s7nftyBXoCGb6+3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XOcVZSaV; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XOcVZSaV"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso7096445a91.2
        for <linux-ext4@vger.kernel.org>; Wed, 09 Sep 2026 00:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788938009; x=1789542809; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QBO8rVGosvhALT/C34PTNGcCszbZ+EEDDPxlTfv6RKo=;
        b=XOcVZSaVwAeE5flgYr3d76gkZI5ya7aysxMB3iNRveC2c5yX7MLvziyFQ3kQSe7wCi
         /a8d5piBWgazVaYEHah4m7Z7F8pzIcYANU+mGlTOljXOvJ6LlobERHTlPzHtnBMQNOo+
         UrJWC9NSOeRhZ5rxNrAtVoPhx4/Z4xyDpmJSW+eVR+rCPvNk9EQ1oskIujfbQzjcbQjA
         /oMBlN1oI8cUxZ2Gl/60qIJtRd8w+svtc4VvAYg79EXfzAq0oRheIdHxX0p1ue5+WIqO
         y2rB13eqzV3Bpas7Q82ToshkpB2T9QW9pC4N7vwDwvktPgAGKJZG6LGDrOY7NPWIGIv5
         Jx+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788938009; x=1789542809;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QBO8rVGosvhALT/C34PTNGcCszbZ+EEDDPxlTfv6RKo=;
        b=soqLp0dqSUL2ClSudq2xWgCJXhT0gMGC6gaeCTE91wEdYhp2PqMJeA/KWQYnBViXI9
         Debz5Qnj36+J0Oxzae9st8kahwC9sjY5ay9amZVUx/A3ta2Jggkm9dGDJiVm76wnJxdq
         2UTDf/JDXvgiEC52U+0D2o8th4hsR3PNINJ5MQ7Wgu5WtnLJx61ii6eAGxVP+q1ElEod
         9VddZoTt4m6wWWoHNYjCZ7ut5xjaE7drNlDhcMvP7tRcEIt+wQEVBjDRO8+A4GAqNt85
         QpKEsrYV6w08dGj8DPVzuTEDMIb2LaGvrKHRn2jhk/76s8RmyJ1vvN0HwQi0GkdvG4jA
         oGcA==
X-Gm-Message-State: AFuF++n/HzoA6jDfNYqoEg3qWyqDjMiREqnfmjiisZswXj6luzaIsJa9
	jWDw4DRBBgMIFS50aqxnAmVm7PoYxA8guiOjStV6z/zApwAvZNWEEcKZ
X-Gm-Gg: AYBFou2CX/dU3Fd/khtZSdjFBin7TomefacfJqYVyMDMea1h20yaU3Uz1H1A/fznFTQ
	ahqiKM+/+wTQNeZsB2HhGgM+THZE7Mt2oEVLy1fRNkoeDkzs26fghtDxPEZUo05wZphoa/LnjTP
	vaW6tlfepvEkPD30mcaWuyFCKBuNEsh7ilTacJceM7BbmhniucKsV3XMkMSWy4peA5uHY1wtOjI
	F1OQv0F79mwrEOYpyNZAcB/ot2KPN7gKr0a1ZLl8Kyoojda26wnaGrhPUSBSHbyzhxZyYoVFHEj
	7Gi3cHPTZjRY0TYwvme05/cmIl88Hh9OqwZUAdWNfvz4jrbPevSC1HycapRT++ObMVadf4hgIA0
	PNFYk1cG3/dOCUl0kVuA43KpeIz9ptQSnRATQvy/fNUYz6Dq8EWFB5hwCA1xt2dmD/Usq6iv9Lr
	XF99Zz8zkvWb4aWRqnj9ty2khwLLTpz2epiktauqHuFmgKcOcMHc9kHM8aZlMyDPgv7wmj9uZFR
	IrRW3+8sqncdKKgDjY=
X-Received: by 2002:a17:90a:1188:b0:39b:a8d8:985 with SMTP id 98e67ed59e1d1-39ba8d80b06mr4301146a91.12.1788938009449;
        Wed, 09 Sep 2026 00:13:29 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08d0d845sm37456830a91.17.2026.09.09.00.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 00:13:29 -0700 (PDT)
Message-ID: <8356eaaf-ff5e-4777-9760-3c596204fc49@gmail.com>
Date: Wed, 9 Sep 2026 15:13:22 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/31] ext4: skip block allocation for holes in the
 data submission path
To: sashiko-reviews@lists.linux.dev
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
 Zhang Yi <yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-10-yi.zhang@huaweicloud.com>
 <20260903134626.1771E1F00AC4@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260903134626.1771E1F00AC4@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/2026 9:46 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] mpage_map_one_extent() fails to check for err == 0 from ext4_map_blocks(), leading to dirty buffers being mapped to block 0 and silently overwriting the filesystem superblock on inconsistencies.
> --
> 
> commit 0c0032b57a5cee4a0ac28f30d5e6fc9a53e4e923
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: skip block allocation for holes in the data submission path
> 
> This commit modifies ext4_map_blocks() to return 0 without allocating blocks
> when encountering a hole during the data submission path. It aims to discard
> dirty bits for holes without submitting I/O.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 1473263dd82f1..81c4625de752a 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -825,6 +825,13 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>>   			map->m_flags |= EXT4_MAP_MAPPED;
>>   			goto out_handle;
>>   		}
>> +	} else if (retval == 0) {
>> +		/*
>> +		 * Do not allocate blocks for holes in the context of
>> +		 * data submission path.
>> +		 */
>> +		if (!map->m_flags && (flags & EXT4_GET_BLOCKS_IO_SUBMIT))
>> +			goto out_handle;
> 
> [Severity: Critical]
> Does this new return path create an unhandled condition in
> mpage_map_one_extent() for the buffer_head writeback path?
> 
> When ext4_map_blocks() is called by mpage_map_one_extent() and returns 0 due
> to this new logic, the caller only checks for err < 0:
> 
> fs/ext4/inode.c:mpage_map_one_extent() {
> 	...
> 	err = ext4_map_blocks(handle, inode, map, get_blocks_flags);
> 	if (err < 0)
> 		return err;
> 	...
> }
> 
> Because err == 0 is ignored, mpage_map_one_extent() proceeds as if blocks
> were successfully allocated. The zero m_pblk is then used by
> mpage_map_and_submit_buffers(), which sets bh->b_blocknr = 0 and clears the
> delay flag.
> 
> Could this result in ext4_bio_write_folio() submitting I/O to the mapped
> physical block 0 and silently overwriting the filesystem superblock on
> inconsistencies?
> 

This should not happen in practice. mpage_add_bh_to_extent() only
collects delayed or unwritten buffers into the extent to map. Hole
buffers are filtered out there and never reach ext4_map_blocks(), so
when mpage_map_one_extent() runs, ext4_map_blocks() can only return a
positive number on allocation or a negative error, never zero.

That said, I agree a defensive check is better than relying on that
invariant alone. I'll add the following to guard against an unexpected
hole.

	/*
	 * A hole? This should never happen since mpage_add_bh_to_extent()
	 * has filtered it out.
	 */
	if (WARN_ON_ONCE(!err))
			return -EINVAL;

Thanks,
Yi

>>   	}
>>   
>>   	if (!handle) {
> 

