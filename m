Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4486638C2BF
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 12:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788440094; cv=none; b=ZXK0zHDr8cVm+I7EHvXB9n7ptV2qk47ywCwBqWxSOGGHqWZQmL4mdZJIO2UKDStHdbrjlCXN6NYccTr6XpmPkGDXdyddFS7ORblElvUvp/P3Ulu4I9X8y3kfoGyL1KrsbT3GZwrsqOJ1JuTjnsLyYMCzHxqjNH6E50Re4sNIy/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788440094; c=relaxed/simple;
	bh=ieF4RAmjUkOFG6g/hXWzMc/RytV6B9HSb9TpAUO7luc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GCTn+iHKlsY42dikDtMgejrtbXlFYVs4GgkShbxoSbxeJ5AV5O2gwZ048kcyW/haNaUX6HvQDCi88ijsGWgdTGeON+UDZ+A3c9bszG0hl6E/4IwfLSz0p/34nVbDAuU3Q4fWtHPf1wnyoPhEQPwlokV93gdcC4qJNrU6Clana7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMsidBlj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMsidBlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33C51F000E9;
	Thu,  3 Sep 2026 12:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788440093;
	bh=ieF4RAmjUkOFG6g/hXWzMc/RytV6B9HSb9TpAUO7luc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OMsidBljoUJGzpNdQJdzmiAaQLWWZmovOi/OG/1dYn4wetmLzXy9uZuTIBQaDbiwY
	 EgJbsSb3r8GQeq4EfgpFbVnOkfI9wFbtnqlPIJzUT1uJPg0rfFC+7KSMGiecjvsE7F
	 7Nh8JKEud4a4RkGnLd/GZbp/jZx6qtg+WT81xNMQntNMjLJfsgsnYA1DiZW6JIsXE5
	 TuWlyH/aBq2fbF7w+Y/ntapLZgZ4CVnDlJ/+LK09zp1ubIR0GCBY2LckvfgzSlHbkU
	 XNFq51/GrRjKb4eKV4GnLKCc8qj6PUgI6SlSvwKtnZsUCdDA679ss//rzv4sFP9ReK
	 5iMHMpAYPcZTg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 04/31] ext4: set EXT4_MAP_NEW flag for delayed
 allocated blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-5-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-5-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 12:54:52 +0000
Message-Id: <20260903125452.E33C51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Set EXT4_MAP_NEW in ext4_da_map_blocks() to properly indicate that a
> new delayed allocation block has been inserted, allowing callers to
> distinguish newly created delayed extents from existing ones.
>=20
> Currently, the buffer_head caller, ext4_da_get_block_prep(), does not
> consume this flag. It intercepts EXT4_MAP_DELAYED and returns early, and
> unconditionally calls set_buffer_new(bh) so EXT4_MAP_NEW is not used.
> The flag is prepared for the iomap buffered I/O path added later.
>=20
> Reported-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Link: https://lore.kernel.org/linux-ext4/cc05c17d-163e-4251-b2c9-aa3a6f95=
55d7@huaweicloud.com/
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D4

