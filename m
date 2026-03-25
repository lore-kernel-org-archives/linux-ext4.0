Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22583BF69D;
	Wed, 25 Mar 2026 10:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774435655; cv=none; b=oGbNuh/N1N80qjE52sQovYrwDmTGLx6yjl028avwe1FIS/Vy44fzX9oqq0dYImznC7s+hOpIob38WwwSosO1Xlf2CJ+ORg5E7PcXuIhlE4/dFoStduc59HNR1xMRguK9XytKVMxUUSfpCI1jtI7LGEPl6qSt4DTGpDCVzUKtKmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774435655; c=relaxed/simple;
	bh=bv+NsVz6OapwrB5TX2Pmr9rejt829yROzXmKIMVXUCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qCJnahgWdrMFuQE6hXY/X5sC5HEeA9egaYudzVPqIQCmfEFsGSs/WbTuYgqoQ1zyaXJ20lxPKZ0ygGIJ/uvwElcH0zw7b+crl4tmaYvxJMgJApBE4FzJiYcerO+9UAfleOYob5Da97WJAbfgaqBqxSY/EiKSRuWUy8MLTmurUBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [IPV6:2400:2410:b120:f200:a1f3:73da:3a04:160d] (unknown [IPv6:2400:2410:b120:f200:a1f3:73da:3a04:160d])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id CBBAF3F004;
	Wed, 25 Mar 2026 11:47:28 +0100 (CET)
Message-ID: <befb1cd7-f709-4e46-b08f-9c2579b10fd6@hogyros.de>
Date: Wed, 25 Mar 2026 19:47:25 +0900
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5BRFC=5D_Proposal=3A_provenance=5Ftime_=28ptime=29?=
 =?UTF-8?Q?_=E2=80=94_a_settable_timestamp_for_cross-filesystem_migration?=
To: Sean Smith <defendthedisabled@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, dsterba@suse.com,
 david@fromorbit.com, brauner@kernel.org, osandov@osandov.com
References: <CAOx6djP4hb-Cd1Zk07SNfFfLc8irjNmbVqq+58h1Whz+h1wSFA@mail.gmail.com>
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
In-Reply-To: <CAOx6djP4hb-Cd1Zk07SNfFfLc8irjNmbVqq+58h1Whz+h1wSFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 3/25/26 1:26 PM, Sean Smith wrote:

> For litigation evidence, file creation timestamps are provenance
> metadata. They establish when a document first came into existence
> as a digital file. Losing this metadata during a routine filesystem
> migration is a forensic integrity failure — it destroys the timeline
> that courts, investigators, and opposing counsel may rely on.

FWIW, these creation timestamps are somewhat easily falsifiable -- by 
setting the system clock before creating the file, for example.

Adding another easily falsifiable timestamp that provides conflicting 
information does not help with forensic integrity, it only muddies the 
waters some more.

If you need to document that a file was created before a particular 
time, the proper approach is to submit a cryptographic checksum of the 
file to a timestamping service. There are various such services run by 
Certifying Authorities, some by notaries public, and some by volunteer 
organizations.

This does not help for older documents, obviously, because such a 
service would not attest to having seen the document on an older date 
than the present.

"Forensic" means that the file system metadata will be analyzed by an 
expert for plausibility. This expert will disbelieve any information, 
including "forensic" metadata, from any file system that was stored on 
media controlled by untrusted parties.

BSD has the concept of "securelevels", where even the admin user cannot 
perform certain actions while the system is running in multi-user mode, 
and direct modification of on-disk data bypassing the file system is 
among those. The key here is "multi-user mode": this is to protect 
against an attacker who has gained remote access destroying evidence.

The administrator is at any time free to switch the system to 
single-user mode, which locks out any remote access, perform any 
modifications they want, and return to multi-user mode. Because 
switching to single-user mode disrupts remote access, this manipulation 
level is unavailable to remote attackers, allowing the admin to perform 
"forensic" analysis after a breach.

This is only tangentially related to evidence presented at a trial. An 
expert witness can only state "this is the creation time I found on 
disk", but cannot say when that timestamp was written, so it is fairly 
weak evidence.

Timestamping services are much stronger: they have a system with 
physical access barriers that has a single interface to the outside 
world, over which it can receive a cryptographic checksum and return a 
cryptographically signed message with the data received, a timestamp, 
and a signature that covers both. This can be presented at court and, if 
necessary, supported by the witness testimony of the service operator.

In short, this is not a technical problem that can be solved on a 
computer that isn't trusted by the opposing party -- and the solution is 
to bring a trusted third party into the mix. There is a reason your 
lawyer stamps any letters they see with the current date.

    Simon
