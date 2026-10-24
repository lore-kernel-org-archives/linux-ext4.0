Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792882105;
	b=oBs7odOUnAvGrKRpPcDf078Uj7qn/+uMCIF0fX9uPftG4I2DoeNUOAv4s39haSEdLf67
	 DNYBuwg9Eor3r2IzSpyBpJl8e6gKnGRpZ5YMm14c7/mE3KDy2AaMhydMOmzDaTwWOIa4b
	 toX2t2bhqb9G1r24beOsSxaFKXE1YE2Fb+/+vWkVaVDWTlon72NksjIG039hPiPpGZLzO
	 e33A8Lbo0e64xppxGox/YojQsPulKBVbVTCDDu5zQhGuo67flUtDAvd2FPxOOCTMieNFa
	 uvehzyjVF7B2QIJGt0vmUWsKpQPzSCXipkiPUQfaMb1R31NLDSMTlJ3QmkHkYhLBQww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792882105;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=plAICp0J7aVWwjoUayH/0hIeKHSJQwpUXkFeZFTFKUY=;
	b=p5qRFJty7A1jgujg/ExFyWw0YRMNFJYBQmbne8O9thk9+x5+HpLwFCCImYk0BYjOZkS/
	 vh7BO6H7PRHrf5tDSLY46B09hRWr6zrqZemuhvNT9lEPcNTm9IssgGD3ahrc7jeAia9F0
	 Vd4D5n5/4ZLQQuqEZ55zET+5S1iu4WnXmnmU0C1TquuYy4VZspmU9SmYM47+fyNQkyXjY
	 DEohbCTFrnDiX/3hrNJUTqWilBgcTADF/2zEUih+GbAfIHhukm9zwJZJmVtuqXvr4Sc8K
	 htNlFJJPjp6aBxtFgewMw9RZZ1v3iDcdfPQhxpqtYt3ho7TYGNMB5UqLepLylPN+u+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SX23AVSO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35673606A31A
	for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 22:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SX23AVSO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0B21F01825;
	Sat, 24 Oct 2026 22:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792882104;
	bh=plAICp0J7aVWwjoUayH/0hIeKHSJQwpUXkFeZFTFKUY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SX23AVSObqZH/GosAiPtKAWcXROXPkjgkVOJb8w59NZQURXA/ifykNr+7HORsfd4N
	 R4AuyEjzb15rGtrnKW33VKxfx8jFuRe8ph6hW1JQWdSkCXsVUUGVF9AhllJkpeS6jd
	 MloYhI2mXcQqbeUJQbHDnoqam6t3Ux3u9f9P2RXJF3/xhxXebZllBglDa7wMQakELN
	 EZFJZkiAvwxm9SPrHtBfl3B8QRRVYm/ND1qYAjlb0exyjyfCjSUCrHp9tOtsO/Oq7n
	 Ooht9OpJWE5cfF9p2uywrCej+jTARlyfxRR8V4yioOBq7QFpAOpu1Z1+N2FDPUfx20
	 k1+AS281w9OEQ==
Message-ID: <sashiko-outbox-183932@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext2: take invalidate_lock in ext2_write_failed()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pedro Falcato" <pfalcato@suse.de>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261024222726.889520-1-pfalcato@suse.de>
References: <20261024222726.889520-1-pfalcato@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 22:48:24 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Currently, ext2_write_failed() takes care of removing extra data
> (folios & blocks) from the page cache by first truncating the page cache,
> then truncating the actual inode's blocks.
>=20
> Understanding that this is correct - namely, that a concurrent page cache
> lookup can't create stale pages and stale block mappings between
> truncate_pagecache() and ext2_truncate_blocks() - is non trivial. This is
> correct for two non-obvious reasons:
>=20
> 1) every caller of ext2_write_failed() holds some sort of exclusion
> against truncation. In most cases, callers hold (in some way) the inode
> lock. ext2_write_failed() is only reachable from buffered/direct IO write
> paths, which hold it. page_symlink() can also call write_begin _without
> the inode lock_, but at that point the inode is I_NEW, so there are no ot=
her
> users.
>=20
> 2) the page cache is generally extremely careful at never instantiating
> pages beyond EOF.
>=20
> This is all quite confusing. Holding the invalidate lock across both
> operations is largely simpler, and mirrors other bits of other filesystems
> (like ext4_truncate_failed_write). Do that.
>=20
> This has the side effect of making it so ext2_evict_inode() doesn't take
> the invalidate_lock when truncating blocks on inode deletion. This is safe
> as the inode should not have any users at that point.
>=20
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024222726.8895=
20-1-pfalcato@suse.de?part=3D1

