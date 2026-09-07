Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65605509F18
	for <linux-ext4@vger.kernel.org>; Mon,  7 Sep 2026 15:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788796530; cv=none; b=IR5IM+mk9t2AfpX9PxDgs5tTbzgaixa2Lk3VTz+iBZWk09oPEIW24xa9SebbawbyRZND4qZPP4oX3b1w+0o8FyqxKtmzWJgmOJBLdL6DFI0kBRHOxEowad8PGOBFVBKFwtl4wbrNEgC7jONREq/pz3gJEObjKvuLZjM7/+TXCWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788796530; c=relaxed/simple;
	bh=PqZBFuAuEhMuRQJWtL+VRj3CL51UJ8kO4D+GTBhYRls=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CAIC0YnO+SuPwtMm/CbCINbUooRErC+TgPRJeck8tCp6U+cEfbUMYlfSvWHyABjQsIUUI8L5yT2aEBIH0roDd1u4SGszJTJajHu84bNRr/6h5We8f0zph3PQ7EYxC7fIiw4McYcVoJhHElksQwClgTJjfYBVD4mcvX8njrW6Ais=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iiQQG8Pm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iiQQG8Pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF7F1F00A3A;
	Mon,  7 Sep 2026 15:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788796529;
	bh=QHyft5VhwVcRbnncAggxvLynus7GgxG7yGf72ddUyAA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iiQQG8PmHfwq+3mdxYq+O4UKylQdrxq3aR1oLTeThS7N0gChOdoatBc1337qDevys
	 qnU72oRVymHTKPQpjIlK1UBTh5bkPXsnqdKS1svRkDA/myfCHOyQXFrRml83H+bei0
	 +gcCC4InS9uygb9V2I0i+nvx5gjQscaxz6RVfEPvt7bW4xyih1jZkoccjuv+Bd58CR
	 xIbH4Qkk+oBdAVRHi57XV4KaTSu68rmTiwmdUhuD7HpZCARfdtayWaoW4B9/yP1263
	 rvEYAWXMF57NJ1akctOLPaDWaYUPW4WeC5DC05KAptt2z0I51O3wRRbHw6+cGngm8a
	 y0fE7s7WBeuFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 v2] ext4: avoid buffer/folio lock inversion in
 __ext4_get_inode_loc()
Reply-To: sashiko-reviews@lists.linux.dev
To: ThangNN99 <ngocthang2710.1999@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260907155017.75543-1-ngocthang2710.1999@gmail.com>
References: <20260906104841.56075-1-ngocthang2710.1999@gmail.com>
 <20260907155017.75543-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 15:55:28 +0000
Message-Id: <20260907155528.DBF7F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> __ext4_get_inode_loc() looks up the inode bitmap bh while holding the
> lock on the inode table bh:
>=20
>   __ext4_get_inode_loc()
>     lock_buffer(itable block)
>     sb_getblk(inode bitmap block)
>       __find_get_block_nonatomic()
>         folio_lock(bdev folio for bitmap block)
>=20
> whereas block_read_full_folio() (e.g. userspace reading the bdev inode
> directly) takes the same two locks in the opposite order:
>=20
>   block_read_full_folio()
>     folio_lock(some folio)
>       lock_buffer(bh in folio)
> [ ... ]
>=20
> Reported-by: syzbot+03afbb29537f0336b7ad@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D03afbb29537f0336b7ad
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: ThangNN99 <ngocthang2710.1999@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907155017.7554=
3-1-ngocthang2710.1999@gmail.com?part=3D1

