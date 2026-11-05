Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906963;
	b=erm50YEz/LKFRIWu3e0kFmi4/s641aBM3VsFAb+XdXTfrcV2jehzUh1sEr/nlb78utZA
	 D7O/vw/s4fcFkqPlzIUst83DQLEUxH16ikaAMkPsw9KoQHWX1Dz08LvSeZfSgeR2knEZH
	 YaMLEadqTEqIGLMZ4l7Gn6/Kysn8mLaq+OEda2fG1JXFyCCinefwpSmcskJfA+diWD+yC
	 XJ5psidSZTsMn9FJhFieLz5G8ISjjW/pLbryB4SmsyDR9/cjNKfUazy3p1FRf99lITF01
	 L4ziAMAssSa2IPaFWZU5LB3Q9Xhm3FKZ/wRgNIlCYMlqF1xarD0rz5s4k2nyWjs/OBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906963;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3aycYEBDbjdfc7/kYe/T64Q9jvyJ2iWA9tEfOPLcA+E=;
	b=eaIIks8+f6Gd0RN1tt/OS3fWcIdMzSjJPk9xLLy58wxgKhL+NSovFbdYlOUfXNjFNGly
	 7TawfQuBEfHt9WwRyDB53VLoz3Z8QdHqcqbzG5WtV2/is5QjHs3oabN213/y0vjm61xiV
	 lTK9DuefvW4tGqRtczBG04Is5k/d4t3Q9zL+MQPMd28k+i537VoJXg+R5xqbmdK5jeKoO
	 uprQo6xakWL1/8v9usmcOptPFJt/p3uvyk2RWrFt9W8eM3V5FI59kzYbsdFpSQ0XpNoge
	 pTIyphEnlvm72bX3z8mH0Q/7uo4gOSc07ZDhxYaQl+0tCJUr2ljBQpzLnvQiNTTLn3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="MKTd/AG4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12886082BCF;
	Thu,  5 Nov 2026 19:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MKTd/AG4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10DE1F000C1;
	Thu,  5 Nov 2026 19:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906962;
	bh=3aycYEBDbjdfc7/kYe/T64Q9jvyJ2iWA9tEfOPLcA+E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MKTd/AG4bVwkR+b2GF208LnMZfWrUlqFbm1pMBbSDD3WYnbXwqUy5VQ+lWyM6SNJu
	 lz/dclSSpegfq5SEGEfBf6625Y4g8OyF4QW4OLSTxiOfTue470fGd1TPQdSpTqnj43
	 ICV2RKLESKaBxJNaibArgn3ldui1C2dpKkNatkQarCY+t3PhxnSOeaKuRbWfL6/xAE
	 ZShLGqZSqpc+z4DdGoHy5h26wpa023m96jQ73G3zVSjOVmGegLWzLyUhy4LNOhpUwH
	 uKO6G2AHPC0IQqrlvprv/L1ZgqClTdg3drPRJPRNRieMLhpDrh7lJjuN+buWWBl5ZP
	 SWx5hlboXGHTA==
Message-ID: <sashiko-outbox-199879@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 16/51] PNP: isapnp: don't read past the end of
 the buffer on a large pread()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-ext4@vger.kernel.org, "Chuck Lever" <cel@kernel.org>,
 =?utf-8?b?UmFmYWVsIEouIFd5c29ja2kgKEludGVsKQ==?= <rafael@kernel.org>, tytso@mit.edu, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-16-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-16-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:20 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> isapnp_proc_bus_read() truncates the position to an int. A pread() at
> an offset like 0xfffffc00 turns it negative, the check against the size
> of the configuration space passes, and the loop then puts everything
> from that position up to byte 256 into the reader's buffer, no matter
> how few bytes were asked for.
>=20
> Keep the position as a loff_t and clamp the count against what is left
> of the configuration space.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D16

