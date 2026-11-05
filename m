Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908684;
	b=JKUuyEKwsLJPfHkArOaG0HyIFBaaFa+wZ83FLm9IfkdT7AScgLmihJEb2Rs11nlUtDvX
	 vAev4+JFYg2zU4K0pbQfz9vH16UQ0y8Vf+aoD6NqT97H2vWQIFX11TZ4RzzocpEXXreUq
	 23cGQcy68TqJRSjHO2hfz72de/igTcVDPU0eABUTVXBVCvIgyGasftShJu6NdL2Etp7UR
	 4+Ema2xnAWp4Y2gpikGYm5x+D2E9DdrPL1cl5bJm4HYRu2D/rHRGI0LvyhFgxdlUvxUTM
	 ZmIy9AYc5shKLHfKdsyIkFpcdUbUE9cxqlPtfPO6fq7HMYBh+d5Hczr3U85rh0Xh/eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908684;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xQw5Y21Jefdqk+NLJ1bgD2wYB6yjyjtlILHzStlkXtg=;
	b=J1iwFlLZrwTijW+oRlyZr9P0gMwMkzs+V3/hRIXp6FWm8494AyIt7IRGYeukBAZCoykl
	 OOP9QFvO9JqOD6rbZH3pDpCpAX8ykn5CMAoi2e9uluFuIIgKVo1CKqcKSNmHWjScpVOvR
	 cYKsJSAkm2NYxMbge7gztJaI/rqpOTuWVnGQxVM6yr0NnOaUKu6a6DjKDG+VthxF71BG1
	 SJTIQFdPBYRY8LesuL6QPFM6Wcmd55SiD4iB/GdWhvy0szZC/PG56kuZEDnLAVWs/KI+1
	 W9VathjkkC/7Te1NFudVxnaLbDOrgHMKZITckrA3HLFFHGsiGjR7F11IFA55pxTnhmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLjGD6ne;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DDB606B052;
	Thu,  5 Nov 2026 19:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLjGD6ne
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FFC1F008A2;
	Thu,  5 Nov 2026 19:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908683;
	bh=xQw5Y21Jefdqk+NLJ1bgD2wYB6yjyjtlILHzStlkXtg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DLjGD6ne+zHJ6l2NtLBp7WGG5HHEcKsAxosFKuR0a7RNuYJAWYFmlP+Eo4EW1JlwF
	 0VqWA8iJu/xUCfFf45PRI6wxw6ubU1MPAtOe4gnsizzUCn5G90TIhkS+JaYX/xS0Rt
	 KJgyyZLcQTrRIU+/OkMZbrLRNYgpvjs3AQ62AWHHgn+9vKzQLgChpIiAzq6Sfn7mbe
	 QHvGzpOfFXUXvhf6Sp6Bstrs4fyt+JGWdnKOviq93faMpWfzEPEWnjRXTOWMz15JYf
	 bGpLKj6EreLgLDC1RKy7AynA060/DZ2MLXiHudUwyVC6r2EJBdb29sdOTmnyqWnhCd
	 8WBHWj+qczWmQ==
Message-ID: <sashiko-outbox-200051@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 17/30] sched/psi: let procfs own the seq_file
 of the pressure files
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
In-Reply-To: <20261104-work-procfs-fs-v2-17-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-17-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:02 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the show functions and let procfs open and free the seq_file of
> /proc/pressure/*. That makes the open functions unnecessary and
> ->proc_release() only destroys the trigger now.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D17

