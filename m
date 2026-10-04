Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E402478861
	for <linux-ext4@vger.kernel.org>; Sun,  4 Oct 2026 18:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791137762; cv=none; b=phpgYIFUmeHl192rjd6SqeqBkUyZ7tNAOkvfVhfIVuQitxo+d0LydHsWtnDkFKm9VuiadZj3MWBMlIQ3kFetNyeq8E1MiJCHebGw/kVw3Mkjb/CqTdMTjD7CW58VczNvBJ6MaZUxdzLDSMVuRZZ0yLLXRpVIKZ1zvtkQztfd+wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791137762; c=relaxed/simple;
	bh=Of7Qec9Lp3KvWMZN+CxN2PE2QO6oc6y6dYsxellePd0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o7vECCKK63NdgpLldsKzZfwn+OJwpLYZjIXfj0naefgblajInCSwQPFHbI60yKQV/O8u+0LBipdghdmeJriaCFsVjE9JFrC4+4BON18ftxb3in7EihoxrQoyC+J7MPmFM3skx52Or6VY6mImQOIj/Yd+aRKuWGwrgdIUFuSJmZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YstdD1ak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YstdD1ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076631F000FF;
	Sun,  4 Oct 2026 18:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791137758;
	bh=Of7Qec9Lp3KvWMZN+CxN2PE2QO6oc6y6dYsxellePd0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YstdD1akPE10eNNgjUYgfZWa1HR++AZ7KZKqwGSF38jVltJ7NGfQNL6VV7J5/lKeX
	 Px0ikCoJ5iENUvT1FicAnLM3Nai6w9kulGuj4x0vlylWWzSXnU7jDNhmvvJHLaDCmP
	 vXE9f8DdEr0SY5BdINGzLOOzVrGI30B2sub8ogivDTCbMTuQ4ArbhzdPRe9YZItDU/
	 FyOMvLDe7p2oKz49qOU9NCcz8SMRrozZPcoxl52djLsfAz5J1i1F2r1Aseysj72FcT
	 FOWMUDJ3508CY4YSGIqkzvr1cto+T4+exi53F07YOhxwOL1siHbEGrVOJMCLK+rtF6
	 xLyU3Wpv3mi5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: return an error when a journal block is not
 mapped
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261004180629.27213-1-kmehltretter@gmail.com>
References: <20261004180629.27213-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 04 Oct 2026 18:15:57 +0000
Message-Id: <20261004181558.076631F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> If the internal journal inode contains a hole, ext4_map_blocks() returns
> 0. ext4_journal_bmap() logs "journal bmap failed" and aborts the
> journal, but also returns 0 and leaves *block unchanged.
>=20
> jbd2_journal_bmap() takes that as success and uses the unchanged logical
> journal block number as a physical filesystem block number. Journal I/O
> can then overwrite filesystem blocks outside the journal despite the
> abort.
>=20
> Return -EFSCORRUPTED for a hole, matching the error passed to
> jbd2_journal_abort(). Keep propagating negative mapping errors.
>=20
> Fixes: 62913ae96de7 ("ext4, jbd2: add an optimized bmap for the journal i=
node")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261004180629.2721=
3-1-kmehltretter@gmail.com?part=3D1

