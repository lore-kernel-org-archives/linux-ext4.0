Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907364;
	b=213vNpwcqf0Gt4/p8UbTJYyh2fHs4zPBdLcW0Qlw2TShrg+TIlTs9mF12EdnS4d6ZP3X
	 JkM9LHiX/XmbW3NfnbfbZF0KD9JDIHr5q23vVnWPDqLMn0LlA+yw2iuAOgO9nxaUaU+e1
	 gy7pNguyeuIkFD1Brdy8tP0iYuQqDUUMBSqSYcgkYlSYtr5YPy22sEd8XllY6MS3gBkZu
	 tlQNfJA0eZ/+io+WcODTO1oyEpouCbQl0TIU11TNbdV3h9vdo1vXgehUXoXqGwJKjh9gL
	 su5jBLCxAQ3JBtzukYdL9Ylc7dqSba5m6lEgqgLYeW6n4W8yelW0EB2KOhVv9YciA8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907364;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gAVlktWGI4QeSuJoAwfYGMkH1PJUJetPfF4oCxqFFe0=;
	b=a712fZfhcJbyd418It//gMnQLWEUnd1mcfAy6QeeRg5HUaTab5AoMhsjmGnkx41POh//
	 fVecP4uTN919dNpFKAr7gD3NVrGxL2kxGFxs5rSlxITelTnL0ON4N7W0MHFR6Z+QZ7l5s
	 N1YGff/glpcTKsmwva/1/H9FeIWLu2D6hu4gbTLnCsnzgZXMNo9Hffkk6QNGWSH3R2Llc
	 ysi09W/umug80/cRAqOivJp8XIYbN8kOAeTEQwsljks3FzDsgSr8TZVSMymrOWWT56Yqo
	 lnSarOL/NfFaAMN9TZX2n2a1twOXqiaCj7wiEvMCX0ZA2QhAGwTx/K4W4Sr/RotVLuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="TQSr4R/D";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A607606EA67;
	Thu,  5 Nov 2026 19:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TQSr4R/D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C754B1F008A3;
	Thu,  5 Nov 2026 19:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907364;
	bh=gAVlktWGI4QeSuJoAwfYGMkH1PJUJetPfF4oCxqFFe0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TQSr4R/DNc1E/FXbeW6HC3m1wCeMgc9IIMGiHJaOK7TVm2g5ZgNiUoNKqCGvkMsls
	 e80ijNz9iXptJP1sPdMzJ3n9rcbsCelmZ++Z3uf8wNwjL0bFsRjGZ0W+orZm2yOGGT
	 MHWHtJwm9E+LGUV0XYeS7ZUb631YlqElIEwM1EGlELy4RjUHz608szz0/Q1TsxHjQC
	 sRQwE6PrOlK8doE+ZCiBF8WQRnKJ6xM7BYNVmcDVPI2Hr9/eJBOxU6R5y79dTXTIws
	 2IKZFX0+5DkFSsq4cZPsKn0DAwp99uEjMEyNObggujtHKxIXTeECXEcKidjU+y8LC6
	 gXxtrmCBTSTsA==
Message-ID: <sashiko-outbox-199953@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 23/23] Documentation: seq_file: describe how a
 /proc file uses seq_file
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
In-Reply-To: <20261104-work-procfs-core-v2-23-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-23-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:36:02 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The example in seq_file.rst hands proc_create() file operations built
> from an open method that calls seq_open() and from seq_read(),
> seq_lseek() and seq_release(). procfs doesn't work that way anymore. It
> opens and releases the seq_file itself when the entry declares its
> seq_operations or its show function in struct proc_ops. Say so, and
> point the extra-simple version at ->proc_show() for /proc files.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D23

