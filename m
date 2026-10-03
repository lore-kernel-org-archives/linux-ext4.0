Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B26C381E8A
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991255; cv=none; b=VQxdV+wXPlj/IbHf1lqNNifwfl2XQ9FXUODM9hehztXD02hlmrVMkrAoXe9RORXROB1YK/n80qNJn0aCIzyJTQPHNJta5gaVON8yuf+GuupOxagZ7UHfLPdumnMpKbvOIWmzgmkIB6U2Dxs7xXiDnbKcDF9HT8JZGbd+6jxVxjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991255; c=relaxed/simple;
	bh=D7v4czSqaQOBll9kIxMZsEZsf1OcWxv9pCd6XdjqECM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GE4kZvkoYFJ/rYWuc4xiVerxzDcGfcs+bM23tXV1PeHYONRlFlW4OFldUaSxW+DKKHOS2YGIMsVGBp5FdniXrArDgUElmWSsvOmTrPckwagegrV4QKjQ4wzq82Ep/hdajbBg0Q74fVMWYqVOc5EsjI9zSvLFmzGT0cl7fL7I52M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNcwYxPq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNcwYxPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A921F00899;
	Sat,  3 Oct 2026 01:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991254;
	bh=D7v4czSqaQOBll9kIxMZsEZsf1OcWxv9pCd6XdjqECM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FNcwYxPqOwjEgtkKz9pxX/mvvgyoCcTiB47GYVeD89oGVGaREQBqe0XeMf6CZ0Eu3
	 actWcWjF5Tr3XHdLI+9s9ZrxTmF5qCfZxP7c7uLoS4QmPRQ0USLWgI3hA9HwmEMg28
	 Oy+/tySqm795gucmI3yYJmbMkY8GmvCqTFxaPh0b7Qlt175uJuYL4UlLKAG530Eswf
	 QGIolBEtUc4DhAESYuV6gg80v2DHLfgmderbl7w1xuwiHSvgK4qQUe4BpjYnfQhz0r
	 PfvQqUvBtEeAfnGnPwPABY6uUFEeO5ayN2P2x0eY4LKCsdjEQ2LK2c1sbKaRNevkTR
	 DaHyt7NCDE3CA==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 18/21] xfs: advertise fs-verity being
 available on filesystem
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: tytso@mit.edu, dsterba@suse.cz, linux-ext4@vger.kernel.org
In-Reply-To: <20261002223705.2175542-19-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-19-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:13 +0000
Message-Id: <20261003013413.B4A921F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: "Darrick J. Wong" <djwong@kernel.org>
>=20
> Advertise that this filesystem supports fsverity.
>=20
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D18

