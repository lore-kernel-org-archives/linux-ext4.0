Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792961084;
	b=MYySMkxZMEKKJgFo5OcFVv/JZqUJdV1Vm8dtDbxYZ+s1axzat3+LB/pO3t+T4JlHZzF4
	 xV69RjolInMmWwKZSkzJ+fFmPHOtohAGp4+SvZIXLIaAxlwgfYex4Wn9XJAQqgsOrht5r
	 uzPDLQz8A9yKfD0CiI2vDhtQ8tRvc6cOIY3zZhPft90pezybxlh2Wwc43Mv5tEXMtJUet
	 hgAFvaJGCX69dGxSaMNusqjDLv+PAOUzz0cx1s0yy8Aq57ODYxnEhzSftFUpBfoGd45MH
	 tJ9k5CuwR4FCYmneDl9N6PCOPuXYREnSm1W6G7rwWdHkrzdOVG2mj2fELLwkYYJz4lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792961084;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hmkXI4Js+5hqXXJIgnMKwvLs351UqOy+0ITBBeFzcGI=;
	b=WWxnz5nG0tiowlO81yY9G0nTwRotD3dhdGs8VY1SljISE7gO6FpaSdI7aVQq0o5SsR/T
	 6HIGC4O7tRy2tdNIZBL4naaM+T2DOUCgfufLPnT19v2YcDKnFsuuU+Znh18s2NCfF2Gsn
	 28duTAA5QNKF32UApWxcDmJr+f+BgXXKe7HTHy9HNVoh9i7q08ScRdJNZj9FQpcWbsCdo
	 CVT3jvy/uLQvB7cYSIK8aCyigZoc1lr9GMulGMt+gU0VxrMt5SXWkrk8iX95ikohXSRS1
	 zCTrnXhWJ1QO6U/m2pcMQ2wNVcm2OMsY4rqmVCn+RWaYdC0XXbVLpaQg6SckmUB3wjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mtkMude7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BA6606A31B
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 20:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mtkMude7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BE21F01825;
	Sun, 25 Oct 2026 20:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792961083;
	bh=hmkXI4Js+5hqXXJIgnMKwvLs351UqOy+0ITBBeFzcGI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mtkMude78bMUH6ynNqaFp8LTKg0mVpwhMrChQ7CvHitVY/+eJPCu+Pa6U0XAsgG4N
	 hXyuhYjbJoMWlQFOTiFea4sW2Fq03geWSm39MjoNXw7zMiECN4F4GLMpC4PntQmWuE
	 uf/zybLN+ndReZJkQCstcVP1f5koi7eYvVgQYpZOjd3btUZUZoJfG4HAnl+qFg3M8n
	 aXicF6HMI3SmPJzEa1zehvaQEnQhnE6k8zn4/t63ZXGEbPh6NxnSO7QJlvfnZ0Wytt
	 N5et6EvcNXmOgmFhuouRIx6EiHKhwRS2PxnIMOkCNZ44gkrhd+z1oDhOt6bgpVfFTB
	 6CFXWdoD9VrVA==
Message-ID: <sashiko-outbox-184439@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] fsverity: Be more careful with return value of
 ->get_verity_descriptor()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261025203831.120095-1-ebiggers@kernel.org>
References: <20261025203831.120095-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 20:44:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> If fsverity_operations::get_verity_descriptor() returns that the verity
> descriptor has 0 size, then a zero-size buffer is allocated to hold it,
> and it's called again with bufsize=3D0.
>=20
> But bufsize=3D0 is a special case that says to return the actual size.  If
> in the meantime the filesystem has decided that the size is some
> actually valid size, it will return that size, and then
> validate_fsverity_descriptor() will read from ZERO_SIZE_PTR and crash.
>=20
> Of course, for the filesystem to misbehave in that strange way, it
> generally would require direct writes to the block device.
>=20
> Regardless, fsverity_get_descriptor() might as well guard against it.
> Make it do so.  Specifically, validate that the first call to
> ->get_verity_descriptor() returns at least the minimum descriptor size,
> and validate that the second call returns the same size as the first.
>=20
> Fixes: fd2d1acfcadf ("fs-verity: add the hook for file ->open()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025203831.1200=
95-1-ebiggers@kernel.org?part=3D1

