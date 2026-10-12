Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25A53DC87A
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 23:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791846910; cv=none; b=u5vnSR6nWRw18hcbLKbDR+bRLcm2UKPoBFOqxVKgo390qxHVtyBSYs67Apyver4FEhzRV1quPTS6CVw17VCDQ36eHctyfSmHSIT4RtnvuRGw0ViZvqTAy3nKisQNAha40hlB6o6DYlhFCQbmUXHn0y98L2uF5r3yOqXiJB9x8rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791846910; c=relaxed/simple;
	bh=3vQhdPydBko1r2lCzxFPNs1rBta3VVM6cey7X2gPsdE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pnOnT8H23kILj8DIOwGLvN9aWe6MO2lf1dJlcOW2EVtt/bvEFNbV5lO7X8DcQqA4yOAWzXE8205aKeOjzMO9BgkSJjKPTgFureJKDHXeMOXEI6dbX9XSYK1vBXvrk4NjQMrxRb1hsGi088wAJRfSvnAJO9uJnrqk5Mhk18uuyHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/+Ccdz1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/+Ccdz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4A81F008A1;
	Mon, 12 Oct 2026 23:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791846909;
	bh=3vQhdPydBko1r2lCzxFPNs1rBta3VVM6cey7X2gPsdE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N/+Ccdz1/P4J30+aFIryySZoSu2v/IrFPuJkLuf4EJzgUHjDf8qkcWWhXgPw6JoBc
	 VUQtjknmDbukCTqIjkxwwdc624c4/x63VB+3JxjXfxlWancqnE/fn/c7xZc9kHhkSj
	 jdOaphw11f6DWPf58DZRSYNLR9sMo86GzKPEHIKPu4rJLiteuucXb+jPNMWVP43DsY
	 BiNk/pq0c2rZQvSxuq6uc2KYdSqE4Ogt/EpHYUvYohzjrzqTz/xNuTQp4FZPILBUfF
	 a+a2Y0/H3gUUukDLIwq4sHA4g0LKix6Ve5sYGLEZ0jsZlFbQD9T7Gid9YLJFIqtyf5
	 nttAwb9qMQQ8w==
Message-ID: <sashiko-outbox-168703@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/9] firmware: cs_dsp: Run the wmfw payload error tests
 with invalid block types
Reply-To: sashiko-reviews@lists.linux.dev
To: Mark <broonie@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261013-kunit-param-names-v1-1-4b22ec5b85b9@kernel.org>
References: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
 <20261013-kunit-param-names-v1-1-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 23:15:08 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Each of the wmfw error suites lists the truncated block header, truncated
> block payload and garbage payload length tests twice, once with valid
> block types and once with invalid block types. For the payload and
> garbage length tests the second entry names wmfw_too_short_for_block_head=
er
> rather than the test on the preceding line, so the block header test is
> run four times with invalid block types while the other two are only ever
> run with valid ones.
>=20
> Point the second entries at the intended tests so that
> wmfw_too_short_for_block_payload() and wmfw_block_payload_len_garbage()
> are also run with invalid block types, as the header test already is.
>=20
> Fixes: feb5fb0615f3 ("firmware: cs_dsp: Add KUnit testing of wmfw error c=
ases")
> Signed-off-by: Mark Brown <broonie@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-kunit-para=
m-names-v1-0-4b22ec5b85b9@kernel.org?part=3D1

