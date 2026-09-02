Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AC12BB17
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 02:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316962; cv=none; b=egE/shs8pW/bKE13ten857i+vqFv/SdHSgnsRd7eoAVagzn46YbRJmuDVI3DI7/9xVWAYm+d9itpBWOcMBseloYYe/dMcU3zFR5vMT4f/O/MH/fPWrNxTuqMENdjNOHsFEKFNiMElaELSw73SKwNM1Cg7R2eVDxUNsgMkGAEniQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316962; c=relaxed/simple;
	bh=MtcEOZdbdRxuODCWD5/2FvCUj04swZpFXfjNs4HYq78=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pnIXpceMpyOTv47dGyO/R0ya7cdNXVxULCJTubhnyhAFRhJEUiCTPiruBwD7xFUZATPOKG4ovFBFXsLCkEuL7gCxHmedwmtyoSH3ttYd5doqsxhymaG6LzzpyQJVGaGUTGRuPB3ytFLSIZOzjyaswOF08dvudsiDlhCOpR5XX1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXzymjhY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXzymjhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877B21F00A3A;
	Wed,  2 Sep 2026 02:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316960;
	bh=MtcEOZdbdRxuODCWD5/2FvCUj04swZpFXfjNs4HYq78=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nXzymjhYDjpPwjIHw6GmoiJg+E862c2lu97tZoRm3484dSCfJqnOHqkrrqAcck1c1
	 ffe+ZiAsZm6G7ExReR8+s5HHixG88E3tI9Rnj12sVeMlKWK0F6ALpnC08ImrRrtWjm
	 Jl4mU4l/eCvzesiPZT3V/1aJXuKHzENrqLWwGA/AXNIddxKSNTkwQlszYpkzzijHPU
	 m63cmag9S+cfOfy5Q9v4B2KVytRr45PokkFahXxuK9gr1Z9y3F9GWufm/HFZUep77m
	 OlldccPidlj66Qf384TBZEIKCxK1FTynPrQrtIk9EEo3W7I850neMY6Ra5leWBnvnn
	 WwMSRzczWTjJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/12] ext4: Convert group-count barrier protocol to
 acquire/release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260901024234.135119-9-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-9-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 02:42:40 +0000
Message-Id: <20260902024240.877B21F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901024234.1351=
19-1-ruanjinjie@huawei.com?part=3D8

