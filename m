Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657836;
	b=HzShiknUkiQEU/sT5a7rTh3peSsHrdSlhQa1NiBmrTkljUW/VnbKXcLNuRbUv3OnWDAg
	 yrSoNze59GbvpNpWDeiNdTRo0+d08N9xjGtgfB+BWECP5FbS8VhLwR7z/eQ1m1kFbjpBc
	 Z3ntddVQEhZHSnDWZJiRZPj+SK01XaViLJQ5SLbg8h/SsB4SGjUlI0Nuqz3agVZ2v5d7o
	 bakDdcw7NnoB4EKaPEKIy6jnGWsD+gW5JGAbB3+1rGn+KzcI4R2eMjXrwdxRlXU53A3nJ
	 dXrK9R0CQj9/bV+BfqZmXX5PEyPBQXpp2S2Zi69kmu5UvJk2Sdpj7Y+MiSDOG+NkSMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657836;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eHiuu3LHuD9AsChF9iMY77TYpvurFO7Knh+fJcAxx9I=;
	b=zxjLcCK4LXg6fc03D2+NQ+j8nXbtha82VXT/77WQTnVBkGJAMWrJLTqQz8b5fkeGtTr7
	 ej/YGvMAy4yrFw6pWKpib5eWWjey60mloNYBbPSbsJpGGDlSi3DU20eSOlLSw/XdtIegD
	 useZJEiq1yZFiPK+RChkPdELdWPi7CzxE4afqDV4ZhDpL4H4z3YJq+xjP+SMJ2SFayD51
	 MBHM3fCq1gGhG+46y9h5mp62ChIfwQcfp7UzusrBq35P8+pF76Emkzbug/Ab0fPaWNwVF
	 Txg98aVWa2XHVgKpjikS/s80F0LE41nBrWtpO29QiP/H9wlCEeCquYAZCxaFud3O6+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HsUb+hXK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41732606A886
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HsUb+hXK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C8A1F000C7;
	Sat, 14 Nov 2026 12:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657835;
	bh=eHiuu3LHuD9AsChF9iMY77TYpvurFO7Knh+fJcAxx9I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HsUb+hXKiu1fclaCBgRVkDPX71Df+gbyG58hy90P6+SNwfaepuqpqOW7AngL+HWye
	 PToqH52pT8PB/9hjacd3sgime4iv6zubTIPWTVukAPxHII20hNYjRkkXHqH4vFzxLy
	 a5URVQDKSa0QYQhIMIZK1YOInxZ7fb+SohZ6reEPf35OsJlPYFfiQak4QkAmHR+1Ll
	 I50woYkvqQCLF4lxJ/aF+WxiiD3tpLR6z2GZwQBhJ62WJ2Qi5jBUta1cvZDyFk1u4J
	 Q7n4Uk8jqd1jgflgY7a6hkPxXM071qKmHZsmX/m+gTzEjjBJxDVNcEV/XvHx3DaGh3
	 oGU/aWXY70EEQ==
Message-ID: <sashiko-outbox-214484@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 33/33] xfs: allow remounting read-only after a
 shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-33-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-33-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:55 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> xfs_remount_ro() starts with sync_filesystem() which fails with EIO
> after a shutdown. So a shut down xfs can't be remounted read-only and
> emergency remount (sysrq u) WARNs in reconfigure_super(), a panic with
> panic_on_warn:
>=20
>   forced remount of a xfs fs returned -5
>=20
> Going read-only doesn't need to write anything. So ignore the errors
> from flushing and from freeing the COW and post-EOF blocks once xfs is
> shut down, also if the flush shut it down itself. The rest of
> xfs_remount_ro() copes with a shutdown like unmount does. And refuse
> going back to read-write with EIO, xfs_remount_rw() didn't check for a
> shutdown at all.
>=20
> Fixes: b97cca3ba909 ("xfs: only bother with sync_filesystem during readon=
ly remount")
> Cc: stable@vger.kernel.org
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D33

