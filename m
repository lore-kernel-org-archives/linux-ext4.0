Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907325;
	b=5VAI1hcISwYQSn0xhd2GKmwAXu9xUBkziybgPXCo7a7VW4LK/K111R7BAjdL9Gtx9oea
	 5XoypDMp5i6paEDreWaWiw1uqaFGUhG280dyPP/BiqrjK9+CrAu4FugWajWBnZt+Plm56
	 MY+Fl0lkdyRFsFRAm6C1zyc2AGZdR9CIebK1GDWrzdWyvGea2YFuMpz7E3C20SOFT6TKO
	 yXZKsXDmSnisPCOMrm04Y+02PY/iwmTaps3KwOH5jJAlLKwklhK4n25bJe006s6g3FQp0
	 Rn4wcGf7vb4emECkAwowIpteTS/KlieeI+E0HU9iG+SC+e0Q+uoVgqhGN5aB3ZpmXlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907325;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KYpEmlst2RMAqFXyOGI9xQrnSxV142QmlHBMWmUsiz8=;
	b=XorDyrPkinKzoes+AFyv17APeLwCCGG+8jnzurMK9Wnt+z2CPRQ1i3rSZWq2dLV+CCz2
	 Q2b0OMRM9seqqX/Phvxj8gmYOMQEo8cVtw9ek4vxNfmuVoVvietm13CCDjt7+Qcr1Pt7K
	 YMXGall62Og5IBJf/uFnBWyMuxxKtLU92C9jLdJuF8BnyukrmTpmikEhdivRtbgX0tvV1
	 RqoMUTbRrc2TOlvDFvuHcDtaavev79A4jq4dReA5e0tnuZLGEIaf8F0dbWC8QzFNH+Qa3
	 MTLoPz6CCpaXjeWWueyTj2eDwdKHLWRxj9BY61+5MZS0jGLMyHsaZ+2gueDOCAH539A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D7HKWZpd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095796077B4F;
	Thu,  5 Nov 2026 19:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D7HKWZpd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1833B1F0089E;
	Thu,  5 Nov 2026 19:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907324;
	bh=KYpEmlst2RMAqFXyOGI9xQrnSxV142QmlHBMWmUsiz8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D7HKWZpdJlBXoSwsMjTjzNPkVew6KHrh4fawwQ2ulEULxhqG9XivG3Fp1ISuAwQMs
	 Hbq/80xvcy5mK2zclNAv5UeDsWP9xoAeq/jUyUIkH4aln+AG0f8NlrzzD8Lp/NDA2z
	 asdv9M90m9ShsSX4Ou/gTVHerHVAH3lLWi5CocYCqRvM/6bWUqB04QX6LVAK7e1GKK
	 UzVX0OSOF7WsaBpjey4MAjogWboVvhDsYVxoh9AXfTdllPpwKgRpIWe53zpJYPr6YQ
	 eHh6pR2ZAvzxF2Dj6TA9K/8Ca7BrjKlLNX6M0uWnkQFqgU9vYgoQJLLUshku7SS+Fn
	 EUH1IEGMOTXBA==
Message-ID: <sashiko-outbox-199935@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 05/23] proc: keep the open files of an entry
 in an open node
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
In-Reply-To: <20261104-work-procfs-core-v2-5-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-5-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:22 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> procfs remembers the open files of an entry that has a ->proc_release(),
> so that it can call the release hook when the entry is removed while
> files are still open. The list head for that and the lock that protects
> it sit in every struct proc_dir_entry, for the few entries that need
> them, and the next patches want to keep more there, the vm_operations
> of an entry's mappings for a start.
>=20
> Move the list into a struct pde_open_node that only those entries get.
> It is allocated when the entry is registered, whether an entry needs
> one follows from its proc_ops, and freed with the entry. So ->open is
> constant for the life of an entry, nothing has to look it up or pin it,
> and the removal path stays what it is. kernfs allocates its
> kernfs_open_node on the first open instead, but there every attribute
> can be polled and so every one of them would need one. In procfs the
> entries that need the node are the exception. Permanent entries don't
> get one, they are never removed, so their release hook only ever runs
> when a file is closed.
>=20
> The spinlock stays in the entry and now protects what hangs off ->open.
> Moving it behind the gid fills a hole, so struct proc_dir_entry shrinks
> from 160 to 144 bytes on x86_64 here, and it ends up at 160 bytes at
> the end of this series instead of the 184 it would have grown to with
> the read and write limits and the vm_operations of its mappings in it.
> That keeps 32 bytes of inline name instead of 8. 34 of the 68 /proc/net
> names a network namespace gets are longer than 7 characters.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D5

