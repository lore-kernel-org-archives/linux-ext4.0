Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12E22DCF57
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 10:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792145402; cv=none; b=N1Mtd5rmeD4aX5BkYx+HWzC/R9ih6JfRuaCzSAsFFPF3lUvdmLWrGbFQmHAm05690r1NuZ6S6kOXzFqK689ZBHqxM3Oxska/pHsbE2PR4IX+v5uDuMr07PWALDv1wlfKJMeWscS2roVW8N8+A7FzvDjROuj8UA9bxq7cSP+4CPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792145402; c=relaxed/simple;
	bh=7mtaB0XTjJONHrqLzWfHwVkAG6Aj9Hmm2/Wz9kFXV3M=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=gElrgtERyzQuvtn52slD1ElLuQTW2ChSaHBdgi6sfVHJHZMEfSssnBwXZbQM1fcY5BZ4ak9HGy74q3wO5472HzfKf+/DyV7aWtYTB128uFEjT3h2EBMToo+X2G9A4UjXSPMklwpvr9nzmSZHeyQhIjrZrz4RopX/3PZKDXLan28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ixs1GVGp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ixs1GVGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DA81F000C4;
	Fri, 16 Oct 2026 10:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792145400;
	bh=UQR8f2EJDBqgSx+akpiwsM8oqoEgOgeRf9sbZ1QxRHo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ixs1GVGp6TWR96tuSKAFLpm4Xq7JK843Po44hkUmicoNt8wR26dvmf+PIVSYiWpdi
	 gnD4yJ6mqV9Us5LwOn0UKRBGQfylUJfLb7vVdwi2S7dTwlL/bra+bg9CdsqaRT5q84
	 IpIoM5WW4279Wk1PCi6ENo3Xt6xdMy+im9sAs1asBNVmX+dtts+TPI+/svF8HT8MMN
	 SO8SnM6RuBxHaCxTPjIc9pvxmrNa7dYtriGo33iVzWWUq3MzlAca5QbJdnQ7YZm7tL
	 ewSQ57X/nGBrUdRwP6fWnTaU1fn28pAxOr5a2fEj6JJ2ryZPB9d64m2CV4cJl7wlR9
	 YoFmWu/wy5u+g==
Message-ID: <sashiko-outbox-174126@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: return 0 instead of stale ret in
 ext4_iomap_writepages()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261016095927.1762656-1-yi.zhang@huaweicloud.com>
References: <atHZN9YIl8T2E0tK@stanley.mountain>
 <20261016095927.1762656-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 10:09:59 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> smatch reports a "missing error code" warning:
>=20
>   fs/ext4/inode.c:4518 ext4_iomap_writepages() warn: missing error code? =
'ret'
>=20
> The 'ret' variable has already been consumed by the ext4_emergency_state()
> check at the beginning of the function, so its value is always zero at th=
is
> point.  Returning it is equivalent to returning 0, but it is misleading
> because it looks like an error code is being propagated.
>=20
> This branch handles the race with ext4_change_inode_journal_flag(), which
> flushes the dirty data and drops the page cache before switching the inode
> to the buffer_head path, so there is genuinely nothing to write back here.
> Return 0 explicitly to make the intent clear.
>=20
> Fixes: bdcbb0f19e92 ("ext4: partially enable iomap for the buffered I/O p=
ath of regular files")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/r/202610160314.PLMEXaOJ-lkp@intel.com/
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016095927.1762=
656-1-yi.zhang@huaweicloud.com?part=3D1

