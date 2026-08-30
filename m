Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E24632
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2026 04:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788063977; cv=none; b=NqorEdTFmsGMEYLXykPv52Eql9/R9+cyL+1tbId6BQC6XC1xLj1W/JMFLsoXNM2Nrn3mLXp/apRlWtV4TYvcorIrWWfPBRgljV1wF7nFLflbLt1teJ1f7Cw41beilVKHFNZdw8XK9YzudhxUZBI+XzAxoRdgeFyqWPZB6VqsTGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788063977; c=relaxed/simple;
	bh=bBoarn6sUU3EEKZprRMZYJuXmg+Az/W95qcddylG5Ug=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XGfY8x1cK2StThyHC9oX8aScRdtWwyT0WQ92KBKxKPbJZSMFihG7CcLro3wYxsc0u7Qcmei/nq8pLcUqhjDEKTuyYAw3xY8ZPIu9TPBsMPaNlkmUOLTgGiV+0XSXh3bfe9nBq9hh43+JT+rzxmrHISjAv6/8NWJq3vR0aBqzqgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NLIgahR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NLIgahR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5F21F000E9;
	Sun, 30 Aug 2026 04:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788063975;
	bh=bBoarn6sUU3EEKZprRMZYJuXmg+Az/W95qcddylG5Ug=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NLIgahR/Wb0dJJVqCr44nLxXY2jUhP9j8XyJSeYkzwU8/28GW/UysvcAhDQ5RJ3RN
	 K1kowhkSIF4OvtMVxi7eCueZjEtytDQkoFZ6IlPKOIws2vycy2ht57Jbp4S2WFelOX
	 6Cnlewv2Cz7Hf+/NXJhRsHwGAuEVCQPwkAgUaFcDxMGDzivUFwPKNevBqxOPNOSQTH
	 pH7ae+/6nl/YJKcA6lqWm8Heaciwq8NZhhZ4sdHlXX9rhjD6s8yDUgoSWY5lLrBL+c
	 mhR7M9h9HrtDdz00GbE4gCfFnNL7f2fzsM3NKNOhH5UHws8jfL3Cp9kvgmBf/wiKAu
	 o+wOzUx7njqbw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/9] nfs: Remove redundant FGP_NOFS
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: "Jeff Layton" <jlayton@kernel.org>, "Anna Schumaker" <anna@kernel.org>, linux-ext4@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu
In-Reply-To: <20260830041901.2668-5-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-5-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 30 Aug 2026 04:26:15 +0000
Message-Id: <20260830042615.7D5F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The flags already include FGP_NOWAIT which prohibits all reclaim, not
> just reclaiming from the filesystem.
>=20
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260830041901.2668=
-1-willy@infradead.org?part=3D4

