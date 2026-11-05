Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906973;
	b=P2TFmx4rxmTgkDxF6mnphQzONVGmgs9p5agui8+BHul8QyPgZkJQXvmpPLq7BM36cB1P
	 FKinvN5+DW1B6hmsRVKcEnKYvuTI+XNdHCeGmprqVB2HMrcFagMpzLeTHzvMSlCaWTk3z
	 n/gmrtRupXtD8xpFYTdfEHX347H7gMqtvFACIwBHDbHvb6nf1HcDrX3LA8C/tu8usato8
	 6p01Qy4n/7MVu9aFLgxb/pTDuF9yIm8Zo5+Sntm7h2Ya4jAQb12vsvC+4ej3wxuHvcmT6
	 ncd8HwFVoirQvzAJaRjTXretVlHWmmLF7Y/EVnMFq6CTfHmZdyAhQjZDQ2QY2RD5udQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906973;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cpvz9ZtguPBJKqyMAgbWcY7C2hCaojY5Py1Q5FojWTs=;
	b=X+B4yOVTJFrqofycIqwaKa4bNeOjoqadoSoTod+8j3atmBYFL86o3C06ZFFP/LpVguEs
	 B0/A2zwVIZrrLw8claU5J9tjBAboeBoyMLe3cAo9LolBHHaSG2yIzzQi/lwkrQet7J5QT
	 F6VFHDsQzgTkXFU0RkEsF3u59TOAJIdh0wGZWs13sxYRESNX1l7RVGSmVTx9L4Tyu0AWl
	 q+G4ynGjjVqzxu5R2p/F+DZi5gcIpR3kjQVF4FP7S5QM7ZnF7TUXXu4prUQukc4RKXF30
	 tDbgX527WbnNZ57+rG2TLF/uBgHAonrUJqULi+fIbIyGoaQHecmvUW5YYrWMbljwiBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BOfP7Od+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C7D606D825;
	Thu,  5 Nov 2026 19:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BOfP7Od+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134461F000C1;
	Thu,  5 Nov 2026 19:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906972;
	bh=cpvz9ZtguPBJKqyMAgbWcY7C2hCaojY5Py1Q5FojWTs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BOfP7Od+3tLJPOZc6sJbk/iLsFM1pPigpKtu4EQBqXBmK4HkwMVGsC2uatKkm7neV
	 EZ4GcLTMhwZ+sdTg+l2zRyMfToDRW4O2bKOf7mCtsJMA51Ax7pZjywuAfUHV7l60zK
	 Sq/7GgR7KGam9IZjFxY6zw2jbOAXhkbhSEU2lGdOVZHC7JPVzuBeZnUlY5cQtQQYdl
	 iiukn37YQzkrqyS1hBEVPe7zdS+O4S3+0pn1wEE9gINxcvysTW1fGYhITb0tpHtKwa
	 cAg3ROO4tJ+Nh87XueHg8st2idaQa151qlYERsBEmm8rL/XGHPNW+Z4eSSH/K5f+18
	 l7+JcMjs+vnog==
Message-ID: <sashiko-outbox-199884@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 21/51] powerpc/rtasd: zero the error log
 buffer
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-21-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-21-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> rtas_log_read() hands out a whole slot of the error log but
> pSeries_log_error() only fills in the sequence number and the event,
> which is usually a lot shorter. The rest of the slot is whatever
> vmalloc() left there. Use vzalloc().
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D21

