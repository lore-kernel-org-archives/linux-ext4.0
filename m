Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906964;
	b=jeW+OtSaVwt1C1f77vU/7AThJxfTe+KFHnlWswex44gnasTwd/Q9jX/zvkHcrLc7mZp6
	 u8ciT6iZINKB80lBipfjs+NJYgbsmN7CQ4MFfy8dNqoIcMo0QxJqgypTYKdfJQagFICvJ
	 QOK4f4z/GQrBp4LEzCnp+wnTC9PDi/aoavNkMtAfiDAYr+EV9mGOF/+KAaDFzQ+J8kZmY
	 Zpd/0JnnD6gr0OirL0BcZsM+gja4yxY26kCfPhGPtUDJdPPhRsUZhd04RkVjhbsjEm1Dd
	 mB4+wMfG/jZTUOurH+c58ypobYgEMCOqZAga3yl/wFkP2pjfewpyQnmQPMLYLMAPVIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906964;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=l5G/lSqezWnwCKCStpatk32BvJD6IXrDlHThvqht2Tc=;
	b=sm59c5Rb+dYOr/6gsulfJHo/gJ239ToK7dQLC1CEC6q1efxzEr56HxMaZcmkx7oSeI41
	 fcbEQcBCelIsG0lDHs+zkCuh0qWureuk8osYE+0z+BeR39Ge9xBC2gWO2Dm6lYJGPjmgZ
	 DZ1VMXR3wKQtB1y4k/l/847cnvk+Kn6poYwWLoTFDomPBdfbrD1z6PFF9IY5GGOtfGjP7
	 OE6Q5u+w0sldywsMYi9FTmihBtjTq/Jf/XqLjZtmg5zuyl4oVJ/TCpa9yZ3WwK0lO3Hsj
	 DwLwk1Yn9uqop+sTC1nH2mT4U74Jb3oAYeRB6tDBpRXnIMNjwxlPk3j2PAusXzTWDWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VVy9ydzD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A776082BDB;
	Thu,  5 Nov 2026 19:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VVy9ydzD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8691F00A02;
	Thu,  5 Nov 2026 19:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906964;
	bh=l5G/lSqezWnwCKCStpatk32BvJD6IXrDlHThvqht2Tc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VVy9ydzDdwrK5cUkSQY+dtAoabFVfA9e0V3qgpjVjrIB5KvMO1MvQGDUHk5rAvgfm
	 iSf6w+1kKcvdBAFR8ELGlwwFEK1XZJXOrXKCPvRouxy2Jazs+nmQAJSesB401a9CCa
	 vxio34XgVPMayf8Fmf2wRqb4Hs5BmvdwkdXQYrWsL8VIX0WNnzZbN65SIXxRDOYRkF
	 eSdSep7Up4ys5dzeLjGW5O3+D7EGEYwGaI66O+jjQoRyelrpDYdY1cW3+4VkosJ21x
	 VBLkNWVbLXjLlwjMd0uLQ3706fcKWPjDKmaSPAZcoVtTTzHDmgl+ieo3UPtj39/IgW
	 0E/kdo3j/YNww==
Message-ID: <sashiko-outbox-199880@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 17/51] s390/dasd: don't look in front of the
 buffer on an empty write
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-17-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-17-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:22 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> dasd_get_user_string() strips a trailing newline by looking at the last
> byte that was written. For an empty write that's the byte in front of
> the buffer it just allocated. Only look if something was written.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D17

