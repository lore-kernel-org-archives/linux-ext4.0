Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A58C451980
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 15:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787065857; cv=none; b=cE9i+LRmNZeyuCvUFCw4FYBhBG+HQJXDGJMQkYu02kI7k6t/K3QT22hGsOJRF2HPz0nCMrK67rwRdd9v00RjPJX63jkGQa1T7wlKwcSYj99ifWduKX1MySYCOhQ/ZW45lIJZK7KDmEQNk4mWSkByxkPz33cwKfzJhLecJyD6fb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787065857; c=relaxed/simple;
	bh=Ot/t5jxTjZvC7XADL+f6swv4cIZk8SpzpVukjiWB11o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UzyRLq1bftKEl5U8T00z+0/O3YBJjHUI27EPxUInkxCi1bchbjL+q0w7U5aXYEAyIAq4OfyWDQ4pUnIoyZmD/1YGV7AS65rfbYz/fJuXSnctLbRAHQuiH7vrNhO+U4cRTxd3JrFC5pEM2200pPhpU4Cwt8AStGLhD0m1qLS4M/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VcH2bwKo; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VcH2bwKo"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84a4d8fd6ecso35242b3a.1
        for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 08:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787065855; x=1787670655; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IoK9jdkq2s9TIMfxVwD9tr8LjrjLh+loBroz5RPO2Yg=;
        b=VcH2bwKoSwUuqxWq5cZAkahHkS/6Lj53/1H8Q/pYoadAQ9Kqi7IEfv1UAaxvJ6KIul
         YjfA3q2HXdN56Ejf0RWu2dXyzoqb17gM/jhYJvRy5eZzzREnAC7WXzY9UJwTq5nIzRT4
         26WkEPDij2blCn7w9a1Oi0Qf44QjtxiwPAE/VHA1lNVLJNWgp4g9UpVYzrC5kQgTGYsL
         qTMXRa+i6ytSEIAApJ0szIoXfFBmNQF1HNsTHyeYVz+eq5hK3mSBcWb12imaI+wFCMY2
         q0ZiCYHmc8iAPlVjb5XCwF5+ajTLKsvb53ZbmnkztuI4+kl9cD6GhG6ImkOkmjRsv5J0
         ftVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787065855; x=1787670655;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IoK9jdkq2s9TIMfxVwD9tr8LjrjLh+loBroz5RPO2Yg=;
        b=ovlBZ8T7BIGN6XmSYNvEEDLSnH7SJli1+9EOpaAxhlSEpMmGAEOW6ww9GPD76/Bp5c
         8eboeQ1W5ODpFIFXe/trQpXVH5sK+q/B0OKPjORXa2xfRTH8tEOm6DSz0TsidFlMW6j3
         Xx37KlaaLNVf+kz8VDOepsZMUUopR5XdtyCRTlVJOkNuWkFDpwyntZ5th6SPtwHc4hJW
         WwzqtbD5hr6vd12ZaCz2P64I1X2Egsz1LpeaVGyN7QlUVvoEij8I1pBvxarHFtlEhVSM
         +wlxHn0gK+oiCGcoVi3zrkbsNn+bhDyNhxCXpwANo9p6wQjRCJ5rrQq5phYevz4OUE4E
         uMtQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr7OMmm9T6FRyuLzjrXyWZEowJNVGfGk4musaOa2WVoGPOmdYBgvMDD0EKi+FmRDwgpkV8y5UcefuYv@vger.kernel.org
X-Gm-Message-State: AOJu0YzCEpMghkdsd3fw0cQ9n7naWpIu0p8IcVU44fZ240KDzu+/oLiw
	dUvG6D0IJigZynp+kuW5lSHcDgDu6RYdkpI36EMWLIN/wLp3KWJMw8nF
X-Gm-Gg: AR+sD11N9xHuDLqiYeJ7JHabpCM89R6bxnmL/u/7XrOTpvynTo7JJb9EDTC+/31i+pK
	Rte7KL7fhCbsvCLLl5W3nR8VBwGD9IP+C7Nb66Vr0+HghIroIYXyIEO4ENs/PHUpzLaXnHPO+Gd
	MLCvz26OgH20W7bs41DxWghrkUTD2l856uBkwMlgvGEG9QEQW8a7gWAqjCO1Xo4pMMNGIBR8oau
	JMvmNBHnYhlVCrlqgr+8MEsvA+vIyEysuP40g7p2tMoXSjZv0bkhv0fFbfJ3G4NH5uEMEBA+1oR
	j9MlAkFQ5WNW8cVcjbOMQAwCjczRGGYCEaoLM/N/6YUzJImSpqegXxDnPjObY4NdzYSdiFxnK62
	5XX2G4HDQg2uxx72AemgTnPi+l2w/duy00cJSgST1motG3iqfcS0X53d4tqM9FFRsp32IM1rH+b
	DDG5mcVfypU3C2bImoUanATgc8Lb+zRfgPPQqvV2V5cDyQgDHDMMqM4zplm/MRWz41N/tNtkp+a
	gVilj+X
X-Received: by 2002:a05:6a00:3754:b0:851:92fe:504b with SMTP id d2e1a72fcca58-85192fe58f5mr17921064b3a.7.1787065855241;
        Tue, 18 Aug 2026 08:10:55 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc20dasm1667432b3a.46.2026.08.18.08.10.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 08:10:54 -0700 (PDT)
Message-ID: <330f29cb-ec4f-4f7b-b0ff-47414e1290eb@gmail.com>
Date: Tue, 18 Aug 2026 23:10:27 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 26/32] ext4: submit and wait for disksize-grow
 I/O in fallocate paths
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-27-yi.zhang@huaweicloud.com>
 <20260814102837.9BF8F1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814102837.9BF8F1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:28 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] In `ext4_do_fallocate` with `O_SYNC`, the fast commit can execute before the workqueue updates `i_disksize`, resulting in lost file extension on crash.
> --
> 
> --- Patch [26]: [PATCH -next v5 26/32] ext4: submit and wait for disksize-grow I/O in fallocate paths ---
> commit 918bb376bb323b629f0c4b2e5c84c055d7c4c754
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: submit and wait for disksize-grow I/O in fallocate paths
> 
> Collapse range and insert range update i_disksize directly under
> i_data_sem. If the operation runs while the zeroed EOF block is still
> awaiting writeback, i_disksize could advance past the zeroed boundary
> before the zeroed data is persisted, exposing stale data on crash.
> 
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index fc5aa2dbefcff..dda6d50e96e30 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -4928,10 +4938,20 @@ static long ext4_do_fallocate(struct file *file, loff_t offset,
>>   	if (ret)
>>   		goto out;
>>   
>> -	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) &&
>> -	    EXT4_SB(inode->i_sb)->s_journal) {
>> -		ret = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
>> -					EXT4_I(inode)->i_sync_tid);
>> +	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
>> +		/*
>> +		 * Sync the pending zeroed EOF block to ensure the
>> +		 * i_disksize update is persisted.
>> +		 */
>> +		if (new_size) {
>> +			ret = ext4_iomap_sync_zeroed_eof(inode, 0, LLONG_MAX);
>> +			if (ret)
>> +				goto out;
>> +		}
>> +		if (EXT4_SB(inode->i_sb)->s_journal) {
>> +			ret = ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
>> +						EXT4_I(inode)->i_sync_tid);
>> +		}
> 
> [Severity: High]
> Can this fast commit execute before the workqueue updates i_disksize,
> potentially losing the file extension on a crash?
> 
> Looking at the bio completion path in fs/ext4/page-io.c:ext4_iomap_end_bio():
> 
> 	if (io_mode == EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO)
> 		ext4_iomap_clear_disksize_pending(ioend->io_inode);
> 	
> 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> 	if (list_empty(&ei->i_rsv_conversion_list))
> 		queue_work(EXT4_SB(ioend->io_inode->i_sb)->rsv_conversion_wq,
> 		           ...);
> 
> It appears the EXT4_STATE_DISKSIZE_GROW_PENDING flag is cleared before the
> workqueue is actually dispatched and executed.
> 
> If ext4_iomap_sync_zeroed_eof() wakes up immediately after the flag is
> cleared, could it proceed to ext4_fc_commit() before the workqueue gets a
> chance to update i_disksize?
> 
> If a crash happens right after the fast commit in this scenario, would it
> persist the inode with the old i_disksize, causing a regression by
> violating the requested O_SYNC guarantees?

Yeah, this is right. In ext4_iomap_sync_zeroed_eof(), we should
replace the filemap_fdatawrite_range() +
ext4_iomap_wait_disksize_pending() calls with just
filemap_write_and_wait_range().

Thanks,
Yi.

> 
>>   	}
>>   out:
>>   	trace_ext4_fallocate_exit(inode, offset,
> 

