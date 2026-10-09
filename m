Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF40B4BD7B7
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544423; cv=none; b=KXXKk7IQmKKlYKzABPZO5uHI1B1WXK7QXuVVqNXabUc9dgBI/mVXBGS5wIqHcBH59299ayI3jBsytona0y3BwDOuWXm9w1/Lm09udvFLbiX96L/Qq/I+Z3Xov2rYKYuAXeTSQ0fv0bt3Nu4MW3EL6AAeTUUriEzVm04m9iOF218=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544423; c=relaxed/simple;
	bh=EPZePUxrMOJDG9qHm6Gks+77EHuvnnaNAc7B4BDLxJI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=NiRxLgZx804jncRFF877cEAljPNR5TbIFIApULLDMBPOTe1VVSYPucV1nVB5yVD+fjylcoaqtPRi2W6xwSR+0eGjTSb7MQ1M3X3m/podHX2wALyi0o1S1RcKO7zeHk3FcYI+4GciAZROSC4NVQJiYmISYcOPj4UNMClmjdm1SBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWPy2+6w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWPy2+6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE5F1F000FF;
	Fri,  9 Oct 2026 11:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544412;
	bh=ZNhOXrBHMbCYVW/+CTQr9gPzJ5ScnGMAmYaRDEuTwbo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LWPy2+6wGX3HcNR4lecFu7+sXAsMCkkBByHG3lHuHcALklV7U4qR205KablEfSahR
	 peN8e9Su47vN53ZkYy1vRgz8J39ltfcNw8ntWFYH6xDDVTmUeYXfa5vjlg3jQaDPjc
	 zen8zeSqKe9N1wEYvnJ/LUebHpRHDRiDPO63ByWH8GwthFrrsfi/HI/dAUadAiMwvP
	 FAqp52rtHuIPMJLDvFZC7U4gUK2qQ3lgqUBHlny6uRqy1s7EIZwaWuByy/HXrBr82i
	 HVolbH3XZDKTJeaiTzP3jfymKnDImyYgBydE/BJM2nMziGVz/RINmrzBjlBaZvg992
	 9TaWClqt6YiKg==
Message-ID: <sashiko-outbox-165333@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 15/31] ext4: implement writeback path using iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009103033.2920530-16-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-16-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:13:31 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Add the iomap writeback path for ext4 buffered I/O. This introduces:
>=20
>  - ext4_iomap_writepages(): the main writeback entry point.
>  - ext4_writeback_ops: a new iomap_writeback_ops instance to handle
>    block mapping and I/O submission.
>  - A new end I/O work handler ext4_iomap_finish_ioend() is added for
>    converting unwritten extents, updating file size, and handling
>    DATA_ERR_ABORT after I/O completion.
>=20
> Core implementation details:
>=20
>  - ->writeback_range() callback
>    Calls ext4_iomap_map_writeback_range() to map and allocate blocks
> [ ... ]
>    be cleared explicitly to avoid double deferral. In the future, all
>    private defer work should be moved to the generic bio complete in
>    task framework.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D15

