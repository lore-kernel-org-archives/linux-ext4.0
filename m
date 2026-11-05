Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907334;
	b=wiaFY3WiWxo9ae9Unpz7zcFk/tZto564HaLOXVPrMQbAwIR4XBoYMvn4wL/tPvZ9+9x5
	 Fa8rZkA2gwH19iOwNfntKHb8awYG49G1OSsn4nXbPNwgBsXzeK8q4BHiOYWcd1VLaCgLf
	 s1iqHe0vwHlp27Ll8bbRiecHDPM8xZIBR4gjUHS3/yu8MNLoC9kiV8o3hQv5dUe5BFLne
	 JD7ITPq4kpsRhSpvT5JuwJc2vMsQIvpuSRml0SXflB/Fs4BNnay/WsmVqv0KZewEXhCpA
	 +XVLcYEJISHXT22zPVoSQW0LzLwcqJUr9Q6R/8E3IB2imO+bXU7GqST9qSqK5NmQeMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907334;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mQEVulUxsU61vokIx6jmHabvMPsxzjhVa8rHi8fRknI=;
	b=jr0dFLsRP6yGaJ1AVuDUQlqg51Bruv4GFGGUK8wS7JX2/Bl/5T9Gl+phjqp5RWSOoUq3
	 DFcTrsjhChCvWGP1IqLBm/DCjxg2t4gRsHNM2aOmEFZZeHkdtIPMzlFZ4bewk8tsZ5C1z
	 VOPD0Jz1LvfHOUOQoxVfRnT2G9PnD4j0IrZAkKK1m5edHZWDW6Mw/RXUod5QsZlD+yZ1U
	 c7VEMQsWSbjyJRzH1M2c34BDCNKwSJttxrsWZX768aeStjI90J4d2GnElf11io5ddN+cF
	 o9v4vGrxVOqHo2SSSGIwwNuI4qu5MsfABnA+WEqGfUuEK5sU0ytmqyJkMTWaV51/Yww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJPRbspg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199CB606F58C;
	Thu,  5 Nov 2026 19:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJPRbspg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D02E1F0089E;
	Thu,  5 Nov 2026 19:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907333;
	bh=mQEVulUxsU61vokIx6jmHabvMPsxzjhVa8rHi8fRknI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FJPRbspgI9rk/ntnFT1Cz7ur8bIM5VssB3TQzm0TW2aoD1RFCmBj9VlLj4hJBQb4/
	 3/FDXpGt5pRBVYUQLnI6BUhnjhk0qTTW2X6mOTlAQFnrxBKc9wf8/43w9BURk4upJW
	 3VNEO+qgIAG0bqC5kDBUhoD0IF2gAAKd+DE2AwVQh6jvyFihiqkp2dzzMcl5jFJ5r0
	 i2c/y7bCjMI/F9vPg2NyoywBBItlJhG9YfDhWfHMm4cLjcGerM7HRyFf623GBrcyEz
	 CHLXwj/sU544msIsOKcRsTFRCBV/+2TizsDpFZX0Bbjbrdl++J4WiLF9eJNZcq1/bk
	 FneIVv4bPKAOw==
Message-ID: <sashiko-outbox-199939@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 09/23] proc: let procfs own the seq_file of
 DEFINE_PROC_SHOW_ATTRIBUTE() files
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
In-Reply-To: <20261104-work-procfs-core-v2-9-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-9-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:31 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the show function and let procfs open the seq_file.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D9

