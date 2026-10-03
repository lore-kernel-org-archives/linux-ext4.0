Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2837B38D3ED
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991263; cv=none; b=FEVclV8ZJo5LBJlokQZoGIiQkDPluKzBanBW16yfgfV8MHI22iFKx9PZTv0JpN3CwI09ujWPUT1kDuKRvCxtLSjxanI1bjEobvlZctgag3g2MF//t4Q4KQ7eIGm4u7vvBtexIIojHqZo+W8XVCzysSbQD4L/2KawQYjo5HBg/1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991263; c=relaxed/simple;
	bh=dp8VyXTYCjr0888oCgwtHXQ7r5/vKbtII0vRpG6MkF0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EtpFL//XqjfAXDsyjfLXntWbqY/OG953eyJj/rqPjGMtkXZH7h5iypPNQuFzmA2GpPJYrwjtnALYdfFji77t83suwFviIrzmDsbBehbhTjuL3uLDaizrCvoc6ZVpBkbA9iw4rTSYxXdn6YuG3/BtH+Jq770e19c2ouvozNWVVmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0Bz+tgh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0Bz+tgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2691F00898;
	Sat,  3 Oct 2026 01:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991261;
	bh=dp8VyXTYCjr0888oCgwtHXQ7r5/vKbtII0vRpG6MkF0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O0Bz+tghKYNgdJNgETuU/RJsfd6hAvzLN943+lzM/yMkMM6ObeM5nhb+0vxXo6FqM
	 EOe5tPdOR4p+dzcl5JCvZ75CgiB8PvsHKygOhytwPWN//5mgQgnGatBmFSLALKVhdM
	 YFCIwUa+hNYFn7Oo2EDOvWCb4LaIHwlcWqTamaLr9kUQaGxJfZNOrLFK4i/aCErc7F
	 Nmu4KW1nGD6veo74k1N4lpU6oTGiO1nsLNEFiMyFPd6iCR1fPEH3XZMoyNLORKcIZh
	 vdQUcjbNmlnnammRD8niFqz+rRzdJm8Q22hf+UfQLc0D5gDG8b/C6oX672oEnew+IH
	 37lKif0barwbw==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 14/21] xfs: don't remove written extents
 past EOF on fsverity inodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: dsterba@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261002223705.2175542-15-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-15-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:21 +0000
Message-Id: <20261003013421.AC2691F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> xfs_free_eofblocks() removes all extents past EOF unless the
> XFS_DIFLAG_PREALLOC or XFS_DIFLAG_APPEND flags are set. This is
> undesired for fsverity as it stores metadata beyond EOF. However, while
> merkle tree is being built, delayed preallocation and unwritten extents
> are used. After metadata construction is done, fsverity inodes becomes
> read-only and won't be changed anymore, none of these unwritten extents
> or preallocations in post EOF region will be used.
>=20
> Let xfs_free_eofblocks() be called on fsverity inode as usual to remove
> anything which is not written extent. However, inodes which are
> undergoing merkle tree construction need to be skipped in case reclaim
> takes place.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D14

