Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329348;
	b=PwJrUe2erSqsN1qYI0huuR0rOSp1AoXrr+lPoRj8qHntr68OhQv+Sj7VFejDVOG+IArn
	 L7X4uyDxz80abJeR310qz5qzTUGt5ZW1OhQaFTC7F9fvmYE0NSPtdGpHRB85dR8EQ8Q52
	 YSAvw3+KCWRM54KJ58bETOQ2CuuCwAVLvV3PmbZ3XICc/aopgLw+p3H/EGRFPmgn+ErKK
	 EaSlp8EQMQ2QQYtNZjz6gKBPqbor+GBIPMpfI+n3Tp0WPqzGaiE2PFEbv870EhEfhQpQC
	 tmQ8xMnU8N/cfYHXVsAW8koaU1BQVfIjwB+ZDqpVirtJTwZwLVj16lqkhxu7wEQx2Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329348;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=j+kcokZ4xHGxJq0P/WhzoZttU3HWbvCpv4EkchTdAsQ=;
	b=v6qKlqGhn96sxEwZ1Fd6FB1/nVSMS1B7nuiXcXRPz0/N/ONhpKNBZZCHVGBDK6d4VAiG
	 nV2e3VdvInZXpkXb3h4YJ0q0WnmZDYPpAvFhha+tcE67gB2DEroXRA6RE0zatwP9omAXF
	 TsSnjy95jCY963zrQEchhrJp8s0Df/0Y2KPpiRLM59dP+BqVYOXX6wxu1gYIeDs8i73Aj
	 2mma7CqPv7/r2UCKcKY4W0Yec7FB2FSRju1KQD263GguXt5cfeOgsh3cE4SYnKZGwVd8+
	 aGyTivd9KwTzOlmqI7psISkbQtZpSJfa+dW8fGFhdm2kS2ud91Kdv2fY1bCr+Dch8mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nwj8Mx7v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22343606A324
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 03:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nwj8Mx7v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC7E1F000C1;
	Fri, 30 Oct 2026 03:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793329347;
	bh=j+kcokZ4xHGxJq0P/WhzoZttU3HWbvCpv4EkchTdAsQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nwj8Mx7vM2cnIOmfEn8lz2yIFgI9x8HxpX60NpMtZD4yHwB2A54cSLkVA4veqGpiS
	 RQOo2qYf700Kb8IF1wUx867DjpWuaIEG6Ya/PDKTdjuCdxIwNV7Ipn61n0Fgghoxj5
	 g5kAyTKV4N6eLApsTslXw78LR0SLzn/Y8IRYxCoQIZ0n7F3SXMh7vIx1ttGRa7lmYZ
	 q/HHUv9tVbos7dVJYh52JEi/CRAyUFwaQ/qg0Ej+dkg+cytBX2lkWEW/7Ie2RQigHB
	 lE5AXQSUh/txEWdiH+soQjKQTKp4sndYXXNXR1FA3lnt7UIoawDbnVkqEGEEXJ5WXG
	 086F/hyJh3q0g==
Message-ID: <sashiko-outbox-190193@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: do not report inline conversion allocation
 failures as fs errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hengyu Liang" <hengyul@cs.unc.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261030025730.3965245-1-hengyul@cs.unc.edu>
References: <20261030025730.3965245-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 03:02:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> When truncate grows an inline-data file beyond its inline capacity,
> ext4_setattr() first calls ext4_convert_inline_data(). If the conversion
> fails, it jumps to err_out and passes the error to ext4_std_error().
>=20
> Allocating the first block can fail with -ENOSPC or -EDQUOT on a healthy
> filesystem. Reporting these as filesystem errors records an error in the
> superblock and, with errors=3Dremount-ro, aborts the journal and rejects
> subsequent writes with -EROFS.
>=20
> For example, create a filesystem with inline_data,quota and mount it with
> usrquota,errors=3Dremount-ro. Create a small inline file owned by a user =
with
> a 1 MiB block quota, then let that user fill the quota in a second file.
> Growing the inline file with ftruncate() returns EDQUOT, after which even
> root can no longer create a file.
>=20
> Return conversion errors directly, as other callers of
> ext4_convert_inline_data() do. The conversion helper handles its own
> cleanup, and lower layers report metadata and journal errors.
>=20
> Fixes: ed9356a30e59 ("ext4: convert inline data to extents when truncate =
exceeds inline size")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030025730.3965=
245-1-hengyul@cs.unc.edu?part=3D1

