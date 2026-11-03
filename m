Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717272;
	b=PJPmLqbL+M3v8q4wuGur5EFJRCXQM4xCQP9hU1b/gZf6+iZQI42Vk/uqiyQrjgtxhzo3
	 sTMoEYJL7l1J+4oHllZ2+YBMdirWt0DLBpZ4n27kV6S7YUfLCx+BDhR3W7Pm2DXO+sl+0
	 gTzOdzGFRHXuITkBmwx50GTZrFVX/4ssdNTVXKL1kWdY9X0SLysWvfEBhH48mGx6f3yjb
	 3ftOm8B1CHrU8fiD2XoWL0w8Vk0OvY/BuJRI3q6HkeGkKdYfM+XRyQlh0jRWINk1hgxB9
	 YKUjJYlWp55/BrX9ladj9XRYlMyG2wH+8IGdY6FWvwt6ruX3QzoG/SqiOGvhjQ/3kuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717272;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AI0rGhRzTqGYKRLTB4K0BKBYUbKuh2b2KCu/bDS4bLM=;
	b=HjucQ6h5A/qtG5NOEE8EflHE8h4y/l+tsDlsrBqtDkyp+hFVyr4FPcviJscYtMCy+p8z
	 efHbHHHLgBqZEU1RKviOnml7SiLE5Nd0VNPqNx6n+ywU0PaWQa7kSN4oygUh00vbamydH
	 U9O1N9vDXooBG++P1xWF1Gmc4tjKLrmrVDuJ71KsONzwS9HGs8B22Cunmk9auwXKt6F7G
	 xkhcyehwHYMIPe+V0PQ0ekH16puxMWMphn5q0PSJCw2GPg0cTldjGzcJMNzYxJRKKsZAA
	 e7OAmSKwYc1miC3tJTMe+CuHN6iirL1JkDyKfXPefCMvDnZQz/UI6JBAcc8sBcGblvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ShMAFIe9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DB86082BF9;
	Tue,  3 Nov 2026 14:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ShMAFIe9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F4B1F000C1;
	Tue,  3 Nov 2026 14:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717271;
	bh=AI0rGhRzTqGYKRLTB4K0BKBYUbKuh2b2KCu/bDS4bLM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ShMAFIe95BTdZ2y4kYVfQPHLm//wuCkQQIPlY09N64k9vZ1VUW1lmnEqdkl0tWce+
	 knySIL9/DVo9aQOZYQkJG93Wyzcd6C/0Erm0JdbeY5hpN2CyahPgm/LOQQv98jl2VZ
	 Hs9IowAUWCqL1UitWEgdsFMjAqrvDmd7D9Y4C6j9jU51K/WOU8uJ8PEvTLiQR/wbXx
	 aKoA8OsXfqxzDd6qpl2ukJsC2GUZJ9+0eB4F6fsScC07klIl0X9a1IqUD8OdA0MlIl
	 icJQrYztLOnx3QIlvIFAO30B3GUV3EHclXPPks/c8ySMPgjLbVipKODsdqGWJXlGa0
	 Nh/UTh9DN36ag==
Message-ID: <sashiko-outbox-195484@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 12/38] wifi: libipw: don't return 0 from writes to
 debug_level
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-12-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-12-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:49 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> debug_level_proc_write() returns the length of the string it parsed. A
> write that starts with a NUL byte thus returns 0 and writers that use
> stdio retry it forever. Return the number of bytes that were written
> instead, which also stops writes longer than the 11 bytes it looks at
> from coming up short.
>=20
> Fixes: b453872c35cf ("[NET] ieee80211 subsystem")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D12

