Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA2737DEA4
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991249; cv=none; b=i5KDTEZfpgInjRi49JuJ9B+NaRGl8GeCqSB6IhL8gb0ZcvHZN7ZLy7yLa7MG9Qu8u6ctZ8t1vGB4wqpVQP1jA2c3CC94FKPPv+IlYxcOJA1QtR6UuERn3X7wqUeOHLcTWc8OT2pSiH2h6h+Iw4pdXGIaRQ8vuvNSn1GRczMllRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991249; c=relaxed/simple;
	bh=retjv276DMbfkXVjd5UNojsS2lKORkHAybiSCADKjZw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RodVrrYlp/Oy5yYLkAcgI8De95jESm815J8x1YZtwf1afiHGmkUmliYAXti0hDmp3v3ST8Gp+yQceeo69mjl3odMXtMDg/7vfbsB4QDMhXeMilKfdD1yIi3Z4lChIQeLDEnVDFcCinlIDSBSzOXBRHW4cFOhN5G23+0JQc75O8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dL20owRF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dL20owRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F6C1F00899;
	Sat,  3 Oct 2026 01:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991248;
	bh=retjv276DMbfkXVjd5UNojsS2lKORkHAybiSCADKjZw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dL20owRF63oJscZreT5KHeSqXAnc6HSC+yIgEq70osePVdJzhziAFkaXtqzSZ8UMa
	 qMqnkBHRWno8GufmNCkqgV1rWGNbn6Tcw70Cnq1n9zwXtNqZC7+0wfuPF6lQrYGMCm
	 KwBufYzwjg+MLxWDjeBRATN47kpvTbW2B9QvJjM1DKaSAuON2qev70PEzPALE0QMvv
	 ybKoLBoMdmogdXVrzs2/mz1YmMXM3ik5nEji7JXatTxLOKccs7gXJJssVIJ7ziSX4P
	 mu5RxbY8jUE5PXwe0tLiCXY+QmPgp++zKQeM3ihUZOwVcwdcMpi08mC5xOfDKgFlz2
	 0GC8Od5Zezogw==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 03/21] fsverity: pass digest size and
 hash of the all-zeroes block to ->write
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: tytso@mit.edu, dsterba@suse.cz, linux-ext4@vger.kernel.org
In-Reply-To: <20261002223705.2175542-4-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-4-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:07 +0000
Message-Id: <20261003013407.C3F6C1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Let filesystem iterate over hashes in the block and check if these are
> hashes of zeroed data blocks. XFS will use this to decide if it want to
> store tree block full of these hashes.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D3

