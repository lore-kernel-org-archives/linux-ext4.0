Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD01459AF4
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 11:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787053717; cv=none; b=n43thcymYJZFXGgdPFZktGZJX/lE/6lTsZYC3wFjCOlw5FRjWOgj+hFY8xkC+M0mVjxtp6jQlqp3Nr2UF/+dKUcNYN/xutwZoi/Nuw4P0KwRiSWZ+CW3reRjPuhvFVv4dDP2wr5uMnzXAxg4USthn2WNaQ9gzgqTZysWF3JsgGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787053717; c=relaxed/simple;
	bh=f4M03IgTGvJzs6Io2GQZAJIVHwGhSeIiCc9sVfHn/Mo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eJ9QorKK5aFZ1hWkpfu1bDYrrYIw/4Pb5v3ZDHvGpd9bazHtudWf5i6lD0eAJVc347SsPYl57W61pvPeeWESR0e42WB8tLZYHn/w6j0OSs+CQoQjmkXv65huKO30YJMC3Ls85SL/eFT+KwGYNftZ8r59brq1yBWSwJg2k741Cdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UkCYjVlD; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UkCYjVlD"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2d5655cc850so31715975ad.3
        for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 04:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787053716; x=1787658516; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MInesFRTHKDvaq1Aqhz6QHAocvKV6d1p+jvF87TFwgg=;
        b=UkCYjVlDIo+1oE9mu6Rj5b5rpoHDDI8vCdmUQwgaRYUY8FDYBDUin3uUNqKdJMev3D
         m0rD+ktQtOqneahQu/qGtTfyp94AI2fBAuS35UWXkfJyG2HJdhMzbIUR010YW3Xl+GX+
         QX4sQmrlsq1RxIB9LzljeVOjyuJXbT7Z1OmQ65KjG+HGIYJXwPVqyiyhxseFxLxk5UWU
         J4kvV1V2W9n5cw8r8+u63/jSWE4MdIlbJi9OQn1idZw0o8r7p5KvQ4+kjDhYw/WFgB8t
         bdcaOGa5kUR7IQuHXvM5RoH1gSkGD9TzT54HtDgW/yhXPSqXThACTCy1pOTOaIlnDA28
         Zxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787053716; x=1787658516;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MInesFRTHKDvaq1Aqhz6QHAocvKV6d1p+jvF87TFwgg=;
        b=jqiVX4GTNuOSoFpVQKs1kVh68P31hIhJNg6ilNx32oVE2d2Oc7oXIi7bq2wPYroXI8
         aOSxKfBE0m1vTv8yVJCnzXR6/ePoD/5y62Dx1Hi4bF+2IfuDlm1Y4KXSQAc5+dHa6ZHX
         6jeRtkor5p3u8FFHxV/v5S5ysNFj7yuxhRfan+K8UbxxIZ2jRvhuJ8CvIynTrEE4Vrc7
         aFnjtX4aOFeaB0AZcuaZramoDKRy6CQ+qBwvRuSEE5TLXpTkpR1wcTzubIl4wXS2LzRp
         rDXqygpcx5wq3Hmil6A/vItRbZdffZgKeQ1u3txstcAWghNvZostsnKQVnPvWeFam9kf
         tYsA==
X-Forwarded-Encrypted: i=1; AHgh+Rp/ZeLkXPXxg/hxaauZ92hbpbuJpXsvGD0BdmDUOexfv/TLhu7g8wpWXsG03dKf9PuF9gpaHTRKd0Tr@vger.kernel.org
X-Gm-Message-State: AOJu0YzPEdykKE5aqouTpCtnM7iZ6gocjhRQOE66DnzW7Od30VZow6os
	QlAtj2cVb2XUNBS6Bm2L8/8vfAqp26cIydGIeLUN8HcHhgEU0+DE5QEO
X-Gm-Gg: AR+sD10yuauBQ8vIUXpq7XdsSrkV8Jo06lc9K/781h4i9TX5MO7/oiidl6kzpiJCoQj
	YfUvzJetnIyXzgyJgdwzoXTHiq7DbECRLS3p1Ccn2znJAFvd+HNnGew0zgqP2cHBTv9Qm8d2Cky
	PU8PA8etsg/s/kRnZ7X/VyrEPOAwZSn2kwJQBI1erOImEGp048FojqwNecBLOD8Aeh/nTc0P4q5
	1KZXUA9WofAqjEj4h3B5/jacaarI1UXv7CMxD/P9MXq6YX4JTFQ6qfSpAVkLMB0pT+3i8P1sQ2X
	TuDdAcgf79AbC5bQvoa/HEFe/VKYEHRwjYb4AP84iYy1Mf8fyxDjT3X3Y5CK93nhSI82J+ts3AY
	tDKbfBov70g66b44zoZpxXRShrBgNkxUQCNTDGGvvyePR29g0KPk70JQ9MWQT9x6GOHg7Nk6yMr
	mU1sGwn6pTqPJVDlyFuWuciw6+Am3y3knfVVBYpWxVzczWLnzDo3jgLMbn1lALjWVwaz7lpVdEz
	1dhW8pa
X-Received: by 2002:a05:6a21:7d0c:b0:3c3:a3fd:db0a with SMTP id adf61e73a8af0-3ccdaa0da04mr11555031637.16.1787053715788;
        Tue, 18 Aug 2026 04:48:35 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc142c4af3csm1026035a12.0.2026.08.18.04.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 04:48:35 -0700 (PDT)
Message-ID: <fa08be09-fa95-4b55-a13d-1ec5886b010d@gmail.com>
Date: Tue, 18 Aug 2026 19:47:58 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 24/32] ext4: advance i_disksize to i_size upon
 disksize-grow I/O completion
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-25-yi.zhang@huaweicloud.com>
 <20260814102545.E85101F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814102545.E85101F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:25 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] The EXT4_STATE_DISKSIZE_GROW_PENDING state bit is never set anywhere in the codebase, rendering the entire disksize-grow logic and safety mechanism inert.
> --
> 

This is a false positive. EXT4_STATE_DISKSIZE_GROW_PENDING is set
in patch 28. This patch is just preparing for that functionality.

Thanks,
Yi.


> --- Patch [24]: [PATCH -next v5 24/32] ext4: advance i_disksize to i_size upon disksize-grow I/O completion ---
> commit d834c25602b493451d52cc75b3ae8fd40461bce9
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: advance i_disksize to i_size upon disksize-grow I/O completion
> 
> This commit updates the iomap writeback path to advance i_disksize to i_size
> upon completion of a disksize-grow I/O. It introduces an is_disksize_grow flag
> to ext4_iomap_wb_update_disksize() to trigger this update safely.
> 
>> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
>> index 955ff88045db6..4f1176b9332f2 100644
>> --- a/fs/ext4/page-io.c
>> +++ b/fs/ext4/page-io.c
> [ ... ]
>> @@ -589,9 +589,36 @@ static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
>>   	 * i_data_sem.
>>   	 */
>>   	down_write(&ei->i_data_sem);
>> -	new_disksize = min(new_disksize, i_size_read(inode));
>> +	i_size = i_size_read(inode);
>> +
>> +	/*
>> +	 * EXT4_STATE_DISKSIZE_GROW_PENDING is cleared when the pending
>> +	 * I/O completes. However, another thread may have re-set the bit
>> +	 * between that point and here, meaning i_disksize has already
>> +	 * been advanced and a new EOF zeroing has been initiated. In that
>> +	 * case, do not advance i_disksize to i_size; leave it to the
>> +	 * next pending grow ioend.
>> +	 */
>> +	if (is_disksize_grow &&
>> +	    ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING))
>> +		is_disksize_grow = false;
> 
> [Severity: High]
> Is EXT4_STATE_DISKSIZE_GROW_PENDING actually set anywhere in the codebase?
> 
> It appears this state bit is never set, such as during EOF zeroing in
> ext4_block_zero_eof() where there is a TODO comment about tracking the
> ordered range.
> 
> If the bit is never set, ext4_test_inode_state() will always return false
> and this safety check will be bypassed during concurrent fallocate and
> truncate operations.
> 
> [ ... ]
>> @@ -607,6 +634,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>>   	loff_t pos = ioend->io_offset;
>>   	size_t size = ioend->io_size;
>>   	loff_t end = pos + size;
>> +	unsigned long io_mode = (unsigned long)ioend->io_private;
>> +	bool is_disksize_grow = (io_mode == EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO);
> 
> [Severity: High]
> Is EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO ever assigned to ioend->io_private?
> 
> Because the EXT4_STATE_DISKSIZE_GROW_PENDING bit is never set, it seems
> ext4_iomap_get_disksize_pending_range() will always return 0, meaning this
> io_mode flag is never assigned.
> 
> Does this render the entire disksize-grow logic inert?
> 

