Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793645232;
	b=DVQaoe9qIf8QtllQdTzbxXqqCGryBR0ERGrLH7xCmvgjQOJ4Iy6RWAc6nDH0gGiUgLcv
	 2fMcSUZZbDbN8aLtPINx/4MFxAVZtwI99zCXEpYJsuKyKj24/hVv83yvPtxswE2eTGDlg
	 2qVXsTZgEVXTLPYBrq9VhfEIxwVcd5mnalH1SLPjYt87xDGV3/gteqW3ec6wj3CAXmPxc
	 82n0GpmKoJD4nXKyQ/VhTCASsWf+4AjQdy28oMuIu2sTS2R2AqyA497UYccZlFUKKL73G
	 SJYWB1rE7vZe2WD7f/VTWinzeTBnJuR/bo1CDXGF1mj865JzZacK9eA/JJPMGZlpZpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793645232;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SEsBJBw366xJ52+LPOaVa3++mQEwnrnaAytBVVgLDwU=;
	b=FCRZqo3pB8FbWH8iuqJWsj3Q6hewB+oMWHTF3bWIgB2fIG6RYN/+xCUQytCym3b06h94
	 kvcgJkF5ADLqJ6286MqU0TQUDL6ICUl/G+DlFpCszhBoQdvSeH4zhK+HLfC6zyIf6IdEZ
	 imQbRWf9UYGlUPBIiOHpCGG0QRK5DyUgxIOsNmHStK0W/zfShlZFfUVW4FVWGUpokuxSL
	 lfwzi62LMaZRjxCQMviwnOVT0WuuUTh5A+EHpRTP84JZstZKJO+DArhsOQ36cUKBmEHLa
	 1vKfxXKDuv6fSYnOzE88ZibHJ6RlWiVs7vsUnVeNKJwjJzmwpzYWi4LhbgT1dcmWhjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EthkNfkZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A7C606A327
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 18:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EthkNfkZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC3C1F00A16;
	Mon,  2 Nov 2026 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793645231;
	bh=SEsBJBw366xJ52+LPOaVa3++mQEwnrnaAytBVVgLDwU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EthkNfkZNsW3ttibqtMHIQobx5CN0TqmWfAJ9iUh6tCwXyFpX++IaSngCIXGHLnfX
	 LOzKc5vqr5lvPIUnW7m2ieglEclIaOVFLXouQPziyjEUWsk8BGGv1i8dnTqegI/jrS
	 S27nAH/KssQSISoqdqy+EAMPQEPi6G9Jvy1VA2fgXf3m/sqBQrGJhqRUCsevGTy4X2
	 sbT2QZdkzf1HLTeaklc1z/M/STRAruF8WXw0YQXd7PHnIVjFFjxmuGXYHC5g+/sA+p
	 cWeo7vtm0e+1S+Ah33vJ1Jj30ObnV0EsyY1e+QSmCwR7dQUKi2U9toW7holbYUu8hH
	 fsCPGQMWEFPfA==
Message-ID: <sashiko-outbox-193963@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/8] ext4: don't zeroout if we have inflight direct IOs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261102-ext4-endio-zero-bug-v1-5-266d2bb9e6dc@linux.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
 <20261102-ext4-endio-zero-bug-v1-5-266d2bb9e6dc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 18:47:10 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> When endio conversion of an unwritten extent fails (e.g. ENOSPC while
> trying to split the extent), ext4 falls back to zeroing out the unwritten
> portions of the extent and marking it as written. This is safe only when =
no
> other in-flight writes have valid data underneath other parts of the same
> unwritten extent, otherwise the zeroout would silently corrupt that data.
>=20
> Commit ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O")
> changed the dio path to submit I/O without pre-splitting extents, deferri=
ng
> the split to endio. This means multiple concurrent writes can share a
> single unwritten extent, and a failed split on one of them could zeroout
> data belonging to another.
>=20
> Buffered IO fixes this by counting such IOs on unwritten extents in
> i_conv_pending_ios and decrementing them after conversion. However, due to
> the way dio iomap is designed, it is not very straightforward for the FS
> [ ... ]
> for all inflight dio, not just dio over unwritten extents) but it keeps t=
he
> code simple.
>=20
> Fixes: ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O")
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-ext4-endio=
-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com?part=3D5

