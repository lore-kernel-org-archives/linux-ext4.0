Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864E14CC261
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543648; cv=none; b=N+CiYRmK0vxisw5YU7kfxShRY1JLu/Mq+Mh2aKLIIK+Wx0TDkioy4ZsOWIVwZVCSfRQKX0t7XNZ/vGARJGGlX6e+92OW0uiKoXqTrHN0IUg/hfM+wOBe26rJPGrXdr9pQyDpzMN9tR7pWRu3c9duZVwfjpe9tz2QmovUlMgl3IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543648; c=relaxed/simple;
	bh=m+xXj77t87O1pkZemzjhCgip12l2KZdwhEh+JFzvGhw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VKCWKR//V+LadLaDcgS7CPiofKBYWZG4bnEhAbO6DHitMn5Ronhx240Oxly8fRcFinUJ++Bv4upayt++uY0Hfj7PaDH5BUI4tSBcg8ovTeap2yOEmlRcZE4SRttpKBt6M6cyAB7wKBlgayTIl8TZ1XXNDBulyf64KkurOgpBKX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9ll1xik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9ll1xik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B58F1F00898;
	Fri,  9 Oct 2026 11:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543639;
	bh=m+xXj77t87O1pkZemzjhCgip12l2KZdwhEh+JFzvGhw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e9ll1xik3mVwhG5fli/+oni2rGZ0wHadeHe+FN4O2aZGWKnncHwSgcGp9y+vp9fcK
	 B8jyZGMjk/VZdGE/rXq+1rM4E/HgUmGbKJLdpuzFO34ZylkdwKHL8he3jqdLuE4Jnu
	 Os5tU5t3Tqh0wj2YxdMSCcRMBGqspxw11gtTW4wi2xinHod3SBsjOX0MkuaFTnKBpj
	 uAaWLFT0zFOpEHEhkRMnL4WP7/SkfNJJEAAuagX9yvcBe06PkFJEWPufOAOusYzk+8
	 232LM8bayOxw1+Ua2PRBNR+HdVlW5hXYT4J+n/yoTxRUcy1kLkHxA1OvF7fAYqoL1/
	 FCZsbLRdrxIvw==
Message-ID: <sashiko-outbox-165297@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 20/31] ext4: disable online defrag when inode using
 iomap buffered I/O path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009103033.2920530-21-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-21-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:00:38 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Online defragmentation does not currently support inodes using the
> iomap buffered I/O path. The existing implementation relies on
> buffer_head for sub-folio block management and data=3Dordered mode for
> data consistency, both of which are incompatible with the iomap path.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D20

