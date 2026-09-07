Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28F2404882
	for <linux-ext4@vger.kernel.org>; Mon,  7 Sep 2026 06:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763387; cv=none; b=icie8lyr3TfOpbeRoBmXp6liSiZ+siv/GR/59WTuSoLz8z93ZzHfRYMv4SsA78EnLX8/FwdAWvUaaFVTdGkw6Mqe1H/vnvrUMwBveu9+d3szpyW7ydaihb567SfyrTXlEUyzsKzPlPkQWcXrb0n/kaU7OhU2ZIoN0XrYmrk0icI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763387; c=relaxed/simple;
	bh=chFwSJvUTzDqoqc29HecFe+P75eO4ecvrjUrYXksMns=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mK95ba7TY90D+4KWTpJ+AbRvji7ind4+xH3hNas7w8SwT+fkrre2kei1L5MY3iFiD6VfSbx924S8em6gId1TwIxqYcOeBTkBK8TJ0FU74woccYPiorEfiPqTEvjb0m51MKXHfx4EGekafAlICrAHKHy07RipxUk5Ng9Nfpmz4LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JgT5xpNQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JgT5xpNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21991F00A3A;
	Mon,  7 Sep 2026 06:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788763386;
	bh=DQry2tp8dkJFKK1PDTH5d0cwpF2K0PBGR7iPP0XQXTo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JgT5xpNQT37Pv59isnqyLqcbKMEG4KZ90uuRdHnKAyWpW3RvBq9E223gV5WWvKOGq
	 3SAutOpoJpdqs20lrC9Hq5MDcLKdVIWH8yEJFY1qWCHjfQw2cNisduX/8pzksIcDnh
	 DiKtJ6x/7QO/jaBmRtV5x9NalDfr5VrfL4A/17N4rvIvEX7MSMDT+Ub96N7T1dv/4O
	 VOFl2UzgrPWXGd0wmqQ8BZV/SAjYYSNbnQ4ybOp3IrcGtcohcP6IYAQxM7mR6AZLoV
	 v7v1rqA2LVAQBJOKfsRbl45GicTqbgQDRGsMJp+GVMm5OIyQ+j4u+7vxbbbM/AB5uQ
	 VJddpDXhJeupA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix typos in comments
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hemanth Selam" <hemanth.selam@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260907064046.36515-1-hemanth.selam@gmail.com>
References: <20260907064046.36515-1-hemanth.selam@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 06:43:05 +0000
Message-Id: <20260907064305.F21991F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
>=20
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907064046.3651=
5-1-hemanth.selam@gmail.com?part=3D1

