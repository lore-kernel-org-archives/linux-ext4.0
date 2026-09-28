Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E38362137
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 20:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790627375; cv=none; b=mizNZOd01bWf1GD5fpoKzcRiz9fZdDERf5IRlXOHrHrHtuQY+5NRrndkppf3pHcOs8IAeZmNbgmx1u6vq3dvLo1g8peArte3gciZ8bvrqcveTpus/CFTxRPlv8pcZaWLJswdt9f6hM6D7XEzO58z55WlRKygehQXezwUlqEnhDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790627375; c=relaxed/simple;
	bh=ktMyRjv4NBqVs3LiBeGUrxffwR4FD88Hr2vjyCTV+/M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ileN8oEhxh6bdGJYGIn6LKUtBs0+XGu2kMq7W8HMQkYlQ00nIMIFCunZJy8NwOZOZ6l8GeAv164gqK5Y7NVy0O/etyvmni459ebMOOYLs1R5G5s++tGE5LfK3ZjsrxGoFITzM6+NWT8MzVeF9yogwVSi9Qua+CkB+FDdQzJY2UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPqGtZTu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPqGtZTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3831F000FF;
	Mon, 28 Sep 2026 20:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790627374;
	bh=axFmf7t6z160kkQMGU4ghAWFyCvNX0M/ZZmwl5AX1Ww=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YPqGtZTu2WgFa4EQNU9Eg5GVf4f+cR9LwYRZTEK4dzBPpMB89T25dlUWhZC/gjYlZ
	 CnYv1t21sU71zN7idzKssdioKDxiH8SFbA6dvf1TAiu5A7IxhUS1ac81nUT8A2qTUV
	 FGzeSvN0uMFMH7KawKoJwlSucCgnjAhGIAC2UhGECsYMCl6jlS7KjU0wsHWBVn8VPN
	 riFWDbK7LcdAyxpHY8V6928B39kg5PzkVtNC4vtYeItZCKyBvO9Xwn6PBz2uZ3voQc
	 YbC8i1qmuBQi3cLcW8c5Lc/a04AAXXlOudTPV4nY1yfrN0RlHpK6VfkwPxRusCYtEN
	 5A1Vh7jhQgD9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] jbd2: set JBD2_LOADED under j_state_lock
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Q2hyaXN0aWFuIEfDtnR0c2NoZQ==?= <cgoettsche@seltendoof.de>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260928202159.2463182-1-cgoettsche@seltendoof.de>
References: <20260928202159.2463182-1-cgoettsche@seltendoof.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 20:29:33 +0000
Message-Id: <20260928202934.1B3831F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Christian G=C3=B6ttsche <cgzones@googlemail.com>
>=20
> j_flags is protected by j_state_lock, with only quick racy checks done
> without it.  jbd2_journal_load() however sets JBD2_LOADED with a plain
> read-modify-write after journal_reset() has already started kjournald2,
> which tests and may update j_flags under the lock.  KCSAN reports this
> while mounting the root file system:
>=20
>   BUG: KCSAN: data-race in jbd2_journal_load / kjournald2
>=20
>   write to 0xffff9c6b012c6000 of 8 bytes by task 1 on cpu 3:
>    jbd2_journal_load+0x279/0x3c0
>    ext4_fill_super+0x34dc/0x5740
>    get_tree_bdev_flags+0x21d/0x340
>    ...
>   read to 0xffff9c6b012c6000 of 8 bytes by task 77 on cpu 0:
>    kjournald2+0xc8/0x3e0
>    kthread+0x1bd/0x200
>    ...
>=20
>   value changed: 0x00000000000000a8 -> 0x00000000000000b8
>=20
> A concurrent update of another flag, e.g. JBD2_ABORT, could be lost.
> Take j_state_lock when setting JBD2_LOADED, like the other writers of
> j_flags do.
>=20
> Fixes: 470decc613ab ("[PATCH] jbd2: initial copy of files from jbd")
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Christian G=C3=B6ttsche <cgzones@googlemail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928202159.2463=
182-1-cgoettsche@seltendoof.de?part=3D1

