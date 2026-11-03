Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.230.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793674748;
	b=TlLRHN1FMpzEU4Shei9utCxDi3hhkKbuVcZ1BA1AYWqcm4zsuLhiJzq3lFwvgbYgvuzw
	 883raET6Bl5QW+bfkjGDEunyNwFmuKNnoCQ7K6z03P7rVGnqTKvty91yMU1VvdCV27flI
	 8pV8gv/G7WZNMr2qJt6naEpcBoIJs5+Vuc6gzImo0aMvAMKveb3qMF3u6zfDrnpdY+5gg
	 RP7dALtbzdyY9earTWncZtVj+YUhDH/LsRMaank9vLSzESYOTbNAbQ/kv80Ia9vHrBKuF
	 mA6eCBoVBZ7CGQxl7R8RAMm3v3D7wGLIlNyyLtUsLkDpgTNrqL6rhVh+8DQfZmp4mLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793674748;
	h=DMARC-Filter:DKIM-Signature:References:User-Agent:Content-Type:To:
	 Subject:Date:Message-Id:In-Reply-To:Cc:From:Content-Transfer-Encoding:
	 Mime-Version:X-Original-From:X-Lms-Return-Path;
	bh=TkYxQFL24ujwNipbqSI/lL60uuTROX0qlC7c+u8mj4Q=;
	b=E+NVoYYSAAfGG0jeWk16R1QHqfPnmHm+qoTJ/fOZSauqK2xjh/2LJf5qt8EeIXACIRi4
	 UJwNaEyYoL5KahYcFluA0ImvN/77+iGpYme4A0Uo6YDXXqNE1t7E43QNbdTldyqS08NGE
	 C00o/uSes8kj8whOJzsqe34aiL/IgxKtPX4yy+0Q6qNYYe9mrPorF/Pc9BqRhKRQ9ngJD
	 wmnDxQQPJ1o8JoV09YJ90/sJyPdyitHmuNCDSxAs3SU/DjN8G/rWFMQD+uvb3l3H7BxOV
	 ceQ8WG4z3+6rnS4zJGLV27mmTbv2NsywRVcBAT6D1I2aOVfGBxDsAlfvJ1SBTswrLXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	arc=none smtp.remote-ip=209.127.230.115
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C9C606A324
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 02:59:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82C9C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793674736; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=TkYxQFL24ujwNipbqSI/lL60uuTROX0qlC7c+u8mj4Q=;
 b=qmCMyisyjRaqshse65hbt4ZF6sqwcgsQgF6hlaLYSS+17mzE1VqIIxR1L9S16HkTxFWzt8
 T/cmzzpz8Pxqui5XLy8Q18Tm3pAerkw4NB7dzRe8PlhxHWPQjFJVoT/0AAnhyHbaPaATR0
 ecTtKAyJTemwne62bNT4V4Ws1OvCYp7Qsujf8LDli2ivjaqgahjj4v7DEJAPoag1FBZGIS
 KS6ZwzzXIETHqhPMJqD1Pk3ZX+zKytzGPh+sPZwQ1w250cgrOdb8N0oiw/zYJYklaiP8xx
 o+bnD5P2/CrTfIKqrDKbEI2fo5kE+mBzElZmJMNZENJ5u9oj7GYsU2VN4Q0KZQ==
References: <20261102042428.65204-1-zhaogongyi@bytedance.com> <F238B62D-6BED-4D64-B099-B956B820BA44@dilger.ca>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
To: "Andreas Dilger" <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: reject impossible group free cluster counts
Date: Tue, 3 Nov 2026 10:58:38 +0800
Message-Id: <2c1663e5-fac2-4346-ab2a-b35ae652373a@bytedance.com>
In-Reply-To: <F238B62D-6BED-4D64-B099-B956B820BA44@dilger.ca>
Cc: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>, 
	<libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, 
	<linux-kernel@vger.kernel.org>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
X-Lms-Return-Path: <lba+26ae94dee+bdb50c+vger.kernel.org+zhaogongyi@bytedance.com>

Hi Andreas,

Thanks for the review.

On 11/3/26 6:10 AM, Andreas Dilger wrote:
> 
> I think a lot of this class of bug could be avoided by doing very minimal
> checks on the group descriptors initially (and other metadata, enough to
> load and validate the journal inode itself is sane). The journal inode is
> otherwise read-only so its allocations should never be modified.  Then
> replaying the journal if it is dirty, and restarting the superblock/GDT
> checks from the beginning to validate the _current_ blocks are sane.
> 
> That should only be done once per mount. To keep sanity after checks, we
> could validate the journal never contains updates to its own inode (or at
> least not until an SMR "wandering journal/log structure" feature exists).

Agreed. The post-recovery check in v1 is too narrow: it uses the live
superblock geometry, which journal replay may also have changed, and
leaves the other replayed group descriptor fields unchecked.

I will rework v2 so that only the checks needed to safely load the
journal are done before recovery, followed by full superblock geometry
and group descriptor validation after replay and before free-space
accounting. I will also check which existing validation helpers can be
safely rerun without duplicating initialization side effects.

Validating that the journal does not update its own inode also sounds
useful. If that requires broader journal changes, I will handle it
separately.

Thanks,
Gongyi
