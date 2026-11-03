Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719119;
	b=dFzR41pzpK7dFp1jQ52SQEEj35PxS55AnJTrxe0zm5h9CAwL3dNpAG/iLd1ofD+xw7a5
	 JmTSN7rhVzMRW0RPGWjwkqJ7vBD+l5VZ5EgzvYEpa+hgD5wSKGMu/Vh4ma6dsKT8DjH4p
	 KI8C87YrQ5fW81smltyc3NNVXoe6jN7xzOZahvgm7WzUIpPMCiquf1RlRsT207+u23GuI
	 d+KQtgbq2jZ7vlFIeoozGZ8OkCPHOUnrPKl+ayI5bF71A9PNOEynHadvrBcGt9FEapVqo
	 Ox3NmpqKHQb99T+/7vpWkR9FMbpLROBgFnrHKsiEhCXgYfAKQwGNDCM1k6iQG00WUhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719119;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iYkrqCMK4sFn+IzKtXYQ/U5EAsE/ebvjSwDe60Rgl0E=;
	b=PgBWghahrN+taN8ns+nLxUXKTz1EvK/k2yjPSaSMSnu5ssKAT+6jPgxCJPjXiFMPnUvl
	 IF4XjokQIGuK3IEg2Fjq5LUWlt5UmUiETysZ5Vt3sfu/lPLepfBPMGZMwPbozJT10tv35
	 aubKceA4+kNN7G8M8j3uKGjWAeIL6scYrVlNfTdI25IG5V4vj5Ic/n1j5sJNmuXCM0fz/
	 /6Lt7TLGa+dTo8MzDBu9IN/9+rc5cckrg5aKhU4ijKxm2BKFY5qRvF6f2LsuqaTm2SHpo
	 MNc5KTz17jQvPA9n3imPWZYCQrNW5kgp0rDMaiQjcmcq6qO3DO8DUZI1UgKCxbZPWpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HpJXKwG4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E633606FCF0;
	Tue,  3 Nov 2026 15:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HpJXKwG4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7805A1F000C1;
	Tue,  3 Nov 2026 15:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719119;
	bh=iYkrqCMK4sFn+IzKtXYQ/U5EAsE/ebvjSwDe60Rgl0E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HpJXKwG4c83h/WlMOPfbG+pXRjut25QP4ALof5n4perASl+pG0+XdnLAbH2pMqjWu
	 ZpqwtUvq+pwD25biFv2DLmaWL7DlQpG3/qb8VpBOvxd5wqf/4VNn1Juy6IsBSymW7g
	 LtxumV7l/CDvPksMz+J/phWUSoo1dPWSJ9E/KVqcESkpZHFoXwDV2h/RTh/BVVsupo
	 ywpSTGwrOlS88G9c7TocjGL//IsVNc+C80+riS0EcI8W467Qh9hACT4HrtUR2laHK7
	 s3CQWjYxjczoY5WJryXtrQuJdT8nqogkMRxvjIzU1yLUca1vgAib4Yyq8AR2OjsCdV
	 hQ9tAaJMXUQbA==
Message-ID: <sashiko-outbox-195587@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 07/23] s390/dasd: let procfs copy in writes to
 /proc/dasd/statistics
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
In-Reply-To: <20261102-work-procfs-drivers-v1-7-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-7-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:37 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry, and parse the command from that copy. Commands longer
> than PAGE_SIZE - 1 bytes are rejected now instead of cut at 64k.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D7

