Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D282DF13A
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 03:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776311690; cv=none; b=OQc1NbPm1e92upLKR69T/bvvGrNY09nPLuLCOABMvw0YujfugQE6DK0DgOioB+8FDl/GcMnfwAf7SPB3ycJjhnc2fylx08PnbqT/ajcN4JXZkLmylQUGZhZs5CGm9zv7fOeisMBA9Px6kGPBh3Mg0RQS/whWA/VeUlGIXLbyodQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776311690; c=relaxed/simple;
	bh=FRtxye/7XATNQiRwvPJ7zj4jM5BiMBcNqlQXvVp6b6o=;
	h=In-Reply-To:Content-Type:Cc:Subject:To:Mime-Version:Message-Id:
	 References:From:Date; b=W5QlHaWdpO5XtOC08+3u24qE8vUmDIM1qpDgX5Pdv/HLld4BxyJ9vVv2bCSU9NWrpn5lkELhWdj+DNtyXGz6Ky4aOr0hprZhIpo4AauvM2UZEYLNbqNjsSrBsFkA6Xy04B9PDi7pVD08ASFbdeipuAX35b+1EsELBNBUHIuWb8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=UUhz64C3; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="UUhz64C3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1776311683; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=XuUijCRU49VU51RPVF7QODH/tQoawFO7A52ugknXftA=;
 b=UUhz64C3WokIoUnig+6fdptc4C+Kd/RGQcaO66T8RcBXjfOHPQGySTTa+WBPP4avK86hkr
 IoBqFhbrtX4+nifDG8unDSvz1ezYd8rAicAK//9emZyNO47GYuInBHF9P83tM4r+VsALjF
 dc494e2xl4mvKPJhueZI46sExV5fi0ubN2j2iEb9tW8x0rFLZjQnX4gfcF8NciWpb8NQmv
 S0GaMTmaONXrIeS303bnpPA3Z8tA2P4Wrp9Vn2sUL1Pwq2VX4Fa5pbd1vytXNoystnRqwV
 C61QEJy5EWLhDf3e2TFkRS3R5IxK9T1tEbDgwEHjAXIkj4ddrVsKy2nbYb2F7Q==
In-Reply-To: <20260413124703.GA20496@macsyma-wired.lan>
X-Original-From: Diangang Li <lidiangang@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<changfengnan@bytedance.com>, <yizhang089@gmail.com>, 
	<willy@infradead.org>
Subject: Re: [RFC v2 0/1] ext4: fail fast on repeated buffer_head reads after IO failure
User-Agent: Mozilla Thunderbird
To: "Theodore Tso" <tytso@mit.edu>, "Diangang Li" <diangangli@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <03453fb3-0f3e-491d-ba12-e4208fe1c185@bytedance.com>
References: <20260325093349.630193-1-diangangli@gmail.com> <20260413062500.1380307-1-diangangli@gmail.com> <20260413124703.GA20496@macsyma-wired.lan>
Content-Language: en-US
X-Lms-Return-Path: <lba+269e05d81+3eb8a5+vger.kernel.org+lidiangang@bytedance.com>
From: "Diangang Li" <lidiangang@bytedance.com>
Date: Thu, 16 Apr 2026 11:54:27 +0800

On 4/13/26 8:47 PM, Theodore Tso wrote:
> On Mon, Apr 13, 2026 at 02:24:59PM +0800, Diangang Li wrote:
>> From: Diangang Li <lidiangang@bytedance.com>
>>
>> A production system reported hung tasks blocked for 300s+ in ext4
>> buffer_head paths....
>>
>>    [Tue Mar 24 14:16:24 2026] blk_update_request: I/O error, dev sdi,
>>        sector 10704150288 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>>    [Tue Mar 24 14:16:25 2026] blk_update_request: I/O error, dev sdi,
>>        sector 10704488160 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
>>    [Tue Mar 24 14:16:26 2026] blk_update_request: I/O error, dev sdi,
>>        sector 10704382912 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
> 
> I wonder whether the ext4 layer is the right place to be handle this
> sort of issue.  For example, it could be handled by having a subsystem
> scanning dmesg (or by wiring up notifications so block device errors
> get sent to a userspace daemon), and when certain criteria is met, the
> machine is automatically sent to hardware operations to run
> diagnostics and (most likey) replace the failing disk.
> 
> It could also be handled in the driver or SCSI layer so the "fail
> fast" semantics are handled there, so that it supports all file
> systems, not just ext4.  The SCSI layer also has more information
> about the type of error; you might want to handle things like media
> errors differently from Fibre Channel or iSCSI timeouts (which might
> be something where "fast fast" is not appropriate).
> 
> By the time the error gets propagated up to the buffer head, we lose a
> lot of detail about why the error took place.  Also, in the long term
> we will hopefully be moving away from using buffer cache.
> 
>     		     	    	      	    - Ted

Hi Ted,

What about moving the fail-fast check into the buffer-head path 
(submit_bh_wbc) so it is not ext4-specific. We can update a BH_Read_EIO 
bit in end_bio_bh_io_sync, and add a per-bdev/per-partition sysfs knob 
for the retry window. That turns it into a generic guard for buffer-head 
users, and it naturally goes away as buffer-head usage shrinks.

We did think about doing this in the block layer (submit_bio) or in 
SCSI/NVMe, but a generic solution there seems to need a per-device table 
to cache the error LBAs. With buffer-head, we can keep the error state 
on the bh itself.

I also checked f2fs (no buffer-head). It tracks repeated EIOs on 
metadata/node pages to avoid infinite retry loops. How do you see that 
compared with a buffer-head retry window? Are either of these directions 
worth exploring further?

Thanks,
Diangang
