Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FBB344DA0
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 02:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788402215; cv=none; b=IFtG5sBqxHh9HpoZs8FxV7CSfIoC13XSCaAViRcBBdVCSN0hnKZxUEO6YIUrLG+u8kkPM7dJsC6Ycq+9+qm6FF7ZubKaZ/JnhvzbRr2xfJJX+4Hlb65ZsnL3qTz7FYzNQdYCDovbScngp8C8p4wg4jAjmKYSi1Nj2QtrmXyj2QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788402215; c=relaxed/simple;
	bh=kQwD1zOrDnHSVKYV2ychBaOKVb2gfKy15sYwkGwGc2c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ILx29P2KOko5q6uQU0Mn9dw7+4kNd5JLpJK+UPenweA3KzrjixwAG4TiLSxYimClMfZ8YqgNSgCPzb1s0MUHj4uUlNRIKszW7Rv5y9jAlu9Ld3nWMKGaRt9GuPt32P/zIJHe2BhASVlMx4JNSuXlLr9lRRsQq184VC/71Nu6tY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QcppnAB8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QcppnAB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335811F000E9;
	Thu,  3 Sep 2026 02:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788402211;
	bh=ge3KriVRvJ/H/37yU2E9wS1Y0lqq5KOxqVSDXcFkKCw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QcppnAB8xLSvbbNEaRaw0/d61UxNWMPTI5kf1w8ONC1pNARpCYL5BYxVPk3a6XO6+
	 H5IdEqjtQ5EiSYPpZaQBvKAKbheOCsaXev+flGEQv3e/45NXEj9PawTYuUDya56oiP
	 DvgSeyj+QFa6mWbL7laPN+gX7PHNL3RF+B+qtkutv7WUws+88ZirF/rpf5FS1DJvvw
	 uqxsgKcsfd331cOM1AxGK9vKtOtrc+MNxyNPv87DgCnZptjMlY0X8zAi7iI5v+FHGM
	 VvIg8oEqdLpgS7XXmji90JmOG611vPRfQcChNY6f3mt06wqawEWG19KpAj9AJpJ3x7
	 ZtIi5O38jan2Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: isolate s_orphan_lock from read-mostly fields
Reply-To: sashiko-reviews@lists.linux.dev
To: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903021836.962624-1-jonaszhou-oc@zhaoxin.com>
References: <20260903021836.962624-1-jonaszhou-oc@zhaoxin.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 02:23:30 +0000
Message-Id: <20260903022331.335811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Jonas Zhou <jonaszhou@zhaoxin.com>
>=20
> s_orphan_lock is modified by orphan-list operations, but currently shares
> a cache line with s_journal and s_ext4_flags.  The latter fields are read
> from common ext4 paths, so unrelated accesses can cause the line containi=
ng
> the lock to bounce between CPUs.
>=20
> On a two-socket Intel Xeon Silver 4208 system with 16 workers, throughput
> improved by 4.6% for stress-ng.dnotify and 1.7% for stress-ng.unlink.  Pe=
rf
> c2c showed that HITM events on the affected fields decreased from 3,699 to
> 3,125 (-15.5%) for stress-ng.dnotify and from 1,368 to 571 (-58.3%) for
> stress-ng.unlink.  Remote HITM events decreased by 45.1% and 65.5%,
> respectively.  The journal/flags line had no remote HITM events after the
> change; the remaining remote HITM events were on the orphan-lock line.
>=20
> Signed-off-by: Jonas Zhou <jonaszhou@zhaoxin.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903021836.9626=
24-1-jonaszhou-oc@zhaoxin.com?part=3D1

