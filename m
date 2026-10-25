Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792960466;
	b=EzLsLqfBiQ8ZNFdRmmdMnCmX8GbGwbhncEcL2JJigPPGm3Qibw1yLhZZb11nhDgsXvyx
	 LG08VWi14T/E4jAXGryGJrPd4GByZW7zTQYxo8IMQg8cAFRHmFlj5sQSptjmKX8mpnoDZ
	 UgZj20cwz0oer28T990OZJt+rDR4wHTiRftWPfnDz90kuUYP3cKc57LIGCx/gD6Vut3w5
	 3Z/nP9eJnLEI+593b+8AV63WMeEWjrzR+HEB6BIuGu9uf5W7vmsW9SOuUODP3cgkluWAd
	 74niPixtXc0TZE6hKfLyCWkZVxUk8/3iMUUiSHyEPIMvc7exVWxJNfD64clu4Lo6rRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792960466;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WQJ2T3vOwTmSMWbCokVQSZz0Nbr74lnM8DC1s15JLkY=;
	b=XRSeRr/22uqGUuVFyfQ9Q9a0dk49PEdb98y40lzTWDMGpxFD+RiyvDGnDvbQa07Olp10
	 YLKq4hu/X+QvnZICsWiW3McR2BSzhl1lbAAeu6pZu78VfDgToBWDgiQSeMKGTsgvDRcci
	 mDEhPJM/12rGL2qtlFbUTJWZboxeu91m6DQJx5XQnzauT94CPRnHXv5MA8Yq1qgKkumKX
	 6TEdnZKzssVmIrrfuPFhPoiOoe18TGh1CnV5YOIi6ddiD9O1KSFKMXxXqJmAlz0PGFAzC
	 XJNqRnktU16lwixe3qkdlUBCkrlnekXFfwsJ6SnQCjabn6zeez7G6MIzgLif290S7/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AgPKpE2Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C7B606A321
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 20:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AgPKpE2Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDAD1F01825;
	Sun, 25 Oct 2026 20:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792960466;
	bh=WQJ2T3vOwTmSMWbCokVQSZz0Nbr74lnM8DC1s15JLkY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AgPKpE2YtHEa3wWosrkkn776UFgzMnqXiPd7TkVzbPHeGWdwZUxmKRz93piwjR7VC
	 SCFn09a4mPVJqbu8ifdqMCEanMmmWTNUGJB/9znsOeWCON3QGIiNC2ud+6aGEP58du
	 PUNd2QcJDnnJqaqA3qlTDs53eK7gt63+wsWSOtb+pDk1PrlsDy1LcwymixdeauDKzw
	 BfCbkTWX0wtFPCyt8jV9smzhhNkrhKPNFS+yr2dnAas3c/r5gucf2cNuXy4Kwn0DC8
	 5RWqEmuZoERvsgQw0f3z0LbFvlTXWFAKYpudan3lPQXsO5eUGLr1jmONceln1gqMdc
	 PlrE24TKPzJPA==
Message-ID: <sashiko-outbox-184437@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] ext4: don't lose the error of a failed migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lukas Czerner" <lukas@czerner.cz>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261025201803.3043712-3-lukas@czerner.cz>
References: <20261025201803.3043712-1-lukas@czerner.cz>
 <20261025201803.3043712-3-lukas@czerner.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 20:34:25 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4_journal_ensure_credits() overwrites whatever error the migration
> might have run into previously. As a result EXT4_IOC_MIGRATE ioctl will
> report success, while the actual migration failed.
>=20
> Fix it by using a separate variable to store return value from
> ext4_journal_ensure_credits().
>=20
> Signed-off-by: Lukas Czerner <lukas@czerner.cz>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025201803.3043=
712-1-lukas@czerner.cz?part=3D2

