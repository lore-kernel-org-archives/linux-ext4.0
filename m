Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793585204;
	b=2HWZuLgB/lelP5XsWCmrIMbA2POwKphpHWrxy8hPMKVQQycIF4Xh2joeU0FS2JMPBYP2
	 fRaxQoQ6yQklcIeKlaFJbK3H9O2dcjrXM9A4j531Qps1y9AIQ4aZTtpJPZVw5o31vR0Ns
	 kNKl7JJOMJCcRRxanW8/dOndfLkY33IOoluMdWVQ46iPV2BPaeHqgQ25lYzd9WqMp1lKr
	 u+aFqs9oHmaw9j7Me9OEF3UNsSmE1x25DI5KOXqjIeBmDSKcB46IvLII6fdaaqPS6dpn7
	 W8FONzCMI767XPf/elPX1x6OH2JlEkqUnDz43O4LNEUa/a7/LDZy9WAhRA41XWBPNdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793585204;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GYtVFnKq8tgZL4p9Wd+ah+GlfF4TA42QN2bEJkKh524=;
	b=v257oVujgH0RilrXJoWxBVm+LDPxDve63zfLgP7/ByGhTq+guZObzPdmR9BGHf3w5A9s
	 t/CTwkLK95fjKijL0SdSkNSl5sD0WrJo3J3iQDR/1kyuz4sQCpcVIud5vpXhasdRUDTyJ
	 pYqJp+BNp7oJHi6xPM2eHJI8x0g7wZzzMQkr623RmBMZN4sWB6Ni4/QZY2I76xF2GY66u
	 ahCG79fAAzvNPY+vk7+xmweRjSH126usiN7Fd89Z8UdNmm8JAIWnJSNIcfyyIyxablVOE
	 dRqAd5YUlgvxA4o/MPzLc2B8UomJqeLAz5bq7DGNd9Gsgl62x7p4iIGX+m3U5NicN4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftHPsZIr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75234606A326
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 02:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftHPsZIr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65081F000C1;
	Mon,  2 Nov 2026 02:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793585204;
	bh=GYtVFnKq8tgZL4p9Wd+ah+GlfF4TA42QN2bEJkKh524=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ftHPsZIrxaVXYSO7Dhw3bsjXvpbqRIwKBc5cftZsdrv/9fEzmaBAf+7qq1Oi9GdxY
	 dqta1Ij7PmmrmpGgJuPVHK9rjUnvncDWLYLjqSkziA5r3snL46upTHwimGfW3SnBVh
	 ZByLHYK2/HH08rNAP4wNGK8SovvYb79o8zdZ9wKfmVz262jvt2r7aXJlp3pGazaX3A
	 dkdBF4nWvq3mP6wt2SlKgizdlugVJyO/YklVLtqljFimL/uF9KrG3PjHgH0WMfCokC
	 22jRD1p0lXrWlnKZUl1ZKTZUe1kTqKO9KHPzlev05GDVBuYyyW1SWD3p2DUrkF+nHq
	 QxjMVgiYK122A==
Message-ID: <sashiko-outbox-192821@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v4 2/2] ext4: remove unused locked_ei parameter
 from __es_shrink()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261101-fix-ext4-es-scan-nr-scanned-v4-2-1290a288f5ea@gmail.com>
References: <20261101-fix-ext4-es-scan-nr-scanned-v4-0-1290a288f5ea@gmail.com>
 <20261101-fix-ext4-es-scan-nr-scanned-v4-2-1290a288f5ea@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 02:06:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> __es_shrink()'s locked_ei parameter exists to let a caller pass in an
> inode it already holds i_es_lock on, so the shrinker walk can skip
> that inode instead of deadlocking on write_trylock(), and fall back
> to reclaiming from it directly if nothing else could be freed. Its
> only caller, ext4_es_scan(), always passes NULL.
>=20
> Drop the parameter along with the two code paths that exist solely to
> support it: the ei =3D=3D locked_ei skip check, and the trailing
> es_reclaim_extents(locked_ei, ...) fallback, neither of which can ever
> run while locked_ei is always NULL.
>=20
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101-fix-ext4-e=
s-scan-nr-scanned-v4-0-1290a288f5ea@gmail.com?part=3D2

