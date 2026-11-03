Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718074;
	b=D5SxxmBbz1k1kXDTyW2cKWKIlXJ+sXoY8eUxRdpIE7qjHgY7EtDJmoCJe9oX213rtVcj
	 f6NHy9I+ucCZnaumJs1bjSjEVHSznasH0LEkSO+MjQ4VXA/0XyVZa284SCMmjoezidErK
	 LHOt/MpLl0Vlfl8K/koaHi/iDXWE8zVOii5fgkHGI5h3q+1Pa+kmM1TfE8bWoDQJIA7q7
	 f6NgKZvzVj7PpXwvszjjrBviB/3EGwdb6uXSWAdAwLwrBqfmCWNazWA0N7Py3Rf66GIQZ
	 EF6J4bE9AkWRnl7DL2hiasdMBr6ociJs3kKBUbLM4Zvf/lcbAl9rmkm0zVFe4p6f31A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718074;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kvVp6/NtD4O06uidDq3MP9X+fjlnBdRcW45/WP+WAys=;
	b=nCwy2EvKSFgjvQjeQaFIlRr03xF3+j3zEFkSa6taYpu9OXq11kjT3R7AR1gbbsBGvUbK
	 gXL5wGsZeRt2UZ5UrCBntDvjyXKVcGa7M1bcEycRyrjIULk6QBGD6/GnErxLglh9y8L4+
	 v8DeZJazvhSrN40XyOpSrYidV7gbKZFOQgK53LLtynM0oGN1fUP9q59aGSbKxq59zCPRe
	 znQcDuJY+IIhROstHMzxEwO55z1E8sj7Gn19MJc/3LgiyiSHaZtv6Jh2PryIFwA3QTG4B
	 ZVvgCZOLhG1wtA20FRuH2SLlqGjxAYpcZVN4FHosAt+XNqjyfceuwnO/QLIDHYeHiqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AXfOxjF1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8644606F629;
	Tue,  3 Nov 2026 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AXfOxjF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815491F00A16;
	Tue,  3 Nov 2026 15:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718073;
	bh=kvVp6/NtD4O06uidDq3MP9X+fjlnBdRcW45/WP+WAys=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AXfOxjF1cFFOFEeIWx2xBBnAGj77mnIVsvzVgjKhzgr0aqmFy/7m8mW9lEar+8Gjk
	 v8RY/QaM2uCeWfqdy34Mf/rBHgTDRvW5o7+chp43A26AiLXBmD/XfUpAxR/m6HPuvT
	 zJCtoefjleVPx/b6O0g6IeF1TPgVhPsueLpekkb/UkQuFbzbZeP3FdjzqUM056msL7
	 PbV9VDBEK5qU8KSuh9oEBnMpWE49gjG3At0fGXJWRjk6w00B3xBXGEvETcL9ykXr5t
	 A9zIdU4PQivKxdRrE/HP047xrSqTkkvO9699obHnimL7KMB7BxtBBEkHCbOPtxypsN
	 iBvlOP9dg5drg==
Message-ID: <sashiko-outbox-195533@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 06/16] proc: let procfs own the seq_file of
 DEFINE_PROC_SHOW_ATTRIBUTE() files
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
In-Reply-To: <20261102-work-procfs-core-v1-6-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-6-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:11 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Declare the show function and let procfs open the seq_file.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D6

