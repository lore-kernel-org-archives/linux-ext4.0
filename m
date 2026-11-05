Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906967;
	b=4fc2Q2voM8mvL8cv39y2i+LO4WHsY5fK8k+bnb8Jxh8pyCSK0vBQQTzM79/SL2fLeiEg
	 wIXh0CgDt9s6PfaznzWQVCHibSkVQENKB7qEK8PzWZb0DYYxcMZvLd5riODuRSffNbWmY
	 nrBoHV1hHwKXpjcUYzK3nsqGwGKJ9uNRIjMoyDKqMgvZxvQb189ZkmUmzbdyxiXUO/wUy
	 BltUqO4X06NKz25ip1PL4/mZVlDF9pz6tAJ8WpJzJiYcHluWWmzdPDdSkIzQqWi8btCUP
	 sTSLcBpNcaUaa3qTI6yoavjUbEhE55/HHXFxWC/otk8hpPYNQokZ2HDVaj1q/4SnEaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906967;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Yw+/Du8pHsdCvYl6IbYLuKH+OGLUIcbJDiY7LJnllJI=;
	b=lQV3LkIBO4Ge5ToGqnOqeNmY8ccLmu8SqXiTEEFa6SAtyuoR2GV98T634uUw84OKmqWh
	 ZCSEqCk5ifs1OHPI8pH+NCLEBLTImX9UvBtJXEmsB3Mxt0CUJTl1IcVKw9begPHFAIiiy
	 Rtm52AXM7SSndnAClsonZ0DqjWJjxgPKTxyWaH8an1M1zHu9Sto9EcpyC0A8Hd1hRvZEV
	 RmJWvejT0lT5oklHu8CyapQwNWA8ZjdgxnZKICEMzZbi28slKVS5HBtDKX07QVWqhpTKA
	 xx0S7TieVPdVipu4ydo5WnEbJjOoDDiWpVcKVK5EqBVVq4rscKiWs9MhC2n79qr+jog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="l4Eko/RK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CEA606A330;
	Thu,  5 Nov 2026 19:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l4Eko/RK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDBE1F00919;
	Thu,  5 Nov 2026 19:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906966;
	bh=Yw+/Du8pHsdCvYl6IbYLuKH+OGLUIcbJDiY7LJnllJI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l4Eko/RKkbQXervUh+9BCXJ+sLsI4u38jjERwv2HDU2tKr1bCDnCCw/QT/dKc1MrD
	 nG24sg/ARdKOAaioqHnqlbMFng54iK9sFGR2MBxpRI9bPa3il41oD5LUCxrnPRtNn5
	 DKJ+CPjlIN85/i9wz8h3zAaLEB0HSX87FOiOgckHHu/HvAH0MfRD7oR6NdGDjHmHBp
	 bZGWS58CuzW9/drusy9qDOn77viubLposGHA42hn0poE0IRqBJ9Hb2OJZL55U5B7t6
	 /9ggt31U3dXthnEYRs2zWGFTAlTOnVxIM8pubtNQkp2PuptVcHbgqPWl/ETNFUYpMm
	 KKXNeYjAU9H1Q==
Message-ID: <sashiko-outbox-199881@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 18/51] platform/x86: toshiba_acpi: reject
 malformed brightness and fan writes
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-18-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-18-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:24 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> When lcd_proc_write() and fan_proc_write() were refactored their checks
> were inverted but the && stayed. They only fail if sscanf() didn't
> parse anything and the value is out of range at the same time, and for
> the brightness value < 0 && value > levels can't be true at all. So an
> out of range brightness or fan setting is passed on to the hardware,
> and so is the uninitialized value if nothing could be parsed.
>=20
> Restore the checks as they were before the refactoring.
>=20
> Fixes: e1a949c1b988 ("toshiba_acpi: Refactor *{get, set} functions return=
 value")
> Fixes: 3e07e5baa2af ("toshiba_acpi: Add set_fan_status function")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D18

