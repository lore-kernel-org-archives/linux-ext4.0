Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657814;
	b=sehpExuddvVcPideG86mccEVK/YTFDbydeCNFula15lPgpMZVgA7UDIyGtDq2fjyBOia
	 DOLnOygvuohz8mtDGqSykNMBtsCqMeF0NTRTBYPhkoPk5gPxnghI76WwPGringXchEDxP
	 Jk3HbyKLpS/r4pw4XfIoCVz3GzkEzt5bFzWzJGKkwgTFaLzvH/FzNrfQ1WVa2jGbXHBgl
	 nSTHuTGBw4heDBoRZ06rpawtVJJPdpImMjfhJSa9y0SyiSyQNl9SAebQUXlhtnQIC/tNB
	 gQAPavsFToS8FEfGaJTFlDFoNtvaRZBpTgXlDLI5DqyPmGE9PZqd4NDPGqAdjdz4cqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657814;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mBj0pNnT6ZmTV4Sfk7l6RPmHEPeHMBZ88EemaVBM708=;
	b=tYccJy0LZ4bs3uqMsyfm0mVVG6QBFxvSLaEnnbz0GdNNHZv6BjGQMUN5hsJuw0pxbdEJ
	 4OnWwoBi5vT/VMhpixy/qKqO6Az9CEVVRekFcvU6zntu9uZf7iSc/Tc0IogDNbZOYtRf+
	 auC7xbLKAVvF4fFRRfPa2fsoZjPrTGjilHg2bW1E3fqcQUtNG0GjlVgQ+Vyok/DDZa4o3
	 INVSchsXACM7cTc0rj6FtsRRxIPf1Rx3pp0Z4LUJOJwOEwywDGXF8IUAHtaNbIP4ei8Gk
	 DsXINCrM+Da9zbdbNJcWA5Tf4SuRfHzeZyGBzcM6ISK7L708izUFtj6xmXrih/+ZVhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kGpsqxq9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64238606A323
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kGpsqxq9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDBD1F000C4;
	Sat, 14 Nov 2026 12:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657814;
	bh=mBj0pNnT6ZmTV4Sfk7l6RPmHEPeHMBZ88EemaVBM708=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kGpsqxq9d2NVVM80oAgjWBrlycKFsR87GMIXxf2Y60PaR844WZmrsB6+FOAjV2ncM
	 vM26L1nUWZuY/QAoJvhMHeTbm9dhB44OqoYkXxn1l11hld6lYghhTEtNEP65vAYJsx
	 GJQ9rNhjQ4g83mjWk2utdhmTW2Fa7N/K9lB5se1CAEuacaw0UQ62hC2+m12qNGWwUD
	 KqlQYBfYNJ9g2WYuSztugQo3aeNACQjDvSuHbm4wf+bl6CQ4tBvPPnUw5Wz3zhOqiU
	 8N9TejNYlt8RN0/eFCHpPE2O+l9MNqyrBiFP8xW7sWEYdUyJ8pg/KLf8Q/oWm0kASP
	 XBrqm5HGcWGGA==
Message-ID: <sashiko-outbox-214465@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 14/33] hfs: use the generic emergency read-only state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-14-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-14-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:33 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Set SB_STATE_EMERGENCY_RO instead of a private bit and drop the checks
> the VFS does now. What's left is hfs_get_block(), hfs_file_truncate(),
> write_begin, O_DIRECT writes, the hfs.type and hfs.creator xattrs and
> the MDB commit, close and dirtying paths.
>=20
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D14

