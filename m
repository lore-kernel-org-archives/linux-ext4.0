Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907336;
	b=vP4MMEGO//3K9RvvsxTN1/E+e+E/dacmk4GiIVFokyOqVaN0E55uPe4pWQHJeBqnMKmE
	 v9WeTha/P8FrpqfdSjffVieNWlGpKA0s6O46IrrQdjzzrcidCzJYrHSS1pePTq2KG/xGZ
	 cAlN/EKtB54o1eZznrzxicK8YegTKMm7OlO65GGnoPEtffUkF/m6EHehQM34gGiWjrQuf
	 nqHXmXI+eTe17QmFVf8eJHkAxG/x5Az4SASM2Jh+XCKv3slajFLPb90m+xLsnn2kTFi8L
	 ewt9Jiamxz+dbcPBpJfsrz+xtA9jMUdbekjgZMD7MufkCajaudvFOS1q8uSXR9E30nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907336;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0VkIWc5YSc/16gdJRgE/wqoAJl9T13wcKhPi3jcBrXM=;
	b=v+Cc1dWAnpcyDZiBP5Th8hs7mtwCvA06pjGZPUDyhq33CckNIEl9mB9+4F3Yqt1zEvre
	 5gV9qqTSYpsQYCxrYYVQijw93noNwBZfGxU3pCFfDEdOXzpjdG0r/MGx/snFxthIy5NGa
	 xCEk0qy+ede/zg7t/oYPoFuCDGrbqUjL6oIjhA85ZJd31aKMsIquAFv+00iSwarH2cEbh
	 tuG8YMIjsjNHXKnBjHMv6uGgRG4FcBzIQamYUKftWcAyQCdAoIkAaQcu5iIRDhbC2Mkwi
	 CuprDPII5sNtu3wTjWEIlJGRH9IM0juf6Mi0mHXTgTmgt1/O7MMm6NSexS7NeQtaKUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VjEspZgf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD85D606F58F;
	Thu,  5 Nov 2026 19:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VjEspZgf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7D11F0089F;
	Thu,  5 Nov 2026 19:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907335;
	bh=0VkIWc5YSc/16gdJRgE/wqoAJl9T13wcKhPi3jcBrXM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VjEspZgfU4eKMMqB9SFUwQFEgUfUeQ3jH47yjDKy5gKa7goiyoJQ4KT8Y2OW2Q6Fo
	 mckOShFnLCJdeNQacVL6/e5c2btxxwP60dtFMmJAny23WinyxuDv5WFOKuzca8YlCQ
	 xzyBWeGx8IJaQkaPgAQE+RKnp+6kHhwEfZpVXM5C6TT+Ta5WsubtJx54pnUCmFrgla
	 eg2pdZdFCcg25/PzMiAbXTRg0r2sq+jiwdQS4sjA/pzkJdwe8zIBApF1P5gdFPsNNH
	 UyLN7ZOuCVpFseTkBlTREiuiM4hczJrJzVN3nzniGFHhGRG1pHdgc1vuaUpxQb9mEw
	 Er2tcFs0RlX4A==
Message-ID: <sashiko-outbox-199940@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 10/23] treewide: let procfs own the seq_file
 of simple proc entries
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
In-Reply-To: <20261104-work-procfs-core-v2-10-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-10-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:33 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Most proc entries that bring their own struct proc_ops only call
> single_open(), seq_open() or seq_open_private() in ->proc_open() and
> free the seq_file with the matching helper. Declare the show function
> or the seq_operations instead and let procfs open and free the
> seq_file. Reading these files then no longer holds up their removal.
>=20
> Done with the following semantic patch. The new initializers were
> aligned like their neighbours afterwards:
>=20
>   // SPDX-License-Identifier: GPL-2.0-only
>   /// Let procfs open the seq_file of proc entries whose ->proc_open() on=
ly
>   /// calls single_open(), seq_open() or seq_open_private().
>   //
>   // Confidence: High
>   // Options: --no-includes --include-headers
> [ ... ]
>   identifier open_fn =3D {single.open_fn, seq.open_fn, priv.open_fn};
>   @@
>   - static int open_fn(...) { ... }
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D10

