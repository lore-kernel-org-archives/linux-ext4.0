Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26B14A6CF0
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788440556; cv=none; b=YAQx1vEU3OITWH3vW0lWx4gzYzB+M1wyfkNYWWmfp2/oFQuq87prH8Efhxj2KPbFjgY0ra0vbuEntsjaoBY4gRlyL0rcD7SzYk/0fzSJ5VEduNy6nYgqGq/OXaVN7fLesYNcoVTEx34SGSlOXYnWUnIB4zoPJCB44zzS+BDq/cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788440556; c=relaxed/simple;
	bh=1YC/ilksJg4wyJJZ701Z5qWOqr/ISb6YJ+zc/trmJZ8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tp7PoYjp5oiwUd3tcqkewNC0GCara+6w777zi/JDanvpgtkLVe3H3nMi8ONvPlb0+tYSL17JAKk1hgd8ffBB6P1u3DAZNhcrCoCM9KXnwBnk314BYXOG+pYoeeB6233IwahbYCr5b1IFhH0iVTtz//9YKDM0R+5lJ9NmBAQ9Z/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzkDrmn0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzkDrmn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0E21F00A3A;
	Thu,  3 Sep 2026 13:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788440544;
	bh=1YC/ilksJg4wyJJZ701Z5qWOqr/ISb6YJ+zc/trmJZ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mzkDrmn03upuI5KHGFPNFqFm6s0wv01EKEuqQonPyTsYIfpVfRGktr4bw57uUvygZ
	 Q38JUl56kcqF4z4KrItgFT7mPsQT6qvpDQAFEWy4yV2Tym2180GvewNRl/PofVsb+s
	 b70o6Qh6N+2dk2s0v4x/M9I5LT0yoeu6/CYv7d0xmZFgLETKaodeJtav3x4SICMyuK
	 7zd0TcaolI2ARKMMe05NXpDPzxNWwZ4V1HVXwFfpL0fysxnaAK97bTrhRqU9VPVU8u
	 GvpUJXKIC2AE0IPoAJ/OLtx/6ciivuOhcG7ALs+l7mhLxFyORFnm+TchPUc6eNP2ah
	 QdH6765PyqHVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/31] ext4: allow ext4_map_blocks() to start its own
 transaction handle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-8-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-8-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:02:24 +0000
Message-Id: <20260903130224.9F0E21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Make ext4_map_blocks() start its own transaction handle when the caller
> does not provide one. The handle is started after the lookup path
> confirms that allocation is actually needed, and is stopped at the
> unified out_handle exit path. This avoids unnecessarily starting a
> handle for pure mapping queries. This prepares for the buffered iomap
> writeback conversion, which improves performance for fragile overwrite
> cases.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D7

