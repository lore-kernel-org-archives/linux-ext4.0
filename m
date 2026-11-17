Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794958812;
	b=kPx11/54RCtVz23sW3kxSZ1JxSBHkrzurg6RPERndnwACV7hffJN/eWxEk6gj8xvcb6A
	 s3adD6if2KKKQXs2+bUo4luCgk2E/O2tS+W1hU5vriDcLhqIBpN9v0aFA5Hq29DCII9qU
	 v0mqVPoEYogySRH2YAzSDYyWR6rmhF7sxleI1OEz4gsAdivDdqRKVgda9MIEcOiPT8ffY
	 j3Vl+QQ1HyM3Cj+yxNG+12zTz4+/W6w1LmQ2+PuEzyO37IQ0sAXY05Xga01b2jhvTH8Zy
	 hVUw++hV7k3Pgvtu8Ab1M0KEyoj504EUeQKASByUvMNnOV3Twu0nAo9AeErk77HxCMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794958812;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vwVBKvTccgd7UAm1yGKTGpbQ7krn1ALZBwlKaNuQ8jE=;
	b=yYOkkqrN+HaKTQBxmgXrEalIB9dtiOYITSeaXKZi7sCXiCXk/w3ATF748Onkcz0qlf4s
	 L9fuWPpqprClELZF77qJ1X9WPguOZfbT/QRGEAW85Gb0w0RkAtGUOl5czkY7FPXGx0Ltn
	 nrjGONT+oUa9GydSuYyYH+lklbwJrO5t6JlIL5omjLdOl4kicfCe+4eHRRr77pD1NkIbX
	 yfPk/2+V3TXSTlKmDSR+V0ecfT+ZzJKsSEw50yE4BVdfz2kOov1X2BfAvCCmzIL0grIO3
	 ka7mZx4mP1eqlaM7OVz28q6mMXm+ioMlH+XnxPHxcwm43p48gAV2EHgPrc3hgp+l5kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I8uHtv3h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE97F606A32A
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 23:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I8uHtv3h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44191F000C4;
	Tue, 17 Nov 2026 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794958811;
	bh=vwVBKvTccgd7UAm1yGKTGpbQ7krn1ALZBwlKaNuQ8jE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I8uHtv3hy8GHHyuKog4d4+EhW/wUBmdcK37OkuVnMiC3UPRil6O9qzio7+uRxsLOk
	 O12Nz0WchoJNbJgfMgnus9RbHqOkg3nVlRgr80D/xYNDBE8sksnPBCaVRzErVW/dJ3
	 FYxpDizPrbF8IavEaOyR/EbjrH7mKvzkpCy2QIOoPP/RVniC7gMNR1WYbB8CHlKPE1
	 p2IUcg5GzNw52QdnAAt4hnlDQ4RIMfjX/NsJSL+hs0u1VppT0plQJ6568jmGe5vr1O
	 37AwDlZyRbazlyFa8KLWOn3u22gO6FC3rn8lyt5KvQzHyOgoCC9FqPeNoh0w9Um1Tu
	 /10JMEyJwJB/A==
Message-ID: <sashiko-outbox-219803@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: fix race between inline dir conversion and
 folio read
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sandeep Dhavale" <dhavale@google.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261117233208.72628-1-dhavale@google.com>
References: <20261117233208.72628-1-dhavale@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 23:40:11 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Commit 90f097b1403f ("ext4: refactor the inline directory conversion and
> new directory codepaths") moved directory block initialization in
> ext4_convert_inline_data_nolock() into ext4_init_dirblock(), unlocking
> data_bh before setting BH_Uptodate.
>=20
> When block size is smaller than PAGE_SIZE, multiple buffer heads share a
> single block device folio. If a concurrent read on that folio runs via
> block_read_full_folio() while data_bh is unlocked and not uptodate, it
> locks data_bh and submits a disk read for the uninitialized block.
>=20
> Because ext4_init_dirblock() initializes bh->b_data without holding the
> buffer lock, the disk read races with and overwrites the initialized
> directory entries and checksum tail, corrupting the directory block:
>=20
>   EXT4-fs warning: ext4_dirblock_csum_verify:375: inode #...:
> [ ... ]
>=20
> Fixes: 90f097b1403f ("ext4: refactor the inline directory conversion and =
new directory codepaths")
> Cc: stable@vger.kernel.org
> Assisted-by: Antigravity:gemini-3.8-flash
> Signed-off-by: Sandeep Dhavale <dhavale@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117233208.7262=
8-1-dhavale@google.com?part=3D1

