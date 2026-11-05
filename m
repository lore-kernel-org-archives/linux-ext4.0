Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908704;
	b=y6vlPPQLhRd4qhW9Nh2XNwwp2Kx/i1H1qbYwId2eu5e1I8Ji4nMjH4yXvIxCIsMxz/il
	 YXtSV8VS9SY8StOJ7o+RnlBXgqn5pbJ5SsHjNvB6bY1Kw/tjL5L3JcqgF7rho7zuuQzug
	 34mB86H/o2OBDvEYDA+ZCa08mmK60IuqUW1gPFMV3IR3jyelmClPGt7yuGcyTBt43EqOh
	 9AOpOOL9noSSpKhHmDSDm1s0I33OU5vny0EFiFTRRRjP4KjpSSFq2V6Yn5stSP9XSWGin
	 7umML4THYBjqe5Cfv7sZsHzBc1tWu1/1MGx3aczIBixIOtTUIW4XP6TUB4B0c8XSOMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908704;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=R/3/g2fG5Ih3FrXZKD6wYYWFmbxOB3C9DuUCxAhNm2k=;
	b=l8/YvK6xvUONI4RKw01V7QfhA5FgKYDhbpueKN2NmtXlGh8PGpBkmJzOOLz8gWbwNmij
	 M2Elp3jD3I7BtZNXTMQL6r8RNDDOwth/CCjtko3ZEtPlzxpaXn/FaS/sj6clh0MRQxKi4
	 vf4T+cSX3ptqnhkAQq3obMVC25Lkzroan+9tcKe2Gz1HwY9wPEDsIT+zA34Db13rQ9nwI
	 dTxpwXpHI0LhjAtvgPI6AUnH5nPKts8I+9G/AYkjF/1/ksugq8unsxxwQn4IOm7ZFr1uR
	 uVSbwLo29GuB+P8Jzys+Aws2fJbPClOo+GhEW9/NwNxKJGIm3WUoXtU48XadrO1oScw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RC0Bdglu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0356A606EE8E;
	Thu,  5 Nov 2026 19:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RC0Bdglu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323861F008A5;
	Thu,  5 Nov 2026 19:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908703;
	bh=R/3/g2fG5Ih3FrXZKD6wYYWFmbxOB3C9DuUCxAhNm2k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RC0BdgluSVhj4ol2IdHageodVMrz1ruWf/U0VxnqQ4YpmT+3H+KpS1pFcokN5n4WU
	 x39afKlNtYk+2xyAOEVfn030cpNGvf1y+B+2c12eu1zaXEjJ5E5Ymn0Ehw1xNQbjXq
	 GqmH6aUhXM6WJpczF2jaIDB/vcvoOfnmd8aGdAMKEu/PUeWZVuBOzczMgkJgepjE7S
	 5TyQrDbgTzzs+fyS320ark9Hh7Hesh6X3zd5yacoQTwB2YFlyh4RmsILA0baND1l/r
	 yFJg2G8biRNchELzTifjspykyjR5pSfS1xYVZosKkAo3Jk/WZ/fEnqCmI7QJA6WoQS
	 ThsQ78KLs2cBA==
Message-ID: <sashiko-outbox-200060@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 26/30] alloc_tag: let procfs copy the ioctl
 arguments of /proc/allocinfo
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
In-Reply-To: <20261104-work-procfs-fs-v2-26-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-26-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:21 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_ioctl_buf() so procfs copies the arguments in before
> it pins the entry and back out after unpinning it. The commands encode
> their arguments. procfs converts the pointers of 32-bit tasks, so
> allocinfo_compat_ioctl() goes away.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D26

