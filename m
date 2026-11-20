Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190472;
	b=pALnGlTtzACa4TAdMGiNm4HanOeIwptAUo+vpITr9exeQTR32ewxM0mqib4pRaWx80Zm
	 FV3Y9P+0JO3de1mWRj4xPtDVHHmWJSv+iV5d7Yr4dM90mBPkBs4Oy0qjYfqN4HbSGwCS6
	 JcwNtBTkxMXdAqOVYv/JeJBPwr5ZZzYIn5b1RyjTb65aF2ZHFj/zesDt7XIj+eApKJSKC
	 H8hGW7up+GCwTuzXDYPLAMJxe8Mp+rogPOmWS+YA8Bfe3Ye66KI58jkSqGMbt+gP9Ny92
	 j2nsW2VyZhAsABnuz9fHAVP8TD9LtgJscbU5I0zZm1+2Sj9ZaVVNhid0pFylnUXgcWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190472;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=spBkuYGKKr3FS2Wcz1kceTfUznyIHFN1FC3pVzAltRM=;
	b=MknSIs0f66abdUmO0OYyYCq9nBtT2PysPDhbLQwreXCzjnpuqWgwWzp6gDXdX6iSfJdc
	 fnC8yZkW7TFDGPYe9uh6QeiMObvQLbkaYwOjGTH4r+Enu+Gs8wOAOoUsLkWLF1bC/QIi7
	 gPkxE2qzA/HFx+2SIvGpZcay2FcGveMm4eEM1Q2Llz1qLbujpBKj04Ik7kizE+LxismFR
	 vrhpgLE04N+5vy8l42H+kv+4zGja9IeDE/uSKosofPlwp19Q7KuVee/WlJsw303iEwm60
	 p3PStblGfWDp+4ZeMEM6CSZvR3EqF9b6MjPYfkslkE74sVlzIHxS3N/XmMdVQRjSi1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W0Hjpa2U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817BB606A320
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W0Hjpa2U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D403C1F000D0;
	Fri, 20 Nov 2026 16:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190472;
	bh=spBkuYGKKr3FS2Wcz1kceTfUznyIHFN1FC3pVzAltRM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W0Hjpa2UBj081kEXytwq3aTDK7DB1AKKT7370mLs/luMDyJTklvCE22b1MJwOsabR
	 kVn/eWSbAAajBpSOdc4CQx61vmDz/fHjeDfPeKlpR/UmWcbrn2YoGXOSsCf+6bcswX
	 w9ppB272FkD9uesLvk+8gTppTSZ30EePkHM++xk1PT3j74yWxJc0wtJvviF/56BHzC
	 vx0RxCs9rnVDbbZROBJmPFgAGBKVCwImRUAp1nl1qqxAknH2TKPXQZaUsK5W6ZTKjw
	 eYl6sWu8haTVlwf0sXygsl78Vf1xvAFW3xbj5A16TD9U4b8IsiEl5L6OBb7RNvs4pp
	 XDGRUpxvMvOzA==
Message-ID: <sashiko-outbox-225510@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/7] ext4: use I_VERITY_BUILDING instead of private
 flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Cc: tytso@mit.edu
In-Reply-To: <20261120155032.187246-7-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-7-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 16:01:11 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Now that the VFS tracks an inode whose Merkle tree is under construction
> via I_VERITY_BUILDING and handles the concurrent-enable guard in the
> generic fs-verity enable path, drop the per-filesystem runtime flags that
> duplicated this state.
>=20
> Replace ext4 own helper ext4_verity_in_progress() with
> fsverity_is_building(), and remove the EXT4_STATE_VERITY_IN_PROGRESS
> flags. The IS_ENABLED() guard is fine to remove now as
> fsverity_is_building() has stub for disabled fsverity.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-1-aalbersh@kernel.org?part=3D6

