Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714191;
	b=ZOLu36f0HqkwzBCPbYDzImUjDfEzpOUX9CRmc7m+HtIRDsH2yAst7riwfg9GEGex0jIc
	 Lt1Nk98qeBQuhXhhwPnKJeeSiGqUoJVsDhjwPeSnDWpph/8mMhnXEWt8ikNRpuSkg92yT
	 rQoa0Ey+A3ycDfAnFhXG+sbdwHASVy1tnVCeWyFmyLa+gcHf9e4RpEupfN8Of9T09YqWv
	 +eh6pDAMNWe2N7bwgkd2JfLckVjGQW/Q866bPhBIR4+LmWUtwxs/PPC6rZRr2G7/yE6UP
	 9Mu8kVQ7LvlNT86hY3JThKdK2P2wi1VQzleWKVHibeoIbeuQSsGsIVn3ZLNARkZ0Ifw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714191;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=O1i8exWF7Ru4bQtD2cpDRZerVEg9yo+ha8oF6fcbatQ=;
	b=w9bELsoiNm9N0HrAMydP64gRv1Tz3t70jLUi2T9qa/nJwDOmWK193ElO2B6E3EbM+iqN
	 xjsbOrKyOYcPIV6ADBqvlRqRkH1DRPi18ISWpONAHWELaUAY66Q1kPWdp/gjZAkdrYaMS
	 0CNRq4X9zNj0/4kVYl9JbsstUDW831+hr3qER/GN3bNeazM9BlYh4KwomYmSzjjJ5wjfn
	 ZEWizK5dH8kcO8/soWH1qZIPcSqrykofpyfgcp9UkvC/Mwyrhf4h3w9L++mbP5dv/vCt+
	 UhhUO/eMRrzAMjrvoR+mzCVRQ5u4PR6wuyjWkeYy00PdstpaINpNInEj4Uu4jo6Uqkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FTAEWQrK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C632B606A332
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FTAEWQrK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297EB1F00A15;
	Tue,  3 Nov 2026 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714190;
	bh=O1i8exWF7Ru4bQtD2cpDRZerVEg9yo+ha8oF6fcbatQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FTAEWQrKFndV8ZIPI7ZLSDUTHTCRnSNQ+SW0DLVRvWw8KcWH1GbFdrtFx6HNJnNR1
	 10N8Z6ESGUiNFwPAQerYCxdJRtvQZBgzM4z3myg6+i9amM+aIbcZ9mR/L9Xk8JKtTc
	 ZyQFBCIlEe4EXcGAJXxtLwON4ckzsc/gH1/iS6X9U6QMiOrtHVc3+VbsWvWZU2A8Zw
	 6/p4HzqOiNZQ2EbiS7a2CYvUL8zTbs7nM+CbmHq3W3txf7jWUQKiSWp5hmWnOc5Ie7
	 IsaPmjtXIiHI1/Kwj7Ya7L6TPYwyjaxUNKbTVz+BgmosuMbVVp/9/IStHLxzAiQ4IV
	 +4lCg2Gru6WHA==
Message-ID: <sashiko-outbox-195402@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 01/12] ext4: validate count against limit in
 ext4_dx_csum_verify/_set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261103134921.610047-2-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
 <20261103134921.610047-2-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:56:29 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> dx_countlimit's count field was read from disk and used directly to
> compute the checksummed range (count_offset + count * sizeof(dx_entry))
> without ever being checked against limit -- only limit itself was
> bounds-checked against the block size. A corrupted or maliciously
> crafted filesystem image that sets count to a large value (e.g. 65535)
> makes ext4_chksum() read far past the end of the directory block
> buffer, hitting adjacent slab objects.
>=20
> Reported-by: xiaowu.417@qq.com
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103134921.6100=
47-1-ablagodarenko@thelustrecollective.com?part=3D1

