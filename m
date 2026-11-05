Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906984;
	b=Ej8P83s/WdGY0hSbUH5GByOVH0lXYGmc7BNG80TlsVCZJBqExocPxdfb+HVk5lIMBovT
	 6fBcupEQunDZZbfTWmsQl5tBWpdCgKyySs+IEJwGmq2K78ouYiz6Wv5TwNpWSikB1IGdw
	 K6+HkqZmezzoFre1nLIpy3QqKXKvUuS5cL6iO8aGN1TCam29E9rZyRlY9/WvhePZX8lp1
	 yBrsyrySVS6NzzTSSQJ48+L7JIAe3hmkPM8toaBYKI8G8UkI2aDm/Zyrs1CvEOp+un2mx
	 Aedtcy9QaA7X+EJA9eghoa1LeWVBG3v7X6yEmhRmdjBY8/ELwAxS9on0l3Qqw2c+iEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906984;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FD0zXeI/isP72fw/ayOidXLEWS0eS7g6u0vyIbhFYcI=;
	b=BgaXxClQfoujgrkUP7245BSnA/DmUOiy7kY+/oAYkm24yvA5ujS/lZKNgeMsApkCzPdD
	 xTkEri+LE6cLQVzahYJ0G9X0CrJStmUlXJLpb7FpM7iof8BQSWU7z/FUTuJTR85RtBxiw
	 X3ketqofqwZQT/SJ35rbd8qJOiSbhW/H3JgPTFXPx1AV88nRV6WZ5o+5uYD8i7sBypSw+
	 0h8vxT0Le899Ev1qY1q2rGOKikEjlk7/oiDocj1HUEn5Wo9u0PJHLeCop9K9gTvhTBT8D
	 nxfVPFaPBm24VCLRZ8z2s18YJqcfWkF7DyuD0Jjd+Y7qNAWiqFdAtXf1piy8A7H1+Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H1XBvOeH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1783608363F;
	Thu,  5 Nov 2026 19:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H1XBvOeH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2966B1F00A20;
	Thu,  5 Nov 2026 19:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906983;
	bh=FD0zXeI/isP72fw/ayOidXLEWS0eS7g6u0vyIbhFYcI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H1XBvOeHKHmEnMkDZUHXEyfUtxCM50iTgTdglUxQp7JDN+qlEWTIsqSpbnUlpXjRN
	 988hcRyCOI8UWFHz/f+qK5LDQHQXayVRQ3262j47Zn0Jqh760jpB+AGIZEjmyhHslx
	 Qqs2Y14lCac9UjAE5y2LlNmPZovL0mIlxziAqVpEYWF7VcSH/XugirGbUWyl+1JJad
	 +WoSrpl7AP1ruZ40/ApjycvpY+4AnxyaNTaAT+qJ2l5Ec76Lx2QiGxwb9aykDXG/Bj
	 ZE2WhLZrYRFfMMBbtAErBrjrpSX00IacUpKBWO3AqMz+Y2+flePrBdhMVItf47L5ux
	 lY1VLRG53p8sw==
Message-ID: <sashiko-outbox-199890@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 27/51] um: NUL-terminate what is written to
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-27-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-27-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:41 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D27

