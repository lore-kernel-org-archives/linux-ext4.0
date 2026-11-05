Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908654;
	b=rTsXi/nzGfpaBrre8xjJwvSZpWu0EzJoOFAxqmgd0D2ydGo4jfTb8Gcw0H3Sy7htJCaF
	 oKQzXTOO4/KVKPsqG4tvco4znezj8MF+qLaM/sjtHPi76PpXLN5GansN3yUOR//WAx/yW
	 NSPAUwhklr6kEkAkoC5uTiauQjC1dNKgGUORZTJ6upADpEvcsc1EbXD/ZY4uEuqFfCq1D
	 /O8sjyJw48rs93X69R2+hz3IXhFCqFkDBAT1SxUazNg3mZqS3ygHJTXdpkWzgOIuPus33
	 YV0akY57CISxWrafN6maeS44tBtxBRdgToSwe/cCAct8eROr7RclgaTzQAoWGPWeUMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908654;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xFHbGVRg6yrT3KlueEhkmvkVUBCbD/lh7sbmFSVtLTQ=;
	b=ln5i4x2KoBfD0ekrmA6sUXfIhhuczOf81jBtyWOnovokeoLyoJ8/aDCug7AtPWBMos/Q
	 481ipZZzup3tBdkkPzGqGswRIoh7w7gZptaY+fwpHAzBg4RLmTTLnBOvQyqaFB9IGh87U
	 h3nE7GuDjP0G3Fa1k1UwwBl1kzPcLMvNxZYwJzL0HDN8iH+J+XeUviU/72s9Yvj+/DAVd
	 rhzD6WX0Gncra1757xZcvL2j5Iy4195f5lcTcQkfgoPVgRFJFhlPaNQFR1atFddMxw1Y6
	 EG/Q0uodIx+vnfpBN53roBzW6YpAEb7Ou8go+kg1S6eZ5rCCAW2OJFGra6xd0YtwUZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MH+i2+6U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2837606A6D2;
	Thu,  5 Nov 2026 19:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MH+i2+6U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066011F008BE;
	Thu,  5 Nov 2026 19:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908653;
	bh=xFHbGVRg6yrT3KlueEhkmvkVUBCbD/lh7sbmFSVtLTQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MH+i2+6U9jE27VRxSnmwAC1I+KZsyQYelc+SI0/arXlN1acPqvYicclIueaGmnw0S
	 7Vufmku32aU/0LTS0ZsEhPWcfV/nyEAphelMqVOOOUXzL7KizWCwGblpTFLBfRVOQ+
	 aRw3Xd1lLfS6Zlieesl7Sd7dG27m8Iqdo392aGzfQpYi9FKD9imCBtAkWRVDGlQ5yL
	 tyCoPN0YxGIGINh+RaRkYpaUWkADRL5JES4DnfjVlT3zfh7STaEF5tXVV/1aeg93IZ
	 vbsnaVOjzd37+164Zegh13k1Ov7WlOlHKfVz6T+tPlvgwuvjMPOhmpOl2Tm3RCKXke
	 hwokiwRFkoaZQ==
Message-ID: <sashiko-outbox-200037@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 03/30] lockd: let procfs copy in writes to
 nlm_end_grace
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
In-Reply-To: <20261104-work-procfs-fs-v2-3-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-3-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:31 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry. simple_transaction_get() was only used to get a copy
> of what was written, so look at procfs' copy instead and drop the
> transaction. A second write to the same file doesn't fail with -EBUSY
> anymore. Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL from
> procfs instead of -EFBIG from simple_transaction_get(), which refused a
> few bytes less.
>=20
> Acked-by: Chuck Lever <cel@kernel.org>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D3

