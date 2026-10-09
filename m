Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74894C0409
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 10:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543115; cv=none; b=fmvcJgR5uHTHzG/+m/EAZra6hIL9GdJr/TtooHD7CEqUsHOXsSsL6ndeVNGlnESD5B7HKbJN16lmPFIFh0FC25E0i2HFqCUTfKRBcpJkN9zaPmTR9oMG6JgIRxmfwr+8VXCWmTylPb/g6lt5nLQyxubGvC2JYXT3i6JPW+/qjMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543115; c=relaxed/simple;
	bh=EC6vNueq4oCgoW5014IPr/f7IzRgr3BOpD59RC7h9WY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=epG7wPyo0WTjmhW+1lq8fA31roCGlD603qVTNVE97fSXR5d1cV6LzaWci3FEBGFLZrIVBj9AnH3PEUnLurhDwIJz27QB9GU8DKx1psvzH9Jnb/npElxklGQNVlLSSeXpVnMfmZhyG33DB6+XyLQa38EPEXxl8BJ0LXJzlYaiNAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0B3KdIU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0B3KdIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAB81F000FF;
	Fri,  9 Oct 2026 10:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543105;
	bh=EC6vNueq4oCgoW5014IPr/f7IzRgr3BOpD59RC7h9WY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C0B3KdIU+gwUdOI2hnAIXaKpWqPghot2SSpXklfQDbfWatzJehn1bxqYPOA/AAW+i
	 NyvyTyAqRi1k7963Hns7SbyW278IpDBPelwe2QfPTCszk7xClZESiAK/Hz5erNhdlw
	 D7jrZuTKel3pvlyZqzJpKc1+3DlwSrlCErB4WV249XlZMBgP4tHFau2jF8HJx1RMVE
	 UE0ojFGYjeNcooVz0FprElul/wY2uUh4l8aBoIwEFH+YTByS0mv258D3PlAHfloDnb
	 yg33EoT2R/ssbM0qdhqdGyjOkgKw6EhfeWIn1CaS+FC8n2JZIKF7DxdVEOnXLzL596
	 Xn0x2Z3YGIoXg==
Message-ID: <sashiko-outbox-165278@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 01/31] ext4: simplify size updating in ext4_setattr()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009103033.2920530-2-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-2-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:51:44 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> The logic for updating the file size in ext4_setattr() is currently
> somewhat messy. By directly entering the error-handling path after
> failing to add an orphan inode, the unnecessary recovery process
> involving old_disksize and the file size can be avoided.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D1

