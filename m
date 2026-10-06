Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46483AB28D
	for <linux-ext4@vger.kernel.org>; Tue,  6 Oct 2026 11:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791285787; cv=none; b=R24H6Mjc7BkXFF6g48YqYEj1110QIOzDsQYY0SJUMZYjjXyiuhScXWuJ/UMpw/khGT3cB5Z5l1bqrihdL2fpJ1Ocwknztu8DG81Y1AYyIGHOEF0VLGAkcTGAACEkQk2dwja06lMmDVlJfAF83MY9u5pPitq4OP818bPLaUB4T+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791285787; c=relaxed/simple;
	bh=3nhqe9FRziYj2i7VnrEC+q85iJVI1iamO/qAoGM+kqk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PqDtA3IoX72EzGssIX00S5aL3M+pajp8VmozKI9+VjJ8RaFGqiPU6Ya4hT29FDEYXorZ3HlShpX5Wpah1A/6DHAcvCqOfBrIVAYE8zPIokKV8u0H1cuzP8mjOnufp9LPXmYINsGlplwJN9K3jiYZqqQGjU9DFEqeZ8KGjYoAWh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SzSzrYue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SzSzrYue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAEA1F000FF;
	Tue,  6 Oct 2026 11:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791285786;
	bh=3nhqe9FRziYj2i7VnrEC+q85iJVI1iamO/qAoGM+kqk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SzSzrYueSIE+p1Nu36QAbcHVaQS6LKxGbpGIJsWTGnSGd6vEOVe8ubfVSGLW45Opw
	 KXgrq7ns6w6D2f7EtZWTTpntLHPSJoZrJZfRWgaLM9KTBtRPNfIkClGZuK9bu5p8PJ
	 WPAqJ1iTcHDd3TaJ4wMc//pNpbaXonAUtKC//zoq05v1VKnd/tDaCvfTRF6quRVI+M
	 WEE7ftzjYFOAvWLAOK0KaoAIKdDMsgNaL/VJjvvU80vEAiMK9krDstvD+g3w2NreRo
	 ccsucxkvpNehMrUKxbwebjViVTlO3hgt7WG6qPbYVtVPPAE5yxYXHSd0wrOtPV8y6i
	 KzwX8KtHqIlcA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: do not accept rec_len 0 for block sizes below 64k
Reply-To: sashiko-reviews@lists.linux.dev
To: hengyul@cs.unc.edu
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261006111546.3252481-1-hengyul@cs.unc.edu>
References: <20261006111546.3252481-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 11:23:05 +0000
Message-Id: <20261006112306.4AAEA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Hengyu Liang <hengyul@cs.unc.edu>
>=20
> Commit afa6d5a16bf2 ("ext4: remove PAGE_SIZE checks for rec_len
> conversion") made ext4_rec_len_from_disk() read a rec_len of 0 as "this
> entry covers the whole block" for every block size.
>=20
> However, this special value only exists for block sizes of 64k and
> more. With smaller blocks, a rec_len of 0 means that the directory
> block is corrupted. As of now, a directory block that has been
> overwritten with zeroes is treated as an empty block. The kernel no
> longer reports the corruption and can store new entries in that block,
> while e2fsck still reports the block as corrupted.
>=20
> The issue can be reproduced on a file system without metadata_csum:
>=20
> [ ... ]
> unchanged when the block size is below 64k, as e2fsprogs does.
>=20
> Fixes: afa6d5a16bf2 ("ext4: remove PAGE_SIZE checks for rec_len conversio=
n")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006111546.3252=
481-1-hengyul@cs.unc.edu?part=3D1

