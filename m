Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717260;
	b=QId2T5qVkoUXhNCHcBi1Zlz8r46aruVB1hJQQ51lLDencAuBH7u94C/jNQA2bKKbx1PQ
	 SIvwOFGlcnm2EQw1+IuV5FFNfJ6xLdur92Ds7IM/JpGEj0p69Y5k3LkvCQmwlvgVVynWy
	 Gg/Lo9wSRH2i2LcYVRLaKidEV/rKLemceG/4kefs5q6B5aP5IcAERoPG8h0EHWNx3P6ZG
	 57yo0y4tMqWFdgKGUzK6vatg5TLBVv0+EHyP+TNAvPMB6cfEXOXDuhlahDVzr5TjfJ93b
	 9fTpEG2eaSTrXtuCwYGNqIqUc0xvPBSyHg4G3gGX/wTbszdD5N2hiLt11cpX4AF2uug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717260;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AHZE5U1/G8L/MKk7wGGr6FGK5Q6/1gif03quLsojNHQ=;
	b=KiIi/mxXlTPOnk8kegG9LYa1+hhVF/WwA1I5JephwMUeuGcN7tDv7vHrgIBUnADfiXOS
	 yD/Kn6cCe8UUS3R5n3MyyFh4y5AGBHXX6WyvIC/moEHLEDhtNzFW9OSD2LIKk0HoWWg4+
	 Oj0zpkWacqRFk9yYqh8f5330MdKpLRPe2e1GlMCwqJqwM2rDneFJIhyuCr7SVpWln5Q6g
	 ynGgFmLXq96DI9Tdlvxh3rkX+GD/Xb8XyqL+LC7SnBe5ly8+wR6Zgd3mt3xILfReszupa
	 GgTneHdtQ4dSWj3vSHguF8449+fAe8J4LQtt+eWhhbEkpRXH9pofg7+HyusUz8tGj7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SMSRzi2i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB2A606D808;
	Tue,  3 Nov 2026 14:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SMSRzi2i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DDA1F00919;
	Tue,  3 Nov 2026 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717259;
	bh=AHZE5U1/G8L/MKk7wGGr6FGK5Q6/1gif03quLsojNHQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SMSRzi2iAFg28V5GkWAlM9QpBqGeZuRWtZTUm0WRq97ectI/p3rTRq3mnpNy7ngxS
	 UobvvqSTuRoo9QscSCN7Ayu69nZQ2kTxWUzR7HxT93yBXyY7WzAqTZdcWVI2zEAQ0Y
	 wqTqaA4cjw6oZ+WaCsoJFAWRYr0VGsPFK2+ApHxBe3UdltXRfdUBqr1CozJORTaIKE
	 Jgw4HsGMz1cEl/teFT45xpUxDv6vM2m9aCJlOtQfMTOAoxPRwRZc0ehArjp9mz3UJW
	 tgQf+8MJB+svNLyVTvanGS3UaTeuGomFgYbJOww1liMOiuGQbS1iPFbGiH199iIbXN
	 HucjPbCeRQYaw==
Message-ID: <sashiko-outbox-195478@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 06/38] xtensa: simdisk: don't read the file name
 without the lock
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-6-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-6-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:37 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_read_simdisk() looks at dev->filename without holding dev->lock. A
> write to the same file detaches the disk and frees the name under the
> lock, so a concurrent reader can copy out freed memory. Copy the name
> with the lock held.
>=20
> Fixes: b6c7e873daf7 ("xtensa: ISS: add host file-based simulated disk")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D6

