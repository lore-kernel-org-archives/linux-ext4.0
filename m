Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908200;
	b=qh3qM1oVV+B1ljIIHywIssN+qJdoWbKgycY2wmukXYCfBg9bIbgLMM84CGOG4bhIGGnr
	 7YR/QgwGeyycSXrkT6JQTrZrb+u9FlF8pWW5znmDX31lgBLzx9DI4t0uj/iotcDeyovLc
	 SFNPC16h3tjrzTYQ57XlAWqSubUq2dVfzeCOMxDDaIWTV0dd16SQrv5wgFae4vb/xgcM8
	 t7aT8HK+toHNi17sQIcq4H7guTqwJYHIbvcreMcS47PDLPXBVNia+yKH8GgirLFbOxZFo
	 cxUNlZkg2kAQBmheaIa0XuqHm89tGz/VNdlUmbaDjaMo+y4/xc6jav3Iycac9g0Vpaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908200;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mJTbTSNaksdvlnijZLFCGOr4psTGJIHnmxgFlkDd4gI=;
	b=mw/5fQ+OYzfKnQ5BGcf7lNARXTUWvd5gIFDeFFh4BhFe96Y1tkS+u1Sb2rQL6ZVorc1e
	 nKnA+MnYB1N2fZbNeD4zhcP/5zCnbxT++ZSELYJkHIMuD8yDoDg2Ymtj/3ECg0/h52Kq6
	 fgymXV3hXiEXIk/ocgO9UVEv5FbHD+p8fG+CbCF0vcKKWL89X7zyDsH1VSHgDN8KEmclD
	 /K8Hdkqp/L4/hXy8NXRrt9P6AIZRzlVNX+TsI7cEGctFtojMnWx0Y2o8zGCBOr+qSM1fV
	 n+9L5VD+EGHOHrrw4wvRavtZpFWCM8P8Zo6ds9LGzVoj7l7T6WEpADOIvtiSFXbMR5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BiP3vWa5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20966079C33;
	Thu,  5 Nov 2026 19:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BiP3vWa5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4531F0089F;
	Thu,  5 Nov 2026 19:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908199;
	bh=mJTbTSNaksdvlnijZLFCGOr4psTGJIHnmxgFlkDd4gI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BiP3vWa5C7VCqt3Apwn3UEuoadJLOFVATCUGY/TCkjTG6EioUj7msFuDm+u6S80/v
	 F/ovWS0/vbG4NoPvX3oaC4Ju6kOgutrh42xA82zotUqEKnnIjJM8ubgYbG3hMNjSXM
	 Swiblg6S0THlNhJQxthAwOda244CN8fXsj3HotdqSR0fAud3TJ7au54xUuBJ8QVgNK
	 I5516bErhTjW+BnoKXFgRN3a76QQkuKdwJlNjT9I9qk0/OjcS7X9lfr0QyejL4LM2h
	 sFNh7YOripcN6NumdxOyC3c7UON5Z1tyyMYNW5N1EuFPeMdzK1EbeZGlbAlbQ0aysz
	 NQ51S20K/BX4Q==
Message-ID: <sashiko-outbox-200010@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 24/26] ALSA: info: let procfs copy out reads
 of data entries
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
In-Reply-To: <20261104-work-procfs-drivers-v2-24-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-24-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:57 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_read_buf() for data entries so procfs copies what is
> read to userspace after it unpinned the entry. ->read() of struct
> snd_info_entry_ops fills procfs' buffer now. opl4 reads the sample
> memory into it without a vmalloc() buffer of its own, gus, cs46xx,
> emu10k1, scarlett2, cs4281 and mixart copy into it instead of to
> userspace. The driver guide still told raw callbacks to copy to and from
> userspace, so update its example as well. Data entries ask for
> PROC_ENTRY_FULL_READS so that reading all of an entry at once keeps
> working. A read that faults on its buffer in a later piece returns the
> pieces before it now instead of failing with -EFAULT.
>=20
> Unbinding a card then no longer waits for a reader that faults on its
> buffer.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D24

