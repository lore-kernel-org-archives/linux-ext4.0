Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718061;
	b=cLZV+PLdmUAHdn6dXMGmYY8SUuoiWm9BnvIQL3QFCcEVudYONSjo64rSpwRtiv1eqllw
	 cSChgaf5oKI1KgdYLUOxvFwr33qq09whbn8tKHmYpLTdOUDwdGLm2kp/H4sjZtknfP4I0
	 N3hDhOrPOxfQn1D81lu/S6nZF2jIm99WesrrAR/Msj6Kv4pjfxsJBWgcvYzIRAck3exLB
	 IqBkvT7jVD6HlY261ZyLOcQlXFpJojYMCamgBI/QqXdwlVvr8G0lvSODSqzbkQnVVgQmC
	 b28eIFN6lKKOWd4Wq7CltlDtN1Wi15UQHJpkZLPdxsQMwsZBpvZMICoeSm7RsSHCFzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718061;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=l0X2QAFJot0IX2Q2/PWev3um4yqz8IITz7l9GjGkrL4=;
	b=fKZHxDUqnGKoNPhEUIi/S8BWu+o8VeB4zwLAIKJTr6QG12OrJEYdKKus/fscW6Z9Rdwa
	 ReFZgpJk4MGRmTnReifg2r517P9DYyM3wGskKaMuUU2i/+1bD8UeEVuek/+K+2sZJefa1
	 WMRxxO7Q96Afl1e1LfR1uFXE+gEFO4itocHvZihoTLev/94jWf/AG5WoN/p/nolVVkAY1
	 5d/IsmYnEOAap7IkIHXua30Ef0M2OmhzCUjiKj1gwX+irg4lTunWlxIMdTYhycYbHvmmI
	 TIg4zf0pnqkniytDhNLSWi69BywTSKS9Pzy+KDJZyqMKeel4KmxCi8Yu1IJSWQW3adw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YkpfZkS7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B653606A780;
	Tue,  3 Nov 2026 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YkpfZkS7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A043C1F00A1F;
	Tue,  3 Nov 2026 15:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718061;
	bh=l0X2QAFJot0IX2Q2/PWev3um4yqz8IITz7l9GjGkrL4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YkpfZkS7dZWvU26v0lWwGLaCaRutuB6NiB2HUX/uekFcZ6yPhi43CmkI0piScwXiG
	 XdmBl4Dct7JDxY3Oc7vA0poDAVacBGmgTZaVJ7ciP4PhbjXPYKY3rpzkHBOsWEuvfj
	 PJZNqUEfVII+aZ6SZHk3HybJGmkzh2Ta9HFLe/fuaYrlEEFMWJnDyneLI4ytXuGeYK
	 ilddlytumyI3zcVD0Jtpr/3wYGR4B7vu09t2E2PQFcbxIfr/kjBi78lHIMRodLZAan
	 +mf+PcsUlbGluhMP5X6y+JNOjw2mxyTW3Ila/ruuoWUTlbTJtmYRKX+yfPYzVC48+Q
	 X/ep1///7lR2g==
Message-ID: <sashiko-outbox-195528@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 01/16] proc: drop the compat file operations
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
In-Reply-To: <20261102-work-procfs-core-v1-1-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-1-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:00:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> procfs has both sets of file operations twice, with and without
> ->compat_ioctl(), and picks the one with it for entries that have
> ->proc_compat_ioctl(). That's from commit 778f3dd5a13c ("Fix procfs
> compat_ioctl regression") when a file without ->compat_ioctl() went
> through the translation tables in fs/compat_ioctl.c and one with it
> didn't. Those tables are gone since commit 77b9040195de ("compat_ioctl:
> simplify the implementation"). compat_sys_ioctl() answers -ENOTTY for a
> file without ->compat_ioctl() now, which is what
> proc_reg_compat_ioctl() answers for an entry without
> ->proc_compat_ioctl().
>=20
> So always set ->compat_ioctl() and drop the second set of file
> operations and the flag that picked it.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D1

