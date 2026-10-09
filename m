Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1597B2C08CF
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544077; cv=none; b=DZfukS5BUXbeb+wXjEbHKUJRrLHW9PtL94EFs3m+EPOTMlbMmnehQ1CBbDxJDA0OZ07HUKRDkRDIWx23gE0ui30ABKlOiHdX8bWXOhIZ1jzM/1mLTq2AdBN93HJaGrwbb3tThfACGVS02fIHGMNRvv4We+gVYYIwCcbkvA8Xr6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544077; c=relaxed/simple;
	bh=PIG80xLRZRGc8mBX5/2qBLifh+gGNLKCg36HjQuBcVg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=d3HOsPXep9fBm1zerdAlQxhWaxZhfhcNgMAnUyowPD007b329Ye1dt/0A0CeZ2LT1apvuhvbYCKxARorij/j2tkeHZf3XqgH0BvB3p6cQRiRJMvd9kdw57DY8ZrjefYKPxyXb+IWq+EyOLoDY2R5Xgh2mPd2xobHkniVoD0Xnys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HLzetCcJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HLzetCcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973A71F00893;
	Fri,  9 Oct 2026 11:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544067;
	bh=zkACWvL2LVDRW1+2CrIZ2X7GbXG51BbSCdNP+Iq8rk0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HLzetCcJzpKOTkrjH6hN1yD3L2szwJf8N/Dz1qz1wo+ylAz5Q29EWx+f/BavJLus7
	 S6NLhPHGh5TOD736WRMyt9dZgIthnH4pFxDT1eLG3xDPqTc6RYud6HqfV7h4Gsa74O
	 U58eTXuBzhk6AJh2oz2DyFG8llhg0E/GdK/QKpFNlxNfgj6fqaHKUDBcde1j3XNQYT
	 Q/k555p0K5bVvh5Kbemu+ROm6pBsGc1yizpSIjbjDjfxELdZwZ35IDUZDjyb9XXEyf
	 yK2VxRnJTHJQHGtttNRtjq6fJo+yEgrnXg0TN/7FyEpP6/cEMrNJB82C4J6aK4rSnA
	 bc6dKYrRHpMIA==
Message-ID: <sashiko-outbox-165318@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 10/31] ext4: implement buffered read path using iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-11-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-11-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:07:47 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D10

