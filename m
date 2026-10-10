Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA47638B157
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 03:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791601919; cv=none; b=aXwHF92Gyz/nKkHZT9z+C4jI2lZwPUJnDpFslXqnwoC2xHwSVzVyGBe0BmTNS+kgrhxZgI918ENDsm1j6xwiRNq7IUzTTcrSEYYfklgx2eDm/H8nGiQtd2JnJY6lZX2Tq08XqLq2RolTS+LlJd5rHSu+tLCtC0UzFp8js3NT0xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791601919; c=relaxed/simple;
	bh=pMCtAYw/2ribP9N9uQOEDCYn6zfk2FO7q2pgAbzIqiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M9kFiTtLZBMWVqi/ilcvfkIr6kG3aHON8pZt421yk30Jxm89GZ/6jCFJbCf8Qewv68pBcNjgp/XCByMe4eLtjbTmkDV0Wmof2fefD/hyU3pRn0rWMwZr+fljkrafN/UW9m33OVdt4omNveubSgc+9KP02Fj0wJfSo/dBPoIvsc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=INIRafQU; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="INIRafQU"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc4dbcf2b85so75985a12.3
        for <linux-ext4@vger.kernel.org>; Fri, 09 Oct 2026 20:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791601914; x=1792206714; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1SHh/xa/SK2kqTvZYLL1BXzklOLAk2qI5f7ULjUB1uA=;
        b=INIRafQUevnxT2av9CJCPd9Qpo9HRaHzetgRvrPTomI2Xg1dNxblYidXk4s7hIVSQF
         HOzuNdVlR5+mcnXx+eIDbTN3r9bkdPJhf3vlyom72nHRCykFdr+IOHPjTIW5WikPvTuu
         1oRGZk7FrtTc+d8ws19NODTeYmhzcXoQ8A5JTPmMWV9hAPqTxWTEk9ihB8/sCgnt+gIb
         lYuiS6dC03SbORaRZo53H6fvdYewYQ05UMf/BSiLmC5ka/ELzXS4R05LBqiZgtGbBLn8
         dSPEL2VyikrlIgUv/oIfYcxr8J/Jx56OmjOfG3QHRRKvzKrf+UeiSSg8IOAU9TLIAisY
         f2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791601914; x=1792206714;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1SHh/xa/SK2kqTvZYLL1BXzklOLAk2qI5f7ULjUB1uA=;
        b=YUBAf3KQz4EcnO0UHQB6xM04gYNakJ34QHizvtR2zv4ZXgfohcWNTfp2ttOJsOz7Vy
         n4NTp9H2RVZuR1oAf7ia/PdU0KKYkdvqWv6zD9dyJ2Vo7yN88fHzu4Kgda96VSrH8mHX
         njFT3ILhYXR15+IN5n+D/mFKrq2zbfaZ+qrjOleGrMXOqNgOhQ08RJhCojRkpdPnrY0W
         FfNWrVc/NGm3fnmF4QeyTj4CLaOdzjnFR+34oHP5wNQqg/x+/0l1/1Jiz+kXYGb2Zd3Q
         bCQbC5kxLPsUNCL1OEQQpiRBeMwKmeCgEVwyUwv3J7rCcGPpmwoQJDawTRn3nj1DGnha
         KT3A==
X-Gm-Message-State: AFq9FYK+fkXVXlo+0qIXbE85MXlgRXL6eVbfZgaI2Enx6z29UAa31NKB
	RVYnumKx1jS9vtim7OZzTaW47RuVOVIgk6OFwYoz+Pea9DL6mxaGpbpx
X-Gm-Gg: AYBFou3fVhn8+giSYdqLuF3yn/BMxIKCUttCcasYsY56jKTo5Fy8YqcSCsO5oKmUovx
	C2DVKOiHhW6sglOmWpY3P+3JE1YpLjfHw0IRN8BwB9myHH1CRXTdnKajA9dshSI5Ck98EefAKom
	eiW5BGdZu4UIqRNEa9f91oRTDEyWCqrDEdEXzHGrzripPQP2EwSkXX3YPS12EniAz88qSvLm4rR
	BVN7g+KiVbumz4sxCw35jFcNb6EJtYfTeVEc6v7E6gh7v8STblCLGBLCVy5yKrOamz3v72aqT0P
	FaPiHXQi5hqZZwxoWIBlcJU04hTMLu3hS+dTLBBrgU1nwkk9gRZ9Av+tjTcb2riXcmysuCPe6X9
	ERRJwI2HgGxLDcvdZtvCqAPb7HZ4eSkKX4tGv7QcCYnVS3K79RbFIMxV74orbfnC/ZES6VqMWeJ
	ijmQ2OMVleLET7d9Cwge7hm+dGp+BBoWWaQ4spJJjhqMz4JqpIJpJ1iuiu9ZWj1LjyrIn7KO8Hn
	ybMqXher6EmpCftvhMl
X-Received: by 2002:a05:6a00:4c08:b0:891:3e34:e080 with SMTP id d2e1a72fcca58-897c6c248f5mr3380575b3a.24.1791601913966;
        Fri, 09 Oct 2026 20:11:53 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c3107363sm1833002b3a.20.2026.10.09.20.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 20:11:53 -0700 (PDT)
Message-ID: <bd4ccce7-4e42-40a5-a7fd-d5716d0080d4@gmail.com>
Date: Sat, 10 Oct 2026 11:11:32 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 22/31] ext4: submit and wait for pending disksize-grow
 I/O on writeback
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-23-yi.zhang@huaweicloud.com>
 <sashiko-outbox-165347@kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <sashiko-outbox-165347@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/2026 7:18 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] ext4: multi-second stall in rsv_conversion_wq due to skipped locked folio
> --

This is a false positive again, for the same reason as in the v6
iteration.

Thanks,
Yi.

> 
> commit effefa308fc467b9330490d20efb3b9b03f85c73
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: submit and wait for pending disksize-grow I/O on writeback
> 
> This commit introduces the ioend mechanism for the pending disksize-grow
> I/O range. It attempts to proactively submit the pending range in
> ext4_iomap_writepages() so it completes in parallel, and waits for its
> completion in the ioend finish path to avoid exposing stale data when
> advancing i_disksize.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 9c45a0c01d1c1..76e070eaa6f89 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> [ ... ]
>> @@ -4404,6 +4422,36 @@ static const struct iomap_writeback_ops ext4_writeback_ops = {
>>   	.writeback_submit = ext4_iomap_writeback_submit,
>>   };
>>   
>> +/*
>> + * If the current writeback range begins after the pending zeroed EOF
>> + * block range which straddles i_disksize, issue a separate writeback to
>> + * flush it first, so as to avoid prolonged waiting.
>> + */
>> +static void ext4_iomap_wb_submit_zeroed_eof(struct inode *inode,
>> +					    struct writeback_control *wbc)
>> +{
>> +	struct address_space *mapping = inode->i_mapping;
>> +	loff_t pstart, plen, range_start;
>> +
>> +	if (wbc->range_cyclic)
>> +		range_start = (loff_t)mapping->writeback_index << PAGE_SHIFT;
>> +	else
>> +		range_start = wbc->range_start;
>> +
>> +	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
>> +	if (!plen)
>> +		return;
>> +	if (round_down(range_start, mapping_min_folio_nrbytes(mapping)) <
>> +	    pstart + plen)
>> +		return;
>> +
>> +	/* Keep the caller's sync mode to avoid stalling the background flusher. */
>> +	if (wbc->sync_mode == WB_SYNC_ALL)
>> +		filemap_fdatawrite_range(mapping, pstart, pstart + plen - 1);
>> +	else
>> +		filemap_flush_range(mapping, pstart, pstart + plen - 1);
> 
> [Severity: High]
> Does this code risk skipping locked folios and causing a stall later?
> 
> If wbc->sync_mode is WB_SYNC_NONE, filemap_flush_range() is used, which
> skips folios that are locked by other threads without returning an error.
> If the pending zeroed EOF folio is transiently locked (for example, by a
> concurrent buffered read or write), it will be skipped and remain dirty,
> and its pending bit will not be cleared.
> 
> However, the main writeback pass will continue and submit I/O for subsequent
> folios in the file.
> 
>> +}
>> +
>>   static int ext4_iomap_writepages(struct address_space *mapping,
> [ ... ]
>> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
>> index 9b0e12b5463cf..697e12a54a49a 100644
>> --- a/fs/ext4/page-io.c
>> +++ b/fs/ext4/page-io.c
> [ ... ]
>> @@ -594,6 +622,9 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>>   	    end <= READ_ONCE(EXT4_I(inode)->i_disksize))
>>   		goto out;
>>   
>> +	/* Wait for disksize-pending zeroed data to be written out. */
>> +	ext4_iomap_wb_disksize_pending_wait(inode, pos, size);
>> +
> 
> [Severity: High]
> Can this wait block the rsv_conversion_wq indefinitely?
> 
> When the subsequent IOs complete, ext4_iomap_finish_ioend() runs in the
> single-threaded rsv_conversion_wq. It calls
> ext4_iomap_wb_disksize_pending_wait(), which waits for the pending bit
> to be cleared.
> 
> If the pending block was silently skipped earlier by filemap_flush_range(),
> the bit will not be cleared until the skipped folio is written by a future
> writeback pass. During this time, the entire filesystem's I/O conversions
> are stalled, potentially causing massive latency spikes or deadlocking memory
> reclaim.
> 
>>   	/*
>>   	 * We may need to convert one extent, update the i_disksize and
>>   	 * dirty the inode.
> 

