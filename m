Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282C034EF05
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 12:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774526975; cv=none; b=I2Atqwzgt1n5JxeYayVPFEyFRG9r4pQwoAIiMCdC5dyRa0skdQx0fPJsOOKCFJKpxZtHdH6CiFHQiBEYM7+vPfzse8WJv3zhBN9upr6lH2TX8Dd21FKNMLytWu3Ltyid3Z4pZdr9OpBE945ClTZKGSvjmhq8rttB/R3gFOkLvG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774526975; c=relaxed/simple;
	bh=6V2ldDbGE+hirwsVOobsXeMIKV23Yx22E9G8nbKthfk=;
	h=Mime-Version:In-Reply-To:Message-Id:References:Cc:Subject:
	 Content-Type:To:Date:From; b=a5504QIA8AeMqOUQ4jPxdEXdBEmqZtglqhLqvLRcKvjWK/QSnNHDaLUNHsTGuaQp5bvBSQaHWr6eGPTehufQpox3KfqlkgjArQX0MTYbJq/PAhBiipvHmA2EhzWKFWA9YD2+76BI9xxJ+sU+uYnZgyxYMI3SlQg/eeBszJQBeLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=dqs42eCK; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="dqs42eCK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1774526967; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=kCXkJW1bYEy/j6tn+IASdmpLScjftFpR6RUcFeI7UuM=;
 b=dqs42eCK5R+smDgmkiXsOMEgIwVTXa/mVovLEKA8JRa4bd0zE5cx+Lqqwtoe2KQhhsM+RS
 IsYaBABLq3LGb9kiD2sBSuCkSdjiJo8IeOyfzZllECPwZ+oQAwy0psWR6QqVIo5F2O6/id
 /h3deqvr0JrNRMesRZepcdlFhQPLcN9PP5i+aZMVAkJygZnnss6likKdG1J8VMF/1xUSHW
 2kQ99+/s7FmIRWeW7BiDsOnVedvjaHtQ4wspllCle/hQsHuOCB6CHNBvw3dhrL76/jp+VN
 fssjGGFnUALa254HKYWa9jMj4euzhGbsPmiCmqQy8w5BrmEDvtfQCje4Z0iDkg==
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <acP5-v85CwUQZlMB@casper.infradead.org>
Message-Id: <7792457f-453b-4534-95bb-f932cbc62d12@bytedance.com>
Content-Language: en-US
User-Agent: Mozilla Thunderbird
References: <20260325093349.630193-1-diangangli@gmail.com> <20260325093349.630193-2-diangangli@gmail.com> <B53E253C-F314-4376-BD9D-58867FC8D3F6@dilger.ca> <acP5-v85CwUQZlMB@casper.infradead.org>
Cc: "Diangang Li" <diangangli@gmail.com>, <tytso@mit.edu>, 
	<linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <changfengnan@bytedance.com>
Subject: Re: [RFC 1/1] ext4: fail fast on repeated metadata reads after IO failure
Content-Type: text/plain; charset=UTF-8
X-Original-From: Diangang Li <lidiangang@bytedance.com>
To: "Matthew Wilcox" <willy@infradead.org>, 
	"Andreas Dilger" <adilger@dilger.ca>
Date: Thu, 26 Mar 2026 20:09:11 +0800
X-Lms-Return-Path: <lba+269c521f5+7d4f15+vger.kernel.org+lidiangang@bytedance.com>
From: "Diangang Li" <lidiangang@bytedance.com>

On 3/25/26 11:06 PM, Matthew Wilcox wrote:
> On Wed, Mar 25, 2026 at 04:15:42AM -0600, Andreas Dilger wrote:
>> On Mar 25, 2026, at 03:33, Diangang Li <diangangli@gmail.com> wrote:
>>>
>>> From: Diangang Li <lidiangang@bytedance.com>
>>>
>>> ext4 metadata reads serialize on BH_Lock (lock_buffer). If the read fai=
ls,
>>> the buffer remains !Uptodate. With concurrent callers, each waiter can
>>> retry the same failing read after the previous holder drops BH_Lock. Th=
is
>>> amplifies device retry latency and may trigger hung tasks.
>>>
>>> In the normal read path the block driver already performs its own retri=
es.
>>> Once the retries keep failing, re-submitting the same metadata read fro=
m
>>> the filesystem just amplifies the latency by serializing waiters on
>>> BH_Lock.
>>>
>>> Remember read failures on buffer_head and fail fast for ext4 metadata r=
eads
>>> once a buffer has already failed to read. Clear the flag on successful
>>> read/write completion so the buffer can recover. ext4 read-ahead uses
>>> ext4_read_bh_nowait(), so it does not set the failure flag and remains
>>> best-effort.
>>
>> Not that the patch is bad, but if the BH_Read_EIO flag is set on a buffe=
r
>> and it prevents other tasks from reading that block again, how would the
>> buffer ever become Uptodate to clear the flag?  There isn't enough state
>> in a 1-bit flag to have any kind of expiry and later retry.
>=20
> I've been thinking about this problem too, albeit from a folio read
> perspective, not from a buffer_head read perspective.  You're quite
> right that one bit isn't enough.  The solution I was considering but
> haven't implemented yet was to tell all the current waiters that
> the IO has failed, but not set any kind of permanent error flag.
>=20
> I was thinking about starting with this:
>=20
> +++ b/include/linux/wait_bit.h
> @@ -10,6 +10,7 @@
>   struct wait_bit_key {
>          unsigned long           *flags;
>          int                     bit_nr;
> +       int                     error;
>          unsigned long           timeout;
>   };
>=20
>=20
> and then adding/changing various APIs to allow an error to be passed in
> and noticed by the woken task.
>=20
> With this change, the thundering herd all wake up, see the error and
> return immediately instead of each submitting their own I/O.  New reads
> will retry the read, but each will only be held up for a maximum of
> their own timeout.

Hi Matthew and all,

Thanks. The idea of waking the current waiters with an error makes a lot=20
of sense.

I=E2=80=99ve been considering a smaller change on the buffer_head side that=
=20
might get most of the benefit without touching the generic wait_bit=20
APIs. The idea is to tell whether taking BH_Lock required waiting. If we=20
had to wait, and the buffer is already marked with=20
buffer_read_io_error(), then just return -EIO and don=E2=80=99t submit anot=
her=20
read. If we got the lock without waiting, still submit the read. That=20
should stop the thundering herd from reissuing the same failing IO.

Another option is a simple retry window. After a read failure, don=E2=80=99=
t
retry for some period of time, and size that window by error type. For
persistent media errors (e.g. MEDIUM ERROR, repeated IO ERROR) the=20
window could be effectively infinite, while for transient cases (e.g.=20
few IO ERROR, BLK_STS_RESOURCE) it could be small.

Any opinions on these two approaches, or other ideas for this problem?

Thanks,
Diangang
