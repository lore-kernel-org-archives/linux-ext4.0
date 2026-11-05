Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906971;
	b=FS1F34Tj75yAtQRdFUTvHJr/GliDBFue2uE3XsOORVg9W+zqFS3mKrzvGV55BCY5BbHd
	 wjXAFExDqAfbQEadc+/tr4XsgWF2/jSPWAHm9eGybMOheoBBu8HkNp415lyq+WDBMOlX7
	 Q++VzwhBCIH+f39rToypkd1p6Usqukhn+/7rh2MUax7r/4JLXaUHQPjV/Ua/dB7vkc3ed
	 VuSsjF5LThQXaYOVoxf76lQX7Zvp/2Gj2HRcp3eUlTejhOrb36zLK/KtCrnSX1nJIWW6s
	 EA67lPCUZ213uUnQ7QZKki/mMPP4/CLxBWpoCMEVkUORVTsn+g89D1csDee5Bzg7amQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906971;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=S86yJ+B5qGfSA192YZydUPkrd91cCUN2X40z9NmB8To=;
	b=k9hDWs8iF1VuiT1FTxrhkq5dYk9OnMVTjzNjomd+goEn1UB6+M/0J7UhDRAzgAEsCzYQ
	 akChnlAepCcqk1heMcd56/vQ1DGy2NIoS5IYz0jrob1Tc9KNYn+mwljTgR4iknV154smo
	 oecxJm/97cYm8REJha0y+oKSwCveggaOtN2qTSyIzClmOXupjXiAaFvEiWJvrwHr8US7I
	 Nv8/tdVdU2fUDI8npeqJDrn0tUAee1UL5k5fG+Yv7w98P5nzAwQH+rqGuRjTsWYsFq1oh
	 metMzE6g+ikQRgHVg35u6sOAuBFS5dnwpo6+vEgqyunrXRjwzUPux/iWSH0qcZjNLFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SeuBgQaq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17836082BF3;
	Thu,  5 Nov 2026 19:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SeuBgQaq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7321F00A02;
	Thu,  5 Nov 2026 19:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906970;
	bh=S86yJ+B5qGfSA192YZydUPkrd91cCUN2X40z9NmB8To=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SeuBgQaqVWpGru3W9sij1Kx5fi/6U5rjetwB+P6G5tdeUO4escEUXQNsmkQ8RZJsR
	 N3ad0PsJzqTqBNUpF1Gq9bKq4Gs6PPnGr2kbOldzxfmsAxwk/I0ywFs+3s9dEovcpK
	 4fycBMvMdv+bDBbPSskelSCoXY5q3AokzQXZU4pI9d+YtuhY/MZRj5JY5FqeXz0QwH
	 wFVR7pturO91QWS5cokIA+tbR6398bzKWWYmaM6GJBXeAUZ84sKfMtfLgH3UqLIkJu
	 P5j0DmucSdoJn5dFSjExx6Tv1oP+zwkmPj0euNx6/FjN6JIUAcg6dGbM/GzyKStVRA
	 /FuSc7MXCNWwg==
Message-ID: <sashiko-outbox-199883@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 20/51] powerpc/rtas_flash: don't read past the
 validate message
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-20-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-20-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:28 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> get_validate_flash_msg() adds up what snprintf() returns, which is the
> length of the whole string and not what fit into msg. If the update
> results the firmware hands back don't fit into what is left of the 256
> bytes, the length ends up larger than msg and validate_flash_read()
> copies whatever follows it on the stack to userspace. Use scnprintf().
>=20
> Fixes: a94a14720eaf ("powerpc/rtas_flash: Fix validate_flash buffer overf=
low issue")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D20

