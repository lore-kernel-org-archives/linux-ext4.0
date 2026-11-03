Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717288;
	b=ePcb4R1PV+Umi0MbQn4sU6lDMRP3YXulXPD4EcLAphk/rj3V1TWyHTfoMJtjsdJhdyo+
	 8HBrBk61+AXIRnnM2bJoK7Bjz3YaswxCWTXPbaYI79nuB7uPYYqR037zp/nhWFLOCTMhb
	 CaudRzA+3vC12rCuQU90WD9KdrlgMx5+71TsgCg9t7VpwL+jNab+yank+e0auttxR0U1D
	 nzgcDG5FQQPYnMRFTOt7EXjj9gQ8Bb1nLhtSvzrg1QnmxmDEO4oPZ4WvmRApfPnEoqDbJ
	 WiljxkitD7tscp5nWtBiO3Mv1UXC8kDIIATg2+6IZYShX0WsvQxQgAJnSTo1nhoJUKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717288;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Icn35Mi91pQ+tLfg0mCdB4U+ZmjGBtIaKsilMrrc5tY=;
	b=UHuLhnuokubDREKU0OoPyz2Y07or7VE+52g8I4n1UaPNKmzK2eUsY6vzCKNkNN2ugJ8C
	 /CYrb0VzP/T8wacAVpTZAytrsAJW6PJV0HiiA7i0mGOq/3lvVSITThle0NV79cAqY17wg
	 OdC2WBDN0rOV1VA+dLUoIBKWAHfhmLjiRQokKFb8WfXeWfCfs//7eCg3pQUBcURLGxq9C
	 /pCn0LTDKQ6qTKAqtOX63PchLkfXFoKNvdseKCx9gMhD1YE19LHfvQYuOU0GraM/tcKRl
	 jM3HxX5SX7zpLMAaVIf2WCnCB+IPgDP7G35CUYT3/ZyvKJW+AuIzUJoXfU/DLSyly4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dh1dKt+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA7160A3833;
	Tue,  3 Nov 2026 14:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dh1dKt+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441281F00A1E;
	Tue,  3 Nov 2026 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717287;
	bh=Icn35Mi91pQ+tLfg0mCdB4U+ZmjGBtIaKsilMrrc5tY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dh1dKt+STUs/pEoLctpFFtQkyKCAxxWJoxXDNG9HNkYmLm1AdEmDmmdWV64Js6Az7
	 D7xeBzM6wvr24BHDVnxZNsmdK8y72d/Sc8fRWz9vjYY2X1n981YMEB3CvPmhvXhzoT
	 CdEliGimDf4eL7SpBrWs7GBDY9OjYAOjox1SovFaGTGUyI/vN6Vhs36589r0zEyUdi
	 mVeMd6wVewqD9lCD3HCijfRClz6bHq3RpQ/3lZQUAdmOC5lUq0F8u4W8MwAYT72JS1
	 NFUnHmQbjcLibYcuMjtBUE9DfbW903ryc3o/4VSRPIMZquWia85CdIpJWlxt1Ne+x1
	 8PIhBdEx8sqOA==
Message-ID: <sashiko-outbox-195492@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 20/38] selftests/proc: check a /proc listing while
 entries come and go
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-20-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-20-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> List /proc/net/dev_snmp6 of a new network namespace while a tun device
> comes and goes:
>=20
> - with a buffer that holds the dots and "lo", add a device whose name
>   sorts first, finish the listing: "lo" is listed once
>=20
> - with that device added and a buffer that holds the dots and it,
>   remove it, finish the listing: "lo" is still listed
>=20
> - with that device added, stall getdents64() on a userfaultfd page
>   while it writes the device's entry, remove the device, finish the
>   listing: "lo" is still listed
>=20
> All three fail without the fix, the first lists "lo" twice, the other
> two not at all.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D20

