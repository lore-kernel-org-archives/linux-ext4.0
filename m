Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FAA386453
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991256; cv=none; b=qhcavgp5Uk5ipWXuO9e+tczG54IfZFGXXnWWMo7X93sWDFFuSRM/iWYI3HVmth16wSGULK0JO9RlCvBU2HrilMQS+L6RxV+ljkpFAVrriWYmY/wYDAULzLqdDTKwXJxhBJlSdY3+AjlpvOSSV5wk97W83tENmGHPO05qyJ+lfOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991256; c=relaxed/simple;
	bh=5mnYw/Q3hhZyQTGx26TjPWwuu2r4YUGujWvPrRUMqCs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BKFW8wLeWq2yNt81t3XdYFB6sxzQW6mc3cRlcpy1BLvD8ZY/wJBeGb7VdUtln8yriJnR4IBdtgEJIT4q08UFn3yEgOrzC4Qkja3+JvGD949zQFvfVcMjAsrZ3wqXM3TUXc5gST0AYRM842lDK88Xr3eR0zNGlQa4FNRS9mmQlVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZLzKjI8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZLzKjI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801FE1F00893;
	Sat,  3 Oct 2026 01:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991254;
	bh=5mnYw/Q3hhZyQTGx26TjPWwuu2r4YUGujWvPrRUMqCs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WZLzKjI8hiP8w4frEJA2qn3nuGNoUwqu9bajUCPRxUtYm9q5KfxgPmMhKbydwx7Le
	 9jqHSvKttIiiwb5WPBzfsdsE6Ld+OpUs4MsB/5ocU8LzkRebrlA5SjfJ/VRvFpTV14
	 +LuL4Ag7dZ3qOWUztNCfnk9uDYMF373RRglXpyhCkncQBz5GlNzx0bSBLOq+R5AmDG
	 aVh16hZiEygSKShhZyt8OginjS6eQi6QGR6wXMDpMeIi2p9xMoXw5bkrAnU7lzvF4Q
	 5v9KLH1erjUtC2KIsazc6upH00PLqIlJ0vJIdF/5O8Lxr+QLbU00SHOd3IIvjkuE/q
	 LSeUMk7FNB6bQ==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 21/21] xfs: enable ro-compat fs-verity
 flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: dsterba@suse.cz, linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261002223705.2175542-22-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-22-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:14 +0000
Message-Id: <20261003013414.801FE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Finalize fs-verity integration in XFS by making kernel fs-verity
> aware with ro-compat flag.
>=20
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> [djwong: add spaces]
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D21

