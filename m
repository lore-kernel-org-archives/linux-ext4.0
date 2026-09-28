Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359EC34402B
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 12:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790598259; cv=none; b=pCiuP5pYcvMOCegIt1vEG87TQmzyWtWo2WRjckFQyUe57lMHMOp40Li/Cwf7KoWpfnw2+PoND9pCKFviX3TaTjgGNyzjphiFkSPp/jZgNzla9Eh2g5rIzSdYVcGcSqYjOeBFpU0dc1mHylmL6/tm6+/CQ1IucaA4Hl4wqDdFyk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790598259; c=relaxed/simple;
	bh=skLPNCu9NHMCK21eLTIAOixrDvX5Mr2HP2NCEI7l/Wg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UbVbBFYH7vKc+yhzQbJw28KDLXQiQVUMg0Et3l/m/oKgo7Sl8oj3xO0rh7J3ZVz4fOR1g0/dQYza/GboYL4q0aRm4rkhAIQjArkDEcHViXObKDdrypRlZN/k8K/gtJ+fpm+f9b4H0SlJUpO60C6wmbEM15YV+UxxUXFpSJJhiIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5n4uL9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5n4uL9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A5B1F000FF;
	Mon, 28 Sep 2026 12:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790598258;
	bh=skLPNCu9NHMCK21eLTIAOixrDvX5Mr2HP2NCEI7l/Wg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i5n4uL9bu6VvI7A4XMae9AfdgRC5cvYp4S9rOWKWLBz1SMbsNX9gVlYAWdlej647N
	 mNXps/k1kTLmmZH2FbpXI/CvDxgHjzn+CkUna9KGhQdJRu7HQ40CAgAj30/4fLr7/a
	 1gU6/7vTVVMc9TkNtM6aydlj/UjqbdtPgcb+EwdR94LHEzsQtwZPWPWF/2egiKRH43
	 uBpGCqMlgvKgy0d7jvt5kylwboPmi+WMHeJkEeK/4+8j+AmUq4IvUkx1jqJGQOa5ek
	 JoBfKRkmLaKpq8tYvVPpNJsXI1yQ1MIpJYUYgE/ILlCiIaAYrMICPm4q2v6ggyeb8g
	 GGxhP95tmQ/Mg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/4] mm/truncate: look up the end-edge straddler by
 index
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260928120833.3440834-3-yi.zhang@huaweicloud.com>
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
 <20260928120833.3440834-3-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 12:24:17 +0000
Message-Id: <20260928122417.E4A5B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> In truncate_inode_partial_folio(), after the first split at the start
> edge, folio_split() unlocks and drops the refcount of the after-split
> sub-folios. The sub-folio straddling the end of the truncation range is
> therefore unlocked and only transiently ref'd in the page cache while
> the code still derives it from a page pointer inside the original folio.
>=20
> Between the first split finishing and page_folio() resolving split_at2,
> that tail page can be reclaimed, freed and reallocated as a new large
> folio in the same mapping at a different file offset. folio2 then points
> at a folio that does not cover the end boundary, yet
> folio2->mapping =3D=3D folio->mapping still holds, so the stale pointer
> passes the mapping check and folio_split_or_unmap() splits a folio at a
> wrong position (or, with a transient refcount, a use-after-free window
> [ ... ]
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928120833.3440=
834-1-yi.zhang@huaweicloud.com?part=3D2

