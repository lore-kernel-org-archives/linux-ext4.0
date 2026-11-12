Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521512;
	b=DfZhRjmYJ8bj9Nq504IhfbEdhhO80LRTKjfRJyA3KdODCq/n5dz/JDTI5kl3iqlmtIuE
	 4Kp3y01Z/YuxAseml9yMKCZKPmwyw6+bO2DA3ilbergKvyXa7fkAs9/ZmOpn/IyJHXOkd
	 6P72We02YRlwv4KrLWS84FJqjPgb6xqVf8UelGm9DI6bGkkKex2+tY7L1xRXcKFWD7uUd
	 jiIyH929dh/vkZFJwWHGI4G6Dcvog7NoIUV8F3KyI+Bee/ejxOtFse7CfCM1vpfPfuWO3
	 I9YBKdZ885s1V89hAu14/4NOjWZMc7EOjj/9wlFPzjUdX/eE4LLZDppK0ktlA8iWyVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521512;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=b369l5bgi+Ag6eu+JfttK0GpMVrWBQQohXx4R68fSBQ=;
	b=S6v8sypfxthfOfVwoWLbko7bLW6NAnk8oeywG772beGQrcW4d7K52HHeLX3/ov5PgSMq
	 3SVG7vsfHERjR4ukvtlZumGjiYGAiYpUeRdwuHiFrJewTKEAE7tD0fuOrvAXTR9968ima
	 /5Pl2fyl4vnKnrSLmUD88bYgtgoAOcakKVZpTUgr+IjpVxbGijv3s79IxfOkzWGXo0/eF
	 vigf3S981E0k97SWegBSLgb85RTZ5oWUhftZAbpyfqy7dxa63WI7Gj1Cp6yWi2F/iu0j2
	 zuNbjii1+8vs0c+cz9XKhybHBCYBIM3y28QQdHi94d7rdADA/TbJuSEcoym8+g5un8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kOZlC74b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B1B606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 22:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kOZlC74b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234BC1F000C4;
	Thu, 12 Nov 2026 22:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521512;
	bh=b369l5bgi+Ag6eu+JfttK0GpMVrWBQQohXx4R68fSBQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kOZlC74boB0O6c7dwkPmWvr+B3WyxC/DP/D65o7OfVTS4kVw4fER2X30mQgpQjOqv
	 38ZuaRC4Ij6EYq1dMcipz18MfU6wSkkIUzV/pE1nLUExPGHo9GSwl1kxlaVTFziNCV
	 TZeKBgidNZnUoNLIUEecsedLHRQVUoBfNB/FRsWnFtJoQWboS88KFY3gj/0Wepv/dv
	 HqM9U0z6KXQ7yU9uBnIZexjjMF+zi21FqXhMo0dPYLm7ZnAcLWaA4O7yA2drIY3CXk
	 pbsKQxVYXD6KGgnV3lvhr1G/4i9pdW4CcmDo30GEEW0He+s5gZ7OEdIUpROZ3QGOAT
	 3DRTwf51o7xSA==
Message-ID: <sashiko-outbox-211891@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 08/14] xfs: refuse writes to files racing with
 realtime inode flag changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-9-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-9-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 22:11:51 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Christoph Hellwig <hch@lst.de>
>=20
> Zoned writes need to reserve space before taking the iolock to avoid
> deadlocks with garbage collection.  But this means that the realtime inode
> flag which indicates if the file will be placed on the zoned realtime
> device or the main data device can be flipped after taking the reservation
> and before taking the write, or after deciding to go down the regular
> write path, both of which can't work.
>=20
> Re-sample the realtime flag just before the actual write, and refuse the
> write if the flag changed.  Do not retry the write using the now correct
> path, as switching the flag under a write is not a normal use case, and
> trying to flip between the zoned and regular path is an inherent life
> lock as it could be switched around again the next time this check is
> performed.
>=20
> Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
> Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D8

