Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7222643F4C2
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702363; cv=none; b=dM+LpAm8sEpPlkKlvJjM0Kb+npvWtuTP2dvdbegCEMR5Lmx9opjhVKxgc58x6UnM/JmThvVn33EH5CZz0Y+YwKm7YoPw/KXaMMY7ubbTCI1zv8vWMTjV1wbrPx+HJ1tGDDjHSre8JnNVtyGExmbFw4JJCT+9LvMFzkxDIN97rkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702363; c=relaxed/simple;
	bh=sSWQUNmauZlh0OZ+NJHGRD9yDtnYO4M+Xhl+BELtErs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AQI+LHhPnUeCl55aXjJUgSjnKcUFak1iI7FguEwKVP2PSY1MKYopEJvnmlIPGpWXhD4HpmRtvS7GN9A1ZniZE+nBpOQ4f1aMjhJzb7LjiJfUFiC4Cqx8vuDAZtmO2Sj/d4h3aR/ziOjzHW9Hv3F5Iofjkoj5bf7ZYx+X86zaNIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cMh/S+tP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cMh/S+tP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605951F00A3A;
	Fri, 14 Aug 2026 10:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702350;
	bh=sSWQUNmauZlh0OZ+NJHGRD9yDtnYO4M+Xhl+BELtErs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cMh/S+tPwtvWl67qvisrBLmruCPL8aQabFB8ENNyE9kPCqIEl4BiQjnCpa6Lyo43J
	 hjIMcDI4Z1gWOCD1X+5hPG/mtqZiCUDQM0k3DJ1MxhLMqrW7w2AM3jacq78eRpEAjC
	 iy/6G0ybzd0SvwI25Y+ib5GWZ99CuLumurvVLLMmP7Xlg65DL3nZQkjIp/uU4egt9B
	 6BEmuL29ybT+zU5foyuKaf13xNguagmWLQK3wCAd8TuQSBHttB9/oy+EbcWygLHTwV
	 8FDw1pfdcpz++4JoIsgRHb6xonYWxtk/MCTjFMncl2c7Lv9ljjfydxU1EljEy5fzvC
	 j68DanYgwdRQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 13/32] ext4: pass out extent seq counter when
 mapping da blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-14-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-14-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:12:30 +0000
Message-Id: <20260814101230.605951F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> The iomap buffered write path does not hold the folio lock between
> mapping the inode extent and copying data. Therefore, it can race
> with writeback that modifies the extent type (e.g., from unwritten to
> written). This can lead to data corruption on partial writes, as
> iomap_block_needs_zeroing() may return a false positive based on a
> stale extent. The iomap infrastructure uses the sequence counter
> stored in the inode to detect such stale mappings.
>=20
> Commit 07c440e8da8f ("ext4: pass out extent seq counter when mapping
> blocks") added the m_seq field to ext4_map_blocks to pass out extent
> sequence numbers, but it missed two callsites within
> ext4_da_map_blocks(). These callsites are on the delayed allocation
> path, which is needed in the iomap buffered write path. Pass out the
> sequence counter to ensure stale mappings can be detected.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D13

