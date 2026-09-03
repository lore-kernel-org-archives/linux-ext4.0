Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421DF4A8A1A
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441160; cv=none; b=cviKTl4ifA03olxCE6xW5ito3M7P5iveAR/INQl7J3dQlsqQbSBl3WbTZAfeQ9aGlkKdeOSdG1UZlzaYOQT+gPKxYyjzkQ/S9Ke4z4ABrztKobr4/5coH5LlnnRpahPDZnEthrywo4n+KQJ7cQrwZxYhVbOk1Wi+z+aZZreO8tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441160; c=relaxed/simple;
	bh=ZHdLp6//jLe8EUS9MrktBdU3LSwA1Tprw2Sg5P+v5XE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=t62AMar/YJPJjroXjEBUvyTumfT5g4dPae8MkF7xCoboSkVK33GBJxPJXeWxcwO/vLhB5ZW448zeCvkrotJf2C4uLnDToHHeX0EzAphKnuwyF+g2zJP+9TdJJ5Q86cILe4DrcqAAIykSxT/n88MQT/YE+Lbshw1CRpWDPm/6BxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4Ss52ZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4Ss52ZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C381B1F00A3D;
	Thu,  3 Sep 2026 13:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788441151;
	bh=+EHSFeJQVYcVEkmF1RcsSgLzqR4hnnDKHF24bxeVP9E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i4Ss52ZW5yVqfyyd0o9il74N5gBmf+qBaVRHniVsDwTLyYJOGG2JrOSsPtClkDQ/o
	 4qtidEvUbSqmrbUrxgwFCj1yoWJo13a7wOtRZvM+GqdQzj/kOhMdBJEv1CsLUoeSEb
	 JpQmbelEAvMH4SGBWdmS+RThLTDcE9uFXsgMlPF1JnXeywtVQRFTWsCq7ZdDmqZHt0
	 mD8tYvrZKjHlRlEDMYUXXSbmYJt3TS8e+FKVJgHrUv6FNBtVZ/5MTChYCabhn4KIY5
	 XQ4PLEUxrKPxiqEbDA7U5AmjLcSPKY8nHJYeM8sj+0BSJhG348EYA7oL+WhnJg41Df
	 6ybrsean7tudA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 11/31] ext4: implement buffered read path using iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-12-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-12-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:12:30 +0000
Message-Id: <20260903131230.C381B1F00A3D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D11

