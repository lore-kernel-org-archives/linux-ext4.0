Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906982;
	b=b3ku1UO5puDDsTKiVuLvefb6wNzGNx+G7Rb5t/OQIziV5BLMsqc0yOPafHMuD8kCPu+r
	 qXvQVU0XtAgpT2y6J3p1U/7jCTA2nnablBilIeezd+WkgS+Rh/unhtDJ5ASBcFRaXPN08
	 Ls79Ok8DRw9egyY+wMYZ4Rzsk5ZuVrIkZaDTy/DFRs1QtNOCp2m0kaVTdvhBRXllnAkPk
	 yASZh2yYksI42NP9RRDvD80yxdbWPM38wv/DMRtoOt+49TAU/1NBbCNKCdpKuUGEkXZxs
	 EPY43y4k9eeFPyGuM6kBqK8bNhLmMiR5CHFHseZcXhgyjXX4NLlGXY/Avj78Fl5R9bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906982;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=P6jpmRzymPT4r1qFhmwUt7rLPG9nXrVikl3aWyHy3zY=;
	b=P7FP32pNscn0xM+Tmk2L3XVPVIKVgBFtjlVO8V9T5sUbIFIL9eifqNbeS49gRBM1CnuV
	 W/8X2zDqPn//4z3iDUKRrTdHxVrWgPSwBI3ETb0w862Pr2Mn3AsUvkrUKLkG73nfMdqtw
	 0EmtNo3VWcaa1QkSUKHbjJudN7d1cDdi/Z9AwCOhNnZ5IS8VQzsVp5W9817+JGRHL5ijZ
	 GNR8OWdCiqCUoeecHwgDewPBpCKCVsFkG92WoA78Uu15x3UkNynzwOB46MocRwANJcHDT
	 XOAusIZ55cFfqOBvOoQYSwUUlAC4qTzmsACzb1LCQpfYHGig0Hqjk3noTQjsqU4T8aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BI6MttIY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB308606D811;
	Thu,  5 Nov 2026 19:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BI6MttIY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506931F00919;
	Thu,  5 Nov 2026 19:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906981;
	bh=P6jpmRzymPT4r1qFhmwUt7rLPG9nXrVikl3aWyHy3zY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BI6MttIYsBkE0g/vJZ+tIbuQi6n//HrvnT15RjmT0kcJcNcEhPSua8MjhEkmvdLBy
	 YJ4Cl9rhWrU2J4FNfrV5LG8LjKzdoOPXpIy3l02i150qUa6eO1W62hdcJOzlm/8UaO
	 8YRGUFIFXaZzA8K6X+GpP9ZjU4yKSbKfjjhUBmROBGXgTGgeHdxAb0ylhCvZ99pGHi
	 UTdy2yICxI8TI6rIlwVdpTX04WIt3mGVdeNnVRbumQIyZHqUl/9zhk34Qq091tX8nL
	 V7uPEQ77IY3Dtg208+RDdYXIh08xvxvfPijNAYM2aPAEKdPQWQJs9yilg/Hiqm9By0
	 dV7TqpBHd20kg==
Message-ID: <sashiko-outbox-199889@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 26/51] scsi: core: NUL-terminate what is
 written to the host proc files
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-26-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-26-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:39 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_scsi_host_write() copies what is written into a page and hands it
> to ->write_info() without terminating it. ppa and imm parse it with
> strncmp() and simple_strtoul(), which read on past what was written into
> whatever the page held before. Terminate the copy. A write is at most
> PROC_BLOCK_SIZE bytes, so the page always has room for that.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D26

