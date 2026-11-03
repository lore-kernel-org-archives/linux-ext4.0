Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717258;
	b=nXnlKwFSuOli0cMAecxsih+BDxKuK7KLJEPvBEzsrLqsiYMBjfVZTNsYDyo/bAztJNb+
	 8+txDM/qZtzr9jJ76eKJ9+PA3g2wQSY32HG19awbD6l33UwXzUiAQye2AwZBDS0G4H58B
	 TZv+6gzrTobbbWQYd0Hj0M/PujXNMqk74IadWIkHrswiWIh5C6vbFZ/4z9XfHX3HN2c2z
	 LZGY9gi3GsdtNEq5je2xyj6Xeg4Sjv4VNzrolU2fRWNlIMAD13d77pn2s1HU2FnwXJXMe
	 Dm9/VHUs53d+AXGAgrolrxKsSbP9rAIb9iF3XLQwdesClMsfBjY2sUc5jchla99lFcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717258;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0X7QfirFXJ6TGEt0F0HTrCg+kq8+2Z7EgGajwy7tHN0=;
	b=4h+fEoZkROBKF9EGRwN9vkMRpA7SPf6bwmS+/Sh9tcIAbGsRodUV2H3ISuLwfbpKGInd
	 10ktrY2C7VsXQpNLwacj8UScoHSmUcPFMd+OsmoLOpGPwO/2rEhyCrqlXZPrDZu0FnsEF
	 VQDIuby6++uoS8DfLocO8dPusv/eSMbYVv6XfMhiNAX8raBS9rOnKF1/2KJIIxZ5FXl+n
	 TUGzXl/iz2M3DetDfsYjvhZXwJ036qE3flyYaki+iptPquU7M8179DeC4xYZqtx8d8qFy
	 Naes19+aj+mtwR9MeyLPzSsqja+LFHz0K+B11rF/ZCbIuwHxpW6ZbjLMUIuKpNEWWAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E125B606A33D;
	Tue,  3 Nov 2026 14:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DCB1F00919;
	Tue,  3 Nov 2026 14:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717251;
	bh=0X7QfirFXJ6TGEt0F0HTrCg+kq8+2Z7EgGajwy7tHN0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eJTPNleoTplgC2QGyAMCEdjZXP18HitdAHpzSVn25D2DW6ccMaFWAr2LwluZydLLw
	 ohVn1cisxm5jNlK5vxJuJIhskLbddiSBnOvJJDXiE3Cu75jtXlQ+8SfeBkpGpWHjBn
	 i28pGRmIIQunBQfMvgJEeYVPdFUqghQBhDG5qp0f+NtoUe1/ghWBC/xCF0L4SXMPSn
	 SBEK86gW2rh0XRAw4rFfYn2bpevpOMJTo8Vf+khdDv+g4gS9a5A6fT8mlg3qaBlIVe
	 /HqY/AYZ/tsDjOSd+E4CKNLsEU1t/Ch/2G5hhpWYurg9grTBe6GvXEvrm0lnVyKiZR
	 b5T/Q9eMN5Dkg==
Message-ID: <sashiko-outbox-195474@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 02/38] PNP: isapnp: don't read past the end of the
 buffer on a large pread()
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-2-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-2-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:47:29 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> isapnp_proc_bus_read() truncates the position to an int. A pread() at
> an offset like 0xfffffc00 turns it negative, the check against the size
> of the configuration space passes, and the loop then puts everything
> from that position up to byte 256 into the reader's buffer, no matter
> how few bytes were asked for.
>=20
> Keep the position as a loff_t and clamp the count against what is left
> of the configuration space.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D2

