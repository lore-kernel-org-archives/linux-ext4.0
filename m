Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5613C76AD
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2026 07:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790841026; cv=none; b=r9WTjWLbDXu6+E+lDZESP2wV3CaCKNLj0uMDdlUiEqd/lURWOUnAVe+mYySsWRfIieI5w+yi29kruB9Y37eVetu/+6fe/1jVF03IUaojP6wQ1guLWWgXgZebPBd1ZeRCXLiYXIrU2kWY3pLN3jpmLhqiXXQtRv+YeG2ITO6AITs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790841026; c=relaxed/simple;
	bh=+B/UQ8uRhmRRYVQDfYB+jLXJxCI+zQAv42/70N4GLFk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DZ4BCCpX2vLmpDt+Zwy6m8SvP2jBSFyYOp0PzhAEhPzGoEsMTe7mr2Sw6CcoIvecKx2hrPQ/0mxvmxzyjgmQuC4RN3shImpLmrrdGpPz0jw02o6BU0eyoyoGl1x6GPS/gInTKdrBmPEdTuQPGRFHvnN+mQmTY1x9XzzX73t+po8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mT3v0Eq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mT3v0Eq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124841F000FF;
	Thu,  1 Oct 2026 07:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790841025;
	bh=K3zpFjmB7p0wtR9SjQPJqN5+iiXp9Of9s3/BIB2feWs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mT3v0Eq7q2m3p3XRppJYwB2SM3PxRQQW2bJ0IPMsgWDWVlo1vxafOfgT4vbHGQLWJ
	 xF2OlBxpaU4WSco2iShh71codpbFsV11J5Q0GGHWHijv3bzJe9oIOpXX2oc3T2v46A
	 6CMy7Rz7nVKLIzhenweERFbXxfo5rwyFy/EfUeEqDlOCpHO4CvMWTlkjXryaKyf8eg
	 e8Xy6BVE0JajwXnt51/FSWRxkqv6Wklj0gTNMoj/28KbOrHbg39Odq3YQdGS8hligL
	 sbUpgEhlfCq8zzyBBobUNYYSIspzR24Ln/S1R1lsIeqZvv1ncp70KuHPWSCnfkwAac
	 kIqpjp7jKJwnQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/2] ext4: fix shrinker scan budget accounting in
 ext4_es_scan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261001-fix-ext4-es-scan-nr-scanned-v4-1-b13703714ce2@gmail.com>
References: <20261001-fix-ext4-es-scan-nr-scanned-v4-0-b13703714ce2@gmail.com>
 <20261001-fix-ext4-es-scan-nr-scanned-v4-1-b13703714ce2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 07:50:24 +0000
Message-Id: <20261001075025.124841F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> do_shrink_slab() reads count_objects() once per invocation to derive
> a one-shot scan budget, then calls scan_objects() repeatedly until
> that budget is exhausted or scan_objects() returns SHRINK_STOP.
> include/linux/shrinker.h documents that scan_objects() "should track
> its actual progress" in sc->nr_scanned, so do_shrink_slab() can tell
> when there is nothing left to examine and stop early.
>=20
> ext4_es_scan() never updates sc->nr_scanned, so it defaults to the
> full sc->nr_to_scan on every call. do_shrink_slab() therefore always
> believes a full batch was examined, regardless of what __es_shrink()
> actually did, and keeps calling scan_objects() until the budget
> derived from the (possibly stale) percpu extent_status count is
> drained, even after sbi->s_es_list has nothing left to examine.
>=20
> Make __es_shrink() report the number of extent_status objects it
> [ ... ]
>   after this patch    239                      1 (0.4%)
>=20
> Fixes: 1ab6c4997e04 ("fs: convert fs shrinkers to new scan/count API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-ext4-e=
s-scan-nr-scanned-v4-0-b13703714ce2@gmail.com?part=3D1

