Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908196;
	b=ieFa8OrP909DTkiPhzaUIhGb/nnp6pDCOMAZwJdyU2nu01Vn30nXExTPAxwsFXWsnEI8
	 13sVHoXWetv3mJF+qXESobyHgIyaitEzSU1k68qBmlgSwgG6C5nOyxbXDvr5nJXzUDc8v
	 iYV2aG2/gq7joh+SdJ8a+BLtra8twHjHcLQ4tO7B2M1Ks7qwsOT1E/sX4XnUaUa6eNgPl
	 h80UyOucbc0goy1QG04bcgA6Ju3aQ0XK9B3tz6qqoId3xg2aVgUC4mwvbeCJd70JUXUwF
	 YOPFxFDdd9diWoHtlw4m7l4Uzql+f8EJOdOZ14rBhZ2kth6f/VSYYY4zVAJZm6D3tNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908196;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=s7WmN61TcEwSAmrgBFcR3i/+X59X7MghGqj63dVkFh4=;
	b=5QNSMtjx/87owZ7ZQCiFALRd1+lPFUsELCX14oNChZumlAogUAw1EAVXb6qacQ/7Mfsc
	 uHddcSYbBRS4CJW3+48wJydJIp7PszmInApfOLpEo5w5tSHuHLzAbhyd+6lYgjdlrHh+Y
	 TVxgt4YHB+E7dYxnbdXjkK4GQ+L+bsyVjfN4FcPPv2EccaeyXfAD6FZo4bSRgNOWWUaLQ
	 6uMj4RmAoJzu0leAIYpqvxiSmZFUdE+GSKpM5roJyWTfe6Y+G6/groanRKIsM5Tga3NAf
	 oJJGc8/msLRd/WExzYe+MLo0cD/GfpZCEM8Dcnitv/LLtOHMo1j5JAY3jAHfrzgTKUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2Onwvw3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DFC6077CAB;
	Thu,  5 Nov 2026 19:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2Onwvw3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4085F1F008BD;
	Thu,  5 Nov 2026 19:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908195;
	bh=s7WmN61TcEwSAmrgBFcR3i/+X59X7MghGqj63dVkFh4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T2Onwvw39ZN0/OoOXxQL/uqI7Po22o2Y48NdiniZqCP/DDbIer53/gM/4OjA9lEb1
	 ZcA7n+7DOArqei7j/E+89ZPKGaiUE1Emcmgj5cNgnfKk3nHic6m/MnYB7RXIp2aTDx
	 GhNaIma7ViRMcjw2Q1iINaa6BRamWn/B1y14v2KnCxNcnpxa6PdzbCS6ZMZ1DEeckZ
	 YWnktcnAhZ0oNTq/YekqSeJaTix4kwO8wQBjblo16bnpQWE3/ln/50BkNHNm01s0ZB
	 /g6GiX3KmmymfcwBQUEuk9hji1rPknI18H3GRTuIJg5WNlSHp1zjuKJTaQng099E5q
	 xL6S0rA3UEzKw==
Message-ID: <sashiko-outbox-200008@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 22/26] ALSA: info: let procfs own the seq_file
 of text entries
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
In-Reply-To: <20261104-work-procfs-drivers-v2-22-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-22-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:53 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the show function and let procfs open and free the seq_file.
> ->proc_open() only sets up the private data and preallocates the buffer
> now and ->proc_release() no longer releases the seq_file. Reading an
> entry then no longer holds up its removal when the card goes away.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D22

