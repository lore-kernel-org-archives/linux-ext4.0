Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906980;
	b=tPmekP1EnPU8dBOOoD3T2FSUcPnF+H9y3AlkKLBmxhYAhOvk2XvpeG/SYddgrGwQcA+T
	 AopkKPz0wmF4fA8maflpkoCD5GX7SmtduYAq7n3ATZ/8/A4HPCFCShPVhiVM3rIj3PwF9
	 Wdzicalyv2bxeWuaxAX7zvHgpSG4glYSfrqmPsZdhHtIY5JUF+ry/I0JFUAuYXO9wqi8V
	 t6mcELXF/mo+aa7/KzWzqp/OcFe5RapLiORTWZ09xWxyjAPjsZTDJJE1BwMh06oZW6MUj
	 BEj/LunTSQTohOZeYG1KacjfIwPWa/nyniqfe6t9uOXvX8OYWQXamjbvo1R+RB6WTOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906980;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=b6fUC6kkwZa6jGlElTDwWL2u3gjCO7plwWOIGlwpTiE=;
	b=w/cZ+0KXDXv3nXepIwda6rX1NNJJemb7Fp3pJdml/MIRYKNR/hn8RiRgAZd78/j77Q5t
	 H/1K6JPDh71pm3ELge92IfHhYG183kf7ZjMMu378H6WWyG13Yf56Ua3gwWba+O+hct9IE
	 erpKxt3FT6WGogOVBPERj5xvXhA8cajqquMq/Mua/eyB9K1TpCy62wi15sD3khbpNfuEZ
	 o9zfJLvhV2IOhWwjV17OE0OQYJQgu5FizAhq4ftcU2cW2SZavPl30tGjb9AXEsu/kPcN4
	 3qdbQjKwBHAK1p66OOcX8r+Xp1aLJBg4UI9qhyyLBNB37eM2TBGU9TOzLnBLpkWXwsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MqLSjmTq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03854606D813;
	Thu,  5 Nov 2026 19:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MqLSjmTq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759BC1F00A15;
	Thu,  5 Nov 2026 19:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906979;
	bh=b6fUC6kkwZa6jGlElTDwWL2u3gjCO7plwWOIGlwpTiE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MqLSjmTqIqsb3uOWNf5itle2+YYZN7QrWSpoAg2AznNJeMGlmfOcDv+I+qQC/PV4q
	 oM/ttZIktk3u2UEYRLi7imIYWeewjGd3g46pq6DVdFDvsmQYVdGsBKqCqZVdWS7N0i
	 tpm6VNMiWBiuscCgtZGDWjujl0tFlJwCL6trdEqlTYYAMvmUvXMpnGyxWVrHMwosBq
	 djqV34NaddaXWJ7uOvgZCHtGYdGCHAEcWmVpgX6aM+BtPqPLPWgB3dldmaWXncEaVj
	 WhGPLyMA3oP8jfMvyP0VXsBlKe1NFyI8lrBj+VpezDdETg3MRYQS3J8VE12drFITzt
	 Ytd9Y83ZFgpZw==
Message-ID: <sashiko-outbox-199888@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 25/51] wifi: libipw: don't return 0 from
 writes to debug_level
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-25-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-25-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:38 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> debug_level_proc_write() returns the length of the string it parsed. A
> write that starts with a NUL byte thus returns 0 and writers that use
> stdio retry it forever. Return the number of bytes that were written
> instead, which also stops writes longer than the 11 bytes it looks at
> from coming up short.
>=20
> Fixes: b453872c35cf ("[NET] ieee80211 subsystem")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D25

