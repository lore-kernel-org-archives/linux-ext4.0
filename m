Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A0136B92C
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 07:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335919; cv=none; b=ei2NwYWI29QiKQCHVLtth+DmZz9+FnDavnXUpUkG9i+lgYLX1ssH8OGMmps2uIjFGAjx4U9nW0uHlGsTxeSypuSsZLRUb/eQq5y6/POHuFe7YIQEVmrFKADBmMHosB2WxyCxiyLBPLrkFJD+yQE6svf9MevWYcnTVJ4FZk/dNMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335919; c=relaxed/simple;
	bh=TtvT0CokNSTJlEF4R/58yd6HdMpyE61eFqSWvxWI3yI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sP7xDp7Xp//9zpJrGEhPcaf1T0bLKLu9mAkZXJvhzNAvc81AvAVTD9V6IGZEUSu3UvGPkJX9auPki7LRqWJJH1a8ds/YnzEUoe/Jd8iM2kOKIxzM6KWxcQcW/FJhOVAaF36c2EUlJX9P9lDh0HS91dp/VzrGcQSMndt6FAM+AIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UhueeYzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UhueeYzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C111F00A3A;
	Wed,  2 Sep 2026 07:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788335918;
	bh=TtvT0CokNSTJlEF4R/58yd6HdMpyE61eFqSWvxWI3yI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UhueeYzwfQylCtxv17LFbDQulZ09OXcyL35hmT2n/VYYKgP6F9A2VaX95RXHE5xHs
	 41rzt6FDhv1qXfTvKn/g8/ggqa+XfjsWU0LlCBSIcBGHlJs7c18P+0vaIzfK8EmhFc
	 Z3R8iIyU4GLxVmbr0j2Qa/fxtg6zZNbbIrJfQhfFsRrvg91zbA7IMCtIqIhc3Ti9Tv
	 t3G96ZoxmGyt+xY7LmqsPzMpWvY2wRMPHav59E+XBVkBq91ynJaZ5YmUAtdAgshLLJ
	 RqiOBBCQ0ZgeWLDvFP5HQOORGTWIjvwEw52X/eOn+1Zw91SbB1WTczcQRwDYPqZhuG
	 Qe3VLBiklhrhg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 8/8] ext4: Convert group-count barrier protocol to
 acquire/release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260902074805.398540-9-ruanjinjie@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <20260902074805.398540-9-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 07:58:36 +0000
Message-Id: <20260902075837.92C111F00A3A@smtp.kernel.org>
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
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Baokun Li <libaokun@linux.alibaba.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
> Cc: Zhang Yi <yi.zhang@huawei.com>
> Assisted-by: Gemini:Gemini-3.1
> Assisted-by: DeepSeek:DeepSeek-V3
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902074805.3985=
40-1-ruanjinjie@huawei.com?part=3D8

