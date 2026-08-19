Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D695B2E888A
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2026 06:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787120246; cv=none; b=jT6akjZKsN/jmA0CJtJPBVI3NExYcQtmJg6NOox9ElLrqt5t19VMaWgChMelB+juQEXWMLayQrJisBsLPIfxkxRuUpJYHjMw6rWegPB/0tACk8Q6v01DqkKL0JpKbWbfI4w/iFCrckKL61Ju+yJzo41qx4SBhkWHfVBblHsswYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787120246; c=relaxed/simple;
	bh=/tu/qyfX9CHupPpI46q3xg1S9C9mfN9OGZgSZvUY9rI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TDvjQzKBguqhFsCmph9o4mpggS6/7YwytsTCSQQ0U0av17BUfvfRKMAwMQbpUtL6d9TXD1pcPMx+/cKGUJ8TUkonOwMSKBx7PB1Mvt9mrlbrlaRVOWje5NVc0Xb6/4NTzBCelntj3SApFrONOHXxJ+8SfjnULa6BZr68oPTLEzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AcNxdEnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AcNxdEnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633F31F000E9;
	Wed, 19 Aug 2026 06:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787120245;
	bh=vWY5U4sK8iHwvuxzOng8VC9bYcQlPuSUws2nd+MkcVk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AcNxdEnx/jJK7T0MckhlFsK6gA31kNxAEX2FNm14qgitvklcrBPdTOLip1g6Qyd2B
	 riM6TYEQF2II+45uFRrZkYHMi6LMlhWOQgYKqUHUM/0w1l5+1DPGqhYbKw4J2/ZGk9
	 Yjk1FYHt3hNM2omeaeMbJ9RMWjPCEcBRzu+Fteml3l8OAWaBnRz072OtCtYHYWUAE4
	 9uPV9NJmmJgyoYytZ5g6rXG9Ap7tBjeN0v6tVfaE7xBOeyjI2w4phgLfudHUTpN6Nx
	 LeCrPoHtKeyGnkW0ZPtueLQUjuhsw+PkhL5UErCrkkosSB+nwNt4Qfqy+i/Dknd2FZ
	 6SWoyhVytH4qA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] jbd2: don't advance j_fc_off before the buffer is
 recorded
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3>
References: <CGME20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3>
 <20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 06:17:25 +0000
Message-Id: <20260819061725.633F31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> jbd2_fc_get_buf() increments journal->j_fc_off before jbd2_journal_bmap()
> and __getblk() have had a chance to fail.  When either does, the slot
> j_fc_wbuf[fc_off] is never assigned, but j_fc_off already counts it.
>=20
> ext4 then fails the fast commit and falls back, and the fallback path
> reaches jbd2_fc_release_bufs() via ext4_fc_commit ->
> jbd2_fc_end_commit_fallback -> __jbd2_fc_end_commit -> ext4_fc_cleanup.
> That walks down from j_fc_off - 1 and put_bh()es every slot until it
> sees NULL, so it also touches the slot that was never written.
> j_fc_wbuf comes from a plain kmalloc() and is never zeroed, so a slot
> used for the first time holds uninitialised heap data.
>=20
> Advance j_fc_off only after the buffer head has been stored.  That
> restores the invariant that j_fc_off covers exactly the filled slots,
> which is what jbd2_fc_release_bufs() relies on: the live buffers of the
> [ ... ]
>=20
> Fixes: ff780b91efe9 ("jbd2: add fast commit machinery")
> Reported-by: Yu Junzhe <junzheyu1@gmail.com>
> Closes: https://lore.kernel.org/linux-ext4/7e4b109d-64c3-444f-a5dc-93c2ca=
4576cc@gmail.com/
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819060939epcms=
2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3?part=3D1

