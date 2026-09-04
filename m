Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9593C3F40
	for <linux-ext4@vger.kernel.org>; Fri,  4 Sep 2026 07:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788507653; cv=none; b=LZhK+OAGN/STxRy07UGARswcK8P9AhUo1hzp8v8S+axytO3c15CbhMFwRgirHW+SLAeDrVOvy5Zp1PLPkUMtw6oQVx+EU+AKnyCGY9OJrDaN10imFL8Og8LivbybHnhs4pDxhCsvpAScY1HGk9ijGf2eDhbCkjezyXvkLHNEwzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788507653; c=relaxed/simple;
	bh=rpuWRpCstQhWt2/weHHoPA6IqQq9qKNE8HUn85/iL9M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Xz+yFgog8V1tDVIGRssMUL97LUud/pG8DOupxbtGq1PXRq1UBpm4+IvwpqWJe8FsKYDjsIboahylXJvju1GhvCEZeUunHFsag1Yk3NKht/lvwFMulA1GNsiulxpj7SX5vcwDYbN3g6IM5OLJodaHGt6xk9YEDNnLrXLpN1+NIfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8vlN/NQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8vlN/NQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA7B1F00A3D;
	Fri,  4 Sep 2026 07:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788507651;
	bh=rpuWRpCstQhWt2/weHHoPA6IqQq9qKNE8HUn85/iL9M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B8vlN/NQPb/GwuQwbnZI0/JAFmnO9msL1ZjI4VVkSJHF+6BlnWK7XFJRivVFQbkhu
	 rRCzB+fdoJ/BfWGfOekh7PfoeYz0Fi8EoC/MGuTBPzn1KC/U8kMrM5aXmqh0sW780o
	 In17r8vTaX3/6VplRtEdkbtu93DrvSuW995AmLFMSXqlgl9kEs4uJiGrsfoLltt9LX
	 tRzBN0V34uhJXN1ka1Vyu24tYChjeqPR1kToIez7WDcFLX+n6Ub1xYqwpmmtPOpc5D
	 MDHeFqNnz1wNTfWKfRDmXZsVmyFpGfjmzHY213zY+2q48/di1JmN8d116eJfhDT/fh
	 FxSEhzF1RW6fw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] ext4: Convert group-count barrier protocol to
 acquire/release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260904073253.663243-3-ruanjinjie@huawei.com>
References: <20260904073253.663243-1-ruanjinjie@huawei.com>
 <20260904073253.663243-3-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 07:40:50 +0000
Message-Id: <20260904074050.EEA7B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> During an online resize, reading s_groups_count and s_blockfile_groups
> requires strict ordering against subsequent initialized block group
> metadata.
>=20
> Replace the historical smp_wmb()/smp_rmb() pairs with smp_store_release()
> and smp_load_acquire(). This formalizes the publish-subscribe pattern
> and allows weakly-ordered architectures (e.g., arm64) to utilize native
> STLR/LDAR instructions instead of full DMB fences.
>=20
> Update the documentation in resize.c and ext4.h accordingly.
>=20
> Assisted-by: Gemini:Gemini-3.1
> Assisted-by: DeepSeek:DeepSeek-V3
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904073253.6632=
43-1-ruanjinjie@huawei.com?part=3D2

