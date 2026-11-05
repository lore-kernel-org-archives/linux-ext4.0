Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907316;
	b=YPDtmjWc/NhI8FhgmpGz4zHtOdbv4IhoHvTP2f0PXmSl8eBOuXsJXbCYtcUBncGWQsTf
	 4C7fJo9FJbgc2P8w4uIonNbyK8jnBOnggQADR50QpG9WTZQouOKmHhyVfUi/jyEED3kmm
	 H/lrjXNg0dfFmjkrHwkXT7wCGWciBCFC3XGRUHq7WluZoF4o/+EjW5orJpW0rLRHJ0NVl
	 VMvUd9tOiOpbjQrNZTaAKrx8UsDH708VdD9sTZIDasBkr/tKfJqGBc7G5AJ3Q59R0z8+E
	 fMwHb0/p/98Jp9an8QK5htm3tNKp1YTEy85MtQblM3lhImisoyJWhnCZ+DCHonplxfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907316;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6hoRvIBjdvZcFdce6OvLL9wYKZneWoJGVeTND16Hg0g=;
	b=N7jvtC3GxIg9zUZRIOOJRNxmWNQs2fTZwwF9CDzDLyFm6/bHR+h9R/DrABG3cq5k3Sh8
	 QD6jDEAJE+Od8ct+3VFx6EmUvB/xqm8/2FdRqNrOQ0XvVtC+KVuwqFiwggDkD/DZjUOl9
	 gAspL2aV3VR+PWyf0qHMnaW7F1qTLo+E3oknTnQa+5akJR0loDNB0OfvOxNPHSsrCVY5Q
	 VsbjYwnqIfxeWRb9VXVeEEvcFtzYebSqf+AQx2GHlGbioJUxFj1ewfp1GljXkeaqM77dU
	 TQ1CWJuIi4dsQp6hUq1z9k5PZTxuFcFTWGSlyLt86DOQBGbcBzoQ0wB4ZtYx4jBecYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="H/IGA7VD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C4A6077281;
	Thu,  5 Nov 2026 19:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H/IGA7VD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FE91F0089F;
	Thu,  5 Nov 2026 19:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907315;
	bh=6hoRvIBjdvZcFdce6OvLL9wYKZneWoJGVeTND16Hg0g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H/IGA7VDolTlFuDSzsR9PpNCLOc+MOL9Jlb497kin2aM9CsKSdGuinZsObzzhjKLu
	 vZB5+O9pGI8nVCo/32oLJsm4VfhHALYRw69cQLc/OwWudG08CrlbhwGxTj7hUqCvjm
	 zVfPAInrWuotxqB48n1/G7DlipPyNWJuwaJ2BWS/mluZe9QG+3hr62O+EHJHS7JbdH
	 R5EBZoDlSrf8ybUt+J6V3XvBz3x5hj9FNHwo4MzJlMjxhvX4Q3MmE7R6Wst9YwTNGO
	 WDDxetp3K1AY572xeDhT4SHRoltfwdfx2B4GtWjR4CUKwVTi5TNf8KO6vilhKxp27B
	 EnYkpbISY24IQ==
Message-ID: <sashiko-outbox-199931@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 01/23] proc: drop the compat file operations
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
In-Reply-To: <20261104-work-procfs-core-v2-1-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-1-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:12 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> procfs has both sets of file operations twice, with and without
> ->compat_ioctl(), and picks the one with it for entries that have
> ->proc_compat_ioctl(). That's from commit 778f3dd5a13c ("Fix procfs
> compat_ioctl regression") when a file without ->compat_ioctl() went
> through the translation tables in fs/compat_ioctl.c and one with it
> didn't. Those tables are gone since commit 77b9040195de ("compat_ioctl:
> simplify the implementation"). compat_sys_ioctl() answers -ENOTTY for a
> file without ->compat_ioctl() now, which is what
> proc_reg_compat_ioctl() answers for an entry without
> ->proc_compat_ioctl().
>=20
> So always set ->compat_ioctl() and drop the second set of file
> operations and the flag that picked it.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D1

