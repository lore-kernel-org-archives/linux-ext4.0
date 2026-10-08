Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9D7547055
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 01:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791423234; cv=none; b=Ehh+oDZNhrnDlYcGXMxAUFZv0Tu6fycqvZL7iG/BrGoeGOQEhkskjOYesNa1wAI0Qc4lI94UbOMzWjHKdlTJLa00KcVOvA7uZwuCnQb5VPhGYz6CUeja0DZc8mx+/pnhSRppJcmJ5oLrc+J+xfD212tQ1GXXRZnKNsxSkyXvclA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791423234; c=relaxed/simple;
	bh=xsccNrOWGjp6mdlqFsnt27rgsIWoCJaz9TU5h6cNfm8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ob3t02e7R9gMmKf5tFh3N/L/iGqEOvFcNoIJbnjdt+Z7sLKabx0XE5H43ndRJ/pFbU7Y0ACwdALUaDQFW0AINcAmJoHl3niqX1Ra0N9AiMcohhj+0XmlFl8v6iSceaH5pDM9fC/yU78aLL0wOhJMM+K02uTBnyPseNEvtV1xrxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7FLQFdk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7FLQFdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EDD1F000FF;
	Thu,  8 Oct 2026 01:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791423233;
	bh=xsccNrOWGjp6mdlqFsnt27rgsIWoCJaz9TU5h6cNfm8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R7FLQFdkDSAmePULIyvIsTT8fRp355g4lDi6og+3bnMbjEC7NtQmR/WiKAabh/fhm
	 N0NnXZZC/g4KCR1YdU+VOPhpBq2HtFVyiTalBVWaMKdgP7DuHNT5VXP3fNKtRwRT5b
	 gRSbzpaEgz4DqdsuJBOTvvf43FJS8O5x3e96+C3M9wut3R59bYz17AgdihWD7+RPTy
	 l/ErNdNTQBpq1OQJX++0DYo+Ma8sRNlfSsC9DyiYANhtiuQjWa4Zb1B5mS7Mnvcvaf
	 O3LcaHZ1M9Gk0ASTXUCOs6Sp+BEXOnM3h0p3Q68ds70ludthcLgii3fNNb+yvlHfmT
	 HXWNfXvAVh6+A==
Message-ID: <sashiko-outbox-163490@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] ext4: track zeroed out blocks of unwritten
 extents for fast commit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261008-ext4-fc-zeroout-v2-2-55cab1e24fa3@samsung.com>
References: <20261008-ext4-fc-zeroout-v2-0-55cab1e24fa3@samsung.com>
 <20261008-ext4-fc-zeroout-v2-2-55cab1e24fa3@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 01:33:53 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Daejun Park <daejun7.park@samsung.com>
>=20
> When ext4_ext_convert_to_initialized() converts part of an unwritten
> extent, it may zero out the blocks before and after that range (a side
> only if it fits together with the range in s_extent_max_zeroout_kb,
> 32 KiB by default, and the extent ends within i_disksize or the write)
> and convert them to written together with it, instead of splitting them
> off. ext4_split_extent() zeroes out the rest of the extent and converts
> all of it when a split fails with -ENOSPC, -EDQUOT or -ENOMEM. In both
> cases ext4_map_blocks() reports only the mapped range to fast commit, so
> the other converted blocks are not tracked.
>=20
> A later write to one of those blocks overwrites a written block in
> place. That changes no mapping and is not tracked either, so the next
> fsync is a fast commit that logs the inode but no range for the block.
> [ ... ]
>=20
> Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
> Cc: stable@vger.kernel.org
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-ext4-fc-ze=
roout-v2-0-55cab1e24fa3@samsung.com?part=3D2

