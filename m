Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39293B3C13
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 03:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789616226; cv=none; b=qTGM/FQZv6j0u8WG6dOZS8i4hAC4qBwBy6vuN2/mMe/KPnbd/zgOExdQanXm2fzQyvoEXRYqlFf5aikagA+aUpu52axA8XgXyvsHVW/JlGLagGX8maJAxB0OZy7U8VNnLKXsXZLN6q9baUq+uXqr5rHXRYQuj+EtsquzBAugKeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789616226; c=relaxed/simple;
	bh=7Z8oxXTU5aQdKP9TAHDxXPxh0Spp287jyZ62I2AyLYY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RnHLK1Cpb+5uoVcJV7eGSUWkPXYfT5O/akyD1mT+aAxCtiz3q/8/7J9qkGi8P4KCawmhecgJYqtFFiTNQ1WDLOQXX6hfsMLKlFl/SLrfTLi+RfvmE4WilqaPuUF8c05Y9qKTvahQylzMqLr14CeoFOvbzmAI0WaVCpsdIyyOc0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHPKIF1B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHPKIF1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351E71F000FF;
	Thu, 17 Sep 2026 03:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789616221;
	bh=8qoCHCl6nefAwHtPHVidXLWdq36YGk7BYQTJuccPQ6s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CHPKIF1B9bG0tYh3nU7nagLCeP/JrS1Bj9vjZjtihy8aBGR0q3AEkSHPC07RTsiI0
	 n1/9VJX5wavn61/sclsvvQ/OOIBWISCZ7kwdUTyzpkgSYk4EuPvnTfjfvUi0cJSBqh
	 JHRj45vMoqxLd056qPh5EwjiZMOzj+n8Wc8soebIgelrqRpSY4tmBPWbyO+oCIyLhB
	 r8VOhmvYFGywzRiZIXtWjWk8XTV0H2iK0susTM7OT1twYI2IIMjZGgZcSAVVzXYrDC
	 yJUE65/FV5LkIobbhEZN0ZrCoNyWQZfOuRwoznIlOC0EccpMoh49onJ0QhQH6eIsJX
	 QqIq1JbXJ44EQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: propagate errors from fast commit create replay
Reply-To: sashiko-reviews@lists.linux.dev
To: 781735889@qq.com
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <tencent_46A95D4281B70962D6EC1D523A85C448DC09@qq.com>
References: <tencent_46A95D4281B70962D6EC1D523A85C448DC09@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 03:37:00 +0000
Message-Id: <20260917033701.351E71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: lty <781735889@qq.com>
>=20
> During fast-commit replay, ext4_fc_replay_create() can fail while
> looking up the parent directory, initializing a new directory, or
> dirtying the replayed inode.  The parent lookup error jumps to the
> cleanup path while ret is still zero.  Errors from ext4_init_new_dir()
> are explicitly converted to zero, and the return value from
> ext4_mark_inode_dirty() is ignored.
>=20
> Consequently, replay can report success and mount the filesystem even
> though the directory creation was not completely replayed.  A failed
> parent lookup, for example, leaves an unconnected directory inode.
>=20
> Propagate these errors so journal recovery aborts rather than completing
> with inconsistent metadata.
>=20
> Tested with QEMU fast-commit directory replay and injected failures in
> the parent lookup, directory initialization, and inode dirtying paths.
> Before the change, recovery completed and e2fsck reported an unconnected
> directory inode or inconsistent inode metadata.  With the change, JBD2
> reports recovery failure and the mount fails in all three cases.
>=20
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Cc: stable@vger.kernel.org
> Signed-off-by: lty <781735889@qq.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_46A95D4281B=
70962D6EC1D523A85C448DC09@qq.com?part=3D1

