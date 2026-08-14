Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742E23B4EBC
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702517; cv=none; b=O8En53SJ2ihYc4ojRXuX5f/lxOOQOz2/PpsJVcxO+9BzWjTgGrnZrOJt+DxicwTddOtAGRS6JemyrxRj2ickD54UfHe7bHFEqO93+r0U6qBGwoRru9fRbRFVXNMBfpxaOIBespUks7tiTVmX7lUHLyewuA1wr2FnlBW2GYEZFok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702517; c=relaxed/simple;
	bh=kWYyewJcUBvhzC3yOCltZFVN3+DilihyylriS3OZ/80=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R6xnv+NwyIoPHieC8uh7+gwWyUN+OuuVeTxMVZLO/ECJFKss4L+DLLvPQ6K5Z9GK46KMrRgxVh4Xo5ipxxabXGtA8Xy6irAsVMY+8q6iZEomOcfTMPpdK2RqFhy4RBtvGQzLIQ0Aiy1ApdhrS8BfH0tKPzVs1mtUw3XUvnjzXmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W4BymYJK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W4BymYJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93F81F000E9;
	Fri, 14 Aug 2026 10:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702512;
	bh=hVlNgp1/4ggOEszYdv9B9HRCYRWxMiXrUM1SOKLW//M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W4BymYJKG6CXDpptoCe8hgjfvtsHAsxS1S4f7j6Vz78Bp2gfHHsRTF57DHzF2N8b8
	 3TgXPFgijSDU/Kz2/XwHp1RONClTiJ1T5cKRPq/wczPNdrExZXMMxyK4EzALYZyp3m
	 q3eYLb+T/IVl++tcIISYB3XvNrB0PFrk/YAbXTGGM5S8Z5/Ii9Jh1UX3aBGWsIRYnc
	 gfm78dNerW7rTXS8msBSl2Ei6bmMFMh5WFMoXK5DAvYTJGZvHEHWJxzE0BmxlzKBmY
	 mhzz2rVp/qW9U3pGNDtfdcgbT9FgospCqtpGZ4hHLmBg55EqCKnmhHWNbNUU+/LnB4
	 yeu1NYSpaY8qQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 12/32] ext4: implement buffered read path using
 iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-13-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-13-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:15:12 +0000
Message-Id: <20260814101512.B93F81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Implement the iomap read path for ext4 by introducing a new
> ext4_iomap_buffered_read_ops instance. This provides the read_folio()
> and readahead() callbacks for ext4_iomap_aops. The implementation
> introduces:
>=20
>  - ext4_iomap_map_blocks(): Helper function to query extent mappings for
>    a given read range using ext4_map_blocks() and convert the mapping
>    information to iomap type
>  - ext4_iomap_buffered_read_begin(): The iomap_begin callbacks that maps
>    blocks, validates filesystem state, and populates the iomap. It
>    returns -ERANGE for inline data which is not yet supported.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D12

