Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908185;
	b=ND53v2Y13ssVV9pTI4PqH7KNFLRKEOQJ6N/iXMxrv8x47ogTdWt7yWBcMdq9+6JMsOdG
	 p2buBuP7CEVSCZf+TFn7+g2xSNIjIFJzn0d0U/y+rj5isbdQzAaoSHeMjOhQAY1l0UHzH
	 7kTo1h6w7/u/Y5S2haDdiVPkyfUB2yM1uAgyLsclc5pclbUZPLYx/MJgaGVRBaM3QhIYE
	 TU8qELqexbiCNJfggy25JRta+Qb/jbrvoYKBgLeRcbzrXRf3QuvPoykmKo/RlTowqsjY9
	 V10mxP3+Sbw6Gc90iyIuFm94Lv3VUCU6OnyVVap1cWAjVgNYqsRKx2svSoLU23Xg3xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908185;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XSphZc3LyPS+EdceHd5ViHHvsF/QdXAOc9PSkDWrNZg=;
	b=1pqoawxM0twq5ldImgZOkGd6IAKCkZaOoDkLVBPNMWSzYIEI3Z36qcI8IOi4BadSgB/C
	 m4vjYtRRxdWw8BipEP4o5P36/snVBWc+G0pq1KXxKt88w1aB6QN7y6X6nNnQRh2DocQ33
	 bao3y+71DVl7uhpJTKLZK/ooi3U9QZf45t+whpNDLQTNQT3QpttWIx2qkwT18/+wzyi4z
	 OYALu4qi68TPmxuvoBA+vlgCBXG4/PSX/fPu/mGNOtTOWz1l+0dlqgkH0vj9BoRiw7EcO
	 i8A0EedLl6BaUmq+pbNAFtBX1Iq6QkfuN8W8PRZGSmrwKdzAAZFhTFxFIgSLabN5nww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="FFKms/SI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A883607728D;
	Thu,  5 Nov 2026 19:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FFKms/SI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DBB1F008A5;
	Thu,  5 Nov 2026 19:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908185;
	bh=XSphZc3LyPS+EdceHd5ViHHvsF/QdXAOc9PSkDWrNZg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FFKms/SIbzeZwhKUlN75YuSiPVFEs5d3cs0UA/g2kXDwykf+fHrTkZiutKodvVl5s
	 k8PVYi4oD9vM00fz8xUvAGWzS16jLX/MFftL4y0XPUzoW8QSqQmMM3gNOUv9jrXFFk
	 MKdcavDQjhD2d4vZDi9rRi9K9rq+HjNXd8Du8YLRwmh+mz26G8lGyG72TD3xa9AsiQ
	 Ky10EFHsLiFarQjEFieXK4vlUf97pAdeoK1sysGLdIMgSxZT8CU9hzK34lFdajHmCW
	 rYrS6SP+zYJOEJk7EoGn/FndrcpVApApmvOioKDCddP+4LLyE64jE/Wf1lsfwAl/KB
	 KkSBU/LxFA5Ig==
Message-ID: <sashiko-outbox-200004@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 18/26] usb: gadget: function: rndis: let
 procfs copy in writes
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
In-Reply-To: <20261104-work-procfs-drivers-v2-18-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-18-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written to
> /proc/driver/rndis-<n> before it pins the entry, and handle the
> commands from that copy. Writes larger than PAGE_SIZE - 1 bytes fail
> with -EINVAL now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D18

