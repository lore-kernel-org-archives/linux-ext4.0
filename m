Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F76C481238
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2026 10:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789469284; cv=none; b=Pbst7b1DwbJXwigaX0oAvqVmQNSxg2kikbkn8vRtxo0XyxqRdZTmqGcf0sOP1HYhAMW7Ieoap+uWg6MUGYeknUq80MnYIAM9R2PlIGJEx0F6psOVUCPtkjseMRE94Q3V7do/NA5abTkvVwCz+6uwegtz34VFESnyEECzUw0TzCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789469284; c=relaxed/simple;
	bh=1IktuH8llkwiH9PRgJn/Id4/A5iiExOlZpU0Cju+e5Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KwnFXU/AGwJolEhjCXk3AKIl35V/H/abP1hnsVYD4xR4hLc8pncChL15uzBZbw+WCDxOdstLKabuUlGU4Bzi/WmPa/EcN5w/Nekfq+YmfnEpwjxCxINr7kbJ2SutzViE9Pe8BvLKlbd8hhu2NYwx1iTesJH/GHVy9rDd5FoZQms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCYlhE9H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCYlhE9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F241F00899;
	Tue, 15 Sep 2026 10:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789469281;
	bh=1IktuH8llkwiH9PRgJn/Id4/A5iiExOlZpU0Cju+e5Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VCYlhE9H8ROTuaWkxJcXcFW/BrRqE4JYtElxnbRnUNk0l+JZkhcSOAaKhZSAkR9fa
	 z7AKYXEfNqeBVjbyV19LmwfIPVgpn27ftKcMXJ5HZmv7iLn0jKngnu18jXiOjwFNnY
	 uSgVd8h+MfP5kDm8aqklRk694lv5WxRfRK+L5AO2fu+vwq+YSmzJf6e2+D15xi84jv
	 wMdw8nVLDjaESmNa/GlQgdaf15hJueSvsQig9J8m5ZdGpRTYzxMa4cuCDeuWoGIALP
	 Qa2X0omFeQ1bx36ErrZYk/wQVRQkqEJgSmcCU7QNArWWrNRowYURLkOysKPKy9aoip
	 uGTdzF7OpVgbg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: propagate errors from fast commit bitmap rebuild
Reply-To: sashiko-reviews@lists.linux.dev
To: lty <781735889@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_B320F7091730E06C02BAB57D87B0CE363107@qq.com>
References: <tencent_B320F7091730E06C02BAB57D87B0CE363107@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 10:48:01 +0000
Message-Id: <20260915104801.86F241F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> ext4_fc_set_bitmaps_and_counters() rebuilds block bitmaps for modified
> inodes during fast-commit replay. When ext4_map_blocks() fails, the helper
> stops scanning but previously returned success. Errors from
> ext4_find_extent() were also discarded, so replay continued after an
> incomplete bitmap rebuild.
>=20
> Return errors from the helper and propagate them through both replay call
> sites so journal recovery aborts when bitmap reconstruction fails.
>=20
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Cc: stable@vger.kernel.org
>=20
> Testing: With CONFIG_EXT4_DEBUG, QEMU fast-commit replay was run using a
> temporary fault injection that forced -EIO in the bitmap rebuild mapping
> call. The unmodified kernel reported recovery complete and mounted the
> filesystem; the patched kernel reported journal recovery failure and mount
> returned EIO. Built fs/ext4/fast_commit.o and a complete x86 bzImage.
>=20
> Signed-off-by: lty <781735889@qq.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_B320F709173=
0E06C02BAB57D87B0CE363107@qq.com?part=3D1

