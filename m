Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C86A42B310
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786701659; cv=none; b=af2ozciWdtffOS+XnMlG3fA7nKV0fXWfbUi0cJniqH2tDqkVucUaPdA8xPKa9eJi0Js5/Y5SYimK9LVutpWrd1b3Xj2gpOZdYKYcblXNXiKKZncG+noi89aWDNU9SEyhFkFusrs3+DzXvjqw8KIHrLym7hcxrI2UiNWb6BIxThY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786701659; c=relaxed/simple;
	bh=xMqNWa9P2vCM5Q/01tUoz8V3e13UMDHB2VeefztLAio=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pnEFQdTvTGbZCoX6wN6NLOlVUqxYGqNm1maUsx895+cGB9CJTaGyepF5J/MXi3IjecWMtKA9RvFuoK3b/fWmf4tNg6yTjdEvq+2lwfOdZEnDCxy+2/IEHNCMA3ozUoz3E6PovIbFn+Ctp6REhH8AADt10KcGou7qMwt9pD+Vgek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8yTDE7f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8yTDE7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5506D1F000E9;
	Fri, 14 Aug 2026 10:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786701648;
	bh=xMqNWa9P2vCM5Q/01tUoz8V3e13UMDHB2VeefztLAio=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J8yTDE7fUbVgSjZBjpZMoab19EAsU8we/90snPUMJ0CYpES7hMzjkD/coZ0YPQ32O
	 o7BcTupo6UGv9t8ZcZ1ErSwhbSZwfAo2bcFDeeGZONmqvl6ED8KKePESP6+b4Fy4R4
	 9EVIic0yw50k3IcYp3XjJ+t1kNRU2yobTz7blDqxEbiTAkeXb948oevCIT2ktBWkPY
	 0TF5KXD7il8baQGEllqTN+rwlTOt5v4Y9q3Nb52uRRypWgxfGaYHTU9o5vVH/HOi0f
	 8rOX6VuDYJDbOtCDxxoSZy3Skv555QrEaFMrRzJtbBInY2egZaP+eTfGpK78CLZXii
	 AT3ua+vnbw4Mg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 08/32] ext4: allow ext4_map_blocks() to start
 its own transaction handle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-9-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-9-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:00:47 +0000
Message-Id: <20260814100048.5506D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Make ext4_map_blocks() start its own transaction handle when the caller
> does not provide one. The handle is started after the lookup path
> confirms that allocation is actually needed, and is stopped at the
> unified out_handle exit path. This avoids unnecessarily starting a
> handle for pure mapping queries. This prepares for the buffered iomap
> writeback conversion, which improves performance for fragile overwrite
> cases.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D8

