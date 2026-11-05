Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908695;
	b=haviqegFBxZGRqSntz78HtzJFUYop/CBjXKNz8zfavn9/zkTpk3nRl0pv2M3J3wfdAPN
	 Gc2CS9MsEb/Z1CtywNGIdFN5Gt3Vm6/RTGwvp0K77RL2Lb7uXEk8KuXxk1fXy71/JuaIf
	 k6TVG+haGNNVMntjdC6S8iweQeVx10rLea5DcJQnWGJ31vbjwvhnmQxUIIbk14FNesafb
	 zjBVp5RRo/7fvJ6iwIVJXbgtzTFP2+yGL/tg7wNsz3Vk5EX1DLdGv4nQr1UAzkZHj8dia
	 RQ/+9+cp9AZCiPutFb2zksugHYYfs2zzEeGxstsI9+3oXte/UB5AV2ZHNG2c37SJNdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908695;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ya5aipYlG9tbmAZIPBPshAgEJ4z8MYbt6drf9ARpCk8=;
	b=yuRUjS5/4sgWwfQpIWfyoPBRKryGpfwzsUncS3WJROpy/FuO2ZQTJI45PBMJcO8BnA4o
	 o6Nc5EVB5PqXncA6G7Ax2gKHbwGfD8P0dmMBqPVXjkf0UtyZBE0Ycng5d8mAC+pySwmsI
	 BvJrTtdnC2FCNIhRtUm7H4KTVlIMHLS0tGUGRR86ZrkomPBRe5scQwIpww52jQdmyXLYp
	 lPPcIaTUjtn7qgymYd+o9zwIu2xnKyXoIkfGws2TY32YGfOcez3CfKqgZ5d7i1HmhdXvc
	 jxypKzKTgSyiVLb6LvkRmHjnxGrLsR5pqN9sFWycNHCvgQ3p2JkpYK6tnazWBFqL6Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MphOF8R5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26F2606B066;
	Thu,  5 Nov 2026 19:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MphOF8R5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D021F008A1;
	Thu,  5 Nov 2026 19:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908694;
	bh=ya5aipYlG9tbmAZIPBPshAgEJ4z8MYbt6drf9ARpCk8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MphOF8R5xAqSxDTABFr+KD9GxM/X1ZjHavkYr28Wi0W5NixBsux8BGwG8FVQ8gQxC
	 n0muH1BId/zm/GOJnc/IV91Vn2LL18FZoHW1z8r2xjbv+ub23j3wP8j/eluc9yIIJh
	 v3yfOr3HIHpd1Np8RpuZrW/wTEaJcppbwgvfZ90pMtj6JOZp5MmFL7iUaIZJapelnv
	 6stnGSu2Sp1ZXD/Yv5+g9S7t3B2JVDiXGepncfr5zUghYMee39n5xqg1V0xSTssuth
	 o8G5wrUf5Yu2JmwQx0TX74oO+WThyTMhYg0XmBz4L77yCzdKvfTWX2IlW1D0iPWFpt
	 PRKQgQI8gnTVg==
Message-ID: <sashiko-outbox-200056@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 22/30] module: procfs: let procfs own the
 seq_file of /proc/modules
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
In-Reply-To: <20261104-work-procfs-fs-v2-22-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-22-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:13 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the seq_operations and let procfs open and free the seq_file.
> ->proc_open() only decides whether to hide the addresses now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D22

