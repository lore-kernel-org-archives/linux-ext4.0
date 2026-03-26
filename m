Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B2233F5B9
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 07:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774511000; cv=none; b=AKwavZlrkd+crfPSbAOzYyrC39F0NGZKvlFMaSMvwnt2DJDh57XCBHtCzQmERF6PhsVHA8DdWaJ2yjt/yb07IHAaSXGDQWP7xezJFw2XcMSp0KzynssVJfyX6Y+nFsz/VpHvo3ujOEQsx4ZnXleYRAdGX8h1F5UNrT3WcW4rD74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774511000; c=relaxed/simple;
	bh=nSUnf9vKTG2WbDQxCg6oJsNQhxrvJOvA3SX+S7lkv8M=;
	h=Cc:Date:Content-Type:To:References:From:Subject:Message-Id:
	 Mime-Version:In-Reply-To; b=TmM2jI63pbiTL79DNGlAOzrMpHTwOaxiTMiMqW2AbIIUTtd/N6KInBys0bofXgdSXp9iPoLYOEkQaW5Ig9CS35FRbJwhAl8NEFnDRHGVX9SCMmP1XVSgS6oWroKCu7Xz80ttDyGTMif2Bg6GyJqZZqhaGJFvwU5DM427DCG/sF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=R4sQiRwh; arc=none smtp.client-ip=209.127.230.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="R4sQiRwh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1774510992; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=nSUnf9vKTG2WbDQxCg6oJsNQhxrvJOvA3SX+S7lkv8M=;
 b=R4sQiRwhdLEqS5YRcOfMoaYtmkrggJzqSkDSoPINbQB7s45paTZHW/auWQyfjU2j+pj2tt
 BElStn97jncS23PSU0oiqRfV9hfVhgoz2H+gAu1p7qC2hXDJI3f1sTOmQB4nMdsWwM/G+H
 WNzA6mXcfq/hP6/ssv8TtDN6SaSpy4qgDKbBts7HfqNDxmloTx2FE5fw6WqPfaOIMEM7/U
 KQc+Oc4WwCTv+H+xDiEb9OZrStlQ5R8tONLGSFXXjsVG+DCaKrafgXz9RPUu3BPwgeMev9
 yEuylpIBrnqDw912bUUNaDnCoiadgwKFeE4Kj9qVqHuylUQSWfVj0RIhCVadiQ==
Cc: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+269c4e38e+14f4dc+vger.kernel.org+lidiangang@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Mar 2026 15:42:57 +0800
Content-Type: text/plain; charset=UTF-8
To: "Zhang Yi" <yizhang089@gmail.com>, "Andreas Dilger" <adilger@dilger.ca>, 
	"Diangang Li" <diangangli@gmail.com>
User-Agent: Mozilla Thunderbird
X-Original-From: Diangang Li <lidiangang@bytedance.com>
References: <20260325093349.630193-1-diangangli@gmail.com> <20260325093349.630193-2-diangangli@gmail.com> <B53E253C-F314-4376-BD9D-58867FC8D3F6@dilger.ca> <c6f4b982-c6e4-4f77-a16d-0c381c1e25f0@bytedance.com> <e5c657e6-ffbd-4327-adaf-ae52cb50b96d@gmail.com>
Content-Language: en-US
From: "Diangang Li" <lidiangang@bytedance.com>
Subject: Re: [RFC 1/1] ext4: fail fast on repeated metadata reads after IO failure
Message-Id: <aa1f5bb1-ffa0-4c85-a228-730593bd4ed0@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <e5c657e6-ffbd-4327-adaf-ae52cb50b96d@gmail.com>

Hi, Yi,

Thanks. Yes, for existing metadata blocks ext4 is read-modify-write, so=20
without a successful read (Uptodate) there is no write path to update=20
that block.

In the case we're seeing, the read keeps failing (repeated I/O errors on=20
the same LBA), so the write never has a chance to run either. Given=20
that, would it make sense (as Fengnan suggested) to treat persistent=20
media errors (e.g. MEDIUM ERROR / IO ERROR) as non-retryable at the=20
filesystem level, i.e. keep failing fast for that block? That would=20
avoid the BH_Lock thundering herd and prevent hung tasks.

Thanks,
Diangang

On 3/25/26 10:27 PM, Zhang Yi wrote:
> Hi, Diangang,
>=20
> On 3/25/2026 7:13 PM, Diangang Li wrote:
>> Hi Andreas,
>>
>> BH_Read_EIO is cleared on successful read or write.
>=20
> I think what Andreas means is, since you modified the ext4_read_bh()=20
> interface, if the bh to be read already has the Read_EIO flag set, then=
=20
> subsequent read operations through this interface will directly return=20
> failure without issuing a read I/O. At the same time, because its state=
=20
> is also not uptodate, for an existing block, a write request will not be=
=20
> issued either. How can we clear this Read_EIO flag? IIRC, relying solely=
=20
> on ext4_read_bh_nowait() doesn't seem sufficient to achieve this.
>=20
> Thanks,
> Yi.
>=20
>>
>> In practice bad blocks are typically repaired/remapped on write, so we
>> expect recovery after a successful rewrite. If the block is never
>> rewritten, repeatedly issuing the same failing read does not help.
>>
>> We clear the flag on successful reads so the buffer can recover
>> immediately if the error was transient. Since read-ahead reads are not
>> blocked, a later successful read-ahead will clear the flag and allow
>> subsequent synchronous readers to proceed normally.
>>
>> Best,
>> Diangang
>>
>> On 3/25/26 6:15 PM, Andreas Dilger wrote:
>>> On Mar 25, 2026, at 03:33, Diangang Li <diangangli@gmail.com> wrote:
>>>>
>>>> From: Diangang Li <lidiangang@bytedance.com>
>>>>
>>>> ext4 metadata reads serialize on BH_Lock (lock_buffer). If the read=20
>>>> fails,
>>>> the buffer remains !Uptodate. With concurrent callers, each waiter can
>>>> retry the same failing read after the previous holder drops BH_Lock.=
=20
>>>> This
>>>> amplifies device retry latency and may trigger hung tasks.
>>>>
>>>> In the normal read path the block driver already performs its own=20
>>>> retries.
>>>> Once the retries keep failing, re-submitting the same metadata read=20
>>>> from
>>>> the filesystem just amplifies the latency by serializing waiters on
>>>> BH_Lock.
>>>>
>>>> Remember read failures on buffer_head and fail fast for ext4=20
>>>> metadata reads
>>>> once a buffer has already failed to read. Clear the flag on successful
>>>> read/write completion so the buffer can recover. ext4 read-ahead uses
>>>> ext4_read_bh_nowait(), so it does not set the failure flag and remains
>>>> best-effort.
>>>
>>> Not that the patch is bad, but if the BH_Read_EIO flag is set on a=20
>>> buffer
>>> and it prevents other tasks from reading that block again, how would th=
e
>>> buffer ever become Uptodate to clear the flag?=C2=A0 There isn't enough=
 state
>>> in a 1-bit flag to have any kind of expiry and later retry.
>>>
>>> Cheers, Andreas
>>
>
