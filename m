Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719142;
	b=T9vlr78RMeT//9TDfDUhOr8Xm32KhviMkxer8kELI/N94HzeyxRoJYPsQTsM/sadMwUc
	 Sv/yWOO3cks96RJglar0z3kkgDLY0EpisJ/DL+tO3oBxRMAz4J09df7aFY9FbEYJSCj10
	 AyqoUonDA9ZntOLUlnV9+3xy1KmnLU+7F4G7AaToeJ7QrCsNSyB/nT+J8Yr9KJe1gi8Ig
	 XfoN7deSMB+mfAmySFT2jCEWS6MZvpsf3bG14Al6UfyL+kuBOSalSHR7vXj8nLGbx0o9k
	 ZXFrIq8yc+eGJqHI929sCmBU8JKHfL1FgmdfG0MJPyIk8yehIPXWqfPOpsZQVFXbfRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719142;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=odwwA5dfKcUGiw60p2ABSqsoXHD3TJfwohDjWQjtLjY=;
	b=GFHmFDwhgxJpD1v2rjb0U9YxiLfRWJX87WiE1C8aRBCx0o8V4RXk5noIRDwDN58G7K9E
	 B/UhHeM7fGakpKgdc0eMjiBVBXWToo1SRl2Yo42DSlGiMBY+nYj3SalGmdl55Lbgddeoe
	 pJqqPEe5AJAY35heb+4jDG5le5Mf/sDq6E3bbD3bdWiGPH8Cwn0vuHQCm5q8tK6Spqgx6
	 CSoC+xZyCeYZoXSJ3tcdpIyCJHAn6K2oi1RqCM9ZxCLusEDXwBfJcVuODAO9zJy/lMdzN
	 K0qNd5w7i4wpCEnShKQYWPtIoHCU7vdRFN+OqzVy1QLJReQplxvzz03MU4uG8vU+IRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jROEVxEx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FB860A2613;
	Tue,  3 Nov 2026 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jROEVxEx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56581F00A16;
	Tue,  3 Nov 2026 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719141;
	bh=odwwA5dfKcUGiw60p2ABSqsoXHD3TJfwohDjWQjtLjY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jROEVxExIThFpbsqA5xAGqUr9cswA8n2qHqo/aORqRE3FqTOEu/Om15ERmPiYGlIu
	 7g8q1aer7mGKtPa4BqJW1SZkElmqfbsX5POPH2ZXnXV8g7aCzKJTWAAN/zeDNaVUwi
	 kOyemUyjCavVCYeryJNauavuuGZorazBlwZhrNEkZ71VuyzAeAKZS7rSdw1kZNZ28p
	 oTmkBcf0kJ37lxjbSjKNMU9ItQ3w+BlCooP4cmHM0J5+lHMYE5pCxdn7eLYdpg+45U
	 WKo06U7ovfEEyFZ2fAApo+ge7BawSBRBymU5M7v3K7NHSLfSZkLVc/EQaw+9hkcs1y
	 +QDI9KvU2B7Jg==
Message-ID: <sashiko-outbox-195596@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 16/23] fbdev: viafb: let procfs copy in writes
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
In-Reply-To: <20261102-work-procfs-drivers-v1-16-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-16-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() for the files in /proc/viafb so procfs
> copies in what is written before it pins the entry, and parse what was
> written from that copy. Writes larger than PAGE_SIZE - 1 bytes fail with
> -EINVAL now, the output device files refused anything over 63 bytes
> already. kstrtou8_from_user() looked at the first 10 bytes of what was
> written to dfph and dfpl, now the whole write is parsed.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D16

