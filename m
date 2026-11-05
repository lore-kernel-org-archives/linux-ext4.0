Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906997;
	b=Qw5wOQ/kcSv9dANOZ48H7kUe3j1sEqf9sW8UCC+jzShQIr6Iq/WRYK9yAV5oCBIGYidJ
	 hi8UJX1ZG+o4ggIpTI0H1UcuBN/sQY573JwRsykz2OCutq+9i1/1orcppkTwl/O91IRPE
	 SCZAVG9XuxuG/KDT322ZcBarcI87Uj7SttkIxgKogsv6AS5DcCNarC93CFyHUD8XDGAVd
	 o6pdAg/HOJINpXNH9J3HJB4nX1gR5CkQRx6V/L2/1Fe+BB0oBZD1EC2FA8zZbdDplHN5d
	 NZ2KSN0XKZV7H8lRzf9P6sZAz8IXsIQxM4aF76LHjFGEC0ZicBACEJ8MjdT+6RQwSGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906997;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zcV+i6POJg+RrsF6YRGTS13AdWK24kXKpMKXUTzyEiA=;
	b=OFFnrDprIY87Ln0zwhKf8OPKEhRwDUMrI50F4A5Mmc0hSlgm+SJ4KiltQQ4afcZg3Bxx
	 dVsmtbF+zxlnvo9nhZjQJb7vDqm5eSoTlWrvVw+etPRSf00RdLYXFSxQt9bWJX4BALgiF
	 xpTpad5axxkSeTP3cVy/17QRGuWxjfItxuzTOmlTXdF1FBzbmBkV7etNTcPomk2Ti4f0R
	 4EJY0dSvy67qOz3eSYQzsBC7yM4gra5ZiJdwbZCdpxPHVYc9RVD2rqzkX2fWVeq3bREEl
	 M+/HTcd1oxY32TBRpYaFjaTYqns7euDhi/PE1QpcOuJkee9hnv9FJ425UAygzAweKWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hkIp2rMW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BDC608363F;
	Thu,  5 Nov 2026 19:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hkIp2rMW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E721F00A1A;
	Thu,  5 Nov 2026 19:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906996;
	bh=zcV+i6POJg+RrsF6YRGTS13AdWK24kXKpMKXUTzyEiA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hkIp2rMWDRL8aX8FKreCHiJ+F7j4BKfzXmJc6PZ0eOL44V9Bx9anECeImDIf3eWQZ
	 CQsJtA+hT+ZN+BsjMDC+4Myk7YdWXtDiWz3ec+ntbhm3ExMby94rd/l77DkKdkzhbp
	 M8ZtpbEVGaVz0Fx3Tr1w0TZ9yJ69+1Fn6/egkNAAHbcoKwUUjIp8R30wCoxDFTv9XV
	 Mj2kudWFsx5lEkvVc1J1kV40ftb635ECGnH4cjLmWAO2ghIVDG6bpdIpREJUYlfZPR
	 qAFtvcqf+3EGNnSIARNIkc7P/WD2CkFmNpfiuMmYjjTmUT9PU8swjMoXDeK1ufevJ/
	 yOPbsNDq5GkUw==
Message-ID: <sashiko-outbox-199896@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 33/51] selftests/proc: check a /proc listing
 while entries come and go
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-33-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-33-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:54 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> List /proc/net/dev_snmp6 of a new network namespace while a tun device
> comes and goes:
>=20
> - with a buffer that holds the dots and "lo", add a device whose name
>   sorts first, finish the listing: "lo" is listed once
>=20
> - with that device added and a buffer that holds the dots and it,
>   remove it, finish the listing: "lo" is still listed
>=20
> - with that device added, stall getdents64() on a userfaultfd page
>   while it writes the device's entry, remove the device, finish the
>   listing: "lo" is still listed
>=20
> All three fail without the fix, the first lists "lo" twice, the other
> two not at all.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D33

