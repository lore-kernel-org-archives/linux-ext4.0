Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B20632
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2026 04:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788063905; cv=none; b=Qr63atx78zJe1EpC0gePltGiOA3FMc180FrcOsc9/nLj+6fypSHeSboPKbQ96vtjyVvK83Q5c3tvjzxFE84go3pwOO48uruAoN/rh7LaLWKa6wsLNU4NJ/xigEcJmDll58yrwkZobP7UL5U1X+kBEl1fOORY/AyfKdIIPMnd8JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788063905; c=relaxed/simple;
	bh=u2d2H54FmwEQLqrAH2pHq4vBpF0rGR2mFhBuqJrpvvQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CL/3kKs2ohzS4mqrmmLMbMIneDFS9DhXNcuPvw0dJTUkQo0OtiJ9lij50ZGWwNkE0It52a42Fi2yPDjj3nqpIWC8JG751T5QPv6FAp2K6jmkN28WOCSQLxJBgU/lRqTx71RdJ51ztxF6xj0nMfZnOC2nWw4FoevIkmuonHmjkHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajRB6zXW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajRB6zXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5511F000E9;
	Sun, 30 Aug 2026 04:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788063903;
	bh=ddEVq6c05SAzvxf5AxrKcrwKyh8FhnW/4yIIlDNUIbM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ajRB6zXW2nd6GHA0Xr7Ug3eWv0eEyw9mso4HjpxUamZvCiXFm+Zj+ROZecL2TLzry
	 h5QzHTwBkYUT5rQnNFKWFkITWfBPbYm4PElG8+jNrXu435r9VJU4JSg1rWU5Y8YeZ2
	 RJYeMiJSOM2xYGZWQT5xJc0y3q8qjHs1sUwq3rwTFyQDvHmIJqsMRVrNQC54qQhtef
	 7izLzZaB67rr6FPF3BcrdUOJfnjq0U5G++Z84Ea4tmy2GVsBg3TDZxmtts0FUkhwmv
	 /wFo4kFA16nXn4gMIRTQsCPbX6DJDayLELrly6VOJmzLddqR55YGTNIstHDzAVo4+O
	 ltMwuO9tNJaCA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/9] ntfs: Remove redundant FGP_NOFS from
 ntfs_wof_collect_dest()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: "Jeff Layton" <jlayton@kernel.org>, tytso@mit.edu, linux-ext4@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20260830041901.2668-7-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-7-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 30 Aug 2026 04:25:03 +0000
Message-Id: <20260830042503.8B5511F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The flags already include FGP_NOWAIT which prohibits all reclaim, not
> just reclaiming from the filesystem.  Use mapping_gfp_mask() instead of
> GFP_NOFS as this will preserve flags like GFP_MOVABLE.
>=20
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260830041901.2668=
-1-willy@infradead.org?part=3D6

