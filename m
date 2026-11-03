Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717276;
	b=aB9et8pBLZntmitEyo69r2J0/qWqDCNEZC9rbODp8feUgg18CeaqUCAGndy8Uk2QRcnP
	 5rfVcnMJ0w9jKVZYOfxv/LWqd2K5n5MS2yURHRXVjZBG/KS8BAzp8EQg0NRyQLrBkndmx
	 dtOy/oV2MAw1WqI8WdlUVFkDEtxt0IJ1lGTaZk9dw2VpRrkO6l6Kc2/BDBdnMwGJ2T+cz
	 WAd7taaP2dOzdvrnGiy5ukDP7d+68ojhE607Dl9qCgQzonNWvHmnWjsKKBmfbSELbPhHe
	 Vi9leWYFQPbKTCgYCGgHR+jqt6WPrYmdbe4z/C3rqm3Ej4aM9b1JfQmEkmQsZlb1wpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717276;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uVu79v5qeIUT2DHIeaxbzu36E3QvgQth4DXw9asgaKs=;
	b=WVTZosrf5cx3oqIZ5r28T5QZfRYmx/QmSL2w1T5NpSYNzGGTGJ7+PGqrsXo3p25Azcj4
	 DG9rE1PRmdA7x4ZqiV0QSUunUY/OaBZtjon/zVU32kwo+Aw+JT+cS+20FjUiaNtuEPVZR
	 7f/wNiz3Mlpc1xMenSMCm4TygPEbBZ/UKo77xcFvKt/GNGCuFE+XKH46IKMQUJZCYw4Oy
	 aCYFEKESmUELsIITJkFkwjwQMn106LYAQ3WVBGEnHNCiJrc41hRkop5yOfT6oyL9pmioK
	 3VO9F9bT2zEhO0sdJqoSznMLIB37EMOTTPhR9w1X2IhidiewU3nJWxUnxMdO3SzZ0kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bRLhN+oY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BE06083631;
	Tue,  3 Nov 2026 14:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bRLhN+oY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF591F000C1;
	Tue,  3 Nov 2026 14:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717275;
	bh=uVu79v5qeIUT2DHIeaxbzu36E3QvgQth4DXw9asgaKs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bRLhN+oY2Yw9kIhUHybbJ0e+ZZSuOHGWuij+w15WuF1xIJSabw1wFMsLCqzDlmojy
	 TK03FrNF7bc7zoE1WvrzzaLmFvKEPPVLc1TPn5UU0/4/KYZ9h51Izc+12sOuXBzSSC
	 vvh8TIDoCAV3mG7NT03ZLOxqjAMKpkvDrBg2IEpsZg+kl1A4hzw/X7tZX8NCniQfle
	 ECsWaxAIfPq6+Q29V0SJTrPcv6uvKP2PxFaYrSLlpfU5Pt/3I1A8ccLjocNj2c6E7u
	 gB9WuCPj5W1+G/AadYSeW6R0FUQdierHCujXWq9jSS10EgcsXeZFeIAePUVh8txQO6
	 oGOGMufc7irOA==
Message-ID: <sashiko-outbox-195486@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 14/38] um: NUL-terminate what is written to
 /proc/exitcode
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-14-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-14-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:53 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> exitcode_proc_write() copies up to sizeof(buf) bytes of the write into
> buf and hands it to simple_strtol() without terminating it. So
> "echo -n 5" parses whatever the stack held after the '5', and a write of
> seven bytes or more reads past the end of buf. Terminate the copy.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D14

