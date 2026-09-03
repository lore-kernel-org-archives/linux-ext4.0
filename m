Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92778311597
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 10:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788431118; cv=none; b=ZEBZDP84ftRQjjB/ANB5cs0aZuh8YVYBdaS+icTDlnqjqSrxY/W9fBmNkSZDaD3kLV1PchW6F75suGHFe7JC2Xm72MygRfwe0KwGOYQVXVZ9vSTe8+OTM878mQl6rqO4+NdtcsmoC5auaMm5X6Fw1ml1IAIVh4P2Wab//U2sd7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788431118; c=relaxed/simple;
	bh=yADuUjFH9Opq1Uy1INKcHuvSdQqGYURUHX715PyHtkk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a1GYL4+4dpmiAUu0YsuJIE7rTVmRSwk/DfsWBq3i6N2M6EmM9KYiabJK6017K3UpFncBYozu5dtmMr/XX54V6/eQQXOW1sD4MnOnuIX+xhZvvOhOjpsEiT/P33/rKCw3tckESVbaKSTXn5Prycvagn8nKeq/u0Thce0/dderxy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SI6GvBzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SI6GvBzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA8B1F00A3A;
	Thu,  3 Sep 2026 10:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788431111;
	bh=jWA3EI3v3nFAW/ZB3br4qIpmRwQIMR1Ci2wVKDsCEF0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SI6GvBzxaNbgxuOlV5rt6lojJDM9oEAvJXU5dyZHmF/NTe/gUQCh1TZ/WoTGGl997
	 9KilY2rtBio9aAdYunS4/RE8OUHeONytCcc/8e9WelpNbx31BU68pKlkDhYNH20obD
	 A3dMu4cDrQrzdSxPO6XQn4cRL8Pq+ktl2HktXUQxYhLbxXUBrfqrw3JVtRJjo8Xt7N
	 KkaneR8EkFLyWwjeV84P1s66Xpy6k6dmqh/rMfjcWmT3TGhyozlkrQK39weac2RJnJ
	 e4P++YEZuE4OaQ9VVNxMmyT5iYcd2xFt6jWFpWEmPESDBJPGnpYB2cmXjsYNXs7j6o
	 vB+qKKDJ9bi3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] once_lite: Simplify condition handling and fix context
 analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marco Elver" <elver@google.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903101843.3462767-1-elver@google.com>
References: <20260903101843.3462767-1-elver@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 10:25:10 +0000
Message-Id: <20260903102511.1CA8B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When WARN_ON_ONCE() wraps a conditional lock acquisition (such as
> down_write_trylock()) on architectures relying on DO_ONCE_LITE_IF()
> (e.g. arm), Clang's context analysis (Thread Safety Analysis) failed
> with a false positive:
>=20
>   fs/ext2/xattr.c:825:6: error: rw_semaphore 'EXT2_I().xattr_sem' is not =
held on every path through here [-Werror,-Wthread-safety-analysis]
>     825 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xa=
ttr_sem)))
>         |             ^
>=20
> This happens because DO_ONCE_LITE_IF() branches on __ONCE_LITE_IF()'s
> return value (__ret_once), creating an intermediate branch merge point
> where the lock may or may not be held depending on whether the once-flag
> (__already_done) was already set. Because the merge branch condition is
> __ret_once rather than the trylock predicate (__ret_do_once), Clang
> cannot reconcile the lockset at the branch merge points.
>=20
> Fix it by refactoring __ONCE_LITE_IF() into an unconditional
> __ONCE_LITE() primitive and redefining __ONCE_LITE_IF(condition) as:
>=20
>   (unlikely(condition) && __ONCE_LITE())
>=20
> This simplifies the implementation, short-circuits evaluation so that
> __ONCE_LITE() is not called when the condition is false, and ensures
> that DO_ONCE_LITE_IF() only enters __ONCE_LITE() when __ret_do_once is
> true.
>=20
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Link: https://lore.kernel.org/all/20260903072759.GA1750084@ax162/
> Signed-off-by: Marco Elver <elver@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903101843.3462=
767-1-elver@google.com?part=3D1

