Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BAF353A65
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 07:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616893; cv=none; b=Cpwrl5PME0mgeur4RMvmAB+5Fo6Olw+Rr2Cd1aDNPrV/TRLb62pFjAb3bBjABP6IQOCj9/qbF2RwDVy1OmNsYNPPPXwta+IROKXMi52QCwIrpeKP/jG5OekgbY8pKHeWUhnahPA/+V3pLBJwcdhNm/aOEQzaAF4hk8N5sYh1rI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616893; c=relaxed/simple;
	bh=xo//w35Kmn7FpIx31KMLYBjgptYPhoWnnYI3piYr8gI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uOmxMWTAE459BPpetDRgCWVtZ37kJk/4ubRP6Img4O35ASsKkQam2mhR/5qM3SUEuLWyI8J22Dii+AkcM3Z/TD7j/IQeVTvcyLEf68m50VQupLQVB06vq43CADK0tvrAi8Wl8Lw2BA4eYcoQFCgL6N6CBJNCv1BAM251HpYojp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mt2gRFS0; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mt2gRFS0"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8897e83332fso1197370b3a.1
        for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 00:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791616892; x=1792221692; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mtZL905viNivAYPB+dpalqyhUQkTx2Pe6yZCdf2c5Tg=;
        b=mt2gRFS0jwR5DAebSe24ucueBQBQitXQMSVPN4Vw4QKC+OZdQrgdnQHf7mXLlyyW9b
         X+8bCEYA8YJVgJd9LaofDrs/xnpt4KuuTJb67KME/AKpha1PpeKD0+drxJu+livYpm8R
         A1i72s/76ZOKojzdoyxontc7ZMufnssMSkTWqoK81KsPBMQ0P8mmlfJEn5/nuwa0GboH
         lCdZf++PmfeE6rccsymlHwOjJu8vBddVZMg2wZBJUHr8NHtOyMDV8BnlbS3w6qoy9LgV
         8AhiMc5lZTAu9fkbnHkzcTA0G33Ba7fVigVN/o/BTr3Gsyps+gE86LdMAl1zg/SSY14S
         oGcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791616892; x=1792221692;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mtZL905viNivAYPB+dpalqyhUQkTx2Pe6yZCdf2c5Tg=;
        b=NRtslTG1wJQtuAGr17Go0GjZ3A1NNrlBRBwqRmmGxiegJnopPrmkXNe5+LA8dhzRjz
         RZTMxlGTAt+3m/+PFzZSHgLu+r5tkJw/K9UbRAksEMntPhcDxB3zmGNbJlognJboH9kM
         8lgYbTUNwkMp8cjJbUpH+l+SbOTTSApV1M2yOdN3tsBA3jOgXuI92vG8aB3Hw/OC5aSJ
         F4oRG0qfTOdM0QBYKPqi3Ppsxj+pvIPrIlrfzYpi3STeJY7akHDGj0ylAi7HFqpBqVK8
         J5K/WaZC+HiJr+xgKx/AbBBxTNyzBvFLhQU0lTXJ5do/Es+leGdKNrAZ1Vf3sf/+I1XT
         TxOw==
X-Gm-Message-State: AFq9FYI6fC9aV+CrkV8Os3B32WPfdqw2q/w0leUlTnDeuj9aOU4RsYlg
	XojLEraXLz9ZNWVVKnG1P4oRH9wvOVI8Eo2e8DiLoCThTGYvd08YPFTu
X-Gm-Gg: AYBFou3zFltuAmOP9nJ+7OETUOIiuqVj3+WiUMujQNxudTn3XX7zOAWRvTH27JsLDzt
	0dqg6YeefXwIw4H7xuD+apn9F8yP24dYMKc9uqvJB6tphaMienHv4jz3qam528qsPZXY1cyZeN0
	JUFxKhqZPFHueqMj52xZuxZFVyYMi9kwHgOQjUvf2XEtokClgb1/hrpiwgAnT7AW6nosT3PV8ED
	NFlF9ERG1zBY9noI7CzRYVdBkIvQbYU1D2UAwMn8sjJwUNaPk+euCh4i1TogMHRCLQFOZ8wMxu+
	YZb5Qp8LdPlXHH/RYYy5ShrcFbgqyduWHH8VV+EEjUGnMVE/r5JG910jvXh4WvGPTYariZvtIRx
	iF/r8AXcAsjIc3W6aOJvkL640Vaof/Q7dmN9Ty5VGmjFgoKgtiOhGyrHBs5pBwkArkTctiNOpx/
	n/amKmp+ctHX1vsI9BIEIb+yDnCsVzaC1PTOX2dCMh+266xi8wd88mfvbmb5Aru5xOY2dZw5bOV
	7ckhPD+7BLd6GGP4om036QjX07pSA==
X-Received: by 2002:a05:6a00:44c7:b0:88d:511a:bd43 with SMTP id d2e1a72fcca58-896a3958148mr2900308b3a.30.1791616891783;
        Sat, 10 Oct 2026 00:21:31 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8985a414614sm1361747b3a.51.2026.10.10.00.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2026 00:21:31 -0700 (PDT)
Message-ID: <7208fed8-d3e8-454c-9376-a359f9089400@gmail.com>
Date: Sat, 10 Oct 2026 15:21:04 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing
 unaligned EOF block
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-28-yi.zhang@huaweicloud.com>
 <sashiko-outbox-165360@kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <sashiko-outbox-165360@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/2026 7:21 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] ext4: torn lockless read of i_disksize causes missing DISKSIZE_GROW_PENDING
> --
> 
> commit 4a76a3a815e11b477d4aaf7fd5a0eb69623ddb31
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: set DISKSIZE_GROW_PENDING after zeroing unaligned EOF block
> 
> This commit adds the ext4_iomap_mark_disksize_pending() function to set
> EXT4_STATE_DISKSIZE_GROW_PENDING after zeroing an unaligned EOF block.
> It ensures that the zeroed block is written before any subsequent data
> updates i_disksize, preventing the exposure of stale data.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 9b6916609000c..3bdb5f3b119ab 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4847,6 +4847,89 @@ static int ext4_block_zero_range(struct inode *inode,
> 
> [ ... ]
> 
>> +	/*
>> +	 * If the zeroed range does not overlap the existing on-disk tail
>> +	 * block, the zeroed data lies beyond the currently on-disk data
>> +	 * and will be written back before i_disksize is advanced past it,
>> +	 * so no stale data can be exposed.
>> +	 *
>> +	 * Checking i_disksize here (after folio_wait_writeback()) is
>> +	 * necessary and safe. If a delalloc writeback of this folio was
>> +	 * in-flight, it could be raced by a concurrent mmap write which
>> +	 * corrupts the tail block beyond i_size but the i_disksize is not
>> +	 * advanced. folio_wait_writeback() has waited for its completion
>> +	 * and the ioend has advanced i_disksize accordingly. If writeback
>> +	 * had not started, we don't need to mark any pending state because
>> +	 * any future writeback will carry the pagecache content that now
>> +	 * includes the zeroed data, so no stale data can appear on disk
>> +	 * even without the pending tracking.
>> +	 */
>> +	if (from >= round_up(READ_ONCE(EXT4_I(inode)->i_disksize),
>> +			     i_blocksize(inode)))
>> +		goto out;
> 
> [Severity: Medium]
> Could this lockless read of a 64-bit integer suffer from a torn read on
> 32-bit architectures?
> 
> On a 32-bit system, READ_ONCE() on a 64-bit variable like i_disksize compiles
> to two 32-bit loads. If a concurrent thread updates i_disksize via
> WRITE_ONCE() (for example, during I/O completion while holding i_data_sem)
> and the value crosses a 32-bit boundary, this read can tear.
> 
> For instance, if i_disksize changes from 0x00000000_FFFFFFFF to
> 0x00000001_00000000, the torn read could yield 0x00000000_00000000.
> 
> This would cause the condition to evaluate to true, skipping the pending
> tracking and failing to set EXT4_STATE_DISKSIZE_GROW_PENDING.
> 
> If the system crashes, this could allow i_disksize to be advanced past the
> unwritten zeroed block, exposing stale, uninitialized disk data to the
> file tail and defeating the data-ordering mechanism.
> 
> While i_size is protected by i_size_seqcount on 32-bit platforms, i_disksize
> does not seem to have seqcount protection here.
> 

I don't think a torn read is possible here, because there is no
concurrent writer of i_disksize in this window.

ext4_iomap_mark_disksize_pending() is called under i_rwsem, so the
i_disksize read can only be raced by the worker in
ext4_iomap_wb_update_disksize().  But it cannot make i_disksize larger
than what we account for here.  It writes min(end, i_size), and all
callers of ext4_block_zero_eof() zero the tail block before i_size is
advanced, so the new value is at most 'from'.  To change the outcome of
the check, 'end' would have to fall inside the block containing 'from',
and the only ioend that can do that is the one covering the folio we
have already waited for with folio_wait_writeback().  So the value we
read is already settled.

Thanks,
Yi.

