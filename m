Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403F8435510
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702107; cv=none; b=FzY8HnWWk6BVQ6BWNxJYwCHZxc8lhbW/SdYEeWwT5hQ/34FriV8F8Im71hYP3VLaiUQFWDM+kCu4NElFoURCjNznvE8ybfMGSi5thEPbVkFRQGqEtBtXyS5oPJk/FW+Q2k2LmXgCz7uEQMf9y3qZr8LTuYCWlmUVAHZnaRemqlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702107; c=relaxed/simple;
	bh=FmGgfqD2mN+Nj6SsiB0CXahUBE75zVHXzxos4hCHat8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LvITbwT/ITZNrYchJkJlNDwFB9XhmzdpLD/sqwoMUAYfbxlqP1T6e78RXz6RyEO5PISVbwinp1z6UZ6mrFDmWyvcCTqYDvQ+Y45DTL2/A+Kl74dPziJVxGYm0R0m3Q50+h8S2xb8xuqrXUOxRnehgSR6GNt4ovPYL0xivFT4VQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O8S7za8S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O8S7za8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEF11F000E9;
	Fri, 14 Aug 2026 10:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702085;
	bh=FmGgfqD2mN+Nj6SsiB0CXahUBE75zVHXzxos4hCHat8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O8S7za8Se0xcdF3hHXKX9V9i2g82QHqd8TwdgzcdFzKXN8O7Z+jDG/9S+n+4HkGzk
	 vKXQsGdRvMd3h1vwEV7WtCCYS8/a44FwPtfzZGipCfMVoq1WZAf+uoVOaMvrhxm+dV
	 FXCVGLYzqvd80LHHPmwj2Z1a68oaoQ+1fZD8ORuo2DwHapp/FWZGU6QhA+thUDwUpC
	 Svu84uX1kQPe9yBzedcVO6lpMHZFKOjQAcoucoFADwquE9RJpoBNdsWO2XtgNpV+Mc
	 HCG1yq8kJKHLI1eJfU7cQl7FqQNryz0CGgkjYUaaEttAbsPZ7FKDJJZxPF9Sa6t9Ub
	 XVU+tGw+xVwJg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 21/32] ext4: disable online defrag when inode
 using iomap buffered I/O path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-22-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-22-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:08:04 +0000
Message-Id: <20260814100804.CAEF11F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D21

