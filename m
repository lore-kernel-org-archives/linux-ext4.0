Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2EF3ACEE3
	for <linux-ext4@vger.kernel.org>; Tue,  6 Oct 2026 07:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791270593; cv=none; b=Q/edOAmgbOVRlkb6hvK6PU/xLdd6wxKnJunIIMLC2W3m2vquFuKQewDJ/i2ZwV570lVvAOhS7iU5fYB6P6YCXvaHRG1DqsDmDgyVw/TmTIQuqUF5du609mUI4Yb26t8xMBq3gM+wuONkmRCkZRw29wMnPgNHIKO8TP7tzxNFocQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791270593; c=relaxed/simple;
	bh=TGivTWQfiCj1FXacVYUlz04qoYhDtjR8dyYyZ1p3Uwo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N8XlKnmw1UOsGLk3pHVDvIxVzIl9IplFRArkN2CcC/M1xI4BInddCsnOlCgGBQ5nsnJM5aOIqRBOM+KAdYkESc0onfbv3DX293w165QxH3aqViP7qUt9rC/j07zB6uz0/omP3aiGEDVH5X6JSIEX+rlKxeACz+spbDawSyxZx2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xork+slG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xork+slG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9566C1F000FF;
	Tue,  6 Oct 2026 07:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791270591;
	bh=cvtFHvQEAgrnvk+8Q4lc6lMiaTUOCV0H8lJDlVjLkiM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xork+slGYljJQwvlDfEPTeKmQSFxqDZhZWubUam/6nDBKCPxmTekeXKMSGgqbdo/q
	 1oLaCtJQezcW1lfzt5Etl6egPKumVEtTy7KLwIaXNvtUZDMJKX4SsxTpTnpbo4iIbq
	 zo60l01cjiZmILfQiBOBUSqMmQHcy6J68CcCjWZEr2eIcFfv7mhsrREtCeMZDIwqGz
	 +hEO4ggUJ9Rra+qCfueEe5TNYDfEiohAjMEYz0fi0geWSWS7+SkW/0ovdh8WZt5n9o
	 z6wDSMCkd93EdiC5l2D2XhLMnMEVYvlt+rwH8jO5xV7IRXkRaDJdO6lwIH1lzEwOJk
	 tW0UdJgzrPo9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: don't fail journal recovery on an incomplete fast
 commit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hsiu-Hsien Lee" <swinds24@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261006070005.1209234-1-swinds24@gmail.com>
References: <20261006070005.1209234-1-swinds24@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 07:09:51 +0000
Message-Id: <20261006070951.9566C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> If the system crashes while the first fast commit after a full commit is
> being written, the fast commit area can hold the head of that fast
> commit without a valid tail.  ext4_fc_replay_scan() treats this as an
> error as long as no valid tail has been seen: an invalid tag length or
> an unknown tag returns -ECANCELED, a tail with a wrong tid or checksum
> returns -EFSBADCRC.  jbd2_journal_recover() then fails, the file system
> can be mounted neither read-write nor read-only, and the regular journal
> transactions committed before the fast commit are not replayed either:
>=20
>   JBD2: journal recovery failed
>   EXT4-fs (sdb): error loading journal
>=20
> The tail is written last and fsync() does not return before it has
> completed, so an incomplete fast commit was never reported as durable.
> Handle it like jbd2 handles a transaction without a valid commit block:
> [ ... ]
> which case the full commit is now replayed as well.
>=20
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Assisted-by: Claude Opus 5.5
> Signed-off-by: Hsiu-Hsien Lee <swinds24@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006070005.1209=
234-1-swinds24@gmail.com?part=3D1

