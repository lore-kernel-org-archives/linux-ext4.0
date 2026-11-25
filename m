Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795593591;
	b=w4r7Zu/N1aX3JwKnT5VYuMjGChQl8Jo3oUh1N/6r5RZAKIy+Ud3uncEtVIqohR+SaTcV
	 lIOocdRMaHjSFHj/IXbSzbj+z3drrPcBWyOLIOYJwni/8NGqJqtPUzITpUG8FZRCLFwqS
	 w/iAZf0msJJsxLV08Yt+V+cD3ZA51GWOyvwsy39NMJpBsiV0qLwFmR2Jo8oNk5W5wk0Lh
	 UvL/lIgEPe+IWPxBbh4IQJl3Z/u5I5+GYCLg2NrTk5BqDHgBagTX23RsB+HOxk6aQlB53
	 qdrIloMzcrWdsNnATrHq4YLEe7shtdoCkuGehejnEvqdCSKHBxL7iSaAQeUPeEgsMag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795593591;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GYDYgIZ/naYVvURhggCiWMNSPVwPpa4G2TukAN2PDjM=;
	b=5ah/1qH4COWAnOJIbRCOzxXooc4qIXLj4jcdLLExssvyRHVbLBLfCaPCgzmUxzhSbJLN
	 YDWdyo6/EMJNKof1EpXrp9Dp7v+0V9p9efuZd/SjIjWqnDXFVK0eMjHJCAiDeBGSY+Ipw
	 sbjxPH0fmVXFyxknbig+C2WAy0Sm2NRqMJz8VEBuIQZKH7o6LakoOPZscUDzla2tpuX+C
	 Ka3pJyg6eE3Bo3i/Y4/ayW13F0TpkMSHp8th/HhCwwF65RD6XUVpJPXh0M9uIA+VkwMju
	 EMki2YQnHeengnqDhNExqxyNmuRKksSjy1JoYxDEqfCZIZItx46tPHvBGDV5mg/U0Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cN2rUWeK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A593D606A31E
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 07:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cN2rUWeK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6011F000C6;
	Wed, 25 Nov 2026 07:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795593591;
	bh=GYDYgIZ/naYVvURhggCiWMNSPVwPpa4G2TukAN2PDjM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cN2rUWeKAkitRSzw68lJoFmcplDirHeofMyys07OzMHKON41o8a97NZNwD+v+DDpQ
	 A0fT/NwhHRSOQKJsaNPdGjbfCuijBv4CFpXlidmsysq+R/kbkgj4Yseb5GAiPGZBpN
	 Sts/W0SpYKlZfZdvy894Li3kpE41xquG0U0zM2abVAsYvnckiHc7KGLZshIUh+INXK
	 IRiJUFrFLsOkAWPhpZ34VnQ+dXBtZeRblGcyy27f1ltLn/waZso00v+O0XegrLfgKE
	 y7E2nBdvP/e7mfP1hbsy1rNbzzhNMr/y7qonlj2w8mw7TooUDvWVMNRKCQWt5SvHBR
	 hiBMJE4I9QSNQ==
Message-ID: <sashiko-outbox-232857@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11] ext4: bound xattr journal credits to transaction
 limit
Reply-To: sashiko-reviews@lists.linux.dev
To: arzuagapozosergio@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261125074616.35241-1-arzuagapozosergio@gmail.com>
References: <20261125074258.34398-1-arzuagapozosergio@gmail.com>
 <20261125074616.35241-1-arzuagapozosergio@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 07:59:49 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Ryuji Hiroshi <arzuagapozosergio@gmail.com>
>=20
> When setting an xattr without XATTR_CREATE, ext4 reserves credits for
> releasing an old ea_inode even when the attribute does not exist. On a
> 1 KiB-block filesystem with a minimum journal, this can request more
> credits than JBD2 permits, triggering a warning before the operation
> fails.
>=20
> Drop the obsolete credits for releasing an old ea_inode. Since
> ext4_put_ea_inode() defers the final iput to a worker, freeing the old
> value's blocks does not happen in the current transaction. Continue to
> count ea_inode references in the external xattr block for the case where
> it must be cloned, and check the estimate against the transaction limit
> after reserving the default JBD2 revoke credits. Repeat the estimate under
> the xattr write lock before modifying the attribute.
>=20
> When an identical xattr block is reused from the cache, drop the
> provisional ea_inode reference unless the block was modified in place.
> Handle both a different cached block and the original block being found
> after cloning. Bound the aggregate credits for inherited xattrs during
> inode creation against the JBD2 transaction limit before starting a
> handle. Add EXT4 selftests for these paths.
>=20
> Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
> Fixes: af65207c76ce ("ext4: fix __ext4_new_inode() journal credits calcul=
ation")
> Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
> Reported-by: syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com
> Link: https://syzbot.org/bug?extid=3D25d45c0bd716f2b794a7
> Assisted-by: Codex:GPT-6
> Signed-off-by: Ryuji Hiroshi <arzuagapozosergio@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125074616.3524=
1-1-arzuagapozosergio@gmail.com?part=3D1
