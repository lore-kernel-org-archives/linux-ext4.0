Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376605;
	b=Yvj/vpdGOFshLAFpr9TNpABwc6GxugmWW4sl4vJFs4aemWVbJ2e7gqNRa8D0cJqYzxLJ
	 0wei0vUqgugui8Pok/gDFpaDz6YA+wad8Wyg+oG1d+ucpNH9BINJKBjjzK2lpz24gd/v0
	 eL0+osUVJRRpLUa6/WqIw3eP3MxYBVcGlzoGhTlxtWY9y9r0y5ju3c/WYlygVJTJGHYE4
	 avavnl+AHOE2h/BF6XfPiVT+5fB3J2cB8HDxbrd6PrO/VK0s6BSmlzvdxbFNosDMwRglt
	 mWReIxeZ1U61zUTJPBhPczJha6neagsib7DX2yDtZRCkQp5RZt9g+52yR1G+UtJS57w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376605;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=785t39YqNF3hZpzWUCykR0QPFXvJohq9kI/th4g707o=;
	b=fO+OSwqzybjZnLlj19l/beZDeU1pMi4hSe0FcKrMzamYDM5L5q97TmeYrRix/mqy56jz
	 So+uNSRjBOnw8sDt5VUHd3fD65H5MvGVSaWXr1M8Zo4Ytwj09SYZ6DLEyZiA6vc1zIMHd
	 p75BHY4asmb/EKSTPS3N/XTDilZlHK9MPlV1z2Sa276X2j4ZLg3aUcikqZ+CKtk+/GXqd
	 S5kXD0FliXGUlm5XrileAMhAt3bDIn++glC2FjHn1/mZHvRw/lCRnq1W/SF7fsOfNCu88
	 PbcwcOf6JawtCmD0hx/BbQIm5t19GBCk9btwnArXeEU31JIwtjWYTjFKlVJWWLZd5pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hWgbZG4k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95E8606A31F
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hWgbZG4k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573CC1F0093A;
	Fri, 30 Oct 2026 16:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376604;
	bh=785t39YqNF3hZpzWUCykR0QPFXvJohq9kI/th4g707o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hWgbZG4kd4/G0LB4CxznbDvIKdpY5/QDTaxOITcaKZ2KxsiQpAjAvY9VjVId6lUnC
	 kgIIrI1eGPyAd740F5ivggfV3TPi7WqVVrNIGnCor3qXnWIgQNe6asiJDQmSqy8fA0
	 MUh+A4Ql6arq0EdgCA8P93HQvcPios0dI0nmCusZa3l1A70o6cudvI4JLuRPO4OuIM
	 vcl1KlMAtlY9LrQY71tr70yP9Wg5oS52vMm1oB856efjgIQeLGZlqRkhTUGVqeb0db
	 fIEkK88hj1WdufoVlktZk+vFzEAV9iRTXzafSaxu958fLYpURASqY/i7dj1RYEGIHV
	 fwPaYizK747pw==
Message-ID: <sashiko-outbox-191237@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 18/34] ntfs: use the generic emergency read-only
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Set SB_STATE_EMERGENCY_RO instead of the NV_EmergencyRO volume flag when
> an error makes the volume read-only. ntfs_emergency_state() keeps
> telling a shutdown (EIO) and the emergency state (EROFS) apart so all of
> its callers stay as they are. /proc/mounts shows the volume read-only
> again.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D18

