Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906987;
	b=QIjKRFbvyhPfgR631kqXS06gmjq/GLAfBMtYKzI1YP9/p9mtp/imZYt3YkoBJ+7mVxqK
	 T4D96XrL9e3b86aQWYoJnsDaEkDE6USYJJTQlXQ4NMX33ByN5VBia/S0+RCwTAzZ16TgH
	 EDP4AaoEryctb5VV95RMJHKsQExyc95CVzsgW72kNA67aSNGtT3H/pBNZBL8JHg+KqxZK
	 gr9dBWTQrw2pRaC5fjERewbdH7PektDhXeBrfyO64t3TAhCaeWoYuRnPs1FMWxF+Kt3jE
	 MPr34mijiiH6RHxj9AgREMpwO0qQAlre6JrEi9QqhD6DIEMAQsIeLwZUS8v2XYsmLbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906987;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=E7qO1H9A1A9rieSqfjYXZ8cAx/UooTrw7Di+0o9YRTQ=;
	b=CZ5WGR06BH3clIRxhyKkp7GX4JZtz0SvZbZs6zQlduL8XCoHtn16ybR0t5W/To7VQcJ8
	 eMu9QcUpUNhDGXYNLTCalndUqJthacUtRUpFmwYHe8Qr8xDBQxNVV9tC0Jm0hhtSwe432
	 Yr2r4nlKKaEuB0lyywQUfv5t8NWd/bkPZ/HBVEZqlql7d4gpAKxLeP53cuocd+Lag44GU
	 drjYjYC4P5p3ml2YfH0KXhpF2luxhYZxeVaKO1gIQtdq5WK4hP+bxZGywXkV4KNeUJ1pG
	 3iAQYps0g0eviQVE9QdpaiJjfHOyiGRA/vigYPvc5jKQAnafLo34ya+MecAA3FpVLUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LTnFsgeX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B03160A261E;
	Thu,  5 Nov 2026 19:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LTnFsgeX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EDB1F00A15;
	Thu,  5 Nov 2026 19:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906987;
	bh=E7qO1H9A1A9rieSqfjYXZ8cAx/UooTrw7Di+0o9YRTQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LTnFsgeXELuRS1S19Bt/pzQ+cb+pUBBhn3cNJZvSOUysjbUq7RfCfegDbQCabe1Pb
	 qSe0NkrKJlORAbTMYxgPieHtNxM2nzEmoUwuiF3r26/1OK2XfIdOA+5L1tOq0YmoQv
	 kS68U1ggMoMNz6N4N4yBl8B2pEM9tNDSdKY9SQ5yrP3x+RqPWA9Q56h+xU/e6TiGG8
	 sl7lOr3tc8GVntL/4M2vfxQsKG06zotuUAj5ygmG4uiLR8oRC56KdW3GXGEqaLnYx+
	 SXwoQ9Tsqzr3DNeN0YRvJ+KZeq2LgvQhPsotMl/HyES9FpciEvKivqFYkYflC1YUa1
	 McABk20UGjloQ==
Message-ID: <sashiko-outbox-199892@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 29/51] proc: don't walk through a
 non-directory when resolving a name
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-29-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-29-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:45 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> __xlate_proc_name() walks the components of a name like "a/b/c" and
> takes whatever it finds for "a" and "b" as the directory to go on in.
> It never checks that they actually are directories. So
> proc_create("file/x") hangs x into the subdir tree of the regular file
> "file". Nobody can look x up there, but remove_proc_subtree() on the
> file removes and frees x along with it, behind the back of whoever
> registered x.
>=20
> pktgen passes the name the writer of "add_device" picks to
> proc_create_data(), and only the part in front of the '@' has to name
> a network device:
>=20
>   echo "add_device lo@"   > /proc/net/pktgen/kpktgend_0
>   echo "add_device lo@/x" > /proc/net/pktgen/kpktgend_1
>   echo "rem_device_all"   > /proc/net/pktgen/kpktgend_0
> [ ... ]
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D29

