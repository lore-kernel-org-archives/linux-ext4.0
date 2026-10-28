Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793176027;
	b=ChCjAJOmJ2TmGeYZE8bqjm5GV96Z1gTEzG538lDXesuKkjyrS+u9vHKBLHg7LY+tZkfn
	 Od6TbZLK+pmW3xklpT0VLUnXEBKmhAp71ZaNQ+LAgeZzeDhMpSy/6KjtgPj9XJr6LWkZ/
	 kY36npYEoOiwLuQ1xnCyN/NPCh6QmtWaUrWGoCHekKjXW314JMO+bIpUwJSXEkHwPdBtD
	 GcI7z9Ox2aKVVNS7OZJmdAG488LTLhwwPiJOuxC/zHdRou+1ycHN3cVa1pIu5n4vKPUpf
	 yBHCOHUp+1/3/Ajej8gayK11bMPbHERd5OiHRn1b7AlTjFbTtqhyJLPjKuKJBN5zToA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793176027;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=56H+4FZV4EHFsP5ISfCr6gB3PZrO2actp2O2zgyxT7Y=;
	b=GW2SynraSDwuUqWI+xymvvjKp2Hd7skHVTO/N3PGJ29oUnjIAoXiEX12+7GwbzmIABZQ
	 G3BeVqtCiuOI9YZRrLObsX96PkXFU0w72ZPJDV83UoI568C8abu3UuRzDN62cGfG4bFHU
	 nPEI4+PrrsWnYA0K1QMkyI57KGskYsk2vHHxSIOfbyZnGBoHdqy42baMUDJHxtDl/pMSo
	 /q4PGgY3Lfu+QP4Tf5Td6lRAvl84Wiw8Kda1Ghc2wTF3UdCwACeg98QNwRV43tAf6PexG
	 jlhRUjqDhbB9eCLfYuU4rvE7JnOQIEvBmYiZ5CpBBsGrSWkxSP1b3tdkxHwMsYgeWyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KNc8lwHy;
	arc=none smtp.remote-ip=91.218.175.113
Received: from mta0.migadu.com (out-113.mta0.migadu.com [91.218.175.113])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A805C606A31A
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2026 08:27:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A805C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KNc8lwHy
X-Envelope-To: linux-ext4@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Nn5H1uJunDYhql3ZlXGrA1ql9hoi7VLRqtnjfTdBp5E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793176023; v=1; x=1793780823;
 b=KNc8lwHy+5gezD1AVzaHKmavk8ONQNPywgnzvXwyXbTIa6NFmGLf6C6atRUV7vnPq5zSTgie
 nD2JGW9RWIW8G3+zFPPL3k02Z0nW3+wGYiYckstyLdS4FIRWM+yVMC0xd5WqQ/FYHB5XCDe56hS
 5qs3RhWSKhxe2EtNK7quKHtk=
X-Envelope-To: linux-ext4@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c20e2f4c654b7666;
	Wed, 28 Oct 2026 08:27:03 +0000
X-Mizu-Trace-ID: c20e2f4c654b7666
X-Migadu-Flow: FLOW_OUT
Message-ID: <37bb5b7c-c29c-46b6-a87f-ac1a6e19fe0d@linux.dev>
Date: Wed, 28 Oct 2026 09:27:01 +0100
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: set awu_max_opt to awu_max
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Pankaj Raghav <p.raghav@samsung.com>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
 linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 pankaj.raghav@linux.dev, John Garry <john.garry@linux.dev>,
 SSDR Gost Dev <gost.dev@samsung.com>
References: <20260910100829.2532894-1-p.raghav@samsung.com>
 <y0d9yw6z.ritesh.list@gmail.com>
Content-Language: en-US
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <y0d9yw6z.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Sorry for the late reply.

On 9/10/26 17:15, Ritesh Harjani (IBM) wrote:
> Pankaj Raghav <p.raghav@samsung.com> writes:
> 
>> commit 5d894321c49e ("fs: add atomic write unit max opt to statx")
>> added atomic write max optimal to statx. As XFS can support large atomic
>> writes through SW, max_opt exposes the value that will be HW accelerated
>> atomics.
>>
>> As ext4 does not support SW atomics, set awu_max_opt to awu_max.
>>
> 
> As per the man page the awu_max_opt=0 means:
> 
>     A value of zero indicates that stx_atomic_write_unit_max is the
>     optimised limit.
> 
> [1]: https://man7.org/linux/man-pages/man2/statx.2.html
> 
> But the value of 0 isn't wrong either. Jan, added that it might be more

Yes.

> clear to report awu_max there instead of 0. So, if are going to do it -
> let's add this info to the commit msg. So it doesn't look like we were
> trying to fix anything here ;)
> 

That is why I did not put any fixes tag, as 0 just indicates awu_max is the supported value.

I can update the commit message to make this more explicit.

I guess this is not a problem for ext4, but for XFS, is there a way for the applications to reliably
know whether the atomic command will be HW accelerated or not?

For normal SSDs:
ext4: awu_min and awu_max = 0, awu_max_opt = 0
XFS: awu_min = fs block size, awu_max = SW atomic max, awu_max_opt = 0

For Atomic SSDs:
ext4 with bigalloc (without these patches): awu_min = fs block size, awu_max= HW atomic limit
awu_max_opt = 0
XFS: awu_min = fs block size, awu_max = SW atomic max, awu_max_opt = HW atomic limit


As a user who would only like HW atomic path, it is very hard to know which value to use unless
they know what each filesystem does.

Even though statx says zero to indicate stx_atomic_write_unit_max is the optimized limit, I think
it is better for all the filesystems who support HW atomics to set the max_opt to the HW optimized
limit to make life easier for the users.


> btw note that bdev_statx() still reports 0 for awu_max_opt.
> 

I will send a separate patch for this as well. Thanks.


--
Pankaj
