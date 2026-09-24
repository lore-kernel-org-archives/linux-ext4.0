Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA8D46D08B
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 10:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790245159; cv=none; b=A8aBZ0O8WyWSfdxHbQ/O2Fx/oJ4avdPwwiiniLbVjeevvt+rwP81Y1u08vU5unlX6PhGxsGD7K6OBqRPXKsGrksLM7zlh2uv4Irf6sbGXgwuZNDxs7x3I7e3txWfYUyv0ssJOaK1d0vQo/D3A8iUIS3L3FGRK2jbwUFr6yiVsfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790245159; c=relaxed/simple;
	bh=CJ5J0HUXTfBAGU4J35VJsDOyvdx2b2au+YMxSfiLwq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hj7rKW/qmTQt5ljn3WO4onlbVuNa39r9X8gKAFLeOpX4Orxhee2dQc57tOPjoaHPnx9YjyNpZ8YIbDmHezAEbNk3eIn+V0UcM9dp5u2jVgSJ8WkfgbTUwlu0H8hRh4o17FvxmHmNG2MhuEQjyXnjGsm5hoXrPyt5jjjWOU6jQdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gcj8yF7y; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gcj8yF7y"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790245146; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CJ5J0HUXTfBAGU4J35VJsDOyvdx2b2au+YMxSfiLwq4=;
	b=gcj8yF7ytovvrkiNUDHDtDuFREddGis3/5gQ4azF9zMCaVSqhhj/8Bk0qEEI3BKl/bDXYrCwsxOQS/vUuPQgcZ0mmF/paBGHceeHSjZcnFkTKrfRMwy4O/Cl0n6fe9ZAA8aRGHf5Q6jwIBcSUSuar4uAA7zIQzgR/fj9Yc1RA7M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XBZMqoW_1790245144;
Received: from 30.221.147.180(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XBZMqoW_1790245144 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Sep 2026 18:19:05 +0800
Message-ID: <b4660572-cbed-426c-b26e-636742aadb29@linux.alibaba.com>
Date: Thu, 24 Sep 2026 18:19:04 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
To: Eric Biggers <ebiggers@kernel.org>
Cc: Alberto Garcia <berto@igalia.com>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org
References: <arO0KE9_Jf8rNRwN@igalia.com>
 <38d9a34b-0547-45f0-b8b3-64da1f913058@linux.alibaba.com>
 <arPIrtWTXUTwqxFC@igalia.com>
 <cbbfa461-c770-457d-bfc6-317d744f1dcd@linux.alibaba.com>
 <20260923180119.GA1506901@google.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260923180119.GA1506901@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/9/24 02:01, Eric Biggers wrote:
> On Wed, Sep 23, 2026 at 09:28:54PM +0800, Baokun Li wrote:
>> On 2026/9/23 20:40, Alberto Garcia wrote:
>>> On Wed, Sep 23, 2026 at 08:12:03PM +0800, Baokun Li wrote:
>>>>> 1) Enable encryption on an ext4 filesystem with tune2fs -O encrypt
>>>> Is it valid to enable encrypt at mount time?
>>> Good question, I always understood that it was allowed and tune2fs
>>> certainly doesn't forbid it (compare with casefold):
>>>
>>> https://github.com/tytso/e2fsprogs/blob/v1.47.4/misc/tune2fs.c#L1599
>>>
>>> Berto
>>
>> If enabling encryption on a mounted ext4 fs is allowed,
>> I think the current change is fine.
>>
>> Ted, Eric - would either of you know the details here?
> Yes, it is allowed.
>
> The proposed patch looks good, even though the problem seems to be gone
> on mainline already due to the removal of the code path that used the
> non-large-folio-compatible function fscrypt_encrypt_pagecache_blocks().

Agreed, then this current modification can be made into a separate
bugfix for backporting to stable.

>
> There can be another patch that removes both that check and the
> mount-time check, if they're truly no longer needed (I don't know of any
> reason why they would be, but it needs to be properly tested).

After removing both checks, I ran

    kvm-xfstests -c ext4/32k -g encrypt

16 of the 29 tests still fail.  blk-crypto-fallback still en/decrypts one
page at a time, while the data unit size is 32k with a block size larger
than the page size.  It doesn't crash, but the writes fail with
BLK_STS_INVAL, so write() succeeds while the data never reaches the disk,
and reads fail once the page cache is dropped.

Supporting data units larger than a page is simple enough.  A rough
implementation of mine already gives 30%~50% higher buffered I/O
throughput with 32k blocks than with 4k blocks.  The patches are still
being polished, and I'll send them out in the next two days.


Thanks,
Baokun

