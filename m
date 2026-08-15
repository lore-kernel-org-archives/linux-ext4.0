Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8F13BED5C
	for <linux-ext4@vger.kernel.org>; Sat, 15 Aug 2026 06:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786777063; cv=none; b=GWnBALASb4ZVlVClHDJeUZk95JU6b7eLjytGWMg97Be2Lahy6YzAfgGu7Xx4HLmN3/M+hWPemxu0wzwAYqF/gKO74xIlmAsuS7O0Fv/V7RTkQF+IO8aapHh3GVi2Z1xQR01abZygbGhNPyEbJxeB+cMnl+N6SzHFZQD52OnHvbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786777063; c=relaxed/simple;
	bh=FGfhaeq2xKFMjBFTHBJ/wj72N0xgrREq6zmCXL6Pm8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jECJUHgZdFN8d7uwsUhHQ2p1HZvib19XGfBpQvpa/2OYQWMapbhQ2CxvcFdU3AFXZS9ghnVqnXyMawcullqeARhc0faRbNvi80i96a82WATO7g6sS9sIXqB2EeSDgqZ4dQMiRgge7Qa/LLVc19Zwf28u9Sib1zhZl+zzFslgzQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EWes0d4s; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EWes0d4s"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cc97653887so29930835ad.1
        for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 23:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786777058; x=1787381858; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0+O+EXhLcJWT45f42scuWhe5FquZM52S8O6m5v2Jyxk=;
        b=EWes0d4skpGbbe9iPNs4TQK0yKJ9oAyVbcyu1fSePkiBAs3dvPnnGnyAi+uNI4iIFU
         rjIf181S5NCJHvxtPybYqERJZWmF++rwi0xl0mQXW6lgz5sVQV9jMO4Cvtbck62xtXxX
         pKpFYET1Nq/CqPaqa4J+nrtDyZKGMezkQBwvPqUiTbrGGRxk+FBcypoctquMvNBj7cNI
         KW3hKmD8khOOIDYDXpAPylmMd9C4xqNV64E9MEGlC1qo6iC3aTpm2b7T2L3gIuNL859o
         wjHkIrp8qYdTkI6oUy193uHtAMXAenDwbISZM7rMpZjMuiW6Yx24qyOF59v9LWPLgm2t
         b2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786777058; x=1787381858;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0+O+EXhLcJWT45f42scuWhe5FquZM52S8O6m5v2Jyxk=;
        b=b/Y2WDZFdQZxfs3oR6mkLZd80hmjzcKsQ6lOanqdlNqTlq7HnfkwYfOuG1ow7WUtoh
         r6zllto+Y5sP/0yzRxCAXjlwFGKBiEteuTQRRxRlfaZUmtuOZUnarHIajulkHXLo0emU
         lwnbnRYSchwk3Zd9I9C0rTbV7RSR5wu1Gsuv1P0ujQvih75Apzj0MaIUhuSRMVBGJYKk
         H5YBZv3mv7sdsuz8n0KLmneknyb1Xxgy7ulDN3JCyx4zuzPxGfGVby1AtsQAhByi/snK
         GPcP1RTlKO4p8oudGZ1sduyy9FKAZGs8+x+RAPkW6q5KhlKQKsKcQo7UgkJHQCcw98C9
         AKNg==
X-Forwarded-Encrypted: i=1; AHgh+Rp0rUJXk/gCCBzfPwB3Zwciri+hWpdQnM3f5pcfJN+pvtdmbRcU6BqT+WnJG25RlrlMaqgfTdys9aXj@vger.kernel.org
X-Gm-Message-State: AOJu0YwqMunMGQU9+n0VB2ugVM2H8WRZf0nFkt4QEJ05LHeMpDCTSp9e
	M5G4D/KHqTWKnJk04ppm46FLK1OaLWLUuMVOzmaEaO1fhhhqSCgJCHvcMDKY0dt3OY8=
X-Gm-Gg: AR+sD12/84Zatk9IdkcCVPJHLf+8JtysEteP3mZLKXFO/lbl4uRGDvo3fCijSLxo+mg
	aGSFQCyiBGI9Lj6zwnVP3jpUseyzVl/Jmk0xZ7/dAGXVCVUTnXCCtLdpcR5olAmzt2ur8b/9LZg
	dDIm///45Cbu4+26r0uO9gSZ37SIpopBzJtvchKsh4/kqUp0Sfe6AIdeAacTjXotK3Q+B9+qHSt
	nS+JBXEpE9GacO16G/TSW3tpxdhb8aNiT7tXv55JWyNvs5JqWacCb8xUMlc7hB5x7e1z+dpKNJX
	sx0zffLouqw2gbP2ECGSw+UXMVNe1NhQ02jgmfrh080b11Sr14njm894aJvYbxHBX75gLo/w4bT
	eNRF8GgigeazM+9ENAYSRgJplydnMyxUMBGp6DsmE4nPtmf8k2jmW65t7l/tJqsltqRl+OXVUjP
	QwmqbKP4PRaoPlFF0JZ6KFeM+WL1jatoIVtJx4AWx0Zaw4jFFk8bOFeuZP66/10A6JXJKVb273e
	QIcIluR
X-Received: by 2002:a17:902:f610:b0:2d3:2b8a:5007 with SMTP id d9443c01a7336-2d3b0e4378emr139170855ad.15.1786777058358;
        Fri, 14 Aug 2026 23:57:38 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3aebf17absm17255635ad.80.2026.08.14.23.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 23:57:37 -0700 (PDT)
Message-ID: <6cc8eaee-9855-4e97-8cdc-b30257a79d18@gmail.com>
Date: Sat, 15 Aug 2026 14:57:31 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 04/32] ext4: skip ordered I/O wait when zeroing
 beyond i_disksize block
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-5-yi.zhang@huaweicloud.com>
 <20260814101457.008C01F000E9@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814101457.008C01F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/14/2026 6:14 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Torn read of the 64-bit `i_disksize` on 32-bit architectures can cause the kernel to skip ordered I/O, leading to stale data exposure.
> --
> 
> --- Patch [4]: [PATCH -next v5 04/32] ext4: skip ordered I/O wait when zeroing beyond i_disksize block ---
> commit bb84de10d990ded9aab4107d18dd1616342efccd
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: skip ordered I/O wait when zeroing beyond i_disksize block
> 
> This commit optimizes ext4_block_zero_eof() by skipping the ordered I/O
> wait when the zeroed range is entirely beyond the block containing
> i_disksize. Since data beyond i_disksize hasn't been written to disk yet,
> the ordered I/O wait is unnecessary and can be bypassed.
> 
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> [ ... ]
>> @@ -4241,9 +4241,16 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>   	 * truncating up or performing an append write, because there might be
>>   	 * exposing stale on-disk data which may caused by concurrent post-EOF
>>   	 * mmap write during folio writeback.
>> +	 *
>> +	 * Ordered I/O is required only when zeroing the tail of a block that
>> +	 * overlaps with i_disksize. If the zeroed range falls outside that
>> +	 * block, the zeroed data lies beyond the existing on-disk data. It
>> +	 * will be written out before i_disksize is later extended past
>> +	 * i_size, so no stale data can be exposed.
>>   	 */
>>   	if (ext4_should_order_data(inode) &&
>> -	    did_zero && zero_written && !IS_DAX(inode)) {
>> +	    did_zero && zero_written && !IS_DAX(inode) &&
>> +	    from < round_up(READ_ONCE(EXT4_I(inode)->i_disksize), blocksize)) {
> 
> [Severity: High]
> Could this READ_ONCE() on the 64-bit i_disksize result in a torn read on
> 32-bit architectures?
> 
> If a background writeback thread concurrently updates i_disksize under
> i_data_sem but without holding i_rwsem, and the file size is extending
> across a 4GB boundary (for example, transitioning from 0x00000000FFFFFFFF
> to 0x0000000100000000), a torn read might fetch 0 if the lower 32 bits are
> zeroed first.
> 
> If 0 is returned here, round_up(0, blocksize) evaluates to 0, which makes
> the condition 'from < 0' false. Would this incorrectly bypass the critical
> ordered I/O guarantee and potentially expose stale data in the event of a
> crash?

I agree this concern is valid. The torn 64-bit read on 32-bit SMP is
mechanically possible, and the proposed condition could skip the
ordered I/O path when it shouldn't.

However, this pattern is not introduced by this commit. The existing
ext4 code already has multiple READ_ONCE(i_disksize) sites without
holding i_data_sem, such as the fast-path check in
mpage_map_and_submit_extent() and the size check in
ext4_dio_write_end_io(). i_disksize has no seqcount, unlike
inode->i_size which has i_size_seqcount.

I'm not sure whether all the unlocked sites are harmless, at least
the mpage_map_and_submit_extent() fast-path check looks a bit
problematic to me. If a torn read returns a value larger than the
writer's actual target (e.g. when another ioend worker is concurrently
advancing i_disksize from 0x00000000FFFFFFFF to 0x0000000100000000 —
high 4 bytes already updated to 0x00000001, low 4 bytes still
0xFFFFFFFF, so the reader observes 0x00000001FFFFFFFF), the fast-path
comparison skips the lock-protected recheck, and the i_disksize update
for this writeback batch is missed.

I think this deserves a separate patch series to properly fix it,
perhaps by introducing an i_size_read()-style helper for i_disksize
(seqcount or similar), and reviewing all access sites. What do people
think?

Thanks,
Yi.

> 
>>   		handle_t *handle;
>>   
>>   		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> 

