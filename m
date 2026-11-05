Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908202;
	b=Gole6Htb8jF3JGfBuVh7pfw6bbnqXDAXKey0WOB6uIZFVjiyTCH7fcKLMWzZRMAn4svk
	 9hlmm4JeAGG92McTprM5yzsSatyBScj6MJ1/sygbAuXo5o+7B0IjiwFTdBGxjGxZTW29D
	 ifMgtw/MSU3t8xpEQfe3pDfO1scxXqC4WAF7TfCH26n4Bw9YXGJrH8FaSuu+t3sssmCWb
	 l8Fx/s54WeUPCHy+AcGe5HQUrXg+jb481aemJFPSRBz+55J3dZhzdCKRMFJ3tY4q8+i3X
	 9JMgdUHNJh3bZwEkJqpO7yVAbCYc9H0FUXfHyZ7pOKHEYFdU+IjhpNqBD20s6WCPb/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908202;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kmHJbewKimZexXI7BH61QhHVq1nSYkHQpCykfrWP8B0=;
	b=1q24ZshRCvYVOgQkxopJYdb6J2Fg58WuY9vZeYBqQLwwpZLyIH3OonvhOul1e1Q7rbiI
	 C2CZEZPcfZuSj85oP1MzoiqAxxu/BbqrWPpUHxNyvmbAW8PsnabFengcfwRuv7enP/Pgw
	 qVaZ/pgBydk3mzq9lfWMvgxaEGZbL17/KGr5aDCVtL34R334MC70WCytLiGkKRergzsCY
	 16CpTVu6iay1Edl4CZgxjvL9O6lvXICZPZv8SSwQew7Z3EvsHAE72V06v58L/LMsIY1r4
	 ZUzZALHcGODWn68avWRE9T8o2yRMKpqE/scRgNf9SdhO4K37ygltD/mi8K7pFfAVQpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yj1T0ugz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BE8606A6D1;
	Thu,  5 Nov 2026 19:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yj1T0ugz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715111F008A2;
	Thu,  5 Nov 2026 19:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908202;
	bh=kmHJbewKimZexXI7BH61QhHVq1nSYkHQpCykfrWP8B0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yj1T0ugzNifTsvf+LRAo6+kTszK1EniN9dz6kA/nDqLCRZF2Fj1Zd7rJFSGBEbQ+X
	 o/5NfGjv+8aOBHVfX8oSOHfQ+Gz59qMKbXPRS2+BZBLCXy/7kFLBmE+QT3SmH4FAJ4
	 wPQvsR/Sik9KmFbNWPMtyeQunJpC6DisUVgMzC5SuOgY1oz8179bClmAx/xBMh4q2P
	 TrxmpaxUEYPEEnDTC+tl87U7YaJYsKqr9QH+yTEa/K2OfqI7BOn3gluSDHOOvJ2PUF
	 dgYEv6jHD8p9iv+S1FUedwISadA75xm6wTiLQLiLH63DyUtVuZfEv4oraoEUVwZ4+7
	 CXIteZ1K8OvIA==
Message-ID: <sashiko-outbox-200011@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 25/26] ALSA: info: drop the ioctl hook of data
 entries
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
In-Reply-To: <20261104-work-procfs-drivers-v2-25-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-25-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> No driver implements ->ioctl() of struct snd_info_entry_ops.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D25

