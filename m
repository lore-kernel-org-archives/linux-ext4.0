Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE4D4C14E7
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 10:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543230; cv=none; b=WDXguy8OqwS1BFboRCEQH7Ax28v8xJv1onkTD6zuWSPaa6IeQ5XZvwvwvWiKoKZeDKR18Ux8l5ORqkBRPhqfiFCp8s//R8chCG4JAedVMuUYQOLsc541Tz9VbW8kOHSEk4py2VNLlbFd46KiaVud52Gb2CKNTeKbh/Yfvk7aE7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543230; c=relaxed/simple;
	bh=y0hJ4c8LA2IcPVdIyAoaKOWhEYh+wTVRPNKBqRN/tgg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=WW8WJWJWY4Z/hQf/UmRy6P/9JI6R90St8RHtvitKGyHFcLjJKOniFLzs9cDLSX8xZ0yPP6nHQE/r0QdpiXMdyBtwiIwVwZ9taAei8BW3CgynT5VIYopmk6CYFfLEqgdaiHk8JwnxK6CXQUFMKssDQ/odsJ3fxWUHJGGeR7S3eMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GecyI0Ek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GecyI0Ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4725A1F00893;
	Fri,  9 Oct 2026 10:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543222;
	bh=y0hJ4c8LA2IcPVdIyAoaKOWhEYh+wTVRPNKBqRN/tgg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GecyI0EkVKJX2Xnm4j8tmJ6auT2YtqSNnnBPZbs1kRg8giUxuYp6iTr0wzOSxtvo7
	 QnX0m5r3YOPLaFsCC9x7YltiYFmdJUMRAHb0OksgYOtbxAnS1K+0coM/wFxjcri0ae
	 4FfFC+U6lDe0/x308+KJn+g0T6MKZFl78hMWkdMS3uJdSwhNU+7eXDelNuA2jvG8vS
	 NPBFKrGsjZV4F1qCCeXXtUaGv3xu5Ekthiqjn8553cGIgLSC5PHraaSxw27K0SWQKY
	 ies6qLfiDoIncOCtndp1OAjXWNUnftUWX+yneAPO094Cf4bOEbgbReBlBqUOubn/oa
	 pB2zOdDheNi/g==
Message-ID: <sashiko-outbox-165283@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 05/31] ext4: fix orig_mlen initialization in
 ext4_map_blocks()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261009103033.2920530-6-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-6-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:53:41 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Save orig_mlen after clamping map->m_len to INT_MAX. Otherwise, the
> unclamped value may be passed below, bypassing its overflow protection.
>=20
> Fixes: 5bb12b1837c0 ("ext4: Add support for EXT4_GET_BLOCKS_QUERY_LEAF_BL=
OCKS")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D5

