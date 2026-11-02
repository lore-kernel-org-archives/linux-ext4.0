Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793645019;
	b=pdGkFmFztseotBHY8KmPvBiJyxB3S8WiGMigat4dVmwndPUbWGRw06S/tQOd9aC0xN2M
	 KLbZjik2IIVQDmI9E+wXxJxa5CX7G+3NjSX+RcUGW0oieX8sGE6XNCi7QDSF4ZyiguJ4h
	 u/Scc6Mh0EwH8dcXofX2sL3j0bt/3w+rkALtp4P3SUhfWv7EFAtwSIaPx73zFxgVscgKH
	 dj7mEbwSInfsrOs8TFd66kX0Hoa3eM50bC4fMHLoVpvxLiicdoVspBuKbvZXhe1cAevUc
	 xe05yIUQs+M2wp4Yb3ITWHPtCR3M5uBmjp61MR9LYy3Qblydl5l3v5fbHviCs9yFY8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793645019;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=a8K+Skc3rt8G7BQkLp0LDPVX9/8qCH00vPpVv2pMJdM=;
	b=OvaLxvdUUhzj5+ippXMruh7NlqfsCx3aIb/g7LpTrqeaXxMG2IlmqPeXvOH+teFs/cho
	 KwMP7eeW1Hr1PU2namIe8u48joQQNeGGaeYHM1s07Sn2CQ/SWAJ4bZ56LGPUvYhMhUEhP
	 FuHVDHQRajgfzBPeePvFFMBNHWqwgGQdhp4Lm5zJy0nuNL0acRrtZLoEOIxsi9LiqsXBd
	 WlMdKyI3aADDOmIGqp/8G4qjxH0Ux6b2rnd64IHiETeRurdwMSlYkolHG/akpIrzYGQ/r
	 hPQeyReK4LfBKHFZecjfcac9F8PJxNoSXf1hQ62SwVUCv4yIxWjkhH+CV+x6/dBHTbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VHlujYac;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9F4606A324
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 18:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VHlujYac
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE6D1F00A16;
	Mon,  2 Nov 2026 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793645018;
	bh=a8K+Skc3rt8G7BQkLp0LDPVX9/8qCH00vPpVv2pMJdM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VHlujYacsls8O8eAyOImRV3EvfcIcYifwqlve9FZJ+DXAVEOg6v9E9Av4MG6JT20d
	 rb650jIBqyB7qEBu3WoECAaBh4hkHi1kXh6nrngctthtXiMWdcGIqWTyRzLvEHs/uu
	 kYzbtD2t4utsQ6Q6MvLGegpumae6pINn68UbSAyJG9CUOvIeLeap8qDEx1dVOgv/Ty
	 lwsZ7Yfmy0/3p4ifIslP8Qc/LjsgDm6DDnJyiPPv48vWWH54wVFF9LO8RgWT0zr9LJ
	 vOYC93opdOoNfkmlbPBOA9pCnGeX5Byd9BoJ36PzqCKTK44azp01jPhXHmYsiIUMCz
	 K/e2r3B5xuEJQ==
Message-ID: <sashiko-outbox-193960@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/8] ext4: optimize inflight dio tracking for zeroout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261102-ext4-endio-zero-bug-v1-8-266d2bb9e6dc@linux.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
 <20261102-ext4-endio-zero-bug-v1-8-266d2bb9e6dc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 18:43:35 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Earlier zeroout used inode->i_dio_count to detect in-flight DIOs
> that might have valid data underneath an unwritten extent. However,
> i_dio_count accounts for every DIO on the inode, including reads and writ=
es
> that never touch an unwritten extent, which makes it prone to false
> positives and needlessly suppresses the zeroout fallback.
>=20
> Optimize this by moving DIO accounting to i_conv_pending_ios, which is on=
ly
> incremented for DIOs that actually encounter an unwritten extent, and
> decremented once at endio after the conversion is done.
>=20
> The main issue is that ext4_iomap_begin() doesn't have any way to track
> something only once per dio, hence, we use a custom ext4_iomap_next() that
> utilizes iter->private to ensure we increment the i_conv_pending_ios only
> once per a dio that encounters unwritten extents.
>=20
> Now that dio has moved to i_conv_pending_ios, we need to pass NO_CONV_ACC
> get blocks flag to ext4_ext_convert_to_initialized(). This path is
> reachable from dio but doesn't need to account in i_conv_pending_ios
> because we don't issue any IO before conversion, hence the flag helps
> zeroout to make the right call.
>=20
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-ext4-endio=
-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com?part=3D8

