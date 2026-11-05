Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894312;
	b=09NcGbOIuicvZuEudk8F38vq84/5jDQqFxV+6nSGDV/l61cZBEpAIGQSWRAZF1JInTRE
	 QhPLnqAbVYay6jFVWn3lBfBf482XHb26H5Iai3rARY68rLKwow9FmzBEI2g0PgFAYyQ45
	 fhKImWPT2dCjoYC8Hg7BCxE9umSE4QU7PMcEhfuCbnIvJd16t6iy3uGg80pM2pK2Bng6U
	 xpFTGMndKYQSlKls4R5E05+D1tCw7rqCneAdgD32cBH9fILHz2ZJ2l4PiKGmyDNQojnkv
	 6JKaU+vm10L7u/OANpMX90Ng4Rf/NGEyEuFgC6kP5yjhqzs1ebqJhCT1726Z5oVsokg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894312;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=i+lq90zCibYqB9fmuWdxuSZ+QlYYjTfSKMhMvi5hyFk=;
	b=Laejq8rsYS+oxKXcJLix6zN/toApPbTxgu325Q+12CP1hFCoTkXb3lBlF02b9rJSu7rX
	 hoJiJUQfO9U2R4+dUitlCxroW3+PCz542CL6QpGGSjTQ0+1kDciQH4VNEOg/TDInKEWoB
	 KCRx6KetmSY1MPDVXJxPoSyy1GDej6GN3S7PawUTSY46sEyiZcOLWIKss6JOus29MkuU+
	 fmPnXgPq58QLLUmQmSvw90HfOLmJQOyszOUlgVsp3/IhDuxSQvmmqImh9vQUZH6zMxdAD
	 WeHmOvTkz66FwqL35K3UI8H7wB7ECKsCGBS9Z6zAYS/unI90nn4ZOKJeBthPMLtCYWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=knNThq29;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9691B606A32E
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 15:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=knNThq29
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB3E1F00919;
	Thu,  5 Nov 2026 15:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894312;
	bh=i+lq90zCibYqB9fmuWdxuSZ+QlYYjTfSKMhMvi5hyFk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=knNThq29r5PCKXosWlGJiA4wMexk6O5QNOo4p7HZkmcfQkMnMUVYYWu09+mXP5Bmy
	 8vB4MBeKB4RzJbnI2iWns7taA3MXmDbdj0kN2/iB3YTJ5vrhJVnk0Zp27vzTKZSgdK
	 q9nV317YmoYmoUgKTQ2ifN5YPGQAbFLzvYt9tIHyuGP4XM4lm4B02QT4orPkL2EK/n
	 +Nq+rtA2SRD1IxPHv0acC/tR5DsZOxIX5l9WDax+GoBjt/cHL71+EzKPmB5oFXesv5
	 gWf59cpYMKvJtPh256kuTreeKxa8UPGoZaUHQLAFuC0+RCEtcOXMCmODund208RVYu
	 OAHvtSoa5XL4g==
Message-ID: <sashiko-outbox-199389@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] jbd2: document the h_invalid handle flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Amit Patole" <amit.patole@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-kdoc-jbd2-h_invalid-v1-1-4bc224f7d0a2@gmail.com>
References: <20261105-kdoc-jbd2-h_invalid-v1-1-4bc224f7d0a2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 15:58:31 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Commit 61e2a90a910c ("ext4: enable scoped NOFS when starting a handle
> in nojournal mode") added the h_invalid bit to struct
> jbd2_journal_handle but did not add it to the kernel-doc comment above
> the structure, so kernel-doc now warns:
>=20
>   include/linux/jbd2.h:523 struct member 'h_invalid' not described in
>   'jbd2_journal_handle'
>=20
> Describe the new flag. It is set by ext4_get_nojournal() on a handle
> that is not attached to any journal and is tested by
> ext4_handle_valid().
>=20
> The warning was found by running scripts/kernel-doc over the headers
> pulled into the htmldocs build. An AI coding assistant (Claude Opus
> 5.5) was used to locate the warning and draft this change; it was
> verified with scripts/kernel-doc (no warnings left) and checkpatch.
>=20
> Fixes: 61e2a90a910c ("ext4: enable scoped NOFS when starting a handle in =
nojournal mode")
> Signed-off-by: Amit Patole <amit.patole@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-kdoc-jbd2-=
h_invalid-v1-1-4bc224f7d0a2@gmail.com?part=3D1

