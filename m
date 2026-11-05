Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908177;
	b=Qdy8i5zUjq09XWoAATpIgPdZAgsKLWX1tnzy8RU3rciDZ/B9Esa8P7VkbSQR1BP6rvy8
	 iOg4hMwrLEaOPPGW12/lpFenJ7oBd0LgHsutnDQDXYilzzdU2DplaWZoCDJF6icu+5igb
	 qQnJpzJ2pcYPZoR2AadtyASn4bsci134VgB9QJNm/X+mchMBzgz8/RTffx4Xm7qCrJlFy
	 EiHI6ZNDjugwg2pn7gukKE+aLBRwjb9xZJgKd3bN8BLaA/9b4DDV3p7PY8Sy0M4x6NUC5
	 LJocZwwk9Ort4PFsglhqX62vw5cguwCirFvzMoaU2TJCcrU4HJNMexNfg5DgLsmku4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908177;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YHZ+8uVKChAh8PF+oYupBqKKIHEYIQSDJ+Uo0ScX9Xs=;
	b=RuhI+uMBY7vzDuiFILLPOU/NTO9ZzFCtDfHwWH0Amwq0NELnaEZcicuOg7tA2YzbcIMK
	 u6Sw+XFzCfrCsYqiEcXzhB9TgcBBTJbHq1U3M9iwM73606s5F2r01EmKME3A5IgTZO1Hj
	 TOKETK+Anc/dC3SKUPRT9NJLHTEXrhXXI0ytHBFge6YNBFg91cmIm8XP05ryMAxfbAnt8
	 o2CTElw56IFLLvA+OSFAxkLRzhv7JxARLJdjDbVcCHerekn1AgS/JL0r0x31yioznrVJ8
	 KBnQLYII40j+2zdjBv3MkrPPJLZDvAlvO02ezebRNsGliSbdNRHBINYpuj6hMy+vzSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oTUjZ+LH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E97C60741C4;
	Thu,  5 Nov 2026 19:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oTUjZ+LH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438A91F008A4;
	Thu,  5 Nov 2026 19:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908176;
	bh=YHZ+8uVKChAh8PF+oYupBqKKIHEYIQSDJ+Uo0ScX9Xs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oTUjZ+LHGRLtXvVbZZDdkvr/3FbUoJ5JC0paxyOu5pDlfJHlHkOBsOwNasDvP0viT
	 Yt4Mn0dAlZdDu3946ErpKG3x6Iu42iqPThIm1GzwfjcnQRX8wGZvcvvClj+htNFMSS
	 TM0wu3gZzNVqMHpO7vFYfD8I8+qfweL9IwVhZVjwxSX5WvnfuuQ5RJ0xrIOlMS8Uug
	 M42glIfUq5MbHJN9B3onJDrdfoMo/NDXrTNDCA+5igP42UCzVhk7hD/zyUwE2ljVyY
	 jtZFjNOA8fUJWzqMOUwZQBwuQj1gzvehH4N/d3NUHSrF+ADcUI+y6Is7zLK/no+YAt
	 GZNTVxlfJVdQw==
Message-ID: <sashiko-outbox-200000@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 14/26] scsi: sg: let procfs copy in writes
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
In-Reply-To: <20261104-work-procfs-drivers-v2-14-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-14-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:34 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() for allow_dio and def_reserved_size so
> procfs copies in what is written before it pins the entry, and parse
> the number from that copy.
>=20
> kstrtoul_from_user() looked at the first 66 bytes of whatever was
> written. Now the whole write is parsed, and anything larger than
> PAGE_SIZE - 1 bytes fails with -EINVAL from procfs before the
> capability check.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D14

