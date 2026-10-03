Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E434388E60
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991259; cv=none; b=diwsZsIdXn3Xd991sODQm860DIVmQM7fWDHblZraPwnNaQw7YgwTbtnKAGWbhVuOQcPDLi884oPiu2kvWV1B/JuwIl5I7OE//E3FZV6pYzJ0qtQ90qVYgwl1vSzq8Uxl9HJoJYxR13noztyqT9Do3/CxMEP3BGibafFst65c8G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991259; c=relaxed/simple;
	bh=RXilpDvC3P9Od+aYPGoREKfyvq16X7Y3kHy/B9Ndgts=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jk7jd9kHyBJ5DHDY2DCUjMd2a+gZhieOOrCaT1CLm8fm1RX/0lhup27AndILcHXEd7k/fdUjuqIAr/uNwEyLk5SxkOirc3uX2hsuVhnzLsqPrX9ByivRPIBbbC/2Nday3z4GEtuwu6mWcpu1uU3OFiVJop46byiM4h1+bIdj1mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TzMLpLNi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TzMLpLNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91CF1F00899;
	Sat,  3 Oct 2026 01:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991258;
	bh=RXilpDvC3P9Od+aYPGoREKfyvq16X7Y3kHy/B9Ndgts=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TzMLpLNi9fS4UMJMLSMXtJS6cZaHojGSO1g4vqL9xo7Y5aIV0+EJtlUEjf0VsjxZN
	 xgGvKmRbJeRZGBNO53vkcBETrH/jIO6Jw7rT3cwyOJNqu7QvNnbvquW3M894O/uFvJ
	 sZQaxkmTb5hBul7Ac96E3hhXJTIiWCe/nEjqWNzXJSR4WMIGRpSJtE7F3foR5wfWnT
	 pFc+pchiHVOnNU49KG9WR4nqz8rorYCqZ8oSou03Xz2nMvBjl8eHfBUBumtE20URuR
	 7qjOWYeWj99mD7X8mByRaximfEZEbryVbdA7PiRqv8BM4ceuNtKzH11QuvNoADEhw4
	 Fn2ehQivIpwBw==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 20/21] xfs: introduce health state for
 corrupted fsverity metadata
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20261002223705.2175542-21-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-21-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:17 +0000
Message-Id: <20261003013417.B91CF1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Report corrupted fsverity descriptor through health system.
>=20
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D20

