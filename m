Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794340362;
	b=NnJbs0u/96ovfOx2ruBOxDjL2uJc8YIgEy/Tq6mu5+B2hT5zkZf0rlORNHut6F3oP8Wn
	 YQGu6saNn3LKwLyYWipSYSWnaNezXMmLkfH1p6tX/kBf4kySFlboDYZFZXUN4AMeBBRZa
	 QZw+zNDfE/0OEnGtaCiFbxf2HJIY84RcxTovrG26iS5mjVKzzWLfTcex3v6TSU2ZKqnlr
	 3eLsTbkQ2+Rm/7Ejjjn9F0xX9P8bsEh7bYNtxH5JirerkoK/14Bhly8e+qEg5ohFYaLVi
	 JiwRxhz1WK56gIrnhMMdRxB/CaYJJV1vfwtQt8MWIOh82zzNcB7pvUJlQiAZzPpy5GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794340362;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oaZmLT7gEerpkmcU0989hJEG4CIaFOat9Jo0nt1dgVY=;
	b=sSa5m1KQM+gIT37zvNa6CUsVHPMLnhwnYiT1dLpMuWZ+LaIsX4AS+AHuJOeK8BCu50R6
	 ZCx4BBv4V6AUj26NMcsgvvvBWIzZDtFO2CbfW6nn/gAweVJRDY13KfxIxPAXDZvMbf+u7
	 J77cXg+cd0Ihj4AyP/fjIqVHfbMwD2zhrw09ILWoFIlQuar6qUqqGRzLkjxDjjMCKlMLA
	 cMDGPFwsrFWih4au+ZPjMydd2+KbMTEcKj4WX30iYZ3W2ybxJ7aaBWuG9hsf3WfgwHJpl
	 U3tYVKlunVXrOB2K0xNeKHFLsE3pxT1f42n5yCPjLzNXyd6TgzyXaQLn5VaP3sGAfew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HkXJ0DSL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E97D606A32D
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 19:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HkXJ0DSL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6101F008A2;
	Tue, 10 Nov 2026 19:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794340362;
	bh=oaZmLT7gEerpkmcU0989hJEG4CIaFOat9Jo0nt1dgVY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HkXJ0DSLfwcMR+amDq/v86UiaeBnDwRP/kdagiYzYuSjnDeqVtRxVAWNg+Rs25b5m
	 +NZ6lfhrPEHd8vHRaIfnD2Sybxtd8eNjSJSLuqh6f/lu6NOJCGwfeMZp3jeoQsnIDW
	 ja9c4fHbuADA07O2NG2SyRc6M1rhIyyK/0SivhVU+Nq5SwmLS5rDQr2pnh+iIjMKv3
	 6SbWIwCUKHpfZs6i43aOSOyHh6OZvspIJ2dHPK4zeL2s204nw9fk3DBgYsZgzGwaq5
	 tmVWCvUaAJOKiOIRGIFX3Aywb/7a8DuNgWHPn5BmZ/WPEJgVEsUGioOgk7mqBspJhl
	 wyCU6IrQVkGrw==
Message-ID: <sashiko-outbox-207686@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 05/11] fs: validate atomic writes after O_APPEND and
 limits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261110190417.32650-7-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-7-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 19:52:40 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> An RWF_ATOMIC write on XFS with reflink can expose stale disk contents
> if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
> aligned.
>=20
> XFS and ext4 call generic_atomic_write_valid() on the range that the
> caller passed. But generic_write_checks() changes the range later:
> O_APPEND moves the position, and RLIMIT_FSIZE cuts the length. XFS can
> then fill only a part of a new block, and still map the whole block into
> the file:
>=20
>     block size 4096, i_size 512, O_APPEND
>     validated:        0 to 4095
>     written:          512 to 4607
>     new blocks:       0 to 8191
>     stale below EOF:  0 to 511
>=20
> The fix used here is to validate an atomic write in
> generic_write_checks(), after its range is final, and to refuse one that
> was cut. XFS no longer picks the path of an atomic write by the
> alignment of the range that the caller passed.
>=20
> Fixes: f096207d3276 ("xfs: Validate atomic writes")
> Fixes: 43c696f9d094 ("ext4: Check for atomic writes support in write iter=
")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110190417.3265=
0-1-mason@kernel.org?part=3D5

