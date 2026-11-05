Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908710;
	b=5FGVVO77UUwYjInpphmqJy2wxW4/po7CBZlx16SOUgDds4ddh4YrMYEyHbfE7pkilHho
	 lqadmQxShsucjxXp0B1s+k0N3tFyh80UwUYnFjFIfPbKXj+wwZiVm7Lssdq5bZ+0wCcws
	 lkQGZzqPwUzQXQwgXqDPRSCVEQCbj++uaqjY8YAALeM8EoSMlgNeN+abLmTNOZFm3otBN
	 7pFphL9CNEqXRLyrvXKMhWT9q+ICXfJmtS4Birm7GPjB0GeIA4XJsRv0R1hwvS16YSP/M
	 LrpwrmkoaqZM7KT6RY3IiqPiPxrpq3B4duMIekUVVMwPu+kClICq737SIlnox6bTeqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908710;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qSNK1g0gSW8NugUx9zVEDY63C5++zrJDEhwhYFNbmMc=;
	b=I2FMxoBsZzLUjEAJO+hL56Ujqt7J6MKWyUix421zAqe+p5an+CScez2swAA2IyFroUQk
	 rpiQFwdKgsY4bLphkc8Mv58vMthwUKTuEKSzGtShHBrEQm+uHZ7bhyTlA3afPCVovgGEy
	 OqrgmrU7W2g7+NHUaXXtHXM0ICgaTHxWrtjmDna0zTJdnZVQGZAULiHtQ9WIP38jaaY8g
	 QRSFCpnfFZB7Gc7g+qUwIw71e/z6bhhu4Flt25vttdXFDAKb5+LlJEXt0pu0NtdUf9W4S
	 B4MpggZnNyryEzPKfcXfkbIxESZcF30VLewqorprMGvcr7iThm1JwliC4GVASRXeITA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cUfhOJiZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2E3606A6EE;
	Thu,  5 Nov 2026 19:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cUfhOJiZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252B71F0089F;
	Thu,  5 Nov 2026 19:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908709;
	bh=qSNK1g0gSW8NugUx9zVEDY63C5++zrJDEhwhYFNbmMc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cUfhOJiZdWr6DDCQTnU/s93PJB4JOqbWSoZ17+yjyziH3vJoQR2wves1ua4+azPA4
	 9xnUL0g8bwEZO/6uFsybrC5mVZzodq4hJVZC9a+qjACBfuaBvEa1w4RSHE+p4rAIXi
	 yR4xvliAgsfXOGdoZOMUuWbJi5VULyFuULx7vceAZqqhtyxLRa17ifJr6uZPDVOHat
	 DXydvmoCU5SqPOOVKdhaY5XZ40FQu2UC1b9rBhrwM2sWt1WWBtJ9AGKxzZsqP410l/
	 3YM2Bzq86iRR/+aFKabvgF/Pk22XU85bwHWRmCq4Gt2ERFvOGy9inAPLsEAMITZ/aL
	 ZMBw/vQ9y307Q==
Message-ID: <sashiko-outbox-200063@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 29/30] kernel/configs: let procfs copy out
 reads of /proc/config.gz
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
In-Reply-To: <20261104-work-procfs-fs-v2-29-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-29-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry. Unloading configs.ko then no longer waits
> for a reader that faults on its buffer. /proc/config.gz asks for
> PROC_ENTRY_FULL_READS so that reading all of it at once keeps working.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D29

