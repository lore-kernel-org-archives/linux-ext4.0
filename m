Received: from va-2-115.ptr.blmpb.com (va-2-115.ptr.blmpb.com [209.127.231.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC87285041
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 11:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774437229; cv=none; b=uM7ak3HCTEWRGr+VqrYKyJeMNzhH+648mXjHjIayisbYoRHD/oGHB+gXkc85KLHCatvidyoo25wa0bcERh796CSJEkH9MbN3QPX2u1pDCEc/h0UarEIu9hr3775PSp0/o9r88QGH2NhDx+91xEsokgA40ThOl8IkqSTV4uqO9kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774437229; c=relaxed/simple;
	bh=SFHCUZ67nBPcXWqe4pxF+iah/BBWuCNThzxz4J6SuqU=;
	h=Message-Id:To:Cc:Subject:Mime-Version:References:From:Date:
	 Content-Type:In-Reply-To; b=UIjoUGSiT+8Hv/jL+NlvWcvPvFVdGoOf6yxF87ku4XNpprenWViRjr7fGnZ2YjSYppWl2GNBMmpk7iga5NOJYbyz8v0VMw2+EGcjor1HFwr4azoRlsFfJz21AXmSpjvC7nffzOrPM+UBIRX27AHvJGrcsfvrjNy/JvnSwOpI6q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=lp7VoRpX; arc=none smtp.client-ip=209.127.231.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="lp7VoRpX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1774437216; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=/2uLAgm3FI5zhNajV9t6fx76xgfhgjkuo6m+NR3j7To=;
 b=lp7VoRpX9+VtgW0e0EYqD10+zbp8UcEA3tsnrK0jjQ1DSvQHk4BRcfg0QX8NhDE0ESbU4I
 4SazBM4BV1ZXKr9VlJyFtBkHIglUlJrlZfdOpE1oEE/5Lxg5qUBASPWBMLt1pmpxdtTLPY
 +UXzNKqUjPhasZENl/BQfsv+iwvmHHjWGMUpmC8uLFpDkXrNIFTp5wFoPmv3vnfZDkUMJe
 MWhdvlKKodsvds3d4u6hJ30EEugsWfv8RPZJLuWX+8WzbWfBJHpCZJxMj4wHWhcVV6tOso
 uiliJxBc4EkMtl60u0jgT42EapGxptTwrINUIPWMCCIGZGi8eqxzDDHvIxts3Q==
Message-Id: <c6f4b982-c6e4-4f77-a16d-0c381c1e25f0@bytedance.com>
X-Original-From: Diangang Li <lidiangang@bytedance.com>
User-Agent: Mozilla Thunderbird
To: "Andreas Dilger" <adilger@dilger.ca>, 
	"Diangang Li" <diangangli@gmail.com>
Cc: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<changfengnan@bytedance.com>
Subject: Re: [RFC 1/1] ext4: fail fast on repeated metadata reads after IO failure
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+269c3c35e+b21b58+vger.kernel.org+lidiangang@bytedance.com>
Content-Language: en-US
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260325093349.630193-1-diangangli@gmail.com> <20260325093349.630193-2-diangangli@gmail.com> <B53E253C-F314-4376-BD9D-58867FC8D3F6@dilger.ca>
From: "Diangang Li" <lidiangang@bytedance.com>
Date: Wed, 25 Mar 2026 19:13:21 +0800
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <B53E253C-F314-4376-BD9D-58867FC8D3F6@dilger.ca>

Hi Andreas,

BH_Read_EIO is cleared on successful read or write.

In practice bad blocks are typically repaired/remapped on write, so we
expect recovery after a successful rewrite. If the block is never
rewritten, repeatedly issuing the same failing read does not help.

We clear the flag on successful reads so the buffer can recover 
immediately if the error was transient. Since read-ahead reads are not 
blocked, a later successful read-ahead will clear the flag and allow 
subsequent synchronous readers to proceed normally.

Best,
Diangang

On 3/25/26 6:15 PM, Andreas Dilger wrote:
> On Mar 25, 2026, at 03:33, Diangang Li <diangangli@gmail.com> wrote:
>>
>> From: Diangang Li <lidiangang@bytedance.com>
>>
>> ext4 metadata reads serialize on BH_Lock (lock_buffer). If the read fails,
>> the buffer remains !Uptodate. With concurrent callers, each waiter can
>> retry the same failing read after the previous holder drops BH_Lock. This
>> amplifies device retry latency and may trigger hung tasks.
>>
>> In the normal read path the block driver already performs its own retries.
>> Once the retries keep failing, re-submitting the same metadata read from
>> the filesystem just amplifies the latency by serializing waiters on
>> BH_Lock.
>>
>> Remember read failures on buffer_head and fail fast for ext4 metadata reads
>> once a buffer has already failed to read. Clear the flag on successful
>> read/write completion so the buffer can recover. ext4 read-ahead uses
>> ext4_read_bh_nowait(), so it does not set the failure flag and remains
>> best-effort.
> 
> Not that the patch is bad, but if the BH_Read_EIO flag is set on a buffer
> and it prevents other tasks from reading that block again, how would the
> buffer ever become Uptodate to clear the flag?  There isn't enough state
> in a 1-bit flag to have any kind of expiry and later retry.
> 
> Cheers, Andreas
