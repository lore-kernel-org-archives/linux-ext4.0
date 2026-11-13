Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794553201;
	b=DAyPgqpHkv03HhZ1mICldY/js7rVfM+hD4Nsl8oYb8EBvBdqQ8V2nIdhU9objE64CaoP
	 zfbpymG0jG1r2wH20ieuANVVIJ2S1KPiD/TAqpM2Cc8B95jpZf+m3IJmEqEQbXxKLsElR
	 rHsFHWrXkbQPkN7VYDP5lRnmaD3v+D04/et6zGaDF6UcfQUSgQ0BrFvtOVTyHTb5uTCCx
	 Yw6VJATo2temCH8SxGaSkeZB82u5O6Gnt9e0qDFR3ABZtEEti7WjV3/kJ3ImZyXr0iVOW
	 lDi9vrABiboxLVEOtz0nHp6Id3khSi7JPsAGg3ZXpgVV2FrawnrTpZwPNP4eP9yqwvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794553201;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7owoO+om+jEw9wGQ4exmBUHnPl5TA1prbch1m/d/BM4=;
	b=vMQCQlJnp3QzK0OgRiFFfK2h5Zk8z6PTLh6ihRkux1xqM5Xm2zL1qVmeiurfHr3xdyAB
	 rJfhW1s5arWQjQo98/cgtJ9EscGpgisdsu2HOfIZSx9MlqdBv9OTyNJZqw3wt7QIoxN9Y
	 TS3XuuoEa8CAhSvWKxqhX2p5jezVRuSBvuGroeMJJlViBRVmEOsoms97d/F2HjCa6Gkn5
	 /3yWL280h8XULORzVNfuhI293NQ5u8uXjP8e8e+I1DtNFuiyIVH7KmRXQAdAXxfpnXf6a
	 s2Kd3zEFN818iDa/9sga4uBf8tCQRxZWaDkKZHRhNIgc/oPtO5L0lq4FqtaBuWUbyWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gB3b4jsF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F17A606A323
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gB3b4jsF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4552B1F000C4;
	Fri, 13 Nov 2026 07:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794553201;
	bh=7owoO+om+jEw9wGQ4exmBUHnPl5TA1prbch1m/d/BM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gB3b4jsFEG93pS3tqLWayx4YgzhoI1vEhMJ6wOkHZ/PDYIJL2GogZ4ClGRNIBHYpP
	 nZfW0ObVHSR1dCx/BoNOlvT+YpbcVEhjrd1KGMo/OqHg3ZFXFGvl7E3RQLFuT+yGh2
	 Jk2f/t3TM8s7zpWoN4368l6Wg1eUHVKE0IEfL/yBXl4//4/eviTxuUWCJlWVfoHGDk
	 FdrX+zicwy/8QWjMhB9lOmYRdNhfUWpGA+r2WPRAj6WHkvoP55BGJE+DwO18u4pZpi
	 MoZJBpP/ogtlKVkg3T4A0RQhbK7bYEyW38lxS7sVVO2pMrM/IQyDJrx7qqtn4CRqKc
	 9j/3H0vhhTrLg==
Message-ID: <sashiko-outbox-212305@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] f2fs: reject casefolded names that fold to ".",
 "..", or empty
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sarthak Kukreti" <sarthakkukreti@google.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261113065332.929085-4-sarthakkukreti@google.com>
References: <20261113065332.929085-1-sarthakkukreti@google.com>
 <20261113065332.929085-4-sarthakkukreti@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:00:00 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Dmitry Torokhov <dtor@google.com>
>=20
> Filenames consisting only of ignorable Unicode characters fold to empty
> strings, and names with leading dots and ignorable characters can fold
> to "." or "..". Allowing such names in casefolded directories can corrupt
> directory structure or cause confusion with special entries.
>=20
> Reject any non-dot names that fold to empty, ".", or ".." during
> casefolded name setup, while still allowing invalid UTF-8 sequences to
> be handled as opaque byte sequences when strict mode is not enabled.
>=20
> Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
> Signed-off-by: Dmitry Torokhov <dtor@google.com>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113065332.9290=
85-1-sarthakkukreti@google.com?part=3D3

