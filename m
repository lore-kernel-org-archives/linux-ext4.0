Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9382F4CA294
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 10:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543359; cv=none; b=ptucz4/4hnCKXjLxOebVSMABzPDQuRxvI/JrIfr1pToTBc/gqzI7fQKCZXlcyf+VzBbGt7PxW+iLLi8F6TtziW2pQm2AL8hty6v6hoV5eEUI+nsqlpaoB3IV/CBJRTceU236BdwnsP5RFWciYiqqVlTclOw7Tyf03NVfFYMP/i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543359; c=relaxed/simple;
	bh=xjlIqjT6qqf2r6Me37fzLZ951WTBhJzsyLTbUipURAo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pH9mZzKnP5SSNsjzyk+y0t2qQU32XIVbZy40GeHjNGy1E4aYmRJwn77uCTBCcYFe6xQ1TO5moZmKGUUMGlJz+87uO4qJUsmWJrrFMUssbN3QFpQ26amFD7nertdGGm5/2x61L0xXLXtS96xnUly3cXWqp14bmaoodvmtLmpF6zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B1SY+T4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1SY+T4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CB41F000FF;
	Fri,  9 Oct 2026 10:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543350;
	bh=xjlIqjT6qqf2r6Me37fzLZ951WTBhJzsyLTbUipURAo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B1SY+T4BifNwktAuLoXVx+ZHFOrFbsrWA3vpfU+6LcrJDdsLhs2cnxmjQ4P9uibZh
	 p4lVjJ0TvgbPZs78gnWM2bpy9Ekc705L0ZMUt3u5ElRNEuI9DrF7yfddwuvGfvEerv
	 BtS/nHkHZoHQk61VocQxxgXCRLuRr78Ozesf6oO+3SHaF80FtLRTTzA/O3cfLm46Ai
	 uEbQ3DO8LSqqu+XONxmpY5ZvP87h+iGFNwD6/atRFwAJkyJxNAs59vAU4RuIYLXOlU
	 4juYu1QhXKZczFJql1ZkbfLfAc+VJgJE92s+DzMm2TCc6EaPh5ZLi+TijwboKg/E7C
	 XSSjKiTvwMH2w==
Message-ID: <sashiko-outbox-165287@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 11/31] ext4: pass out extent seq counter when mapping
 da blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-12-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-12-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:55:49 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D11

