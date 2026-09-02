Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A9F4A2A62
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788359730; cv=none; b=urrogBpgDoJ35+SI3dm+ohwu9mdn9NO/fbqaEASYEhdp73XJVtv7DvWNeursZYdhJDCfYdCozRCRdGJ002yvevEbp7vKXRFy6ur53Qz6UQDqkcDrs+kMS716qdvWwG3Ip6DkznqFvNx3SDw70TIsCNUqVvrkswMJBFT0OESZ8xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788359730; c=relaxed/simple;
	bh=DbPzx0e77wX62KWor6o2GEUp9wM/+EQ+MuFCMjZUKIM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r782TrOK36nzPjfxured3HO4aulajqy5cVsFUIvRag4BWSFEHLS3oY4kjRv3ZIlSC/vhk/LxMi7OGmCH2F4u15JXyCUdKz1YEEfEc6983nrgf8b8GYJRfUF51X2Zb2QeDVieGf5r66MHYsBT0eN/jwxS9lNEu3NLNj9wqH6bhW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fy6m8qD8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fy6m8qD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8151F000E9;
	Wed,  2 Sep 2026 14:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788359728;
	bh=DbPzx0e77wX62KWor6o2GEUp9wM/+EQ+MuFCMjZUKIM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fy6m8qD8hPeNwPHDFVaWyVo+yZ357+S8VebiIVW2BO2QV6ahWuTRtgx1dwfYSjltv
	 p3mhHZEng61GuHHZO9kCqDoaA9MmEl2Y57W+HRIZAN1wpWeEEdZqI07ap3JbxYvxHX
	 Dr8ro0Ai2+mcPlr92bDdKBgebNHv8xz542OyG5dm8JTOcRZLNuk2nQpD2J9HU3HW/V
	 ea/aAMQiCDX02hZVzN24R42iuOMkvECXZg2t4UEMUXcDEbXSCnEk6Go+I4YvkeKxnx
	 AtVPyf/UGumTE4srO3tCBW58Xr0iSMez/mL57kM0lMO6Bn+KI17dNf1zC/OLr8ifA8
	 N6NnHTbYUqQZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4, doc: remove unnecessary bracket
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manuel Ebner" <manuelebnerli@mailbox.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260902143254.702971-2-manuelebnerli@mailbox.org>
References: <20260902143254.702971-2-manuelebnerli@mailbox.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 14:35:27 +0000
Message-Id: <20260902143528.1C8151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Remove needless '('.
>=20
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902143254.7029=
71-2-manuelebnerli@mailbox.org?part=3D1

