Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795762686;
	b=yLz1LVK4lAN2BEcvXd+FDNFeWQ7Z7VZBszmZw6CIYApj2gOubPDmK6smD0o3xCTtpoun
	 kZ2Wi8iaueoQFt425bsqwYf1YQ3oi7E+P4hF3Zl3u4uNxmii3Btd5DJ1Hz9LuHdpXRzep
	 BCE3CCH55jY7s76Z3h8tzIJK2i4EuKrM7GG7kK1B1JhPG+zZJS4D1c/ppPEuJQdjcm0nw
	 UhuzJSt87+H9rJvyzL2YnKwcK/T/I0kxW7CV6bi0EwRhcyog8FoL7fwwJBFFD05Ps/Wy/
	 clay3YjsKvHBsiU1BeNdDXKbkhPY6Hu6seYW78Dqtf1YLus7k92o9pGYAgf+0VYi6AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795762686;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pb7LRh/cnijvNuEYecbyrG34UajYJ+l56qAwmdFiGRY=;
	b=Oc4+oHJOb2K9Z1zt8RlCjTquIUetD1u9J5Lf9PMJsm/O+Xq/HBDUfAwZWQzmov5mYRXx
	 do/4Eybd99z4wkSBSr/qu2s/8NY0e2JAjlrkjWR3TRZWz1FXavmHRGPkqkIcz28qtcjTt
	 IP5Pn6l0drmQJHuIIADCCskbuRJOeEDUmOBV2XeGN7vG2Qet9iu7SisSfGSJfRM6GCPLU
	 BN5EBQIlXIm2u66C/8vzcLXyDfrM4ZBkauwarWZvNk1Jxo/lCh+XPJqehR7Nv16Q5Jvsg
	 nIZDJMsLVgtls9Yug3BBGJyv5kaD8KgWvWF0Gwhddaiijx2G7OzmKyf+DWeKTcgJHQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NuS7XLGe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EB9606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2026 06:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NuS7XLGe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C6B1F000C1;
	Fri, 27 Nov 2026 06:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795762686;
	bh=pb7LRh/cnijvNuEYecbyrG34UajYJ+l56qAwmdFiGRY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NuS7XLGeDiU1ZhWUCQrKvvykNjY7XKavXMbkIvzYBKNyW6VpQYixxOQ7Ma7zurcwk
	 0UyomJK4urxkj6ptmjQJrrWqT5iIoeT3e8TveOIJ+snzFRtyHasHjnLAOcGM+G1zHD
	 WkTefOr4wNdsl1kVG90526mXyBgzZO6TXlTljIDr2dYbAcH/grnuhxf1ILVR6AhDJj
	 imOeJ8jz9LrlpowPB0zTVXj5g+UglOraNMPnqj7R2RIVfvouZYjaWLM4EqfA1kXXHb
	 uAok+5RKFGfEWmB9PQVEGRR8BSh6duTbSOxadsgHLEJ03CAW5D5yO/mNcp3D2psCml
	 9BfaEdpAbqFeA==
Message-ID: <sashiko-outbox-236782@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] ext4: fix buffer head leak in ext4_ext_precache()
Reply-To: sashiko-reviews@lists.linux.dev
To: jiazhenyuan <jiazhenyuan@uniontech.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261127064926.135945-1-jiazhenyuan@uniontech.com>
References: <20261127064926.135945-1-jiazhenyuan@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 06:58:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 2-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127064926.1359=
45-1-jiazhenyuan@uniontech.com
