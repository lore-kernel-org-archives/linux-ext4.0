Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908690;
	b=ItB3KUwITY0j9GIm/RJiiG1EAfCW4ayyErDlLNBuXd1Pa2hQeq+zpAEmmjRQEXQdGQBC
	 dhZJDQ1mBO6BuRlb+UHMKnLbLrypvVaG7yveBbBc/ZVZOnwjX2bmfrGpSOFC0PVxRqfub
	 5oZOOxyjXk0Z5vsyvCxRRB1Rlm1BdhfOsKeGtTrOPJD346KNfflJ+M+SPq8zQ9fwT0kEm
	 CqUNitCyRLrVov1vrzAdgJrxGYFRLo78wj0OXRtnca4oPoG/aEKUDSLYvMmBoQrV9o1o2
	 ka4ulNrISUMi/Zn+guvaYgoNY2OO9i2uYvVApINzBgCUVulbJZlqk2oLgM32VcNj7bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908690;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qyGxYG8j9RHg2vyof7KTGe46hg815xlN1LVcZ72aA7U=;
	b=GU+/C2kdK/7hAkEfJ94Bb9mAVC8Jez8BF0ffTlwOiakL0PDvCyiH1nApsV8OR2EFkUyz
	 bjFa/NJOZHzsGBdRzRIpJ9+dbOlw6E7M3gR4h/hAKQtgZdQxIVC3YFbrU8FSugfYZAGxT
	 Ocgofe1lndPzOQRJ9+249X1KBxUp6EDyRODbLNycWra6juDLWkFWiGDyBxOsBFtJELK5s
	 AolKXefItYwBTo/JoUnQ8dPuJqi/sytzdcmPYxuXhwhJaUWiTic2t2yXRVbjZG07TrhxK
	 FIohBzfeJuCgqcAKYb26/OlUlXn21FfDFdPN4OPcIJkd9uPNgDWFhdXaygoQoJswzpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bTpjODs1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B2C606D815;
	Thu,  5 Nov 2026 19:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bTpjODs1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5791F0089F;
	Thu,  5 Nov 2026 19:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908689;
	bh=qyGxYG8j9RHg2vyof7KTGe46hg815xlN1LVcZ72aA7U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bTpjODs1yFu6YRN5fmCYLdyRvgUUVxxbu846Aeqw4iGqXmWrXiCiCnYZPXasoab4i
	 WJUixvU6EfxiEGSTH8p5m6geOsF2FwabLkl8QCKrLRihS90PkxPQvXsImqBoq6fFpI
	 zXPjdUBvvvwz66/+OxS1xiVA7RcTezVhvc4GfvsAwAc8LsSQy1bEWSsOcEBB4lRmfo
	 ocuNeivszTUjoQ2nmvR7p2FOnQgUPyilwusfSiwQhItw9JJ51vQ6W5SqV4sXQcDH2n
	 B5Og2Tn/U2epxnQVrz5GgRaNh5DnwOIPoDojQJuxrNePqy32coheNJG3FyfeA33AJQ
	 zsiW5uI6//0Dw==
Message-ID: <sashiko-outbox-200053@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 19/30] sched/psi: mark the pressure files
 permanent
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
In-Reply-To: <20261104-work-procfs-fs-v2-19-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-19-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> /proc/pressure/* are created when psi initializes and never removed.
> Say so with PROC_ENTRY_PERMANENT, procfs then calls into them without
> pinning them, like it does for /proc/profile.
>=20
> That also takes care of a rule the files bent. psi_write() takes the
> seq_file's lock to serialize the triggers. A reader holds that lock
> while it copies to userspace, and now that procfs owns the seq_file it
> does that with the entry unpinned. So nothing that runs with the entry
> pinned may wait for that lock, and psi_write() ran pinned. Nothing ever
> waited for it since the files are never removed, but with the files
> permanent nothing runs pinned at all.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D19

