Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793908680;
	b=mJcNew1sNqo8boWkei+o4YW8jJU7GmgBMH3rMZShO1b4RkbwZbEFklcZACzRNWKZhNbc
	 sPJ0Ikoc5k7o4ufEA1yttuxmhC6FTfi+y8KviIrx9Be0D2UHMKpm9EX0xykVsTq7EJyQX
	 lsoPvD+ohVbo3qaDqqTm2H/cjTrtvqHQ9k4/gA2o4o+HY4dcdKLJ2aePSUuuUk5YWn4Bq
	 ypSjPyfqSKDmGB+a5OkJZsCh/wSR4yOLaidAtFJ3AqXEG+W2XQIl+40vHUwv8rZz+1qqS
	 e3iSEkQDmSIkcf2ujpUMPlYihzeukEZWztf3PRNR1Qg35qkJAINPr+PTEunzoxNiHXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793908680;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gSLc/NFQPVB0jheaKA5TG3vFdDVh7lUm2wF5CPMLjBE=;
	b=CMvPL0qiWKFGIrByFW2V15IK1bgoXPh1EnmvmyFX9pFsOFk4ebdLiSC9Ao51gSEZj6eM
	 elQtq0M1E9tWbbJttSjjl/TLvmdEATb9YraPz+sMAswCLzmp90jPGlYibg8KRVCoYIMNp
	 aCNieHdsc+Clnn6k4MsvFO8TsTmfhPflPrNDLwaxvkaWteTM4WRjJa1v8GbDNqg88TMqZ
	 dC4MgkltPAD6vBFVeqt0vQj7wv+xp9Ifgx9plt0QnUSHV00lQf1lhoWoQQcSBk23ZxPey
	 iGwq32TzEhqPm7tZZ6U0JGCW+F0NtS3vxbS/PuudcRuXdgqXbAIcAqLSa23D7zUid2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z6BhYpOi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7528606D521;
	Thu,  5 Nov 2026 19:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z6BhYpOi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0EC1F008A2;
	Thu,  5 Nov 2026 19:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908679;
	bh=gSLc/NFQPVB0jheaKA5TG3vFdDVh7lUm2wF5CPMLjBE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z6BhYpOihLUJ9I+BP48G0ZYNFSOmcO+AiYj1AAUb8k2LZd2aIQW/Swc7nv4VCWJfU
	 DHtDKlv9N2qiG9qzTkTwwCGFIPw9k93r1XJF3AEFu5fiy0J0WZMBVfvlSMpYGeYdhw
	 yryw8xnqryz2kJag/16i+WPnykBtp5uQM3G6UgfxYyijk+piqbU5EzXTtFkwS4uuX/
	 wc6k8A9uOeN/qdMXjzHeoAqeBHqGjjz921QAkO+pzMyUFXL0yIl4mvV2eIfMpCgJj8
	 218TNw4Q4fOoKCdM5IjaNdVPdMjBKOOWdhv5uws8exAyge4Ilrrm1ePkGt0v9MVEra
	 +vemf0Bh6IyOA==
Message-ID: <sashiko-outbox-200049@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 15/30] profiling: let procfs copy out reads of
 /proc/profile
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
In-Reply-To: <20261104-work-procfs-fs-v2-15-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-15-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:57:57 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Fill the buffer procfs hands to ->proc_read_buf() instead of reading
> straight into userspace. readprofile reads the whole file in one go, so
> ask for PROC_ENTRY_FULL_READS and procfs fills such a read in pieces.
> The file is read through ->read_iter() now, so sendfile() and splice()
> work on it like on the other converted entries.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D15

