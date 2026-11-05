Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906976;
	b=fjQXPHpKKwE81oTMpQOq53YU+hB9f4AJ5boNiwNEgozkKK1EtrK3M11qvKtHFCQ8gFyI
	 8A7ghH73gU0Ix39FT06ldUS93ttrSvBFZqz4sdI3MSXtGhrU0ruOBPho7nLr/rROxiCXZ
	 Qp11UhoPsGYcKp78RGN9XvbG9ULEwpgfqoSw70/vjiBEpug/lm6liYAe0q/tQYscPrJta
	 m30bmS6Oh5azThB8ImhhOFudX315SiXgY3RFh0rgJL0xZ+tyhm0V4iu4yqEPYeAytAiQm
	 KDNmEwuV00JYOPYNUprNv6Q4D3/FwsB4pPGsAkbnMGAIeuKJ0pId4WwpLwZ1wo2yybw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906976;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PTE5j5M1lfXRKhGqS4rQ0FGlegosh6AezvyKz9Oa8vc=;
	b=4DJgJidLdjmo2S0hi1zuGbQN+WndVwmJ4E/Hly5xrbv/tZ698XLUFu0dMg2lBgLFj8Sq
	 IyFtEIFlaegrnoupRw7YD1oynioXO/iWLMbYLSavw9zA/o49NRb29l5RW+5mzMnIOomiQ
	 5JRWETy6c407VjZ5KgxbnKuAA5jvatyyEzAlhbulH6A5srwrP6QFVq0d3i+oksjV4MzyT
	 VY2rSE3/uHArWajm8w7mGEfzEvglaZ83AyWNMRP83Sy+wj/cNG0dTGpPSjgjZuSEJMHaB
	 kSXX/QhSSTOjkZbVmYzeuZSV9QFN38V1suQU5gv88DhIGE4IBnWDLvAY28ihj0PrzOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h4W85jhD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436EA606A329;
	Thu,  5 Nov 2026 19:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h4W85jhD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC88B1F00919;
	Thu,  5 Nov 2026 19:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906976;
	bh=PTE5j5M1lfXRKhGqS4rQ0FGlegosh6AezvyKz9Oa8vc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h4W85jhDarFXBHG0k6JfyOGr8igxfgjaZBbbaCRVTQ0udlKQRWyMl8x3vyWH1Yc0F
	 dOtLFgk+EUlfavQaPuDi+2NHDf1/BnZunAx0joRjfA786aL3mqNWdnnJweKA1yHUA1
	 iGSfM1C3r+4wCQJidi28oADHFsujWie1y+IVFLXQTuLX56ywi7d9UyNiLTEecy/eLZ
	 jxw9spucN1hAz+xXZvmAdLSzDnD4wAfRWUb7WZpsdAxmdjWIEV2sHgXEXcerAu5glG
	 lvU3C8k5MtoleqtbURHAux8hlkGA1XhQZFvBuFWItTH3nIjDF/nWCIloHR7f5PjeLR
	 QU48cCjz6Zhyg==
Message-ID: <sashiko-outbox-199886@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 23/51] scsi: BusLogic: don't return 0 from
 writes to the proc file
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-23-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-23-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:34 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> A write to /proc/scsi/BusLogic/<n> resets the statistics and returns 0.
> Writers that use stdio, echo for example, take that as no progress and
> retry forever. Return the number of bytes that were written.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D23

