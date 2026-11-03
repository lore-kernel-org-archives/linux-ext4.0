Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717266;
	b=nj3GEo372ysVR+nmauW6+8iiFxhtYcDW0bRFqcfXFps5MBFPiqpYkzNCPz727Sr4s7He
	 DGIzKcc4ub9EwmDLw2z0wPcuba/EFwH9e3BRFbVZp91rM2YjlmmxNt7K/az3acQxoNeNB
	 bUXMg5W4QqSSqAbpSqPa1pfyTv7Ju8uOQQn/N7B2J8ji6Wxvv77KMEExNg+MfIdiUo6iE
	 w0bhY1TY0Y73QgVNBEWxJuBpoD3CUxDtkNGpEK/zf/xcGKbjsM905QG9UJ7LxSqX2CG+8
	 XKT37XlvyKiX3rxxdOjwNZKaHTpdscBCrQpH0UUENa5PoWUA6U5HvDjLhtjqBuVKFZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717266;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/tLnPlPXv9G/A5LSRwB4ABldzL7QTmUhIz0U/QfhmpY=;
	b=y/P4rGdfF9O7ohpqZOiRY5FiBVF33k70YDXjjH5sVYL/KjNEresWKZpV4wmmFida857Y
	 0NLdRNnmYdhBbqxIBd0f+rBwS4wpYWx0ZR8w65FdldNu2e6nrviOB/U5NxTJUuNM34E4h
	 /tExmGjMPjSGtThA9omw1RWkivT0T/plaCFyvjX/h5WeTLyIvVh/RGR4LC/+2hE30Ku2X
	 QxJflVw+a3f+HasurWo0uVP6bvDSUedV/B3HbJR5Gw6umKOG81oPnkVfDT+OLDdigTq+Y
	 /VWyRaSt79uyOaX6iQaihPllh6j03fEuLaw2CzEY58AEe8/MZ47XI47a7V5NbxL5N6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gnVr8aal;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F84606EEB1;
	Tue,  3 Nov 2026 14:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gnVr8aal
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6A61F00A15;
	Tue,  3 Nov 2026 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717265;
	bh=/tLnPlPXv9G/A5LSRwB4ABldzL7QTmUhIz0U/QfhmpY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gnVr8aallzvFHKfX8uMv/E5wuzx/U/e4tluWEOCpd4vxwHOAENFWai+QEj59i2Zbf
	 FueR79cYduQK5Wd5775YLQ1Hnbw6N0rNFl8tFIRymAq3riJru71CWcnQrbOEI+G5dx
	 /PEy6cYs37h8d3VhAVmzYfGRdTRtJZRTHPBg4V0U28aDjF5G7LYmT7YlnuJVVxai7h
	 ASHng6hlOTQ/Rl8NdR8RiigPr1Mf941O/AAQOSUaA9aPrreg56qXg5kiVDOPyVN58u
	 vtE8gdT8BAP9hwnrG5Pw6qYUmibEvlAQY4bRxxSrAdo8QA8keLjhL+hfdLPBx+Wckk
	 ICpm/kdChLz5w==
Message-ID: <sashiko-outbox-195481@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 09/38] ALSA: info: don't write past the end of a
 data entry
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-9-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-9-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> snd_info_entry_write() clamps the count to what is left of the entry
> by computing entry->size - pos as a size_t. For a position past the end
> that wraps and the write goes to the driver unclamped, for opl4 into
> sample memory outside of what the entry covers. At the end of the entry
> the driver gets a count of 0 and vmalloc(0) warns. Before the clamp
> moved into the common code the driver ignored such writes. Fail them
> with -ENOSPC instead, like a block device does at the end of the
> device. Returning 0 would make writers that use stdio retry forever.
>=20
> Fixes: d97e1b78239c ("ALSA: info - Check file position validity in common=
 layer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D9

