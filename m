Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138807;
	b=JKJgiFmVRngkhQYoE1ltj0u/iTj1iCtAQGtajP7w9jLXTXqoQLzfcDdhVELvuuWCXSyT
	 3W5pbX7AgrGk0UuCl65zOmdnjGvB5wBEK3MEE4zzoivilDAMmhOszMHS7QQULsEN9ZOUZ
	 Yq2Tfa2qP0z8reib4NVNxMsylcHOdwXPtbrtPd40QXUkuGwkdqHBDlOkJKGZ7p79ew2CD
	 5L202707zfu6CwLFKxKLCq1jJKu0dnivxhj7wx9aMluV/5iqsg751qzrwLbU4bQ08RNgA
	 XR1sdtl00F0n0X2/jpXvsEcMhnqyE+s3fczfZPwsp++/OwdIHrrGMuDLBPUC3BNq6uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138807;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YQTUx0eJmLXwQYVBWPZ+Q3zgF96P4Dw1Nl3k7JabyZc=;
	b=GXsE50+XhNysnDkVmqlua6kQ5mRaHX4wx/Mw7oHQxE8uVKTCWZFvay3Qi0hLKQakaSVY
	 ZB+Z6vDhqJ96/FT9vYXMYPjKV6Ao2A/dhS/1PWkN7CJ/rMmSpn1AAv1nwJLcKZ5PdGe/S
	 OM7SUvVgJ9V2YG1eBlcQbMQrwOeIcREZ2KCA4uTWti0U6A/F6x29AQMTJrZeimuN+fi3V
	 qimo8576CIc2tcXS9YIjH5jNIyvQ61cCV0y5KYNARA9jAQIrvJlCFa+JPb4uqDcBDVCxl
	 lIsZFSomHJPQHUr7lCTez4TWyxwy7omM6AR6AKlI+5P7hEtX6KPiqLEhAP+MJWmUdFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OVT5mmfw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B7A606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 22:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OVT5mmfw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756311F01825;
	Tue, 27 Oct 2026 22:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793138806;
	bh=YQTUx0eJmLXwQYVBWPZ+Q3zgF96P4Dw1Nl3k7JabyZc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OVT5mmfw/uB6Zt+bB8mVAD4xIyqcqjjtxNyx84aYD2pf9Gte68RxHUnYh21yzD0M9
	 HJ3FrxIA5yy2o3OyBmtNe0kAr3kxodmT0+KKz8xlqzF1gMN37UqJ9OvKbd5bxOB2go
	 vQYZixJO+3Bgi8D9qZI9ovCXP5mU4RcmKJfDkEP2qNWLBse5EEAEZFN9YNIetJ4L29
	 qy3u8b6V4vNsAltiH/iMm1egQ3HmJMW7TDPmuVu1cvEogo7ZIVhIrfeRfY7HyHKOAl
	 y+Ors06XCzZYyyVRbOIU3XY+IZW88wRI+wjzx53xZzTLwWZeUPHSMr/NbK9eHyTYDw
	 jL4myDkU2KYJQ==
Message-ID: <sashiko-outbox-187142@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/5] iomap: pass iomap_iter_next_fn directly instead of
 struct iomap_ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joanne Koong" <joannelkoong@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027215326.2693300-5-joannelkoong@gmail.com>
References: <20261027215326.2693300-1-joannelkoong@gmail.com>
 <20261027215326.2693300-5-joannelkoong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 22:06:46 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Now that all filesystems implement ->iomap_next() and the legacy
> ->iomap_begin()/->iomap_end() fallback is gone, struct iomap_ops only
> wraps a single iomap_next function pointer. Drop the struct entirely and
> pass the iomap_iter_next_fn directly to iomap_iter() and all the
> iomap/dax entry points. Filesystems pass their iomap_iter_next_fn
> callback directly instead of an ops struct. Several iomap_iter_next_fn
> callbacks become non-static and gain header declarations since callers
> now reference them directly.
>=20
> The iomap_iter tracepoint's ops field is renamed to next to match. These
> tracepoints are explicitly not stable ABI (see the note in iomap/trace.h).
>=20
> No functional change intended other than the tracepoint field rename
> noted above.
>=20
> Acked-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027215326.2693=
300-1-joannelkoong@gmail.com?part=3D4

