Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907340;
	b=F0Q5SiGRCjnWQKcqULvfuOxu5jRVrx+HmlW+Dn7ih+WkaZjdBKqyVCMbRa9HU3Fw10UN
	 dbMYn7REr0Rkrk4c/Zuxi9c2EiRo6J9IcOfmtR5YzEhS9xrOyzGnMYMyc4yUuyBfpmRCK
	 usFV+Sf6RpxpGdG02BVJ4xydPm5+znCDKt4C9q6HqDAyJ8PpNhXbCqbHqWdG1sbHe9aUk
	 7k6XDltE40Wcwr9PsY1nXpSOnAniQOkACBPu8UqurdhcjJd7P+9UpQ6Fdl3bJ+9lSEmRS
	 d6N9F+V/xa3W5Th7JFHnsbVhlPvR91YXl6hZq1Y1qyinELZfu6QgCkfEn7Kvvx7tX/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907340;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aroUg095/6TmMJBeZjgIoSTvyvzHjk9A05ABR3Cu2L0=;
	b=UJYN7LLnLwJZvLfW/KYxV8PRtPgy7vB78zPIA8kAzjGoozJC6YSSQ73TWM3agbMdM19g
	 e1CaPgF8v9n7SGfHa1YdlmM0lm/5e2EW2QJ61Hl/ktSINmETn7gpyU52zm6/hWGzH+F5b
	 aP57Qaa/i5DUjZGAQCvyAwTACig2uHGf9IUBJiHRCi5JJntJivJXluXKnQIz0CXDp1bxM
	 9Ba3YMTrvRIrSoPECothAgRo3EzYnaSSIO1RBHwyTt0LY6N4cWOOhBi5XW6mTSVJmzV4Z
	 TehkJ34VPKt1VtrrnbT8gaxZ4aZ66TA9FfwYRhKDeE69zRPkGUJIu1JrqHHq6E15syA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="aCFaxZX/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92BB606F954;
	Thu,  5 Nov 2026 19:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aCFaxZX/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18721F0089F;
	Thu,  5 Nov 2026 19:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907339;
	bh=aroUg095/6TmMJBeZjgIoSTvyvzHjk9A05ABR3Cu2L0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aCFaxZX/pXJMPefHJpV09W2+w61KUBSGqPrg6CbRySAMTOMm4JaDr3tcTx2cKIuLk
	 JUa1MBKLWQC0ZETuEO66QAJpJgqhbjOyxojVM6ivSCYHHkGowBxttDYjM2eIGpwnEJ
	 APEOw5JcwA0jVhqdTOcM8vG9gm6Rdg56kD7z39j9iMGTnOcL8jgcdJyaHFK4JxakLN
	 DPKfZb5NAMv6q/AFJDp3292ogJxaCXKsP0BD31LNcI437rpmGwZLQz5zNGjx6DHRiH
	 nhsuxsTVQ4aM+It/sbt2s0keUKgj1g/u2y0gxfWVs6QUw26QAPF72OyrzpNfLCn3PY
	 1jEvLMm8/QQ/A==
Message-ID: <sashiko-outbox-199942@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 12/23] seq_file: add seq_preallocate()
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
In-Reply-To: <20261104-work-procfs-core-v2-12-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-12-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:37 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> single_open_size() allocates the buffer itself because it does the
> single_open() too. A file whose seq_file is opened by somebody else,
> like procfs does now, needs to do that after the fact. Add
> seq_preallocate() for that and use it in single_open_size().
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D12

