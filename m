Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793906960;
	b=gjYxXONgTw7qGu68/19Z6xmQQjovw6uKUfJEh7BhtibR2Ok6sXgHD/hZBay+tSe+Q/8s
	 dwUawyXJYUpykn7yXWJQgeboMYPzfcuH8hO4RPqbUSDYoxmd+N2ys1iq+3s31gHTJnq0B
	 3W2W+/FLT3L+pBuSLC/9A/mWs8Z8VV+p9YnLUcFSP+NAGzGFyf0SFW4r600xrelyBO/Hi
	 fhzlwwaAEItHjP3Yapp6Hx2vLYBt2OTMHwj6kU+fA8L0mxAfaAfXO2s8ZX8zVMhn+h9bi
	 zVbiP+qFEJQ6MLAICrYPFjbEgueN8zMtzmoXDOGtm66sAuh6jqzcbIWDsDPlz4PIeLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793906960;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Qw513NKzixnVetQs2aPch799inLwFwvqjGlTZsHFgHc=;
	b=JF7A80URZJsZxlv9VeG7Uhz532Ydulkk0bZZxjcFowAIy2ifVW5j0SpMh3tO0eZPfK6Y
	 lIoHbRqmBsQ3q41yn3EPbELK/1FhdE9W1kOdmi98P1GBxrz2rj9iWBKlnv7PPhweYkdrz
	 tZd8DJh98nsc7YFk5HU/mQdD691bQGZlwlb74E0BQHQFwKbpToF0h1aylFmslTO/o+7XY
	 d4JTv5SAiGLjCBYEzgEvYOSLFn4tBGFnwFOJy/RgWqMTNaGZitTOX1INC0WOLdc0w70Oc
	 qMxMv3habGhWfICaVsKyA93S/N/P3ZWJrLtyRbyvL3sOq9cvjmVpTINFT9QtZYJ6GkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WP5zysBl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910BB606D83D;
	Thu,  5 Nov 2026 19:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WP5zysBl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3F21F000C1;
	Thu,  5 Nov 2026 19:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906960;
	bh=Qw513NKzixnVetQs2aPch799inLwFwvqjGlTZsHFgHc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WP5zysBlV6QoE+ebdO994NPOQCHtVK69BSl7GA0TkgCejzw4yv+Qi/dIb/BiTtwJI
	 CtwiPcppWeOxu8qxGDLb2NNs4muOnWOkbdTfgMZetnT6EYIraiEzVZgwrSfKYuy20p
	 lq1YQ+ODYgN/fNYKxtV+Y3MBG2phtgSlbN/PnX4DhhLfO11dC92+odtKZZNAdRC5BY
	 cOK2uw6yB5xGSlQ2pqLEJNTrF9NrssiHaYNsRIIVDX79TmltA0T6xLv6ahSmhYnicd
	 7xH40xuqXjCm2XXdHJHYyElfh7nUle5CnSYYX4imcJF/N71eKI1RK/06V3FFapNV/j
	 F1VfvpFqH1/NA==
Message-ID: <sashiko-outbox-199878@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 15/51] PCI/proc: don't truncate the position
 of config space accesses
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-15-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-15-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:18 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_bus_pci_write() truncates the file position to an int. A pwrite()
> at an offset like 0xfffff000 turns it negative, the check against the
> size of the config space passes and the count it clamps to ends up
> larger than what was written. The loop then reads past the end of the
> caller's buffer and writes all of it into config space at negative
> offsets, which pci_user_write_config_*() pass on to the config
> accessors unchecked. The write also returns more than it was asked to
> write.
>=20
> An offset above 4G that truncates to a small positive value writes to
> the start of config space instead. proc_bus_pci_read() keeps the
> position in an unsigned int, so a read at such an offset returns the
> start of config space instead of hitting EOF.
>=20
> Check the position against the size of the config space before
> narrowing it.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D15

