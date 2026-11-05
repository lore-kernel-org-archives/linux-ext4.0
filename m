Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908664;
	b=D6Exsmm9IrWMdG6mO6E+e8UBI0kT10TCzYw9hxHHc3cUdrX0W/Q7rgbbaazPsqZTFGW3
	 qFJ69B3BgLyHKcvlq3Wum9dTS8hRR82ePVv+qjINacZ+b05K0EjOU3e3cu6rR1EJN5Fiy
	 MybDDrr6LJti/x8A/IldXMdXdvdJIoPd10G7LrLUoIszDIp1f/l7CgzS8kURMSlhAelC7
	 tbMvrz2QAHz58lb/S5boT63dxXibUZst0bmlmpNro6zsO2GtA2zls7NygecGkve+qKsU4
	 G5e/MeXXc0GzEpTZbsb4O7VH/CD9f/sXv2qBpsjZU2evC5qGwm/YZANJsHgZ72tj9EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908664;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dJAkA5QDVeK6/YrZazgsLWvhYslgluIDFpPpO5CO/k4=;
	b=Ro6pEs3Xlu0NjdvAFlP4kM41g/Jcmw+l2ht89TxkJ/cf2Opi4EELkRJCVfsIwA1XKyd7
	 aQZglte4PCqXT+LzjsSkig69pGX9s8z9ownYgWKvSFmMKKLYJtHUA+spDrent0zjIsGj9
	 vBK6Az+WXF4kaZ62aksOe8CUSgSwkRiChYTU5iZr+hH7qNYkqyMUCuas0YKyQpzpvExLo
	 4MmyTDj9+tCHU/qyUXiHXegJZ1HhVEaBI0ICCrvSz9ZxGdbjhQ7RKjKcXXeMNW4CH1gLY
	 3rfvJe5zcByoVZJ7k69+USKYZMhVQMMuqjDeuftGxJYV/c1swrwACr337SpV6pKNZkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XzU5PbQN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B32606B9C2;
	Thu,  5 Nov 2026 19:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XzU5PbQN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA38E1F008A3;
	Thu,  5 Nov 2026 19:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908664;
	bh=dJAkA5QDVeK6/YrZazgsLWvhYslgluIDFpPpO5CO/k4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XzU5PbQNrgnaDApRx90DQ4kjNwEFjalsK/Ugt8C3EjiB3qmFHbzDPVH7p+aVkSROK
	 LArRAsXDJ22x/485+7lEAYVBvHAqiC4NExeROUMJ/8LBcNjwuhOeXyTiEI5ODKItgz
	 1bMQyP8cSPHUevmn7qRnsiSuoNi4fuWHl2zoJnC4Bs0UvAx5WHpS5jtBM6XE9CTLaO
	 j5RO97FP06ylY1GxZsrhdwk+ZF7ItucHGlLlkHWa+hzQl/cVo2nlpvqWJVWEQt9jY3
	 FMBU3XpGo3NVyebaz9pnGaoAmod+c0f+r+TtQy5pQYpdK8w0ADpee5Gqfe4XRpus4m
	 rcvgDpQhA1u5Q==
Message-ID: <sashiko-outbox-200041@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 07/30] ntfs3: let procfs copy in writes to the
 label file
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
In-Reply-To: <20261104-work-procfs-fs-v2-7-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-7-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:42 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry, and set the label from that copy. Writes larger than
> PAGE_SIZE - 1 bytes fail with -EINVAL from procfs now. A write that
> large only ever worked when most of it was trailing newlines or came
> after a NUL, ntfs_set_label() refused a label that long with
> -ENAMETOOLONG or -EFBIG.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D7

