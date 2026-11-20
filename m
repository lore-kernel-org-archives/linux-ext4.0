Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190378;
	b=UWe+DzJiovl7OhyikKwPp+L/mpwTJ8DtJ8dMe73AmHmZOJliR+FCONFS6+k7H145K/1I
	 q12jtwFDTpB9vZequkVU8BCQd/xBQEEq5Xu4cp8zb/fGQ679+APNllY1s3sGbXGZM7i0j
	 9yMFMVgMZdTbddrsAL0gpASj9R8UJc9LAP5SdowzE/MCQT5zuB33R2NcgyifU/y7AfNTo
	 q59oEs+cys1FPiZAj3alOqmlD3DcGvh0OQU18nQgjV4c5H55TS+d7wr5NwBmVmCj5HrNz
	 FKo11MgI7p+qDBIS8OEiYGnu6sPbQ3YNr7v8P8ZuzEw1aCYH/DVoFTd65ZRNj6A4lCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190378;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=73peBqxsJIJW6Zrm/I8W98IAZuRLLNl4A0hJKTdIfJ4=;
	b=odjfbTYDHSOfTp1Da/ISqjzL2vCrTpNWld2v/yrPhbFnnv9Q95/cK4pKi7IfFGGH5Q5g
	 Vt6f/zwLxdkYZroF0JPVWfuzXqQFdEiqxlkkUOeqcPD83Ixna9FMf0k1NSWmptsV5qdpM
	 pM/qLVFJXSy5fV6VRzH4lNgntxjaNS0Gv16isBZ1q+yo11hi2uDC1AqQekkYiv+50S/FC
	 hWCp33TjjqlunGP9zykjbTqQOkAVTVkMgynS8h1W4Lgh0nnuVr0bCXXCG/uIAUdNFTz6c
	 PNY3GZIZkEhLeD4gY3K0IicTUJofEFcwWRMiQA54f7JQ3XeDru18gv8OkFXHvlNQfyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lUIxZ//X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3FC606A320
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 15:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lUIxZ//X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ADA1F000C6;
	Fri, 20 Nov 2026 15:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190377;
	bh=73peBqxsJIJW6Zrm/I8W98IAZuRLLNl4A0hJKTdIfJ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lUIxZ//XO76drUw1AN0NUzrb9Mj03NJNe0AR91+cSsbU/MQWT/YsMUn/ZRYZGiCrx
	 mKGPpHgIPLfFkY5R53uwdT9ZQJs0H0Vikh2TXsUJZKMGSsioNBaOtO132igO8DDu8O
	 ilKIcEWTvLghC6vv8Os5cDhSlx4kAupZmWz14jBvAXNMAQL3vj/L3jZYHipglwnmaG
	 Fe3mj08tYJXTW+1Tnx9hQKqxA7YMfwgMsJ5k/FnBigNDkMT2hupJAYwbL+NYo/8Osy
	 MUsKrm5Jc8LoI0ptzIUjRMUdXNHd8Nw1SBImaJg1DX28ZpIt6BYrSvNqZJnn8X5EDc
	 +QPAdDXrYTN1w==
Message-ID: <sashiko-outbox-225499@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 5/7] btrfs: use I_VERITY_BUILDING instead of private
 flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Cc: tytso@mit.edu
In-Reply-To: <20261120155032.187246-6-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-6-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 15:59:36 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Now that the VFS tracks an inode whose Merkle tree is under construction
> via I_VERITY_BUILDING and handles the concurrent-enable guard in the
> generic fs-verity enable path, drop the inode runtime flags that
> duplicated this.
>=20
> btrfs only used BTRFS_INODE_VERITY_IN_PROGRESS internally, so remove it
> outright.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-1-aalbersh@kernel.org?part=3D5

