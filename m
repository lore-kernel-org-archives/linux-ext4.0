Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908189;
	b=yx+7oC6JZuDidBro1ZTnTX4YeTeFCEEHr3D0WjV2Ddnf8AAS+xp8ry9DwDmn51MXa0sW
	 wPc+36xo5QFx+OpeSnlhyLV7P3usv3/cUNx2iocZD6SZhOxp9o8HUubNIiUEUbcR4sDh7
	 VBVvVNYQDVYyVvLKYqwYjHREy3vu4Vi+yUyGJ9ck6AoI1t5VvoeZVvBCbbfdEV+1qJnmN
	 T+ZFY5rOYG6Af/c9WoMZzbiDpJBxM3dO0BS3p6gHRnM8CUvXQTtk3caQsYRFhSpsommyq
	 rhZVJfPI79adbyEtUZIgFKy+rLamSkHOwsbHuOBidw1AapJfuQcoV9WgAsCRC1dR/lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908189;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MrI+rqDmwsTpRPF5ki5piP+HFeRyIsPNHlEWXQTT5Es=;
	b=tnzr/HfZsOdI+eKLVwK7xkLhuM6ea98UKiVMNs/ltvEY+iwmlSORe5YJmZFgqJTxtogO
	 FGmvnU1E/VWWT0ekQO1qycwxG7bzk+GjkG4Bh6rySGEKmgfZWgo6mNX6ijlIfyv9xMmbH
	 AZvvn5m/6UAT2fGB4SKEcMXb2nawIM+zJJlwxWfRS6TsyZInHRHsLNmQtShWVk2nXoWHj
	 eVfSN6mHUXDU83t/IxciTlAt7hpJnDHB4qmvxepRPmqeEYmdKh497FiigIQf903zii+MI
	 41UTwQhKQVy7nt7cRIW6kwCJGnorf41nvCubDaC5doFltHZ+2DkZJ/V+4FnPPIRyTDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JlcRruvS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988B56077B73;
	Thu,  5 Nov 2026 19:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JlcRruvS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE61B1F008A4;
	Thu,  5 Nov 2026 19:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908189;
	bh=MrI+rqDmwsTpRPF5ki5piP+HFeRyIsPNHlEWXQTT5Es=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JlcRruvSXXeF/yHdh8XDwJYbseLZZhFUomx7pyjMpu12GzMnmomelySb2GLdLrQLW
	 qc+ay3RTgqdwdbRkwuHHf/OceJtNxU8NY7lTsvjpgfk7E8wPyCdcCBqzjjWDcqC9n+
	 9E/0cDjv+DLLsL2Ke+qV12ttQoFjDSveLdOwbsYYzRvbQOGaiRo1gmfBu+8rc7Vc1F
	 HvwL7WWrnl/AvCyXWk1WhgKMXHhJpBfKgN/rm6KIY2DOOCwIlXcps1JhhMIyAxL0bG
	 ObpyCzcd0ERlP7sTZXQ4Jn/DqI3IfyN9LEdC5d7h/YR67QqngtLQOk8I1Sym4fpsYm
	 OX5d+yBtndmGQ==
Message-ID: <sashiko-outbox-200005@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 19/26] wifi: ipw2x00: let procfs copy in
 writes to the debug level
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
In-Reply-To: <20261104-work-procfs-drivers-v2-19-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-19-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:45 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry, and parse the level from that copy. Writes larger
> than PAGE_SIZE - 1 bytes fail with -EINVAL now, and a buffer that can't
> be read fails with -EFAULT instead of looking like it was written.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D19

