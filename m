Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657807;
	b=OEUiPxkylME6fLjPE8l1gJEpy+EYh1XcpnCCeRvpl6JJKa07jRqL2NChuUTBJk1UQIBp
	 K06RV+0bLm5ndZSmcBdmjAF/ivvDglBpbSjsS/EUovh6oWF/2Kreezlv5gA73Obi/qn0D
	 BG5T7eiV2MWqi8/slzZc5/rdrxjIsurBxzzRuuoGW0yqarsWMG4eXhVxhaBlnZ09pf5/M
	 IQbRs0ptaHg4wrWwzEJGbmGfi74R18h4dHr3ET56fgvg+bkecMyCHjG2Hlg0dKg4gZX9h
	 trIYx8PZ+CkwpEGR5RfUQGEJEtnet4vcqCScAHjunxjrf/8rAElcn5i7dk6Tn9IoOJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657807;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sTW3p5KHQUtvgDikYXorGXOlOo4iIrNmJx+TUHuaRno=;
	b=m5TtAVgQpTlIn/mn3PGtwVh98PNh9mjfW2RQlD7ojJb0xhlmZtD8/n8Cm4h4tPLUWIwH
	 j1A19i9D/Zh26CPCxNFTSnjHWGxF7FA6Q3e6Z2f4wV/qg1zmN9hkP3qfJaCvAJfpR/c6r
	 t8L46UL94gs5QMycjgaC0kgpnTCwSEp6B1Qd06dE1kxvxIGeQgyf/Zkm9UHzcCjJI4EGI
	 5Iuaa4Ig1RW1AyUo9e2esG08OEBh/d80BJRR0CLMmASG/MZsE9/55uOvfeHNT8G7uputD
	 HT/AezLxXSaQiL64FflegV/MGO1cV5AKhzQs0dxnus1JLfsmoZE3FyGrqu3nnl7HtYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mKZcckAj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A44606A332
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mKZcckAj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16561F000C5;
	Sat, 14 Nov 2026 12:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657807;
	bh=sTW3p5KHQUtvgDikYXorGXOlOo4iIrNmJx+TUHuaRno=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mKZcckAjynfCv5mHP3jT+c5UvZHwBbzY5o81DWkSa5k+MTQYQrsZNQfgdvDvAFc3Y
	 +rHrcnKnbSULofWDr4V4uXLEFHZwRmRdXHxUMhVaZX8u9D/NRa01knc3TUDRnd2sbs
	 /nvgS9ecXT6/mT24UlmtsCLXMWX4g467JW9NBjAlcmUwnj5+IyCHx50leNCFcMJ7w/
	 O51bTRiwCBsdS0JIFOfL1E+nEJ4zDOJziHSgWfOgKiFowDEmwGEK61Cov/ViRqofY/
	 WPSEnMCxNP2rR0/jU3969ZRzX2pmljWu7pDZxvtfJJVZF0l5zL8DrlcWTi6JmB3sYi
	 e/geTt6Aa8Ujg==
Message-ID: <sashiko-outbox-214458@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/33] jfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-7-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-7-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:26 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> With errors=3Dremount-ro, the jfs default, jfs_handle_error() sets
> SB_RDONLY from whatever context hit the error and without holding
> s_umount. If that happens while the filesystem is frozen thaw_super()
> skips jfs_unfreeze() and leaves the s_writers rwsems locked. Writers
> hang and umount shuts the log down a second time and crashes.
>=20
> So call sb_set_emergency_ro() instead and let the VFS refuse
> modifications. jfs_unfreeze() used sb_rdonly() to tell whether
> jfs_freeze() shut the log down. Track that in JFS_FLAGS_LOG_SHUTDOWN
> instead so thaw undoes exactly what freeze did.
>=20
> jfs refuses inode and block allocation and the xattr and ACL setters
> itself, before txBegin() because failing txCommit() with tlocks held
> trips an assert. Allocations writeback hasn't committed yet when the
> error hits leave anonymous tlocks behind. So jfs_dirty_inode() still
> [ ... ]
> before the error fail with EROFS.
>=20
> Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
> Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.=
com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D7

