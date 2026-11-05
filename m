Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E9060A5BD2;
	Thu,  5 Nov 2026 19:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=biBcQDj6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDCB1F00A1B;
	Thu,  5 Nov 2026 19:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907000;
	bh=b0D2++zCZfvjhjRkeCHIgJAL0z7V717Ngy6s2m74N7A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=biBcQDj6b5nEnEvvkhlM1t3pYvLEhlUmJZntrNj8PmC+/8S7e2GAV4U2nJtkIt6lm
	 w2reHjBlHUvRO7ufKHLU/cu9NIcrdZS/QNsjkkcCIQtudOdeNiZ4gnIuiWj1EUhsA0
	 wLwuee7OSv/L9MLY5Dk1FPdohxJpgBQjXWFtlVWYc/tV5I02GkwXABkE4xEQP+YsBd
	 SN1S/9tIP3nfP49YMFvAflaO2LH8vRaKR1oZ0flajKfd6e0qH53GoNxOVYF79PgSIk
	 +HT6s1etrrUyTiCOLvoDd6TEvKEM8PctNC/h2qlEO/MtHh12Lz0HvVTGM1t9FKNGsl
	 udtTbvU8PQXXg==
Message-ID: <sashiko-outbox-199898@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 35/51] proc: warn about entries left in
 /proc/net of a dying namespace
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-35-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-35-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:58 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> proc_net_ns_exit() runs after all the other pernet exits and frees
> net->proc_net right after removing "stat" from it. An entry that some
> pernet exit forgot to remove is left with a freed ->parent, and so
> PDE_NET() hands seq_open_net() and single_open_net() a freed struct net
> when the entry is opened through a file descriptor that someone kept.
>=20
> There is no such entry in the tree that we know of, but nothing would
> tell us about one either. So warn about it like remove_proc_entry()
> does for a directory that isn't empty.
>=20
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: e9720acd728a ("[NET]: Make /proc/net a symlink on /proc/self/net (=
v3)")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D35

