Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908156;
	b=4lP5sNw+kKdUezw7Z3SMdK36k33vx1Rqr/b3lTlt9KLq0qDu8q88leNy7TNr2y4CifHJ
	 02iMA88nCL4lU7U1BE9TJmyVPXgl79QRQ4PCx142PfVUEOq6x3KqqOjGpCmw01Fp+SWqj
	 zIudcQmo5uUequKdjv1CqbZOdqzqsIh8jCxuKgCNQA3gGuJKEJBphudywyM53HPWtYqF7
	 PHPgNfFgRyiTRUyRm09RE/dwysPPGCwKs9G6xwCjKaI5QfuspBStGShsamMavzWfosVja
	 uAUwqwWdLKg1vT/T6ZyVwJwcsyI/3fuQdvErSv/bd2iZbWR+5gBVrTcq3/x8PiOCH7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908156;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DJ2FuCOZ25WP9BjL5sqJhCN93sGmznOaPNO9Soy3liA=;
	b=g7vY8BZmtiNVkfmsVNLZfySkMC3STysFiO++PoLO8Uo1b/BOeAjqElPOdM5WViLp7PGD
	 zy6fylIN911yYQrr4IbBEZ1WcuhedXbNs1fMfoJun0M5iWRgSwuahPNO10439a7lg/3Vi
	 vdf6Pyq2zqSuQ7TrT47xBJcnhUJQWnfCa97N9QwsAsBJkwYfzDwjG4DUAeZHhSuTyahAG
	 fomQ7tZ1aTzFnc5Z1Kxfj6m20ed3sIinksqPmFjYzalWQznah/Z6IWOvIA0VmlDGoDPop
	 z/Yd3fZ8Nyt3JVLQeOnUIquHnvhZML1yWwsLKz+UVlP8BL+vZR5z+kakTD4K63PSQKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDNZQIwt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47D6606F5AA;
	Thu,  5 Nov 2026 19:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDNZQIwt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EAD1F008A3;
	Thu,  5 Nov 2026 19:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908156;
	bh=DJ2FuCOZ25WP9BjL5sqJhCN93sGmznOaPNO9Soy3liA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iDNZQIwt0cb0jQc+O6KdhC9zGQbMi6UO/u3vkRuj84S6NYwrCMMgKBWk2lRKtl1Bm
	 OMrKDFZ/N4us3R1WBxlEVOdXmKsUNMG2/ZYOeQAqTuOvpoCgTsf0y/DWEkXqwq/4eP
	 ytp8wA84Xuc/o5GwBeATfwVp82Kdq+coa5UqQgN3VvWZXc6I3jIJeSoD7B8c/yuc/E
	 VlL5c2FH4+UVDbMt0zECtukiTyAx5nk+qywTyLYhvke6cK68jQDWL9UPhYFWTSw3bC
	 qvZIYjyJXKKaplWXlLHQZ4QPeH6F86BG0T4n4bJy18hD0f1D4RaWPvbu6T8rmjlJDH
	 J7pTsAzwsxqVg==
Message-ID: <sashiko-outbox-199991@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 05/26] PCI/proc: let procfs handle the ioctls
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
In-Reply-To: <20261104-work-procfs-drivers-v2-5-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-5-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:14 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The PCIIOC_* commands take and return plain values and don't touch
> userspace memory. Implement ->proc_ioctl_buf() and list them with
> nothing to copy. 32-bit tasks go through the same table, so the compat
> hook goes away. Unknown commands fail with -ENOTTY from procfs now
> instead of -EINVAL, and instead of -EPERM under lockdown, since they
> never reach the handler.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D5

