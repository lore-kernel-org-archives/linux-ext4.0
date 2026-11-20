Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152979;
	b=D+PV+13qGUM2+0aqk2O+eFgArsnmjp2ZyA/8xeh12WHbfQEiGQZZ2ZUK4bSdcrf7Madg
	 G2t+zgGg+ZUBAxZB9xJhnvCg5fC8t/YdCUdmLHtEfgspapo7xzJLuwOwZ2nOkRVdaRlw7
	 D9fxPSPlQhgzjmfQs7Ty2QrymFhmnYTbpiAZLCEpKMRZdvmOuWY2Hr3UYnmGSCbDM1bi4
	 yyak2Alob+2X3w7rnAe72X1UuJrvyn7ZY4upnn49LVtVnmcQqNnbIj/qdB0c74J46skq/
	 FqMOlshlbRqeL4RkxS229wkWNd8lcYCZ6FBi0HXZVs9aauJh+rSKeqxNaDMA3yRBaRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152979;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LWaxtVgtXct3Oj7oaVBIjD3PowwLnZDzvrVo52hkOrc=;
	b=j0GyGARecRJm0xjOXjaog5iqI8kvpHrTrTwvJnDFvKm1eivAkKsGawiaMoMV1pnUgIlt
	 t0Mxj/9c5E5KQecya9oRnmruIQ7cBGDBrb4rAZ9IlRQJhqD9nadwWsOgw/HI7PBB17acw
	 8fIq+x2XWUXH08hgtcmZUyTeyjeM2xgvliF2v0+MoCSMP3iV3lmm9SFy/s9VtFOdOg9YV
	 CQOtLB2xeaYJ0VBWiU1pkjDB+3Tsy9SgUOTsVytt7+OfsX9Y1K4bYhFf2+DYOGdPG/F7U
	 Rout/oeh8P6nntaHWawdVLSXIxq8BYX06MUAcDTL6FnKxQ01BQfYLXFHaQfarHjZcSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z5SQifBz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7716160A260E;
	Fri, 20 Nov 2026 05:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z5SQifBz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255A31F000C4;
	Fri, 20 Nov 2026 05:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152979;
	bh=LWaxtVgtXct3Oj7oaVBIjD3PowwLnZDzvrVo52hkOrc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z5SQifBzBY6ThowixWreKEtsjk11uGUCIqnYv762YqaIwsAQZaM6kySX+4h5wdHmU
	 uiHTpPTP10j7EAfatExrzl1kte0uwVN52Gy4uFT2hhTzwYp+Jxx5f/P1jFk6h8v75A
	 R5T23mtyjF0MnIg530lEeuNyz9xfRmkv6b+Mf3YI8mYEtwHVqetOpoGgOo99oYuASm
	 Kqux/IsL9/1vQEs25pXwMdZaNAW7kYfDbl7lzfbE18t8tafNxdMSxI0viotTjjuBmc
	 B4fj2bzuwU5t7g9iwtuRXOJL/JO7lYtNm3o6OJ90uPRk8X7vJ3J2UKNkbnd8UHwszZ
	 oxnxM1x0RJ/mw==
Message-ID: <sashiko-outbox-224502@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/12] docs: ioctl-number: update FS entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261119053514.255348-11-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-11-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:17 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where filesystem ioctls are defined and update
> the ranges of function numbers that are used.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D10

