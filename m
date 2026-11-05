Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908154;
	b=mAtdy0mabss6MgT67yphl5CP043ymSgrtMeEQvXoIgYtufPeAcQsHMejmvyEBvQwqAvz
	 buKTHTbt4xUYmaGw9DE23QCncMMwpToW6b1/Yc34U8G0sd0Cid00n7lVuR0fmS6liDzL0
	 bm4AIlwj+mVP2i6G9yZf2JaNHCYvbkKbWkISHHTNH7lnA2VE394vfFjmgeOBpe0IRNTrq
	 Ir+OcNffWHVH+rLVuGPWryDnodxh2x1+3z3IhB2NmqH+jEDEJ7nvIusOYcyhkZe7QXbdL
	 EoPP3dH51OJz4Kqe/z+GOO3w9qrjNLd/seRjQWC3V7mwxxL1W1TmapPOh5FNs5ikrkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908154;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6cps/enMaPjoFeCDjt0OIcQqkD6lwpn3AaQg+KoH5MA=;
	b=WaVATiatOiHkfLtu8ygE/d1XKbF11yGFn0x6Ow7cK3nzvKCGj5ZS9edf8hOTS5jKCekR
	 nrYEKefnVw+BEMRrSjSBgpRKmslQ2MMgxmHUzrjk/i8p+PHSmIv0Rs9o9wcZ+EOAnWvai
	 ua/o8o1xoReIxfC+zC/hv/69wQzzQh2XnO3OgU7wyqsaP08QLBZXVlodVsmGzpTfH+e7l
	 uvxFUi0BCk9fluAF5K5CtqFlpiaEuraXY4DdZ0Uc933HckHd7nQ/XbhjOkeb7oq9zAkGh
	 Q22UC6SoRZq3yC07vKEfKfoa8AR0QKYChJUQZJYgHjpVmul7VS8/UhA2U5fzJVV/yfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PXQczwRB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634E7606D510;
	Thu,  5 Nov 2026 19:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PXQczwRB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBB71F008A2;
	Thu,  5 Nov 2026 19:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908154;
	bh=6cps/enMaPjoFeCDjt0OIcQqkD6lwpn3AaQg+KoH5MA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PXQczwRBEXysSM7qtBjfJavsgQrZKTVx0yuwFzRJcumKzWmphnnHKjGfvN+N4Q8c7
	 0gnr8aWsZJTn6RiwGOM99KsCPRfdKnD2gmZGBa6cZyhsHOmKdk/p3t7dtqB+KkkxUK
	 Tqn73tuLhq8E4PhE8YiMnhhG/iRUbAbieCFh3X1HCoAC+PQOchL+wT/c0O+sZenray
	 0ieAhXUCsy5aAlLaGHYJVAZtCXM0DzFCzGPvlwOyZ0NDlB0Hk+CiPhmTvHt/WW6C/N
	 IJE4tr6U8LvpD2431eh4mGeuBUOnBIYyHAT+kFIsPzYQdWl956WMKsirJGDnRlKrLO
	 vYsd7v/OnW/Xw==
Message-ID: <sashiko-outbox-199990@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 04/26] PCI/proc: let procfs copy out config
 space reads
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
In-Reply-To: <20261104-work-procfs-drivers-v2-4-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-4-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:12 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry, and read the config space into procfs'
> buffer with put_unaligned_le16() and put_unaligned_le32() instead of
> put_user(). A read into a buffer that can't be written used to report
> success. It fails with -EFAULT now. A page holds all of the config
> space, so a single read of it still works, libpci treats a short read as
> an error.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D4

