Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906949;
	b=JM6sqUpe78rTq74ryNBrsxC/vpFwnApI4mvHDsswO1Tswkfq5DOLN3ve7Ca0qpd2WslP
	 8BkpdZoURhZbI/Z4T6kDEkNKSvjKyx2yoO3FglBUST/TpCq8X+Mrh7hXgKGsVwqM7ZvZp
	 stqbz0nrR8zfFukPumaNL8a4VXqV6wwEDthG0oYlzrUAvyoSfUwe18wtY5C01q95WgQTe
	 ZAn0f2DY4JTjEk+0MxU2TV9PAUcznAKFUtpd6i1QrnQmplp8dvsPp3Eq6F7j8sJ/Iyt1P
	 O7lRV2V4IlniHB0a/ZOzVDdUps8+Ydsn5fpAsuKn7ZUhFCxnypjmdQJDMwzV4plOOkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906949;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WG3GFTWAkJDkt5Isqmjqi8WehM/x+yRDWX3FB+RPiNc=;
	b=iY7J8O0juxGBsdlDR0HyFcJo6rHEK4geh+nSUDeFw0ModkRQezWCLkS+IpEqhQYmHM7d
	 +6Ts8PEvwPvevmuFmhsnmA02OPUiz22G0DP+0kfPq3tAJ+fliQIqddEIe6BK0bDaxuCKh
	 rr9cOmmLACKNBsqk7mZigRGr3cf2RNWme+ZbXMTma5DQntnb7kS3ruA8untoBOwtnJ3O4
	 mUcu9+kZ7aCn71ZWpphRCR48YPU4rc5+W7PGDPtNGegl7lNMRMNOZ2v3YqEZA62kJtSq3
	 UyXgI75jlHTzRdCWt2QlYnXXVRmH0tDlGTBXuzSVv52MWW0GS8QxBSXfEnPNNAyqH/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ScsLd3rU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579C5606A33A;
	Thu,  5 Nov 2026 19:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ScsLd3rU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25A51F00A02;
	Thu,  5 Nov 2026 19:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906949;
	bh=WG3GFTWAkJDkt5Isqmjqi8WehM/x+yRDWX3FB+RPiNc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ScsLd3rUpDEsoGG4uwZPfedtyuaPFIkZIqnroJ2uSW01MPdhv2idSC+1XlNMnTbQy
	 u88LGM0YQBO1Mrlqg6jerItStf6+LzwF8Lsr7R4v4U4kuY2c8syp+rc9bdcq385jw0
	 SxzzODvsIb0aRcx1R2Kvuf/rtT0cKt6nSknSCqumzX96T91e5DtA6YJURkuUNYJI9n
	 3i8gyASNFFAdDsgsqwIHciGpNG/SqEafO+JQYVTTHIZzuSs4Uh6bsYTE+P/pxKW5OW
	 OoiVYGwGUHk1o1xftCnj3aU84SDpJJjNmbrsAYtky19RWlV85+fbPUVDVRZD98sJ2Z
	 VkSIOvrj7G9Xg==
Message-ID: <sashiko-outbox-199873@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 10/51] zorro: size the proc files like what
 they serve
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:06 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The files under /proc/bus/zorro hand out a struct ConfigDev and seek
> within that, but their size says sizeof(struct zorro_dev). Say
> sizeof(struct ConfigDev).
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D10

