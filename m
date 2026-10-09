Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7C54D8DBD
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 10:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543294; cv=none; b=TBd9c2jGIpJ+SjQdCXePL3uDYeXvWfRQ1dQzNwYXVNFGcGu+9NTKzt6rxmIJ0mLI9d596WtgQgGGPDwbjWrX1l7aeAGwKxZNE5TWAx6xlDor24jVHusDJVowGmBDAEdPY8ruLNKpNBjyG7wa3RuTyRiHYjFd4DurSQkPCO8vD/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543294; c=relaxed/simple;
	bh=O0guHxIK1f+fvevXXPvOxWpb8PLPXpEZrJTODxKYiSs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QhcyFqH/OVoX+keZf7NHtDuC5bM50yhJFIYX1JgZqmWPRxPAMba20IS/Ug7TFzbePG+lu5i7Z+XED+8/lfPERNRUSkBtBYOPlnpJiwXqZNjJDWljGWNjD8zNmihKaQ1bIUyN2jy9ChSNOL/bvNGCmEz9FnY3OG1u+hoWO2pnsfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DDctjOEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DDctjOEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9058B1F00893;
	Fri,  9 Oct 2026 10:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543283;
	bh=O0guHxIK1f+fvevXXPvOxWpb8PLPXpEZrJTODxKYiSs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DDctjOEi4Sbt4i9aZqw0gnCGjfT96kQ1RB94L2EfSgsihRV0JSGXGiEJ2DmlqCZNi
	 6rTt6noyyCPPafQo6oT+8wpxOZXq+8lsXWYRRDb+TUB9bu/yV0gDDOh2W8ebAIweoB
	 7+2lhEVrknAMSQYstMpKPOL3puqrY+CG4Q7C5l3SBsu31/cqcuxBPKsol3nIxN6zqR
	 Rmb9VXMk0hDngLuuzw9E4qT8gmKN9BFDIiLwgCoRYNBXTmLLMz6ZI6JO7BK7HGrliN
	 +SPwQIQnAfOCqJRHb14aVSqmLe3hs4A7ryhT3+J5PniQRnJcpdq0rS2nz0z9CM4SWS
	 mzv+YNv8H3gwg==
Message-ID: <sashiko-outbox-165285@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 04/31] ext4: recheck extent status tree before block
 allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009103033.2920530-5-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-5-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:54:43 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> After acquiring i_data_sem in write mode, recheck that the mapping
> found via the extent status tree or disk query has not changed. A
> racing truncate may have trimmed the extent between the earlier lookup
> and the write lock acquisition, since writeback does not hold i_rwsem
> or the folio locks covering the full extent. This could cause
> ext4_map_create_blocks() to allocate blocks beyond the truncated range,
> potentially leading to quota leaks in the upcomming iomap buffered
> writeback path, because the iomap writeback infrastructure caches
> extents beyond the folio range.
>=20
> Therefore, if we find a valid extent and the sequence number has
> changed, retry the entire lookup to obtain the correct trimmed mapping.
>=20
> [ ... ]
> continuing on an error is not advisable.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Link: https://lore.kernel.org/linux-ext4/b0781809-4759-4e12-be17-71555b76=
4f48@gmail.com/
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D4

