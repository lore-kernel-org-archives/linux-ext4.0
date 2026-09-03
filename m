Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791254AE113
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441554; cv=none; b=UWBrJEag04QK1SvkkV2NgPqrTmg43nfsvzVMxqyq91M+OfmdBPFLuD0eyUnL+o8WPkVdMu0yvRsQK9qusplpR1lvU0a+/39y+bV3tETCkAgRemU8pLsosg0qBy2HkiuUlQiBRVkjJgjNem/yHT1MKShFIv+kpbRKTALiyXUMYSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441554; c=relaxed/simple;
	bh=TQNoDhX6hnz9OPbCgiJ0qnhqMGgeMN50efh6KjcOV+U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cLJ6oxvAsfh+gWWWBvQhUildW9Mwk0R8zoePt6yFagWy7Oc+MtfeyZVMyW8DsS2NS4b2l+CW4cCmdduzltTj5wOSx5rr48+t5vnF9gyJQymt7h07LnamlhUcYKVJc6JicVkdUGcKyrayRvadzWHapJjpGmmjRZko2odT0863/PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+YppW85; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+YppW85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA49E1F00A3A;
	Thu,  3 Sep 2026 13:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788441550;
	bh=a8Y9/aFYWjXsybv4TLmgyJfdKS9eRixgzRKCoX098Nc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j+YppW85RdSlITGOhzbCEGCkCe1w6Noeu2pzQEoskCeQRo+FFWjAGiud7PbCRSrSP
	 hvLrp5wxDLOi8H2aKTm8cWWaLUWeZ88pUHgMWxc7c3N0Fv/zSuuMGNtaJL14ofeLUp
	 9Im2/NBXZ+5W3ZObJ0kL2Kd8vgFyqIfqr+qwTkwczUEi3TicBTAuFX/rPPf69smhOs
	 FXwKEGcV0i4xT+hnr++n9iXNq/OUJou8MMFnwKT+c0e+dLZR9MILLVSDi84hdxcvBC
	 InIODYXgBtfrLmHguIRClFGXip7yrGcED8HQRy2nD3932p2021yq5y5A/+/Bn25/kX
	 rKteUmQVZmfSQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 18/31] ext4: drain writeback before removing extents
 on the iomap path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-19-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-19-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:19:10 +0000
Message-Id: <20260903131910.BA49E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Because the iomap infrastructure does not always create an ifs to
> manage sub-folio state when folio size is larger than blocksize,
> invalidating a partial dirty folio during punch hole may fail to
> clear the dirty state of the affected range. As a result, writeback
> of that folio may observe a hole. At writeback submit time,
> ext4_map_blocks() already handles this case and will not allocate
> blocks. However, when punch hole races with writeback, the
> following scenario can cause I/O completion to encounter a hole.
>=20
>   punch hole                        writeback
>   ----------                        ---------
>   ext4_punch_hole()
>     ext4_truncate_page_cache_block_range()
> [ ... ]
> always maintain an ifs when folio size is larger than blocksize, so that
> partial invalidate reliably clears sub-block dirty bits and no draining
> is needed.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D18

