Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908713;
	b=SE76yDFeFmcU3Z00DkNgowPzbP2kMT2yzq7ZgR1d+7q4+DhffvmK8+a+OuQk0yZX2yZN
	 HHSidSmCaqCxOWdYXyLD6/u7ACthnU0dFRKGHq5DLNlrzgX8b1XAVAZE5yN/7K13HgZBJ
	 /U38Y4zEPKri4YHcrOwh2vBMwbcV2LY3rKlRgqS402arSp3/SsWEO9c0HbdbfM+L01FO4
	 xno9EFHgusqDjhha60ElCXY5/zTOl3PCgR+8w0CezQlZR1BCRVtQzEXmxwLJ6A5JxTR6Z
	 qqYKwKkjxLxtn7bO3Y69IAp+CTSnk/HP0+nZyDWk5kcubS3QoZaJO5kJpEZ9hUYu7OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908713;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Fu3D7KbVL0XALbxpOg/99/chjuCyMPlpg1MAOjhFXPQ=;
	b=FF9OZbLJ+Fbxd7Sr1/d5bssCEKGY7JIcJJxslU6AcC607iX5qtROUi+QHx/c5gpHTApP
	 JT2dlpMmFhpP0WW0jMCbxE61IfpNs7MrwDzZIYk1zzhF88iUutc/uPM1DRjOi54mwXC7w
	 onpRPRarIBZoMHrcGe5rrDtRSwZ7geVxCb/ofCE8I2sq1OHdgYKCl+8kjz7Obo/v/mn7Y
	 jDHI5utHqGyqZUNB1B77m7He3HYyuFMlHTvw4yCU1Nw813g04uIdLxVKQNsIaCoHtu9T4
	 ASlcSVp/7Sm+LyX7Ztz8qRc26Zm8f9Uxs+NaMBC7aWoEJUCNU/d2J745zv/OB6ueuCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OumfSaDw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F46606A33E;
	Thu,  5 Nov 2026 19:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OumfSaDw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA431F008A1;
	Thu,  5 Nov 2026 19:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908713;
	bh=Fu3D7KbVL0XALbxpOg/99/chjuCyMPlpg1MAOjhFXPQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OumfSaDwTNZBpGJOWzIaiT6pjsiHCqCuEdUaz66yitHN1nNu5txd4yS9N4qziqeuA
	 jKo6oOvNVnrmW1Ld/SRNRJlyIoYW+xi575vQWaVzSfKh4Q6aHkYPJ0bu4ianMe/ryp
	 FY85+WivxPFkJEXo69NxZ98f5CWKvFEwF7vR5O7X1Ds9ii4+w6KQI6rHKutuqKTC/5
	 PJGugGwCCkbyMgPLbKXpkZegV1ou950ZWOzXqy4ZhzEAo//gqm2NGT/LmV6GGVGIFw
	 GkRGt05JBCoUhdhRlgBNsfNUA/ok0dXb29KIdwCOoyz5PlaaZL7x/S1TIIAEL/3HQI
	 uTDOX6NycFX8g==
Message-ID: <sashiko-outbox-200064@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 30/30] selftests/proc: check that unloading
 configs doesn't wait for a reader
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
In-Reply-To: <20261104-work-procfs-fs-v2-30-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-30-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:29 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Read /proc/config.gz into a buffer whose first page is backed by
> userfaultfd and unload configs.ko while procfs copies what was read to
> userspace:
>=20
> - removing the entry doesn't wait for the reader
>=20
> - the reader still gets the page that was read before the removal, and
>   nothing more
>=20
> - and the next read fails with -EIO
>=20
> The test loads configs.ko if it isn't there, skips if configs is built
> in or can't be unloaded, and loads it again afterwards. It needs
> CONFIG_IKCONFIG=3Dm. kselftest-merge keeps the =3Dy that other fragments
> ask for, so it skips there.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D30

