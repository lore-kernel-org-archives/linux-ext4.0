Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907033;
	b=SLzSrfrelbArrch2r5R46yKsUKS1grN4HbDsNPKqehPgdHeqquviCxscOKlF2IfX17Wt
	 PilbEt8GYXawJd46dRTx7wIttvlkPatE0LLYpirTyoxq5QHL+4I80KnRU02p/p6W0yTOv
	 /U9jpScoRUVVNHopD2dzd4njE5vNse0TZA1gquYBe34JIkBNDL+TigVZsKUbPn93SZ40D
	 +dfZSH/7wb+XDO3LveJrdiZkIm+9JAfKbLtjkizrY1gvE1Kql4s72B0YV7/D+ScgiYRQr
	 Muh2eyZOImOBhsaSzzOQagE/XSjpNpGoZrl/DICxlxydQ1RgSrMtuK0478p/cK4PKXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907033;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GA0+/owkDdniY30l313rN8euuBjyhEchmg5u4LglfRs=;
	b=haT0/IgouyeLGanopHzx/H2TPQ7aPPB/JVu3xbJ6ypWtUx/cWeHbNhGYJjdtLy2WScRS
	 BChJIY1/sfk1uSZ6GDfNcsACQhwdgNtVTp+KZJQAjscwu4AKVXLFFKx080LqHYYT3Lzib
	 zaae7AAaTlmC+5AMYSjDEUUfgxAzUScAD+s7sazkfnUYM43RUS3iEm1qawDQ00va+PpuO
	 tlNigNl0tt9ky67Sgxau5znI+oUT7+9qt9Fzo+plFMUGW6fYmccVj1500OIlZ5Ut8Gm6l
	 DDxNk9kGbBudMzLABc/aH/Mk9C6lAy73/8g/pWlq35NmhPEMcZeGTN4T+dS4TLabojA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ckZU7d4Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B654606C8A4;
	Thu,  5 Nov 2026 19:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ckZU7d4Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472581F000C1;
	Thu,  5 Nov 2026 19:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907032;
	bh=GA0+/owkDdniY30l313rN8euuBjyhEchmg5u4LglfRs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ckZU7d4QUH1rI3q+4mXcCPdzjI6S3s0l6AJ0++PpkI/VthC4KY9jc1TUbXEy7w09a
	 QS42jHvzTWmhpuR4sNrCVakO0luPXYf1Pep1PJq3hRlnM+G5j7LV9MiNuMbPYmYvh8
	 szoCOMpIPlXI4pmYgqd4WZv3emt2hKmkx/g4Acbw06/hy66OKKSy4eyXseR+7sXoS4
	 h0IZpdjtLDWYruhg3kAkHHame5PmfbBbyj3BLPwhrZvYj7hO9dMH7e37xj2nGdqfxY
	 8c7pfm36HFDGPa1muEyl/868i4Nqv0yBIOEge1rhlL08kefXVk1eQWlAc5aoAoUcje
	 mrqw0O6Z+CNMQ==
Message-ID: <sashiko-outbox-199913@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 50/51] proc: don't pin a symlink's entry while
 readlink() copies it out
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-50-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-50-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_get_link() pins the entry with use_pde() and the delayed call
> unpins it. vfs_readlink() copies the link to userspace in between. So a
> page fault in that copy holds up remove_proc_entry() just like the
> copies of reads and writes do, and the callers hold locks while they
> wait. /proc/asound/<id> is removed with snd_card_mutex and info_mutex
> held when a card changes its id.
>=20
> The pin doesn't keep anything alive. proc_symlink() copies the target
> and pde_free() frees it with the entry, and the inode holds a reference
> to the entry. What the pin does is keep a removed symlink from being
> followed. So check ->in_use instead and drop the delayed call. That
> also takes an atomic pair off every traversal of /proc/net and
> /proc/mounts.
>=20
> Fixes: 7e0e953bb0cf ("procfs: fix race between symlink removals and trave=
rsals")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D50

