Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A877081A
	for <linux-ext4@vger.kernel.org>; Sat, 19 Sep 2026 11:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789818399; cv=none; b=qUNGqtBx/jXobZ8eNaEEGzaEaPhomFMfbpL+K2pPl11l10EYslMYDHPe5K4gKpKaGX5j81FG63UxNJ9BJyldnr8X2dbB++0072t+KiCIB0iB5EOTckabMIHnd3ES8jaFNCV7SFEiQiDwHKKOvmzGaQ4h0ayuku+YFHP4JdQjguE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789818399; c=relaxed/simple;
	bh=6y33SJzA0Xv9DUIgRPPZlMSL5Ztylq6nZfk51YRHfo4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jBFdKZ3PfPhVG5xGl7NLozsAQIeT1SIbhBltpXPznB0pV+fjqiqVjuvULPMiunaBreCI2MxU7S5a49K3k9dlqA1RiM0r3ZUYET00jslfCO+Q3eTMEuX+lMzbDstqBkynrfEeBV7aH8ioyxGPDsecijUHv/LtKwz/fQQtG5w/doc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/4Gn++J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/4Gn++J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2AC1F000FF;
	Sat, 19 Sep 2026 11:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789818398;
	bh=nRqwuZKM/8wqgIn5OWnZKnllycSEbRPVLUR2YOA62hc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T/4Gn++J9wymGt0zHOQbAkcHj2dWPvJdiwBJmhIsd1c8LnHBsd46ZpAsShvVlicnk
	 Xhi+TpMZ9wdLLMTY3GrT4sUgwrLpaXDfmq2Pq+LKPx27BWU1X/DKxKycBKT1D+vihC
	 ZQKBNBUw7EzGvljoHAaM7t2yzcgKhTphIIQqBGYyhk3zwtr95xRRuaJoP357p8VC74
	 dz/gVo02HLEOUyAyzNQg51Dcx6m4S4d+JX0POHikoRsEd//FrLCx+bZ041PESiATj6
	 QK/UFPaDttpz+MO0rUjfhE4kT7Z7G0wIdgIjwgMJiA3DHwOVIjSqWanOBncZKxadky
	 Kfr/VTKCpqo5A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: stop verify_reserved_gdb() one entry short of the
 block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kaixuan Li" <kaixuanli0131@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260919113940.1823559-1-kaixuanli0131@gmail.com>
References: <20260919113940.1823559-1-kaixuanli0131@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 11:46:37 +0000
Message-Id: <20260919114638.1B2AC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> verify_reserved_gdb() walks the backup group list, reading one __le32 from
> the reserved GDT block per iteration, and bounds the walk after the read:
>=20
> 	if (le32_to_cpu(*p++) !=3D
> 	    grp * EXT4_BLOCKS_PER_GROUP(sb) + blk){
> 		...
> 		return -EINVAL;
> 	}
> 	if (++gdbackups > EXT4_ADDR_PER_BLOCK(sb))
> 		return -EFBIG;
>=20
> The block holds exactly EXT4_ADDR_PER_BLOCK(sb) entries, so when gdbackups
> reaches that value the test is false, the loop runs once more, and *p++
> reads one entry past the block before -EFBIG is returned. The same value =
is
> also the largest gdbackups the function can return, and
> [ ... ]
> them, 256 at a 1K block size and 1024 at 4K, cannot occur within a 32-bit
> group number. The entry the old bound went on to read was therefore never=
 a
> real backup.
>=20
> Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919113940.1823=
559-1-kaixuanli0131@gmail.com?part=3D1

