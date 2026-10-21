Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792552908;
	b=Piv+yWpkOhk/dS4yv0/RKh5BBGopSrAzzIkHsEF6pNCcX/jiDws05AZtgL+27WD2wbPA
	 GopK31ONAuZwQLwzTlRCBGhERXKZC7h/VbZfGdS/Q+BTTCGhJOpnhA86qNaYD55KZgoQ6
	 xGU4cxuQlpplOQPb8dvh1Gp7CHHyOhfMaiDZkCHahowLQ5mHns2ISqP5PHd+FGaR/kGRa
	 DpwIcYREdeHAW54u9jyMsOrykL8AAWEkL7gu7eYuR3htjbB1pRq+Q0RGI416lyKOUZZPJ
	 VPy6p9nNBiXQYjhTdB2+iltTgWLRG/GwiXDtJyTfBwKw6b4sCndo1CSYilcGZAMT70g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792552908;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bOZfFwmxFtgBBOK+554sror7bJvD3aDKVSJ7Z+gQ9xk=;
	b=3fGwwNJy6qaM/MucwSzRx0Rlh5Tt6J1eWWnp6eOQ4dUaAVmof6/JSbzRWllOY4HcjZe4
	 Fw3jK/hHdl6YTTnwEelV/r47QldTw8FZocmEHnNRc+zqqUI7EFP4JxeYr5HXedwlhK8p/
	 rKuN21LvxYgf+cJfKs11atYGdbNeRvDzAcQ4InYoIUrrDvswdZZwGf7yfSK4+AG0brN8G
	 zSD0SmKtSxvUmgF1XkLzzxSzV1GcBn96AZ9vEeM1rYYzMRc11NerSdE4KleV35fvwhRPY
	 3XFK8efNcpDlBrIRe1cO1RWCT7qZemD407hYLJXUwCq4/FTI6SdXSXBSYRGIAr5yLOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DjZnHaDV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2670606A31E
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2026 03:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DjZnHaDV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C22F1F000CF;
	Wed, 21 Oct 2026 03:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792552907;
	bh=bOZfFwmxFtgBBOK+554sror7bJvD3aDKVSJ7Z+gQ9xk=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=DjZnHaDVOhShIVUbXKp3EbXt55SnbMLGC6sCGZ2OjUKLNG4pLEczuw720dPXyrFhL
	 ymn+E1E3Hcj23LargZbgRs+rU9xjNdHdBez9o4i8F2V6a+vGwBNPiXkVFE6dDbvlF4
	 N/lCNJLiva8lGpCWRkdx7eJ4ZNo/Dkp1ZNkV/z0TA9ZQ4q06DbW18oC8vkLFwnbwkm
	 xp8Q4lOXLVi0D9eOnL6QmogeKxksyMo90qO5AybjztE2Rx32/HWWedFWk73HxFeO2F
	 2/njFaDXMcWhHz5KRy8rD03Mp3AaXd0xDO8lXuU+eq3g+U0xvb5nHPW1Hve9mabg3O
	 AidMEOGBwCiRg==
Message-ID: <sashiko-outbox-179747@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: add KUinit tests for fs/ext4/extents_status.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261021031231.40107-1-tytso@mit.edu>
References: <sashiko-outbox-178509@kernel.org>
 <20261021031231.40107-1-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 03:21:46 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> These tests were created with the help of Gemini Pro and verified by a
> human.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021031231.4010=
7-1-tytso@mit.edu?part=3D1

