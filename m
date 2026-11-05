Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907004;
	b=q/rOt2p1xcGTt+qw/jJIXEnasQDw4sGfyFqkhy0do5AJKxIcAX6bB/cwqieWAQ/vu0+s
	 9+lPa8Z42FuMNWypAPZ3BweexnMCfFBbxfwi1IKJOpD7th6PHa2Fe0+cV/ylcfaju3ZB9
	 liF3I4Lymnt1kH4x81g6dyPEXEzvr8/AAX7LS6PKe+jVziLKzq13c8TWjedV5o+/DHmff
	 Dw3z4Kjv2kLmC6E8CZS0cWNxScVZBYadfMBEkcJ02cPi70tY8snZOzWyVQjvLGEF+/nS9
	 P6oXkR4B/nzvMLz/oiXE+e9g/OoPP+P8oNYsm7ekuD4ZooK7GlPoVIRl6p/yYYULUyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907004;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bT7cdtBA3g4ZjNdxCADmBOubkwzRkbH+TQ0hoqO6tiY=;
	b=fabEpdKLLxh6bMqs/EpdPyd2tRq/1uXeRE3/Cth9yk08k1snbqxEEzc9pVofI/qEtgm8
	 7gawkova9bRviP5d30RkSbZ74KNlGSvj6b0sKX+Xtt69ZJly3pMGXPDyPbRKRdKhN1eyG
	 jURGt6RAC5pkSUKeoOWmrC+cAxXUgMbBeFCE/UQ8UtC+1+7Y4Cj9h61KDDcnHJrjXLIBo
	 m1nnm0CCCD8uVxlY8sU8uW9QUzh7FttL2Mtt08NuzXx/chOxIQABsktq7FeoujbAApKc1
	 05dPqJ0+5op+6/bu0nPxPrH7axV7Q4PFEWZCs9CHaFOuzJ2cM9jMQOAwlNwsaZ5BL6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZFkFtso3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC9D60A5BDA;
	Thu,  5 Nov 2026 19:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZFkFtso3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551AC1F00A17;
	Thu,  5 Nov 2026 19:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907003;
	bh=bT7cdtBA3g4ZjNdxCADmBOubkwzRkbH+TQ0hoqO6tiY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZFkFtso3C96AnTUnqfat70nSvPWig/+mlWw5M0UhnuCp5QJxgxNGQrORhQlrQkJ/y
	 hC3IYuBkO3IUK23KYNgrztoNyDYmU4MR+D9gL2C8VjvK7vkMSvevOunoGmfWD0JNml
	 vsF9OIiPC1HM3aRMk6Mbu6p74Dq5+9CvuKroZEovRvm/WILib1QicWaO1x2FWXQ/Gh
	 4URR7CizufYYPnmywgHmy0LbSoLzZeP9pgnBeUiBSkH3rjb0o92yRGCn9Np6O+kLCX
	 Go0H2HcVBVV+M9zicMMj4k9ffVIUnGBdI26ePeddA9J3Se+pxAShijM1YnU9ctvKg+
	 O8G91Qj2o2VRQ==
Message-ID: <sashiko-outbox-199899@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 36/51] proc: don't let NOMMU map procfs files
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-36-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-36-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:00 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Every procfs file has a ->mmap since commit 786d7e1612f0 ("Fix
> rmmod/read/write races in /proc entries"), whether the entry has a
> ->proc_mmap or not. On NOMMU validate_mmap_request() takes that to mean
> the file can be mapped. procfs has no ->mmap_capabilities so a regular
> file gets NOMMU_MAP_COPY, and a private mapping never calls ->mmap at
> all. Instead do_mmap() takes nommu_region_sem for writing and
> do_mmap_private() reads the file into the copy with kernel_read().
>=20
> Reading /proc/maps takes nommu_region_sem as well:
>=20
>   mmap(NULL, 4096, PROT_READ, MAP_PRIVATE, open("/proc/maps", O_RDONLY), =
0)
>=20
>   do_mmap()                          // down_write(&nommu_region_sem)
>   -> do_mmap_private()
>      -> kernel_read()
> [ ... ]
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 786d7e1612f0 ("Fix rmmod/read/write races in /proc entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D36

