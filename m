Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4F83DC4C9;
	Wed, 26 Aug 2026 09:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738070; cv=none; b=cxS6xydtK+Daix3lBaIRGkpfPBEGtm9rrj98LbGqGU/RyjEWItGSzXfeQ/jwsXgUW3RhcgmZx6M98/+iaj0GNBDAMHHvKDEXrjAC6tg1GM6pRYSqK+18EPQXxIP0nwNpjiWKTeAWzxIGk+nvRQhzp5upPCMTBRo2ahLed2RE3k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738070; c=relaxed/simple;
	bh=7zAXXcGtL+k+oP1AJmpiOe/gVZLHI7FrB8F/FvJNTmo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=erR7exkTbjQ0t6I5ofTRnBzgCxWMsZSOaj5crydtp/uDsGUVvRM6bR4CNkcX6Sx7Uox8I/6mAMW7LEdF/d0fbrkZqI3kCdzxzq2T9DEYpCD1ySTYrtqI/yQ7I8d/Gly2IGvFQM9Le1mKUdLJSKMYETFxOAYuuhgIEoK5VyyRc4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D9Yjl4iW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D9Yjl4iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADF31F00A3A;
	Wed, 26 Aug 2026 09:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738066;
	bh=7zAXXcGtL+k+oP1AJmpiOe/gVZLHI7FrB8F/FvJNTmo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D9Yjl4iWEo92890ItoaLcGhxCWrTkzmTFJkL6n6U7RE3LLyA+3vCNbw6qRJ6fBeLQ
	 GubsAYOcHmXvDDtQzjWSZmkQD6WTx2DJlpRl7EkqliVAGhrTIKgY8zQHSaVtgbA4+3
	 +6HSW0Iqa/mur+CF9lnB88pRguhmBpigkupIuo/nE401aQgZbP6zCpnUo/ZjwfAix7
	 vvyP2Lq5zj9W8GMIeFJRXvXbjyL1/B58dwqvXRbPxvODmrrtacbsQFucg32kL+WCpm
	 V2rp0ZKDsthJ9Ap+mxfkL0ThFgJS37+wXXaE3bQ10suDCJ8i+sSYX4dU85IB6cB25/
	 pghMH4fXmZHaQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/11] super: Use acquire for SB_BORN check in
 super_cache_count()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: linux-ext4@vger.kernel.org, "Oliver Hartkopp" <socketcan@hartkopp.net>, "Vincent
 Mailhol" <mailhol@kernel.org>, "Oleksij Rempel" <o.rempel@pengutronix.de>, linux-can@vger.kernel.org, "Marc
 Kleine-Budde" <mkl@pengutronix.de>, tytso@mit.edu
In-Reply-To: <20260825095422.3166067-7-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-7-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 09:54:25 +0000
Message-Id: <20260826095426.2ADF31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The active SB_BORN check in super_cache_count() pairs with the
> smp_store_release() in super_wake() when publishing a newly initialized
> superblock.
>=20
> Replace the historical independent smp_rmb() barrier with an acquire load
> on sb->s_flags. This expresses the publish-subscribe pattern more clearly
> and allows weakly-ordered architectures like arm64 to utilize efficient
> native instructions (e.g., LDAR) instead of a full one-way barrier.
>=20
> Also update the outdated comment to correctly point to super_wake().
>=20
> Assisted-by: Gemini:Gemini-3.1
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825095422.3166=
067-1-ruanjinjie@huawei.com?part=3D6

