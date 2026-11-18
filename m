Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014704;
	b=p5+OfRDLbww2ahScjjr/9xFO3+0AWQWc+i8rvT1Jp+exMERG1jMRJ9O3ilu1dV5MAEJV
	 oAqxdaoSjB9gvPie+fvUb9WPf4KKWy3qqL0VfYPWGotz267h0iFHLT8OAismedXvn9PYj
	 Xb6/dXeG5k8K48sKgxdTtPUztamjtKpzXL+L5vETQ2x94/hEtIGLXZHgGHmiqxwHdtHBK
	 OF4t37x7qLrWILQ3IA8QswGte3Qbmlk25KabbTVQ7IdlnOrWe1MCywz94p8hqajJUpCWN
	 I2M4dUcEPmDrTiZSyerrr0AyS4quZwGqodu+4GboKdGriEwLIYkYqyz1TJuXh/uf+NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014704;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ode2hmaD6qkPxTHq91Z4m/Pb6L0gcYcyoNqIaFlcQTQ=;
	b=t6WdEhcqh92eN25yEXDFzdnw/Fb5yyCczm9obYH749+JcCTKpLmD7Qufiq/2HleuUF2T
	 /L/Tq69Pdp3qNXoByLJPZoBRNpCsF7ebUDNJn4vxG+I4MX2c6yPIQh6gp8UGFn/OdzTsj
	 jjy4/MyzBkTgK71vX2YRXQ8Af8pugbEW0DUzMus85WxJH3SmsEVHY0r9cvmQj/Nvyotxn
	 s6/iz0UY7nAUuVQcjkx0IEl87/VUFQhXy0KqbWX2Jp1YcxafvgtsRMrPJxwcxZwmY7htG
	 CCanDJcvg93ul+G65Cpc1MO2/EEUY4dM29unWD5NpagoXoBMI1I5+OH41tyA58K2zaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RRiPa6NS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCD7606A31C
	for <linux-ext4@vger.kernel.org>; Wed, 18 Nov 2026 15:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RRiPa6NS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0213A1F000C4;
	Wed, 18 Nov 2026 15:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795014704;
	bh=Ode2hmaD6qkPxTHq91Z4m/Pb6L0gcYcyoNqIaFlcQTQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RRiPa6NStighi62W2huxt4LuYvyn9KZ54103fIs83nhlVxmrUElnxk2C9hOBKQias
	 I1N/z7G5Gvv3oyFk26G6yS78lyZjtNPdQ9rddSHSvZ35pb+ATJRLykObvhInbZvUSU
	 xNK59HcJp+LipKFcJpN0anxRcPGS6HSnbJ7pFJUUNJ9KfMCj7/GZHVlL8Xxm0+H126
	 eCwhduy+8i0gvYVwe1dF9pvYDAOlXVAv60XljU9bl186vIBzLpopI6vGYLcfnyp1w/
	 j8U8Uw7d9uSDVBcmRuq+0+Nh/Px0lBbcQ2G95CkJy69DQMD1fJoWx1EOyruQk4NAag
	 mMjdXLS9G3Gug==
Message-ID: <sashiko-outbox-221299@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] ext4: reserve inode write access before unlinking
 entry
Reply-To: sashiko-reviews@lists.linux.dev
To: Alan <3164729207@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_D2DD501AA53948B131F7FD6358E036A4E70A@qq.com>
References: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com>
 <tencent_69B311F4356254E166A5EFDC981AA138D80A@qq.com>
 <tencent_58D8BEFB60308A7011D26F6F7E8C941C2A09@qq.com>
 <zkqch3frmclz7yjyllhcvehbpnfeofs3zt5ylg6ska7hdkf6th@gvd7pv5zrehv>
 <tencent_6D3188701BD3C36F588C221C4CD924FB7809@qq.com>
 <tencent_D2DD501AA53948B131F7FD6358E036A4E70A@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 15:11:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> __ext4_unlink() removes the directory entry before decrementing the target
> inode's link count. It then dirties the parent inode. If the parent
> inode-table block cannot be read, parent inode dirtying fails after the
> entry has been removed, and unlink returns without dropping the target
> inode's link count. With errors=3Dcontinue, this read error need not abort
> the journal transaction, so the directory update can be committed without
> the corresponding link-count update.
>=20
> Reserve the target inode location and journal write access first. When the
> directory entry is being removed, reserve the parent inode in the existing
> branch before deleting the entry. This makes inode-table read and access
> errors fail before the namespace is changed. Keep the existing namespace
> and link-count update order, and release inode location references on eve=
ry
> exit path. Fast-commit replay can skip the parent update when the directo=
ry
> entry does not match the target inode, so only the target inode is reserv=
ed
> [ ... ]
>=20
> Fixes: 4209ae12b122 ("ext4: handle ext4_mark_inode_dirty errors")
> Link: https://lore.kernel.org/linux-ext4/tencent_D60E766CE07D3A1847B81DE9=
BC37B4466908@qq.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Alan <3164729207@qq.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_D2DD501AA53=
948B131F7FD6358E036A4E70A@qq.com?part=3D1

