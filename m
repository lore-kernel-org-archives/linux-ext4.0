Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11DC214812
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2026 00:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334238; cv=none; b=aYufWijRvVk4WGUECv8YowLZX2IGyKwoHBOhja6ujoIUbkTbDABXtbm6p4C0sIJ8mQtEvjdu7GzNC0+6t+5/MOgWcQYEQFceBXAa6buKySTyM4VnEuvdFsq5ilDgOHK7Dx3dh2PcYLMnX0XhORIsqUkfJRV+CJwF4MsAj87NEno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334238; c=relaxed/simple;
	bh=mZCTc8SX1tGh0ErMxydMjJ6hOEJd+gFP6LpHmWs3BtQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Z+UJ3pGZTZf5PeaRlfTeXbBOwOQluWt9PZGq3chU1gh1COnIcRMWG8y38Dbkp6qLTIrheyQM1a1GV6Zveh8ZrOa3IDpUF8AKuI3ibNMsDtlzUAXIHshLrPO0FOIDjbkCATRzdgTknc3fEHMzqhKpBQi2xc/J7lcTVps1j85B4z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MwF0YSFE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MwF0YSFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAF31F0089D;
	Wed,  7 Oct 2026 00:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791334237;
	bh=mZCTc8SX1tGh0ErMxydMjJ6hOEJd+gFP6LpHmWs3BtQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MwF0YSFEJ2nWRrez3hcU0rTIthAdNR33wvw8UCYkH5ux4y+VoQ9Y75cJzlSuJROlo
	 BypK4YDyByD38OcAk38FLv//WyUNVIEcjIUC82c/7mW+K8GxEmhm1/YilrR/PSFZzO
	 5XDVBOFcDm05bTbt79tXgEqc/dteb/+iKXchjfd5ZUoSK7kpboZ/emziZTGjHdaHn8
	 qFUwqEngCqgEdhQyK9vH5rIwJhlbG5UD81JYvubAHRJrmqrvrwaJJx9Hv1z3aU5CEq
	 3U5hF+O/Eu24OFafLpYCh9pnRwRxbHd16Mc77dyFIKUtfEera1WnCVmENlXQmcejJU
	 n/0tQyDQxsZcA==
Message-ID: <sashiko-outbox-162554@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] ext4: don't cache unzeroed blocks as written after
 a failed zeroout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261007-ext4-fc-zeroout-v1-1-b86de6439431@samsung.com>
References: <20261007-ext4-fc-zeroout-v1-0-b86de6439431@samsung.com>
 <20261007-ext4-fc-zeroout-v1-1-b86de6439431@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 00:50:37 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Daejun Park <daejun7.park@samsung.com>
>=20
> ext4_ext_convert_to_initialized() may zero out the blocks before and
> after the range being written and convert them to written together with
> it, instead of splitting them off the unwritten extent. If
> ext4_ext_zeroout() fails for one side, it falls back to splitting the
> extent, so the blocks on that side stay unwritten in the extent tree.
> But zero_ex1 or zero_ex2 keeps its length, and ext4_zeroout_es() still
> inserts those blocks into the extent status tree as written.
>=20
> Until that entry goes away, a read of those blocks returns whatever was
> on the disk before the extent was allocated. A write to them is mapped
> from the cache and goes in place without converting the extent, so its
> data would read back as zeroes once the entry is dropped. To reproduce
> on 4 KiB blocks with -o nodelalloc: fallocate 32 KiB, map the last seven
> blocks of that extent to dm-error, write the first block, restore the
> mapping and read the second block. It returns the old disk contents
> instead of zeroes.
>=20
> Clear the length of an extent that could not be zeroed out, so that
> ext4_zeroout_es() skips it, as the comment at the out label intends.
>=20
> Fixes: 308c57ccf431 ("ext4: if zeroout fails fall back to splitting the e=
xtent node")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-ext4-fc-ze=
roout-v1-0-b86de6439431@samsung.com?part=3D1

