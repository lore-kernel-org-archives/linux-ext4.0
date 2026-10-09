Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99394BD7B7
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544785; cv=none; b=dSaVnzfDWo05NWh0I9UPMWKOIfpccceYAvN7NGNxns1e983riqFHZF//OgWFe+G3oRGBHOkdQ4i80JFQcVvZyAke8v9d5WM8043UimknBkU3Wh3U0ZglHA+QK2tHAwQOi93QLr73CFSxkEJWC6wB3nD8jcRVi5HHtchdb0xCTSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544785; c=relaxed/simple;
	bh=XXkIrcOq62YYLvlZUJ1LpGt3/TrzKuG2tqsLGAVyYjc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=qDZUtTH1fbfmE9AUKytQuEkcnX6LYL8mKZQrwbISNAQeZ5JnpjnM6f7H7Lz3lEFzgEkvQo3lZeJBUJThjVTMcc+LtUMLq57CWaJN8yrDN4AO1YHDN7vf+m+iMZs8LeVCJXplZCVV7OjGLwCP0n9Nu4pTIoriJYWHyeW8Lwkj55w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2v7xRCM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2v7xRCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644701F000FF;
	Fri,  9 Oct 2026 11:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544775;
	bh=XXkIrcOq62YYLvlZUJ1LpGt3/TrzKuG2tqsLGAVyYjc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V2v7xRCMpfnON8ljgxSfhJEflYvCLYBTSJRx80V0YjRvKn9DNQ0DdmrYJrnqR/un9
	 BY2qHWNVyBamDTqKtvSZ1NlAUexIunUT2n87na3VAofSuLFZFQ31/5fqoIblx0xr6n
	 NeaPR7GU1KIB0aqmQk7po/UvrpB6yRzRzjQG83F6yBUbuIJK60ofiynq6Hx+ZnfxLX
	 sTPoXQwoyc8FMzymZoqoCz6mQB3PujsDsTUS+NFHO37nRqeZ9qdFjNhwDYZF5qBcZ3
	 bL0u6YV+b46uLEBLv4mJ7OnPYntP5EcBrLZ5kH3UIkuIq/SonA2/XBJhTN8Re9Hlt4
	 nis6Zj3Ygmn9Q==
Message-ID: <sashiko-outbox-165349@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 23/31] ext4: advance i_disksize to i_size upon
 disksize-grow I/O completion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-24-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-24-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:19:35 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> When the disksize-grow-pending zeroed EOF I/O completes, i_disksize has
> to be advanced. Advancing it only to the end of that specific I/O would
> discard any later i_disksize updates from concurrent fallocate or
> similar operations, causing filesystem inconsistency.
>=20
> Scanning dirty or writeback folios beyond the current position to
> compute a safe advance target is expensive and racy with concurrent
> fallocate, so instead advance i_disksize directly to i_size. This may
> expose zeroed data (not stale data) after crash recovery when dirty data
> in the range is not yet on disk, but only for unaligned append writes,
> which is deemed acceptable.
>=20
> To support this, teach ext4_iomap_wb_update_disksize() to take an
> is_disksize_grow flag and advance i_disksize to i_size when set, and
> have ext4_iomap_finish_ioend() pass the flag based on the
> EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO tag of the completing ioend.
>=20
> Note that EXT4_STATE_DISKSIZE_GROW_PENDING is not set for now, and it
> will be set after everthing is done.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D23

