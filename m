Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908204;
	b=HQfK3qDdSzBYRid7yZ0EBcC0PTWFWgbWGhWyoC+NELgbhZuE6i2S0lbx1vG3EtCmyx70
	 CT4kVGyqkETFnTFb3imt4sHHyIOpIuDNis0ZEgNHVxkfceabl99Fqg+4H6NPzIGVZj0Cs
	 7nQ/ofJvp1UhOwVLLVV9Q0yn5P6HCvcKGibDGtBMFOIE8BChGlF0ObCGpDXaTZvFd3Tfc
	 Cjyd0w97JMay7xyy75J/OCt7NTXs3RMwGvn8NOWq2wszch9JNtK6ce+cTb2MbpJ5F8FyK
	 4AioAWNaXCkZmIDSj3CgC0jEm0Wo6SYX/yU3+azYGyG7a0rKNUUNqWiYoQuwXYiuFUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908204;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=R0jppsKfpO8c+Wfs9tyOHakvTx4OM727OOcLj9g2iGM=;
	b=Ts5VZThkJ0ELS0NqmbND2O8+p/CjSJJralOSWCRCGwCfpQVNOtfwp5qxyjd2gCq8ONVa
	 s/xy/N4BlONVvbCTNNJhNvRFozE2W5synxhVTGCph7uREQToLPL9q9GQSmkIag8g+v/Rb
	 TIGjSg2uwmtipRlm4/6QNPdDPFWKliPzxDFR3S6u00li3+uxtyee7sgeUUPQW2qnAEwOh
	 0FWlyR6qC6PexW+b8ZqdJLABvaW+Gs+5xDELYD7awliTlr9Cz7/g4Uy2m/3T6kC45uFK8
	 +xav8t+hxmnnvTXT7Jw7aCjOsV6fEpEMqLA9RiHeSqskUvcFaf2v78lQS7sxJnlftfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nyw43+S2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975D2607A645;
	Thu,  5 Nov 2026 19:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nyw43+S2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A981C1F008A3;
	Thu,  5 Nov 2026 19:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908204;
	bh=R0jppsKfpO8c+Wfs9tyOHakvTx4OM727OOcLj9g2iGM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nyw43+S2a/7VyDX8w6xahvn9ZApqn4TJ0kh3YRsaUxeU/PqvpCGltRfC1pm+S/RKN
	 0nLdp7uPjhnxLJrT4PEIRs99H7SQAAMyW5Dpkk6h/SVdZvIPpBfgtxl/1VwXucqMCF
	 OoxStV4jZM3fRilLNS/gPiJHRRMgCNmYxkJQFK62QUdzRl0BOMQxUyKfrlaAVb+wzL
	 8MBqjgPOLXXRGgYlOZpPHg6AXB4EGv8eXqVu+otJc/X3aF3UdhH2Sq2mQmlcePMx97
	 MQvhPaBzySigSxDPgMHxqO1ydd1YUYiYyo8odeK6rXwGa0X8QKpBySn/dsFO67X87C
	 imselCmGHpGHQ==
Message-ID: <sashiko-outbox-200012@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 26/26] ALSA: info: drop the poll_table from
 the info entry poll op
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
In-Reply-To: <20261104-work-procfs-drivers-v2-26-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-26-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:50:02 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> procfs owns the wait queue a /proc/asound file is polled on and wakes
> the pollers through proc_poll_notify(), so the poll op of an info entry
> has nothing to do with the poll_table anymore and only reports the
> mask. Nothing in the tree implements the op.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D26

