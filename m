Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908656;
	b=CtxYOjW4qwf1dcVZGSXRimWw6Qzj4d1PBPwkTatcyK15yuSuHq7lUd2TOIRK8BvQZ2mX
	 mWz5JI7/WrgP70pAGIS7xMzuXk3hVoh0XSxIc35H820FdIOESAE60Ap8ZD67xesNE1zpX
	 yM7ojUJBq06alKdZHowkyRKgJyOjcmTiUKfgfQw1JR5CgWK/oun99aW6PlSTkLck0rZ8F
	 jkM+ugnia3OVOAJa8qTVqQomyZj/UUEqt6Mwb/fShuaCHN3M+IMbvUQ3a2IDIO3ibbU6X
	 +Ew+ottlP4sz+NfGoUQnu0J2n9YJbuPBEi8rMK0x6SiPm/3YXQYPm0T4+dVleGNJoww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908656;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LfOG7svnGFtdX6knEZABTuLf6E1euR3ull/6ykf8/Zc=;
	b=OjrwZJNi6z0qKz7oSEknmE2CPKcyBTCj4YW3olRWg/l0yXxr3VwIEFcfTP8lskHv8t4Q
	 l05so1AY4ZVaFXEPBmkDj1bX7ibudrsIoqmj55MSZUt48uLNiZuVcJVH4RQ1ZAPDbD3C8
	 MDzbuh3Yid8skXT4w9Ayzok+do2CdDasm3TalYMY/iktsYfZKZKyXryxMGFEb9pycZDdI
	 QNS/i3ww+DeMyFlqlMrP0dNge2OW/dYON6IQ5AMgtofjt2ZXWsyngzWJ3J6a7NLJfmYLn
	 8c/YCdPFkFpWaxW1Cl9566BELkaZbPv6il3vQfFWZNJWr9PXdCgf4RipUbDhRQJ7Dyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EulWIzEC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACCE606A32F;
	Thu,  5 Nov 2026 19:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EulWIzEC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1CC1F008A1;
	Thu,  5 Nov 2026 19:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908655;
	bh=LfOG7svnGFtdX6knEZABTuLf6E1euR3ull/6ykf8/Zc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EulWIzEC3SwXjb3B/OGCFh1MGAp35llwaSI3zx1zPGSvxB2PueDuPAvRNuIW0oJPn
	 sjdbz20ANDZUpqqqNJYWRjooqSctGjOkY5GPimFTLBQppqUjZSkfBsiaFLcG7vSn7h
	 Ts71xzrZSBBrmI2NeunInw5b4lKrvgqFMJRcufe2yj1uC3V8a9g97CNltEdygplXMc
	 aKctYwgVWKI5yzILnPhQD3EkW3RyhqbXB7x7wBd2I4LGE7O5ksfO29Yi5oMsyxb1/O
	 M2aME1C02nxMYCD8PWTczeUF2/O+CeyEc4TLdS2QpIOb0o3Ay/ztLB6JY5TLiU73AS
	 kIm0/Y+VRxonA==
Message-ID: <sashiko-outbox-200038@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 04/30] lockd: let procfs copy out reads of
 nlm_end_grace
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-ext4@vger.kernel.org, "Chuck Lever" <cel@kernel.org>, tytso@mit.edu, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261104-work-procfs-fs-v2-4-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-4-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:33 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry.
>=20
> Acked-by: Chuck Lever <cel@kernel.org>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D4

