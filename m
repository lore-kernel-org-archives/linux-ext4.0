Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764C1384CEC
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991261; cv=none; b=TzipXDde3KxK1iKq9ZSMDtCs2gM2tKH3Hbr5YXJcuC5y1xqqqlg99Z9A/knGCRD4Y4Lqna4+7vSvLd8YY6I2tNJxFNefPr0qoVVxQhJyZP1DixrhwEmuAjZSgQBPvoWKK4feSEgly+gwE8pVakHdZ1DFtQYmDFTUVQIxBh0urAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991261; c=relaxed/simple;
	bh=ghqta4Z3F6FeYVak6MRt6oJJ5X6zqAtFSLozmoDw3lo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ms0LwzQsCm0m21Fvd4/NevoQEOtHM3UT7/WMPP0T6kFkIV7gMcBHWIf/gVmkzIl+IQxIs7S/ulo/krcjtP4FSybsvBRMlFsGJ5Na9Cra06MgvCqt8eMQ7KjvvwJViFbRfyFLnhx2nqyTb41w3fcmJBCgUiApTApPv4VsX2h7yTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ago9RM6w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ago9RM6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179AE1F00893;
	Sat,  3 Oct 2026 01:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991260;
	bh=ghqta4Z3F6FeYVak6MRt6oJJ5X6zqAtFSLozmoDw3lo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ago9RM6wsl8MS5VMmevuj7Ob47QqzOiU1bk7uoRiLoj6lJYAa5v7zo5VEEAno3vQB
	 /dbWQMgErMvgRNHCbVLP0UH1XHVZWm3F2iw/ocpRqKhVHEV01sJQUmzz7QCzd3jAiF
	 J0wVvXhRKHG/6QoHHfXSMwO3gXTnj5ehpdjENhNSsHktITfFOOx1gSPLgdQ+d+ngm4
	 HYkFyAW7mIxBXHtmqRvIFIr1gpPcdzqUXjEuWo3As13O6j6FgBk9URdATt1/5zOXK4
	 FAl+L5HjzOD+NcDLpy2lBa0Z2/muNZkqZGGiFylSeuuEZzG1/RvIgoNLa4l9ygaYqr
	 IBKCxRa7+z5wQ==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 17/21] xfs: add fs-verity ioctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: tytso@mit.edu, dsterba@suse.cz, linux-ext4@vger.kernel.org
In-Reply-To: <20261002223705.2175542-18-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-18-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:19 +0000
Message-Id: <20261003013420.179AE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Add fs-verity ioctls to enable, dump metadata (descriptor and Merkle
> tree pages) and obtain file's digest.
>=20
> [djwong: remove unnecessary casting]
>=20
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D17

