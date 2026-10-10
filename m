Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6A62EB5A6
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 02:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791599628; cv=none; b=eyGXgo3tDuY7dltK1mj0xZvlqxD/FYLXmYvdc5ljvNtjWcELbj2SoZoAScLZSGEyBQvxxR+FhKkC6OlY0hs0jLLy2MBqbZpQ0n+bRcjanQ734sOnc7eukRJ5WHHJjS9S3mEcO9iAr0NiloKOAtoDTrdrcprz5tgr6IV7paEQ6tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791599628; c=relaxed/simple;
	bh=0wMBqclhma4cJaDymreec7xEshpKLFtABUes117fpWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tppvmlB+nGcWWirIj+JHU/dYU/j960Kt5xyFk48t0b7iiwJObrXy/GABCtjki5RTMcWkb8MzyDNLiHse4n5BFDA4uCuqtYNTryj0p3HgJvaQsqIHGJ9QzdmyHM7++uw8iMUTLK0x7PhPh25J2kPINERvyqZehjUTy1IGKF0GG5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WqZILpYi; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WqZILpYi"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38759bcd877so138362a91.2
        for <linux-ext4@vger.kernel.org>; Fri, 09 Oct 2026 19:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791599626; x=1792204426; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JBelTmompdM3mA4VVDTQCGY1mxSHgpB0e021EZ+22c4=;
        b=WqZILpYiIwDqsDBMSDckDauLtDCmDKCLQCOat0bnwGFvL8ahbPDAa+VUZKLs6jubbn
         lxtdS7rtcTnMH2XLBkk7Yncdh1QlCojUoxpZnSLHaYR4L5dtDcxtbXkp5CSkhJMew4ll
         NBgRDNl7JwKx08FBxvacB6J3AmoweP8n/UN7UCllwc7XHZwYnuKn0O2WqPjDGh1nLSqm
         eiBwhIywaH/KBiCcBz/IsPf/TO/RuKszikT+uTVhKX/Ug5IuPlVIG8oO5B10zOuCnXmJ
         V/1deIPnAytEUyzIu/QGVa6W94GRbH/ZfdmS/RUeZT5sBF8VTAy/q2130aPGwiVanBZ1
         ofRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791599626; x=1792204426;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JBelTmompdM3mA4VVDTQCGY1mxSHgpB0e021EZ+22c4=;
        b=Ka+X5FnBAAEJJBnjmHmfOSxi+phDYYH93C9RaWVUG6QWCFkm8Cq12JSEuA8lMvJlWy
         1wCSwzPaz4HLXTLJMsLP/fN58+BclqAysyFeez+AAU7rsRjIvngvRTNAWwrs1vEyB4LA
         cK9j03n/Rb472Ug6WfVcNByaweN3Iq5b79kuIJujqtLV72XtcdI3oZxnN7pN9s4rZDKN
         JB2++ClVRJKK5pBrKdq1Kv75RL/wtmVPd7AbCDeQeQrpMvv3ctTlyDSRRFW4WR2AfeHj
         2k+jZbVVUuRhIwPD1BR7y2pr18p8TnX4OOCwH64tg2Jwj/sz+gsBp4yLcQUW7J7LO01B
         gjcg==
X-Forwarded-Encrypted: i=1; AKwUvBwrlPjjaObpuDz7kxeKgINCfhRqDf9sImVz05JbSBePHbcVV8tqZEAEi3+raRlMlOtX4DEkERBdSE81@vger.kernel.org
X-Gm-Message-State: AFq9FYIHPXb7eZQiQGlW34Id6JQcIP4kYzoji72HdSs+siQ45iwmYVl/
	c705vSwFC5WuEohFPDdj7x0+SOs4xUYtIKx5VTS929RBFrRSRZ+laLgFSjS6U4PTuKU=
X-Gm-Gg: AYBFou13lNI6KfIxsKaE/CsvsW+Fch/SawaLMyhJbp+NzVfsI4tnz+bmeHY6xns+NmF
	OfIXEhvSh3NXgfMDd15iFlfb01CHvNCvdYopPYs5dorCjwn2JLsXv8xS9ekfU/adBeggGlQi1h8
	him2rmz5cJnK4RFyXkHoTGc66cI5QNna0nSkRkuey3cQucUsBfPQ8HmpyDMPX5ekLn/zWA5IUC5
	/Pe1IcFLZxqGWTL5XLUDnBd94q1shVLUbJsO5YvbbiGna089IrwuZe7Cr7s8I/wMc/9MCQZANbh
	If5ppA9hdSkvGD7IO36ajTWED/CYp4T3ZVaDxjpVWza/s58elvpp8NkP2ReMxn/ygUO1dUMApiS
	P7uh4Pvq5JjODBB1fhcwbGlNB20+LFm4AGoLB3aiECY67ZNprlwAz/g54iJkZVHqD+u5/OaNIkw
	KvKh+r4R2qA2iuDQ7m77XV6ElPn8UuxxuO+CNClmEw7/XpoJQyXfDCdXRXfz8vpoeRc+96LWf5o
	6GM2xiN0SA/EBQ3if9U
X-Received: by 2002:a17:90b:3d89:b0:3ab:c6d:2bf9 with SMTP id 98e67ed59e1d1-3ab3afdaaacmr3655096a91.57.1791599626493;
        Fri, 09 Oct 2026 19:33:46 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38f5509fsm6165781a91.12.2026.10.09.19.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 19:33:46 -0700 (PDT)
Message-ID: <b82ca2bb-1026-440d-871f-d092e57a17e5@gmail.com>
Date: Sat, 10 Oct 2026 10:33:40 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 14/31] ext4: rework handle credit accounting for
 unwritten extent conversion
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-15-yi.zhang@huaweicloud.com>
 <sashiko-outbox-165354@kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <sashiko-outbox-165354@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/2026 7:20 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] ext4: atomicity violation in fallocate extent conversion
> --
> 
> commit 352cf8eb3125c707efc06205d4a61cc670cd67bf
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: rework handle credit accounting for unwritten extent conversion
> 
> This commit updates the unwritten extent conversion process to handle long
> merged ioends. It introduces a check using ext4_journal_ensure_credits to
> extend or restart the transaction if credits run low during the loop.
> 
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 76038b6c36552..83d040e36b682 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
> [ ... ]
>> @@ -5137,27 +5137,36 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
> [ ... ]
>>   	while (max_blocks) {
>> -		if (credits) {
>> -			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
>> -						    credits);
>> -			if (IS_ERR(handle)) {
>> -				ret = PTR_ERR(handle);
>> -				break;
>> -			}
>> -		}
>> +		/*
>> +		 * The caller cannot know how many extents the range covers,
>> +		 * so make sure the transaction can take one more extent,
>> +		 * extending or restarting it once it is full.  The reserved
>> +		 * handle of the buffer_head writeback path is safe as it has
>> +		 * enough credits for the conversion, so it is not restarted
>> +		 * here.
>> +		 */
>> +		ret = ext4_journal_ensure_credits(handle, credits, 0);
>> +		if (ret < 0)
>> +			break;
> 
> [Severity: High]
> Does restarting the caller's transaction here break atomicity requirements
> for fallocate?
> 
> ext4_alloc_file_blocks relies on the atomicity of converting unwritten
> extents to written and adding the inode to the orphan list. This prevents
> e2fsck from flagging initialized extents beyond i_disksize as corruption on
> crash.
> 
> If the transaction restarts during this conversion loop, the first batch of
> converted extents is committed to the journal before the loop finishes and
> ext4_orphan_add is called in the parent function:
> 
> fs/ext4/extents.c:ext4_alloc_file_blocks() {
>      ...
>      ret = ext4_convert_unwritten_extents(handle, inode, ...);
>      ...
>      if (new_size && converted) {
>          ret2 = ext4_orphan_add(handle, inode);
>      ...
> }
> 
> If a crash occurs after the transaction restarts but before ext4_orphan_add
> completes, will it leave the disk with initialized extents beyond i_disksize
> and no orphan list entry, triggering filesystem corruption warnings and
> silent truncations in e2fsck?
> 

This is a pre-existing issue in ext4_alloc_file_blocks(), which is
extremely hard to trigger in practice, and the failure mode after the
patch will differ somewhat from before.

This can only be triggered by a size-extending FALLOC_FL_WRITE_ZEROES
that runs concurrently with another I/O completion. Since
ext4_alloc_file_blocks() holds i_rwsem, what it requires is that the
extent that the ext4_map_blocks() call at the top of the loop returned
as a single extent gets split before ext4_convert_unwritten_extents()
is called, so that the conversion is spread over more extents than the
extent tree had at map time. That means another unwritten extent
conversion has to land in that window, and the io_end conversion runs
from a workqueue, so it routinely completes only after the data
writeback and after the page cache has been dropped. A direct I/O
completion (ext4_dio_write_end_io()) can do the same. Buffered writes,
truncate and other fallocate calls are excluded by i_rwsem.

Before the patch, in the worst case, this would exhaust the handle
credits and cause a filesystem error. After the patch, since
ext4_journal_ensure_credits() will first try to extend the credits, the
credit exhaustion itself becomes much less likely, and only when the
extension fails, because the transaction is already at
j_max_transaction_buffers, will the transaction be restarted, which then
can trigger the issue Sashiko described.

This issue needs to be fixed separately, perhaps by moving
ext4_orphan_add() in ext4_alloc_file_blocks() before
ext4_convert_unwritten_extents().

Thanks,
Yi.


