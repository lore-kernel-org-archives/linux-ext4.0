Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0F749AA57
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 11:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790163831; cv=none; b=jT9PAK2VB6pY2Gv/cjr8GtVQlncys2MKIM2NNmRjxk1KlrIXfukgn7dTpy+ZSFoWYOFAZuGy+g2lmw++8vvb8srSakcVHh3UYjmdWfXT4Awamg5ub54tD7JO1oGFRIQNQjx8snRn2Wvt26DkiXCZDy/RwIKFO430W4qi9F4hHw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790163831; c=relaxed/simple;
	bh=XnNW8IbkQ4NhIs6d9lsvWjVq2dmYU7Gqzr7KgDJSIUg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n3UfqHzx+fbNqEGBTV7hoKydlRtTcTCETshDYLCWZbpC66K8+lr2sgUGTPianKJ/r/Lmtw5Qkzt1tb7BfSWNnHoxjgAIMZzPwX7zm0i0FPHxWbTsCL/CActEeqSmCPisL3bs6v6j+do+w0zTUKzRa2UDbiKRSRQ9Vm0K93w5uzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=caEaOthP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caEaOthP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78681F000FF;
	Wed, 23 Sep 2026 11:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790163820;
	bh=mKU5mNZgWyJY+rrPLshp7TvyGqoP9XzXMQzNFW69wic=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=caEaOthP3SV2Rl3Hv8GTvWrCGST4N5wdCa4oPRZpBROCBWmWdMS38nak9Cknomxpz
	 hFBHu9PTZu6we0Y02g2PCV3xs7mo/7IOhFasIbUF+TmMfILDa9/Nl0aS2L6gbE0Kma
	 dpWiRlFVcUX5tH9jmS5glAm8GFePi9stQ2pOEZ5p/wdpjy2j18Hrd77Qj5pRmjDuCM
	 HkJlgQBcoLHE/DxTwz7y3Fn0ZkM2h7/3W7y0uKn65hZycnquu9PNzuIlA9epNvGB9n
	 PKzTyLfOyrxKnr9vtkatl+3qzoVaXPFRkmWT3wQDeMFmDtNXxOHRB6VkYQC23rS3FN
	 Q7xg4PdSjgA6A==
From: sashiko-bot@kernel.org
Subject: Re: [REGRESSION] ext4: oops in ext4_finish_bio() after enabling
 encryption on a mounted fs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alberto Garcia" <berto@igalia.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <arO0KE9_Jf8rNRwN@igalia.com>
References: <arO0KE9_Jf8rNRwN@igalia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 11:43:40 +0000
Message-Id: <20260923114340.B78681F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Hi,
>=20
> I'd like to report a bug in the ext4 code. I confirm that it happens
> with the latest stable kernel (7.2.7), but mainline (7.3-rc4) does not
> seem to be affected.
>=20
> The problem is very easy to reproduce:
>=20
> 1) Enable encryption on an ext4 filesystem with tune2fs -O encrypt
> 2) Create an empty directory and encrypt it (fscrypt encrypt /foo or what=
ever).
> 3) Write some data to it (head -c head -c 10M /dev/urandom > /foo/file.bi=
n)
> 4) sync
>=20
> [   42.962615] BUG: kernel NULL pointer dereference, address: 00000000000=
00028
> [   42.965440] #PF: supervisor read access in kernel mode
> [ ... ]
>  	mapping_set_folio_order_range(inode->i_mapping, min_order, max_order);
>=20
> Regards,
>=20
> Berto

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/arO0KE9_Jf8rNRwN@ig=
alia.com?part=3D1

