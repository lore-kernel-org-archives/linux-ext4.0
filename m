Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC45C2BEFF6
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 03:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789616541; cv=none; b=ktby0R3vKTeUvO10r3J4e5wx7sZ9TXrKFktPjxuBi6ja8foPMxqMHzOxcuLgtn1PjPWRxgpNUN0umTmWn/4e/6LLFCo3xEQHVFtWLoNNjSqPQzGDVG/V7vxjQdlmdCylF93GdGKM3mocCITCh23G1kjbxTZlsuM6AJ/CYqjy89M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789616541; c=relaxed/simple;
	bh=PZVgOnm5sHX5SBkd7yukcg0gOFYh/ZuuCYVMg+trQFw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p2Y5xhGQj7zkUj4YdCZ2At3xm0sX6r/7zqKcwMawQJWTd3OclQGpwMrtw4/nAENnVSH5MclpMzdZq/GluNXedPeVGMSGuIuqsj2U7Zvalt1VTAmNMRDJkzYRyj0TKqQpxrFL31q76/K2+RCkS6ou6tr9BSK/slXKtKnq+FjIjQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JnKfS1mr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JnKfS1mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F41F1F000FF;
	Thu, 17 Sep 2026 03:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789616540;
	bh=r1nWKUr/+y75/X4yGt5//7BJajCbKT84rskHsex5inY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JnKfS1mr77hx/xpJ8K1H164U3fffeqomdhTL/kTV9Fx75CbYDn+GjUw459+oXoxu0
	 f06ifmAas88PWbVaU+T55ExyfTOrcg452IXe6102yDuqTp9mbESZH9H0tl4B4JrjfT
	 /wrGVA0qLAGLVAV1Usc48aqRduzHTyaWjJ3VXObeVnH2p55YfAXkO7KXmxmw0RRXUt
	 ZTxxL12ZSdmf5ngNgVe+m/W7z5thCwOWMCFiC2eJ7OPzULR14+PiW+tvw5VTNlG6qD
	 mZAWZLqaev/k2xuXxHE0cTi07pHRKW+UkZM05ArfM3Rzh68KV8xmZKJlnmqXhiQwJQ
	 t3D9n496Hlo0Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: propagate errors from fast commit create replay
Reply-To: sashiko-reviews@lists.linux.dev
To: 781735889@qq.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_1289C5B99FB98002A71088AC49394474B20A@qq.com>
References: <tencent_1289C5B99FB98002A71088AC49394474B20A@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 03:42:19 +0000
Message-Id: <20260917034220.3F41F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: fast commit mount failure due to broken idempotent directory=
 replay
--

commit 4015b43a7d3a20549b784ebf5a4fb9ffc38d14b9
Author: lty <781735889@qq.com>
ext4: propagate errors from fast commit create replay

This commit updates the fast-commit replay for directory creation to
propagate errors from parent lookup, directory initialization, and inode
dirtying. Previously, some of these errors were either ignored or masked.

> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 0cac890cf3702..a6230f4411ed5 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -2062,12 +2062,12 @@ static int ext4_fc_replay_create(struct super_blo=
ck *sb,

[ ... ]

>  		ret =3D ext4_init_new_dir(NULL, dir, inode);
>  		iput(dir);
>  		if (ret) {
> -			ret =3D 0;

[Severity: High]
Does this removal break idempotent replays of directory creation?

Fast commit log replay must be idempotent because a directory's blocks might
have been flushed to disk by background writeback before the crash.

In ext4_fc_replay_create(), if the directory already exists on disk,
ext4_init_new_dir() forcefully sets its in-memory i_size to 0 and calls
ext4_append(). ext4_append() then computes logical block 0 and checks if
it is already allocated via ext4_map_blocks().

Since the directory was already fully persisted, the extent tree still maps
block 0, causing ext4_map_blocks() to return a positive value. ext4_append()
interprets this as a corruption ("Logical block already allocated") and
returns -EFSCORRUPTED.

Before this patch, this specific error was safely bypassed (ret =3D 0) since
the directory was already on disk. By propagating this error, it appears
journal recovery will abort with -EFSCORRUPTED whenever it encounters a
previously persisted directory without inline data, which might cause valid
mounts to fail.

>  			goto out;
>  		}
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_1289C5B99FB=
98002A71088AC49394474B20A@qq.com?part=3D1
