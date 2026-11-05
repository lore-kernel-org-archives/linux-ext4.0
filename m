Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907017;
	b=wO2jBGiqImPZjzJpG3J9MrhNzWmLF0xLvV1NFSBeMQnWBPBN5GjDWaFsM2sKRpHPot9h
	 m2096WPMOHw8+6U2xW4ITm72/3MPCM071Pvc3LX380FCvU3Q+hNIz7qzvSiL877OL3uZD
	 yUgA8hAMgaWWnLsEI79Fh/E7+F02Zvcs9g+t095iKtUMSZ+zpTTug4lk/noaKfk+759Bo
	 IPFpz2VQs3uKpZn4iNsCMTMw5I6/WMEsnrQ9BOPSt94ouQTChli4rdOJ/Y+kkaEYlTDI/
	 BaWu7ReO0i5q6uvpAqZ25uKJb56IrMnIW2QGPQbO7SUf4tIyoBrc6yugU+zCZF6z2oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907017;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Wezpe7xp/UNpZ6YyNGBVpwJ4mVErEnOLjUB9+d3ldv8=;
	b=VInJHA+FkxqjA4S/VqjOj9jos6mS7eHwr3r8+FMEWXhP7itNB8r0AGxoh2sQXZ1BQ4dU
	 NyQUzLDbTE93lDkR01HTdBTDy6+ueqLDO8fOKay/3jILc+B43LcCHAZd7o3LhhwLUu56j
	 gK+trGynmjlpWF/qUSjkuEnr3RlX7W2F1iCjDnc/9gbahoQIWGguarezGP4t2trB3J1HH
	 ObyD75MZ2UuJpfXnizi1gTFLoItL6mTG60RNqiSTb74Gg5S5R0Wl3ela9MjGvGkxzJZOK
	 wLbaTsP2iUf+5Rzs2rlMmPTCZNdbzFoS2VljNGEJzxe2Io8B1nkuFmNjYXQkeTFzu9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AYGRhzRF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30BE606A6FA;
	Thu,  5 Nov 2026 19:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AYGRhzRF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221B61F00A02;
	Thu,  5 Nov 2026 19:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907016;
	bh=Wezpe7xp/UNpZ6YyNGBVpwJ4mVErEnOLjUB9+d3ldv8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AYGRhzRFSy9T6cqfIEWvUQKmjtAw0ISW0hgFW2F7Lr/kaRiHwoxuT44bCbiePUUYS
	 tdUcQ4jzDQ7CrEnsBPQgW9Smo5Yo7VTe+wucOJPRcOI77c3zkNZlMJ0NRjRuh8sgD3
	 Lp9j0YS+XwnTNu63HAG+J/YN6pd76Kf7tGh41xrpRv3miTO3CjljECiDQQB+sm6Fss
	 MoJPLRGOyHPcgx9QC5PmI/jl4wIKCwPRrYVaXewwxRn3e/SQ11qLxGvzMbs2L2pJAc
	 lqGAhrJHYOmqMm01AvESwiqJ6R10XNmVbjUe0/EMpwXF0ixUyryXuszpf5w5uT5ckB
	 0j/SBCiu8pzyQ==
Message-ID: <sashiko-outbox-199905@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 42/51] powerpc/pseries: bound the lengths in
 the ofdt property parser
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-42-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-42-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:14 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The commands for /proc/powerpc/ofdt that carry properties, "add_node",
> "add_property" and "update_property", can make the parser read past the
> buffer they were copied into:
>=20
> (1) do_update_property() computes the end of the buffer after
>     parse_node() moved buf past the phandle. So the end is off by the
>     length of the phandle string, which can be padded with zeroes, and
>     parse_next_property() accepts a value that reaches that far past
>     the command. new_property() then copies those bytes into the
>     property, which everyone can read in /proc/device-tree.
>=20
> (2) parse_next_property() parses the length with simple_strtoul() into
>     an int and only rejects -1. A length above INT_MAX turns negative,
>     tmp +=3D *length moves backwards and passes the check against the
>     end, so *tmp is read up to 2G in front of the buffer.
> [ ... ]
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: 610d91511f99 ("[PATCH] powerpc: Add support for changing propertie=
s from userspace")
> Fixes: 46db2f86a3b2 ("powerpc/pseries: Fix to handle slb resize across mi=
gration")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D42

