Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907329;
	b=IgUPyo5rJJalfO06OdtS5tY+Q5TiPV40m5oSIcojKRXayTFrxYXrDaJCWqbX8ykLB7EE
	 QveED9b+Uv5RXMybnjYehnqTPIiRFpZFnZU+uD7MEpAUsaWy5xtGCUSwqLzvngDlGaKAr
	 Nk41soYslYCOJABqlHrBwg/BGEmZ9n4UmjRm/Q71p5vHzEztxwSf5HYESfQMcPJws7wKS
	 gRFsyyypvykJuQxoKM15U70vLQh3+1qn76JwZsc7moZKpNWlV2QMDNmPU2ogeRwGXcmNN
	 HIUrXBp9Nf6F11v6GFwmkGOcY25sjxUIZqboScoTeGqBHCg63K/GKhU9DiywDLINyHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907329;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6+3rBZSpmL6AwycDiybym7wulbxgrmRFLRhclCECa3Y=;
	b=4rJD6v6T0gO5LDhE0X1B/u/37MADBakFL/cLDGXqq5/42kzPSm++uS+z1Q/okjXQBwT2
	 bv9Ocvq2zd4y8cL3EgOSjxd8zWr65EVeOq9ebsQPM6J/Cc752uy9EOnA3tj8tlRZ0M+dr
	 FfMcEQSPWGSw4IBQiLCvlYZn58oQxLZbaA+5C+nslx4qnwPESKZZZ4klVMek1S3wuTV01
	 OsOoBa6QMLbS5yofqNqQK3J5r0nn5S29g02TelwuUftdOjhFAleGzSS29dXUNgpCVBBzZ
	 JmR/EtQbt3D23QnXlTyJNDM/YfXqkwOz8CkRA9FVqubOqIzRmQN34779ZHmDw30Dy9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AOZbcgp7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CFA608363B;
	Thu,  5 Nov 2026 19:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AOZbcgp7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0871F0089E;
	Thu,  5 Nov 2026 19:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907329;
	bh=6+3rBZSpmL6AwycDiybym7wulbxgrmRFLRhclCECa3Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AOZbcgp7KiL117k9ZomLZgNAYCqNPQoGYDGu7VInBnlWN2ACci5GdQGHH77Td5fl0
	 PMqHuG9PSJ1eIcSmO4aE/jRhciTEEC+kaCXQzAkbjSAbEmqIqcFbZPKSNSF+Dz8T5g
	 YNFTdQpoP5CWmhjRyUKESuR+HN1YN/5/HAbEbhU6EhzWiOxUQMENP1CQBZlkoEyGB/
	 kvCg4HTLMHqDXXlApPNo3yFstryquziH9LGxCkx8CbvvTATNAM/9L15zEUZlS5NclP
	 lcEIpX6mHh0IBDkqZ7elF8XDMRhP8BOx6XbMw7DhMmLmu7mHjpMwm0/m66xJ9XieZX
	 C64c3NTX5BZ5A==
Message-ID: <sashiko-outbox-199937@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 07/23] proc: let procfs own the seq_file of
 seq_file entries
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
In-Reply-To: <20261104-work-procfs-core-v2-7-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-7-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> remove_proc_entry() waits until every call into the entry has returned.
> For a seq_file entry that's all of seq_read_iter(), including the copy
> to userspace. A page fault in that copy can be made to take as long as
> the reader wants, e.g. with userfaultfd or by punching holes into a
> memfd over and over. And callers of remove_proc_entry() like to hold
> locks while they wait. xt_hashlimit holds hashlimit_mutex, which all
> network namespaces share, and addrconf holds RTNL.
>=20
> But the entry's code only runs between ->start() and ->stop() and the
> copies to userspace happen outside of that. So let procfs own the
> seq_file the way kernfs does. An entry declares its seq_operations, or
> just a show function, and the size of its private state in struct
> proc_ops. procfs then opens the seq_file with seq_operations it builds
> for the entry when it is registered: the entry's own ->next() and
> ->show() with a ->start() and ->stop() of procfs around them that pin
> [ ... ]
>=20
> No users yet.
>=20
> Suggested-by: Jann Horn <jannh@google.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D7

