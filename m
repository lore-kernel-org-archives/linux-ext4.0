Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE5F47F3D1
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 07:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791962101; cv=none; b=CAGzIdic49Y6HdLaduauKGlvn0VT7qn6QHt/zPv3Oq6c6YJB/OPD1wapcNVlGZlpSQnOJ6tANSaViAANAxu6TLMfXolcvDtgUD+uF0W6UnP4mOmbrEdorSUdXwlXOmWSnMyRRceCPVzkFNFGaIHn2mli3g5HIqJbzETdrNIsv+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791962101; c=relaxed/simple;
	bh=1Lwf+hhmpw3w8k79pyJRhisqrrz0H2X4UofZTveLYwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ds/fNbzv5Ou0TsJZuzT8ML3WNOm0w+DiFA6zmayLmkJQlWYli1EmuCakys7KI5MiRmUX2cnise7mseVT+YFTbaDGhP4j+t6wuYwXMbTc1fp8XmUMlnWcae1v8g4BlXSe1NAx5WDd8LKx2ZS7lzJR6DFmSMnjtEE0qAzqZbAjGmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QxTKIiSe; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QxTKIiSe"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3ab9268d90eso1883641a91.3
        for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 00:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791962093; x=1792566893; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3mxOyqRIlc5Dtk9kMZ9pDtG3G34SgarEZsbcWS6t2oE=;
        b=QxTKIiSevA+HqhKf7jA/LQXpwAmTHSYRrQSbrZwk7Hsw4Ga0mnONrlEs8CFkuMPYU5
         tIzsBkaib+WHtCb1QOiIdGQsHY32HP6sxjMDQ9ekR9HrythUBZOSi/dNnaOmvHtKPaGs
         EmbOLfeAwGFjv5ShtF4x24+3XErD6cPwDZS1rHX86RZJ8hYeD6ut4M6k0MFp4v9YRr8d
         yQCK9T+3r7U5NpjJkxFsSlIftSQWlnJUBZ1hPsXhekY14Ij0xOgz5SZqDzajJ8MB1T4b
         894u1vsDkAlraNi65DX/fPCRJWjFTbBxZ5MZeeueisFY98f6YscyRtSYklEwJphe6yY8
         MuoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791962093; x=1792566893;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3mxOyqRIlc5Dtk9kMZ9pDtG3G34SgarEZsbcWS6t2oE=;
        b=iQqL4JdzPogaurRrkfjLw08C/g7G8CnhXqnukONMeqIybVSzoo4REkm6eV3xOaqHKc
         ldJcAsiFAPUAg4sa/OAFZRUvm5meCdcyjyQy5gOaWGBos9YFkLfYpSGqfw8OA9pO/Vi4
         OhgM4/OrqELUVqIT8oSIJyjyFBGac1x50WlLK0zl0r0F4+2maSdREhneG1LXS4elDsRt
         N0lPMSqPMkbjJPDCE1u1V6BQHD51ayFeZy9ywKHwVtGGarY0UdbFP1hLm5W6Ed7QH+l/
         vz8AO9LJEAbwQSI2R2frjVMnKgx6i2o1/K5aNSV7QP+Aa7eyQaKqMUF8cZ++mQDSnyrQ
         I9/Q==
X-Forwarded-Encrypted: i=1; AKwUvBxUQlKg56CerfxmFjOK9gM0BVWLEfbqB52LDsyV4croxOlwAqYvHBayxGp0SX/etWm8hJAX8fu4wV3x@vger.kernel.org
X-Gm-Message-State: AFq9FYIXHYieXIS1QtxHJ8ZWxBBz8HuwAUdXmgkuh9YBFCRJemHGIdEY
	VUPF3YF81dTHKJJbrPO4ghDnHruy9dH5Ptc/fDqH25+GmUs1l5TmPGh+
X-Gm-Gg: AYBFou1QczXsVeoLIU/g95RAHXBRN47lYSk3xtyn1j9NNU8x+ofEAqFOqCDs3VcO8SM
	x/iBE8JD7zLvcS8lQgNw2RR+vpB1K3YhZNN/qRVxMgrIBfDamozrCjlBBXozsC7nOo+BvLsJo+p
	bJMymNIN8PrL/Zhp0dMAsRU8wFYNe5aeMpw9451WU3FmtvxaZ/95lE5NdWEn1P2M26vDGeEOnoJ
	5lEfnTSKIGsuP0PtssUlDt6HkGXUzPIk+OM05bZpBEakizyNzUiI2lfZg/8vzHREwQLFAx52Nhj
	g3ay0JRA8iZ6P8WogWGi8IQKg+3VaFORViVsQIADJULb7OaXm3vUdopRf3/1amZauxy6QksZ05R
	cbxxJWJYsDcgXyS6oROWqhY1Qaph/oBJXnM+mVGeykC08aPUVsP2o+REUciD3mj2JWOTuBVpXZv
	Ujiy48BLwdwXNKKK1r7PRsEjaIDavSlsXuhK8l+sPMzekdyTSOTbIhDEJtIOESoG6vzfSH2/n0c
	6x3QyGEovp2GcwwWp8=
X-Received: by 2002:a17:90b:5444:b0:3a8:5d57:a5e7 with SMTP id 98e67ed59e1d1-3ab3ab32b3cmr10599306a91.28.1791962092870;
        Wed, 14 Oct 2026 00:14:52 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac61171feesm3027261a91.17.2026.10.14.00.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 00:14:52 -0700 (PDT)
Message-ID: <53a4ffd5-3ea5-483d-ac11-74b95b5d37ed@gmail.com>
Date: Wed, 14 Oct 2026 15:14:45 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix extent status cache clearing when truncating
 inline data
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>,
 linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
References: <20261014021714.2382353-1-yi.zhang@huaweicloud.com>
 <sashiko-outbox-170745@kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <sashiko-outbox-170745@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/2026 10:42 AM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] ext4: integer truncation of i_size in ext4_inline_data_truncate()
> --
> 
> commit dadd6832c867f600a26266f1d17a57f7cfd12f24
> Author: Zhang Yi <yi.zhang@huawei.com>
> Subject: ext4: fix extent status cache clearing when truncating inline data
> 
> This commit restricts the extent status cache clear range during inline data
> truncation. Instead of dropping the whole extent status tree, it clears only
> the blocks that are actually truncated away to prevent inconsistencies with
> dirty, mapped, and delayed buffers.
> 
> Link: https://lore.kernel.org/linux-ext4/20261009103033.2920530-9-yi.zhang@huaweicloud.com/
> Link: https://lore.kernel.org/linux-ext4/6ac92a4c.70ed5d86.2ac85.0072.GAE@google.com/
> 
>> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
>> index ceee69a66482b..b630e56815bb5 100644
>> --- a/fs/ext4/inline.c
>> +++ b/fs/ext4/inline.c
> [ ... ]
>> @@ -1905,8 +1905,12 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
>>   		 * the extent status cache must be cleared to avoid leaving
>>   		 * behind stale delayed allocated extent entries
>>   		 */
>> -		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
>> -			ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
>> +		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
>> +			ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, i_size);
>> +
>> +			ext4_es_remove_extent(inode, lblk,
>> +					      EXT_MAX_BLOCKS - lblk);
>> +		}
> 
> [Severity: High]
> Does this calculation inadvertently drop valid delayed allocation extents on
> 32-bit architectures for files larger than 4GB?
> 
> Looking at ext4_inline_data_truncate(), the local variable i_size is
> declared as a size_t:
> 
> fs/ext4/inline.c:ext4_inline_data_truncate() {
>          size_t i_size;
>          ...
>          i_size = inode->i_size;
>          EXT4_I(inode)->i_disksize = i_size;
>          ...
> }
> 
> On 32-bit architectures, size_t is 32-bit, while inode->i_size is a 64-bit
> loff_t.
> 
> If a file with inline data is extended beyond 4GB via a delayed allocation
> write, inode->i_size successfully updates to >4GB. A subsequent failed write
> past EOF (e.g., from ENOSPC) triggers ext4_truncate_failed_write(), which
> calls ext4_inline_data_truncate().
> 
> Because i_size is a 32-bit size_t, the 64-bit inode->i_size wraps around
> (e.g., 4GB + 10 truncates to 10). When this patch uses the truncated i_size
> to calculate lblk, lblk incorrectly evaluates to a block near 0. This
> results in dropping valid delayed allocation extents across the entire >4GB
> file.
> 
> Additionally, the preexisting code assigns this truncated 32-bit i_size to
> the 64-bit EXT4_I(inode)->i_disksize, corrupting the on-disk size. Should
> i_size be changed to loff_t to prevent both the incorrect extent removal
> introduced here, and the disk size corruption?
> 

This is not reachable today.  ext4_inline_data_truncate() is only called
from ext4_truncate() when the inode still has inline data, and ext4
keeps the size of such an inode below the inline capacity.  Every path
that can grow the size past it converts the inline data to extents first,
which destroys the inline data, so the inode cannot carry inline data
any more. So a file that still has inline data when
ext4_inline_data_truncate() runs has a size of at most a few bytes.

That said, in the future it would indeed be more appropriate to change
i_size to loff_t, but this patch doesn't need it.

Thanks,
Yi.

