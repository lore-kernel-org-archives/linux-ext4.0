Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB3430C158
	for <linux-ext4@vger.kernel.org>; Sat, 22 Aug 2026 03:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787369853; cv=none; b=EjQIbALhSLIUwT18KcKwdX63OO/O0ifdpBZO15i9k15xj/OPE8vSKB73+kBEWFDurhWAqJaDgpieY+FMfID+8UyaEfCwXcxFk5X1DmQyESf2bTZCj4XF9zjdnDzlJXa2cZPbPVeXFEveL1NFikNDlzQYtfBQY0L6oT+HoFGu8ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787369853; c=relaxed/simple;
	bh=tFVl/RBqtsH1Gr0iDifGVyxnBAgdYdwgdDbNQye+k0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rJGhlupMebGpmwQS8ADkhV7gFIVZLQ68qNZUBo209jV9FDHXxClcjup1oouXm50+2lDyoO0mNI+wsMUvXwdStof1/ApPm8wveonfJX/EC4QTTDKiy9ctEXEz5hNsWOCQoUTSRsKqPeW1oG+ZG78WBmFwMIWuk1kjcuQ/20h/MLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qaY2Ujws; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qaY2Ujws"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cc61541f8cso30604525ad.0
        for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2026 20:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787369851; x=1787974651; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ElFIS84/+pbNOt4I/LoEzZYQj4y1cn0LPu5DOnWoK34=;
        b=qaY2Ujws2zAvavlLV+Pvp/p+HzegQXBpuQP5AauVLG3iAbECTHyO/sTdqlmfqgj+HF
         k2lUZsx8+BYhnm+yIY5humerSom1wNZ5AapJ4nKY6svnpTS86E2UkpHAGeMeVUmWqaUM
         DBSikzdxsv751afcN9LNa8W4WX0MY1xop6VAlgSPxVUNAAqoYN+TqxqMFq5OR8pNdsFI
         5L0qlkW548tnlvqYhgiZBB8CRW+kk0cVNAnApn8EE147oa9Q+JeweKngZkRYfIKCWxQy
         g0SfHqb6szGEILMq5UvosIO6pymhPal6CgecTK+TAM3fDbs0ni+606Dy0PLWuSwXXS10
         7mIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787369851; x=1787974651;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ElFIS84/+pbNOt4I/LoEzZYQj4y1cn0LPu5DOnWoK34=;
        b=Y8xyfRwr6w6crbcP332PJ03kSn1WkovRxFOXMZmfkcACByUwAzHRUFqKzED4dCOHV0
         Jp+NACyNJashqbp9p0+bgrhnwAxK4ccC2Z0GO6aUiW4miMOusGrutWckwQTdcnziZ46t
         cObY9fsl/Kx5TAxV1z270LWDutU0+cYYTHdatt37IJrT/RCSGe0PxQzGYEIpiyXhQ5Vc
         XsxftaZDtR7XYa7UbOm5sphByvg3EiPim0UwxHem3H0gaeo0ZF+zhZf15AMMeKtA0Eop
         lKe4hoyObTsC0joAnQJqlUEsbmrH19Pxkc82h01bhWi3shwdX5gLk+3WQfwWYAdumH3V
         /TuQ==
X-Gm-Message-State: AFuF++lXhVMkRZHwX4LuJe5q3IDQwQSYGtF/jHbWL/fJr6TzpCamFydw
	GgCJrX+1egqmUXT8RDZOMkuYGaMRh8m5wUkftfi1waYRAdDhfpRYnFNgwN/darBUyxU=
X-Gm-Gg: AR+sD10CQ9vITKuCzGNL1KpwujdVzyFlMpVzZ6zhy6bzUm0Q7vAJ8DezM4hBE27fkYK
	zr7NdihPrH4/rV3eUIBMTMmtMNOuhy9ZqWZBeSy3uemTSptRahSCUiVvzpueRu7SyE5exOIhvs1
	zk5DRQYI4Qa8ATQLujmVwPA2QEIbGbHbhMS/I+tZ1MXL9gWt+fzjjcj+ZSJJdgKlT3N5eEbdtyD
	pYvxBh+a3UyM2RU/6D2cNRnQGyogRJhZ3yHhQxGjHjTf4inUrI5qpHmakntPYekxNSLFjhipYMI
	SQO+jsYb4Qi4L7jc8qM2fvmqIxlBCMt/6nTIXOh5N6h9+6ZWSM2dkMgRWEOx0OCo4u+TeTYli7s
	uXUz8X/KriIwAlyi/XnpuBybFK4SHmw7Rd/efNVVMFYyNJBx6BaXpaHZvSd1gXc2qWp+e7be5kp
	+OAYN8xUO1TjDyy9WfMjwPKTF+zrdkiPDWYL83c3oK91mnRSFJLbwuaaFcfhRIvQfQNbqAKe5X+
	jb+36Gy
X-Received: by 2002:a17:903:1a84:b0:2ca:12aa:a390 with SMTP id d9443c01a7336-2d64ce3544cmr120353965ad.0.1787369851163;
        Fri, 21 Aug 2026 20:37:31 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d67678e1b5sm1187555ad.22.2026.08.21.20.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 20:37:30 -0700 (PDT)
Message-ID: <a3c68208-8faa-4902-b105-46bbbe322a0a@gmail.com>
Date: Sat, 22 Aug 2026 11:37:11 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 30/32] ext4: add tracepoints for EOF block
 zeroing and disksize-grow I/O
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-31-yi.zhang@huaweicloud.com>
 <20260814101927.E94F51F000E9@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814101927.E94F51F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:19 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Calling `i_size_read()` from the block I/O completion context (softirq) inside the `ext4_iomap_wb_disksize_pending` tracepoint class causes a hard lockup on 32-bit SMP systems.
> --
> 
> --- Patch [30]: [PATCH -next v5 30/32] ext4: add tracepoints for EOF block zeroing and disksize-grow I/O ---
> commit 9f6116e7039af778ef1701a210ea9b800dcc543c
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: add tracepoints for EOF block zeroing and disksize-grow I/O
> 
> Add tracepoints to track the disksize-grow-pending lifecycle in the
> writeback path and the block-zero-EOF entry point.
> 
>> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
>> index 4f1176b9332f2..4464eb03c9728 100644
>> --- a/fs/ext4/page-io.c
>> +++ b/fs/ext4/page-io.c
> 
> [ ... ]
> 
>> @@ -729,8 +735,11 @@ void ext4_iomap_end_bio(struct bio *bio)
>>   	 * state set in ext4_block_zero_eof() and wake up all waiters
>>   	 * that will update the inode i_disksize.
>>   	 */
>> -	if (io_mode == EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO)
>> +	if (io_mode == EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO) {
>> +		trace_ext4_iomap_wb_disksize_pending_complete(ioend->io_inode,
>> +				ioend->io_offset, ioend->io_size);
>>   		ext4_iomap_clear_disksize_pending(ioend->io_inode);
>> +	}
> 
>> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
>> index 4539ef8e5f86c..c9259c2a3e364 100644
>> --- a/include/trace/events/ext4.h
>> +++ b/include/trace/events/ext4.h
> 
> [ ... ]
> 
>> +/* disksize pending I/O tracepoints for iomap Buffered I/O path */
>> +DECLARE_EVENT_CLASS(ext4_iomap_wb_disksize_pending,
>> +	TP_PROTO(struct inode *inode, loff_t io_offset, size_t io_size),
>> +	TP_ARGS(inode, io_offset, io_size),
>> +	TP_STRUCT__entry(
>> +		__field(dev_t, dev)
>> +		__field(u64, ino)
>> +		__field(loff_t, io_offset)
>> +		__field(size_t, io_size)
>> +		__field(loff_t, i_size)
>> +		__field(loff_t, i_disksize)
>> +	),
>> +	TP_fast_assign(
>> +		__entry->dev = inode->i_sb->s_dev;
>> +		__entry->ino = inode->i_ino;
>> +		__entry->io_offset = io_offset;
>> +		__entry->io_size = io_size;
>> +		__entry->i_size = i_size_read(inode);
> 
> [Severity: High]
> Does this code introduce a deadlock on 32-bit SMP systems?
> 
> The tracepoint ext4_iomap_wb_disksize_pending_complete is called from
> ext4_iomap_end_bio(), which executes in softirq context. This happens
> because ext4_iomap_writeback_submit() clears the BIO_COMPLETE_IN_TASK flag.
> 
> When TP_fast_assign() evaluates i_size_read(inode), it uses a read sequence
> lock on 32-bit SMP systems via read_seqcount_begin(&inode->i_size_seqcount).
> 
> If i_size_write() is executing concurrently in process context on the same
> CPU, it holds the sequence lock without disabling softirqs. If the softirq
> interrupts the i_size_write() section, i_size_read() will spin infinitely
> waiting for the sequence count to become even.
> 
> Is there a way to avoid reading the inode size in this softirq context, or
> a safer way to sample it here?
> 

Yeah, since we already have trace_ext4_iomap_clear_disksize_pending()
in ext4_iomap_end_bio(), we can move
trace_ext4_iomap_wb_disksize_pending_complete() into the process
context of ext4_iomap_finish_ioend().

Thanks,
Yi.

>> +		__entry->i_disksize = READ_ONCE(EXT4_I(inode)->i_disksize);
>> +	),
>> +	TP_printk("dev %d:%d ino %llu io_offset %lld io_size %zu i_size %lld i_disksize %lld",
>> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
>> +		  __entry->ino, __entry->io_offset, __entry->io_size,
>> +		  __entry->i_size, __entry->i_disksize)
>> +);
> 

