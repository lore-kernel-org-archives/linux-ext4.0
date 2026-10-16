Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B3B476051
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 10:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792147617; cv=none; b=ibRDUJjkRBFDetHayI7xXxsyH17R4De3G34j3vz9LpQy51OxXeDznzIRLJJOUJqsM85nxVVfJDifxDD8engsCApvEPuqUCM9smKHFN16V71NmX1efk1xoma5AXUSvkgPhwKsVvHwm0BK03Fmmk9AVTlR3EfUIRH6BxFuY/Z+UvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792147617; c=relaxed/simple;
	bh=VEhwMrmN4rCsh1nlSgIc3SGJIlqDBS6FOmEEBHbz9Uo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=sagV48AZBvssyk1av89uTPhUoHKtEaaGFHmO7bst0ECZETMeVdrSi9Zcd34xYMrCaHc3nOdqj4PxlSlI9u0T9WEjpKw224YKjSyplVw0BtjXLyphpzYhmLu7Dzg2eqVPlIMpZKGio9milLM/z4NsIERYJtoMzDctLLvd2+dzG2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8Fz55cd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8Fz55cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D771F000C7;
	Fri, 16 Oct 2026 10:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792147612;
	bh=VEhwMrmN4rCsh1nlSgIc3SGJIlqDBS6FOmEEBHbz9Uo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q8Fz55cdOunlawTBVcvrP2buDo7KOUWM+XwUemRUP76F3VeRiKqGc57w/o32/lVbT
	 01yg4oRMKIBfi56zLreXbLsiKh4+CSfsZ9HtJePVgiU/uyQZhobeTvpXaC6FRARqG/
	 FOgk9rpLEErXN/LSmethnIEWY3QpWbCcfOCtYrKNhe+lhGMLWUDuHS/ey5DLHeESdN
	 EWUoslqOconUnO/QqodtcY5eLK7vJCFcmrx/BM5O7UzZNVg6EOdu1tCksNmiM7TuH8
	 GDSH3Tch+WEnu0RvwX1Ufsw+pS425AFGpXVJBGr8H/HAabX194GSkqfPa+0Dt9PoR+
	 /zLbqThVRstpA==
Message-ID: <sashiko-outbox-174202@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: return an error when a journal block is not
 mapped
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261016103726.98553-1-kmehltretter@gmail.com>
References: <20261016103726.98553-1-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 10:46:52 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> If the internal journal inode contains a hole, ext4_map_blocks() returns
> 0. ext4_journal_bmap() logs "journal bmap failed" and aborts the
> journal, but also returns 0 and leaves *block unchanged.
>=20
> jbd2_journal_bmap() takes that as success and uses the unchanged logical
> journal block number as a physical filesystem block number. Journal I/O
> can then overwrite filesystem blocks outside the journal despite the
> abort.
>=20
> Return -EFSCORRUPTED for a hole, matching the error passed to
> jbd2_journal_abort(). Keep propagating negative mapping errors.
>=20
> Fixes: 62913ae96de7 ("ext4, jbd2: add an optimized bmap for the journal i=
node")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016103726.9855=
3-1-kmehltretter@gmail.com?part=3D1

