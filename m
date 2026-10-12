Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E148E2BFC7B
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 23:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791847009; cv=none; b=EyQxZgJW3pOdfwjSb3ItqT83yOZoowBnyJR5CP2Gc5r0iox/smziBKws7HvUqHs42dsUSBErA2XGojwtSSv0NNi7nRwniFjJLGjy0KgSxlVTbl3X1Ig7w5svv2xpw5ygYfJOEQpqeZPZCGvuz0y3XaaWqaPs3utJHPV/f4k9P6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791847009; c=relaxed/simple;
	bh=p8QJ0hytUF/hssbj5XYyrPBS0BLfMGPN05yadOPHAfg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HwQiAA0rcTkg9X+yNJvFu7RiXvFPBkq+ysiQgRpJD+/RThi2mekEURoPkNe/lpP8AB84KetLHNlC2CwGi6Pe+41UQYPEireLryu/HKUpwPzjr88h+1qse1wlfqSY5Qdlp/oy8er5dQttp9DlPSlzR7QT3HOQvsMhn2D2/Akyubw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJ4yzFL3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJ4yzFL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C251F0089B;
	Mon, 12 Oct 2026 23:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791847008;
	bh=rUXMScom9TzeOiHpl+gb4zjTp3mTotQZhr7uVfuvXa8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aJ4yzFL3KQ2QNNIbzBDWFQjK/+nk1y0WUHkMivErI4QRqIXCQ9mtvl7wgOCAydIwg
	 k6BLv5RgykAl0vYyfkGqUi+B2dRLqFTdPm7m00RkRf+Wy9VqIzP41l6o88UO9gspxQ
	 U1FYkH4/KpoDE/JJK0TVpLwAZpbIakMBG+AtIyShQty/02LgSZMQbLK8Dc8owcAiU7
	 eaC9ef2bMl26Tfu8sUZ695vwyFIY3k0WEQ6Q9YFpGjcbvboMzU/OxeSAdLeYgmZK0h
	 eQYTXAJ5MpTYZsEgBNIgYuUjhfgz9SBrw7err0iUdD6533QoJ5PrSCunk53B6wwH4S
	 Uk+ccVINa7mNQ==
Message-ID: <sashiko-outbox-168711@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/9] firmware: cs_dsp: Give the bin file KUnit cases
 distinct names
Reply-To: sashiko-reviews@lists.linux.dev
To: Mark <broonie@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261013-kunit-param-names-v1-7-4b22ec5b85b9@kernel.org>
References: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
 <20261013-kunit-param-names-v1-7-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 23:16:47 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The cs_dsp_bin suites run many of their test functions against more
> than one set of parameters, listing the function once per set with
> KUNIT_CASE_PARAM(), which names the case after the function:
>=20
>  - the ADSP2 suites run the XM/YM tests again for ZM,
>  - the WMDR v3 suite runs the whole set again with long offset blocks,
>  - the multiple memory tests are run varying the offset and the
>    algorithm.
>=20
> The resulting cases share a name, so they cannot be told apart in the
> results.
>=20
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, for example
> bin_patch_one_word-x_or_y_and_offset_gen_params and
> bin_patch_one_word-z_and_offset_gen_params.
>=20
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-kunit-para=
m-names-v1-0-4b22ec5b85b9@kernel.org?part=3D7

