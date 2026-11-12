Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794442582;
	b=oi5MEhEJuZBI9FomfOzssfl94zQOua7j4ks/2capvZlV+QQdV6G7Y6/OEfbzDJr6kyu7
	 h73la7b+lvnbqjlbu66fesNnrto6YFtazEl77pFFExkKzFny9AA+yAxigg9ko7VJFjann
	 WWI3GZEWUhRYSsvY8M2U+IqtY7mlas05/9IJfGy/jtGOs4WseRFfdlwrZhpeLewMA2gSK
	 9Zc9a6ntnl35GP3rNJGqZLrFO0zSuyMf3B+wp/GVL7UgZpQ6zYOlPxNzqpmlbeMVXN076
	 ILSftgHcwUsU60OeMD70RiIiRleyZwn0aYXFV+IfQuuL9JOxicZKVIgfAHAaOV9wfcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794442582;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gA0M5/vz45WOsMC7JBXyQ5vSrZtJGoYXg1Vm9b3DhHo=;
	b=y4GZ5PFRVD6P3rFkcC+8uV/Al4XiexFQHo9d6e6T09quMGwEl7NTHkBd12Hdpi6gjM3g
	 MOheB1GTg9A0IAOXicSwH4OwdivTUiKem0caJFmP6Gp46b2URrvNiU1FTgp/8LxidCgVJ
	 zIBINGJJgT9orsGGmtcowYwQm22mwYPn0NDZRKG+GgdK9fLz1fnI/fyjRvJudvn2LbQK4
	 j2mmNtulKOvjJwvlUpf4TDXUQFGpzK17c2pwm+g03pWQfeOWZcg1HKmD7qTS6rathX0/x
	 13AsxgObq5iOuRwUfCavaUlBj6xQpU1yf7lhyTJP9w7RbyyiYQ2+Wd81KQAlVHtX/VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QtJHvIhs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C6B606A324
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 00:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QtJHvIhs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA811F00A05;
	Thu, 12 Nov 2026 00:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794442582;
	bh=gA0M5/vz45WOsMC7JBXyQ5vSrZtJGoYXg1Vm9b3DhHo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QtJHvIhsAMsYhbNRq4QPP/oW889/RdiyUY98VJ2tGokNso1PmSBQT+8neef+b3R1h
	 0XLwTHAO8dWWRf8OA0Ilr1f3JHeOFwOeNTFvXqgv+/pVW7XKUir+qWW4wghdysK4ju
	 phDtwVUdfpWAcX817ZUy02928ZBUnZiKTvyRpgEkWSpGpy1izCSaNI5NglNPWr8RGv
	 kPnS2pBsaDu9Ln+fTwnpAl++cOUPD6dVhjBO2RbP8EmV94HkO6YfU0wjIEhhPghaOH
	 6E8OM8RJe0gkOtoU3L22aD81vThjZ2aK8ib/ehkFSGC4Ey3bQbCH1qWxCyTrip0PsF
	 QtRrwLHL3tc5Q==
Message-ID: <sashiko-outbox-209891@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] ext4: fix directory link counts after fast commit
 replay
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mani Tofigh" <mt4022@columbia.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261111-ext4-fc-replay-mkdir-v1-3-4b20be29aed8@columbia.edu>
References: <20261111-ext4-fc-replay-mkdir-v1-0-4b20be29aed8@columbia.edu>
 <20261111-ext4-fc-replay-mkdir-v1-3-4b20be29aed8@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:16:21 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Mani Tofigh <mt4022@columbia.edu>
>=20
> After a crash, the fast commit replay of a mkdir leaves the new
> directory with one link and its parent with one link too few.  e2fsck
> then reports:
>=20
>   Inode 2 ref count is 3, should be 4.
>   Inode 14 ref count is 1, should be 2.
>=20
> Fast commits don't track directories, so the replay of a CREAT tag has
> to redo what ext4_mkdir() does.  ext4_fc_replay_create() sets the
> link count of the new inode to 1 even for a directory, and nothing
> counts the new ".." in the parent.  The replay of an rmdir has the
> opposite problem.  __ext4_unlink() drops only one link of the directory
> and the parent keeps the link of the removed "..":
>=20
>   Inode 2 ref count is 4, should be 3.
>=20
> Give a new directory 2 links and count it in its parent once its entry
> is added.  When an UNLINK tag removes a directory, drop all its links
> and one link of the parent like ext4_rmdir() does.  Both halves have to
> go together since today a mkdir and an rmdir replayed in sequence
> cancel out.
>=20
> With the fix, e2fsck doesn't find wrong link counts after the replay
> anymore.
>=20
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-ext4-fc-re=
play-mkdir-v1-0-4b20be29aed8@columbia.edu?part=3D3

