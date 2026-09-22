Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7006953A3A4
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 11:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790076218; cv=none; b=aTpKNmV4KwDNvkFPiLKfffDfgoJmwHLuIJxOEdcfcLiKg3YvUMxMA3bBeu58HtybMjuQHqQukLbMW7tzTG3xdVqNSK5OgDJLy8FqCFmt3ryCNaW8RyNt+8iBNhh1hnQ868KaxR3Ge+TZGlTPmOxe4FZBCzvTDcnWtnL5QqGw6zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790076218; c=relaxed/simple;
	bh=AmwXJmu0o+889k8T/ySHcriVtiwLI8b/hDe38GFUK3g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Se8zEPxCYPUfyZAv+dGCt8vSyCGcJuJq/3pZN4g1qc7M80s8Xw2LZ5JO1KkRAdv6sRi7bIA8SEgxlzpLMDM+/GOOYjgAdbmeI3PviUeowLWVpjRndDvg8EDHZ8M2e6yUXFKXlexVXzQl4ItTJ4eiO01IPtiEneQpEH8SpN+bbDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QNDSNyfn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QNDSNyfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA5A1F000FF;
	Tue, 22 Sep 2026 11:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790076216;
	bh=AmwXJmu0o+889k8T/ySHcriVtiwLI8b/hDe38GFUK3g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QNDSNyfnDMRTPGwpBlLXM7t8k6VtsbXz5xxCccPomDNGAfbTJDan2eGPB8TV0Mrju
	 xVaT0S0TWpZHaqsdaDXO6wsQZZ3VLwtLmnoRGctislDEgo2IpvAP7mmVhz4JzGfkT3
	 fVVWwZxOpfor5NXtHXSWz5IaMggq09mGJJ9n/Yk2HXGTyW82dorQ7QutGmRnEJF4b0
	 2mRNnBr39KThtrN6iIeYyR9VPlkawkugfYtZXA94gL1TVMNxYUdT41a6hSWxFVSzxP
	 JLV4zxO6qKzQmPJCBqn6rSLRm2j+hc3hSFrgA/aUpkEi9ol2KnxJmR3+sPNlLfK9YU
	 q5NFj3XHb9otQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/4] mm/truncate: look up the end-edge straddler by
 index
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260922110703.468389-3-yi.zhang@huaweicloud.com>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-3-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 11:23:36 +0000
Message-Id: <20260922112336.AEA5A1F000FF@smtp.kernel.org>
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
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operatio=
n")
> Cc: stable@vger.kernel.org
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922110703.4683=
89-1-yi.zhang@huaweicloud.com?part=3D2

