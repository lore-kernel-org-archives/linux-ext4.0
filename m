Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432753C2B95
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 11:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786708577; cv=none; b=SlH8FUslpstdTtqcC94c2myc67wDPiOp/dafdrlTgzwd6ucrAMrYYM4ETGEMUrCgp/+BAPV/fILnVxbu/sDRb0gs2FbYysmSvj84/SXdJSdS83VDEqIDCw/3w62euY4rvB+OP6PN5JWan4rETbiL/2Ge6bF1VWl62ePY+9WpPLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786708577; c=relaxed/simple;
	bh=Y3PhEMyW0cdfEjGpi9m4q6IenmY3PKsiVkBDZ5+EC6I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RKhdvG2opw4911usH8x/f4NVKD5yfufCV/UHRb6tqZoclJf3sYZJRjwzLQaerMp3/I3kDS7d4++gPee6+TP3RZSrwxD25z4gTc0ydPUFYaxpDjH4P7gjC5oW+tWBvjaN2A9LANcTmhNeNOf5dqZ6cqcPJU1osm93YyCyU1Rajpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WV6fDsHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WV6fDsHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECED01F000E9;
	Fri, 14 Aug 2026 11:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786708575;
	bh=Y3PhEMyW0cdfEjGpi9m4q6IenmY3PKsiVkBDZ5+EC6I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WV6fDsHB2uUk0fpYO43lXraeH57zxmJFJC5McmYlp8N5w4NgsH0EtGpR+WKYL9KyP
	 h5aDgYz/6M59NrifH8YfrXkpJiOhOR4PQviW0K6WbDTu/jFpiP+MIvLg3kHYXlDx3C
	 KH1/19V67sKqqrzCensVgbxN61Psh/hOCorNuOluBQmWca3k8zakiabFd1dRhDeXY7
	 8uXKcEUlvWdDO6CrTKfZUpeGp7VDjcO+R+tJIhS6nQEfO47zeZl997RjrsrvJ+RcXv
	 929+k0akOq0cmKmyMe+w5a1rdj0dII4AiQfDkARqob7VlX2K/xM/1z7UKViiho1JLa
	 RqSTzA+KtBIww==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/2] quota_v2: persist DQF_ROOT_SQUASH
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kitae Yoo" <kitaeyoo777@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814114649.51253-3-kitaeyoo777@gmail.com>
References: <20260814114649.51253-1-kitaeyoo777@gmail.com>
 <20260814114649.51253-3-kitaeyoo777@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 11:56:11 +0000
Message-Id: <20260814115612.ECED01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Commit c119c5b9749e ("quota: Don't store flags for v2 quota format")
> stopped persisting dqi_flags because no v2 flag was supported and
> on-disk flags could contain unvalidated garbage. Now that
> DQF_ROOT_SQUASH is settable on v2, losing it across quotaoff/quotaon or
> remount would silently re-enable the CAP_SYS_RESOURCE exemption - a poor
> property for an enforcement policy.
>=20
> Store the flag in the existing on-disk dqi_flags field and mask on read
> so only the supported flag is ever accepted from disk, which also keeps
> pre-existing garbage bits out of the in-memory flags.
>=20
> An older kernel rewriting quota info still clears the stored flag;
> strict enforcement then needs to be set up again after booting back.
>=20
> Signed-off-by: Kitae Yoo <kitaeyoo777@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814114649.5125=
3-1-kitaeyoo777@gmail.com?part=3D2

