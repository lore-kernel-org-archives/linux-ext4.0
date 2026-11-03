Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719115;
	b=IavU1Zor28HFTdGIJ2fUdhmPBFeGtwF3tOJvU7nXfPIUgD6CQIk+z0N0LrZaxapLM/Cy
	 IWk7wJId1jNTTQ2Di/zTEj963xvCVCV1gANwNZlCLyayfpEKd8wPmTZGN5EAxaVcXbAKm
	 fdn39uG5LRQubBm4m4Ld9ks3ms6N6XQM1jvEim1IMyiCl8Ndb1G6Orxgdrfu6nMaMV1lx
	 ckO3Ax4OFTwrpwxzPMaw/GIcnU1JJZyKn1jncgqgY52is32yxLSFr1FoTYp4wdFvBZnXz
	 fOaHPG1zYraxsKAHCU94L/NDYx/8lEd9I5bQzLb2iiYBh+Oi1IR4QY5yd0KL4QxMDtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719115;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DJWMdpN/Mhm849XfylURVc3f+ehsUKnFgT6iodNIu2I=;
	b=om5yaQ7JAPJyr574HUB/ZyjlCCgF4BB3ylCR2aH2jyDwdRomUKbHzspsez5nleXgcjDa
	 A2jji2F3svJ1K4OBrICNgvg8m0kOwhA7vD6gnAqpEiqS5DT9gbkzuPUDgPytiCYpPa2Io
	 tGz+pJ2BQxYMCu3DxOoV1Ius7iPhpsM7kyiuC1MKux8WeIqiWzrD8FwBWWIgGXa9kZ5yn
	 fyl7PY8x0C8SH5l5hwetuR6aex4qsLwymoufsxRilLCM3GwidIH4yp1EcAbD6t04a9879
	 L2hMhfooOVPuN9HNnJjHJQU8aEsnjV8uMQiEMtS6hXfawUiKavp41TBImR6344skdKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VnXRLo8l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7A4606F61D;
	Tue,  3 Nov 2026 15:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VnXRLo8l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D5B1F00919;
	Tue,  3 Nov 2026 15:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719115;
	bh=DJWMdpN/Mhm849XfylURVc3f+ehsUKnFgT6iodNIu2I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VnXRLo8lld+/gqavjn9Dsw66ts+5YWypK0KuqK5iG9mI5UWXfSd0stxLTsOz2QcOw
	 VDQPZ3ScwlwC8ArGOiDqW1zYBC5/UxJTL1APdQsB/X0Tt6H7l++QO8xYyFS10kb0ud
	 e3oQeE2qhraAFmO+n1A6RS7j6ROSd7oXltgPL81WCyHyT6/tyeJ+gbwO5bYmUWLPuk
	 fTjj6Q3YEHbn5drVobbZZFg/j+nCNHLhMyRYPmStuLzP1pTOjwSF23CoDnAIi6o1ZL
	 YSYfKmCbkpYrGFdbTk2Ymk/2GWnXi2HYS6UZMoN6QTq2nVZ3hTdvcaHwRCBU+bmABN
	 LsJp0pWLY7VcQ==
Message-ID: <sashiko-outbox-195585@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 05/23] PCI/proc: let procfs handle the ioctls
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
In-Reply-To: <20261102-work-procfs-drivers-v1-5-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-5-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:33 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D5

