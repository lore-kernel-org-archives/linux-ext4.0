Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801AD22FE11
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 02:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774491988; cv=none; b=d6hLT29DpiI0mR/V2D0eztIwrjCNbhDtQ3BQGKVFjRjkS/t9QpynCcU6d+62+vDJV9JCJzAshKDnQab04zRRBwyvY2bnxK36aDEhXG2ZDmsOHanHxpowH19r/hHpTnkKVZoBoORBbAYx7biypP0VHKEgtUgQKQRARG765rOaSck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774491988; c=relaxed/simple;
	bh=ynby6JrDwn5Ax6abbGMCPRmuLTqO16MRFElp7xF6HjQ=;
	h=From:References:In-Reply-To:Date:Message-Id:To:Cc:Subject:
	 Mime-Version:Content-Type; b=Ct78pSYzPpAxKeikug/S8DD6PF8cKabcwfbAPeAAsZPM0LC98n5uwFhcNPImZV4IMf/7fGmjBYHyryNZOYjtlqz2SdtfCXJ/Z9uhgWPg3A2AGu7kepzON/ZhPIwGxLnztr4XzYjZCuzHFeL36Sz2FC+pj8l7Qzmt++YMtptyv3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=E5n+X4Q/; arc=none smtp.client-ip=209.127.231.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="E5n+X4Q/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1774491981; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ynby6JrDwn5Ax6abbGMCPRmuLTqO16MRFElp7xF6HjQ=;
 b=E5n+X4Q/L5G+c2DiV3CVngYaOn9sbMB7AIgJUv6IY7v9FVZ1RcFbsFwFgeFq8x7uyikqrQ
 TPKICGsDxpiYnpqHCAuYfQmp7c6qaeG6TC/0Sl96LjxHZ1AJRx61izL4RE6/Qy0Zuiowg9
 8Eck6rrI3ozlqwKZeJFgrAqulfWIICwvdkiDGVV75vI6AL0G25UP1Sb80BI2tJMH8cB6wG
 hURQ+qW6w6hCnjJsOhbJ89362V+2/Ljbk18Zgiy6k94yInEXEqepHtF3b1R+ZYRX6sESd5
 yyGZKACfNiBG5KsVR3sK+xqpVqMEhUvtpwYdeM/TB/TsJctUeSBbylpvbGqsTQ==
From: "changfengnan" <changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+169c4994b+c2d505+vger.kernel.org+changfengnan@bytedance.com>
Content-Transfer-Encoding: quoted-printable
References: <20260325093349.630193-1-diangangli@gmail.com> <20260325093349.630193-2-diangangli@gmail.com> <B53E253C-F314-4376-BD9D-58867FC8D3F6@dilger.ca> <c6f4b982-c6e4-4f77-a16d-0c381c1e25f0@bytedance.com>
	<e5c657e6-ffbd-4327-adaf-ae52cb50b96d@gmail.com>
In-Reply-To: <e5c657e6-ffbd-4327-adaf-ae52cb50b96d@gmail.com>
Date: Thu, 26 Mar 2026 10:26:16 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.b75b68ec.808e.4625.9191.7f725153fe9d@bytedance.com>
To: "Zhang Yi" <yizhang089@gmail.com>
Cc: "Diangang Li" <lidiangang@bytedance.com>, 
	"Andreas Dilger" <adilger@dilger.ca>, 
	"Diangang Li" <diangangli@gmail.com>, <tytso@mit.edu>, 
	<linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/1] ext4: fail fast on repeated metadata reads after IO failure
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8


> From: "Zhang Yi"<yizhang089@gmail.com>
> Date:=C2=A0 Wed, Mar 25, 2026, 22:27
> Subject:=C2=A0 Re: [RFC 1/1] ext4: fail fast on repeated metadata reads a=
fter IO failure
> To: "Diangang Li"<lidiangang@bytedance.com>, "Andreas Dilger"<adilger@dil=
ger.ca>, "Diangang Li"<diangangli@gmail.com>
> Cc: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.ke=
rnel.org>, <linux-kernel@vger.kernel.org>, <changfengnan@bytedance.com>
> Hi, Diangang,
>=C2=A0
> On 3/25/2026 7:13 PM, Diangang Li wrote:
> > Hi Andreas,
> >=C2=A0
> > BH_Read_EIO is cleared on successful read or write.
>=C2=A0
> I think what Andreas means is, since you modified the ext4_read_bh()=C2=
=A0
> interface, if the bh to be read already has the Read_EIO flag set, then=
=C2=A0
> subsequent read operations through this interface will directly return=C2=
=A0
> failure without issuing a read I/O. At the same time, because its state

IMO, we first need to reach a consensus on whether we can expect a
retry to succeed after a read failure.=C2=A0
Given that current SCSI and NVMe drivers already perform multiple
retries for I/O errors.
IMO, this depends on the specific error. If the block layer returns
BLK_STS_RESOURCE or BLK_STS_AGAIN, we can retry; however, if
it returns BLK_STS_MEDIUM or BLK_STS_IOERR, there is no need to retry.
For scenarios requiring a retry, we should also wait for a certain time
window before retrying.

Thanks.
Fengnan.

> is also not uptodate, for an existing block, a write request will not be=
=C2=A0
> issued either. How can we clear this Read_EIO flag? IIRC, relying solely=
=C2=A0
> on ext4_read_bh_nowait() doesn't seem sufficient to achieve this.
>=C2=A0
> Thanks,
> Yi.
>=C2=A0
> >=C2=A0
> > In practice bad blocks are typically repaired/remapped on write, so we
> > expect recovery after a successful rewrite. If the block is never
> > rewritten, repeatedly issuing the same failing read does not help.
> >=C2=A0
> > We clear the flag on successful reads so the buffer can recover
> > immediately if the error was transient. Since read-ahead reads are not
> > blocked, a later successful read-ahead will clear the flag and allow
> > subsequent synchronous readers to proceed normally.
> >=C2=A0
> > Best,
> > Diangang
> >=C2=A0
> > On 3/25/26 6:15 PM, Andreas Dilger wrote:
> >> On Mar 25, 2026, at 03:33, Diangang Li <diangangli@gmail.com> wrote:
> >>>
> >>> From: Diangang Li <lidiangang@bytedance.com>
> >>>
> >>> ext4 metadata reads serialize on BH_Lock (lock_buffer). If the read f=
ails,
> >>> the buffer remains !Uptodate. With concurrent callers, each waiter ca=
n
> >>> retry the same failing read after the previous holder drops BH_Lock. =
This
> >>> amplifies device retry latency and may trigger hung tasks.
> >>>
> >>> In the normal read path the block driver already performs its own ret=
ries.
> >>> Once the retries keep failing, re-submitting the same metadata read f=
rom
> >>> the filesystem just amplifies the latency by serializing waiters on
> >>> BH_Lock.
> >>>
> >>> Remember read failures on buffer_head and fail fast for ext4 metadata=
 reads
> >>> once a buffer has already failed to read. Clear the flag on successfu=
l
> >>> read/write completion so the buffer can recover. ext4 read-ahead uses
> >>> ext4_read_bh_nowait(), so it does not set the failure flag and remain=
s
> >>> best-effort.
> >>
> >> Not that the patch is bad, but if the BH_Read_EIO flag is set on a buf=
fer
> >> and it prevents other tasks from reading that block again, how would t=
he
> >> buffer ever become Uptodate to clear the flag? =C2=A0There isn't enoug=
h state
> >> in a 1-bit flag to have any kind of expiry and later retry.
> >>
> >> Cheers, Andreas
> >
>=C2=A0
