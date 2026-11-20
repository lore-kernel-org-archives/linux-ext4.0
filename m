Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152969;
	b=zrj5ubaFaT+N2wLpsg6b2b6TOZT4Trbjx5fyocmwY+c7/WcBVofm262kKOSs5pMbbFP9
	 7HTMIWL+81FAh3nBMSKv9g1apdDjphz9PDO/ZSL24vbYrc2b98ioQKTh6NY7XGT1eP7ga
	 5XBYaOlARLRqFiT4bJ18ItYFEx8sLuzoHHwepEeL/5V9EfMzcduzd9/88eEK8V6t9UNJd
	 GJsxywzpXwvwKCU8hVdm9nRiDE3y5ngsBsCdZ9Hzm3V3G93rBsE9eJtN6D1IAa2Hg4cct
	 BSO/iXfmojp1mBQSS8erumtihcA8RiXIHmhO1FtCQCcFa+wHS+vEz5PHkVB5G+HIYhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152969;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mML7YPQ7izKwUTQcvCs9l5PSqFEUoZWppXAZWVM62G0=;
	b=u9/4j1iRb7Ogy/Y6TldSzPcfy+IJCf+Nj2hDpxZj3JmSdpAooSTxRd+YIO0Ya9fgbvNe
	 xGKdbqfsFxhPv3DcjgEOPH8n1hReqVibitoiqOuqzSFqMXExLJWGvrHUe2tLkRWiKEiFR
	 SnYk4fLzFxRCUf7XmhxqnJOPWkUVGjYqUp2Q3nRYiQPZx7KUI6ZN8fergzVXZzko5kEZr
	 +c+aDtQY305svrJNRh3fbmHUgAHM2vCT4yRYX6f6zPm0BJVWT+AjFgh2RK66avOzIjGST
	 TvxIM3QCSH+nzY2Ro4UQCtgueahFBgrg5HmkOi71pGVxluA1i9CwHKsGyrHk15+P9NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jchD+NBG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5B7606A331;
	Fri, 20 Nov 2026 05:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jchD+NBG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3075E1F000CA;
	Fri, 20 Nov 2026 05:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152969;
	bh=mML7YPQ7izKwUTQcvCs9l5PSqFEUoZWppXAZWVM62G0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jchD+NBG/gZJNkz98w4WRZNcomDTK5cYepWEECy3ZaNpBlJDZByGn2KxOpE8iBi5q
	 gLY3bJpEZ0RfpNMizAMsbvViYCM1+IvEZUzQ+6YaYYmK7nUcikxN+upc8yD2m6JC51
	 RCvfVXZHvdGwour1Sk04omiuNpV1oJkkur26uZmNjZlgPk3qlBtGAplBmWAz7jgkBo
	 QcnVZd40eTZvANAJbVIIHNOcNWV81rzSxAIkD9FZU1IyElXAHZ0yeBBIfvSzhba0xz
	 t48SilS0PUQUXlgZA985q4fNnYNT4qL2NBTP9TXd8N9XOFOdgCey33jqnieVf4BJEv
	 BjnNOnPwT+QEw==
Message-ID: <sashiko-outbox-224496@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/12] docs: ioctl-number: update networking entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261119053514.255348-5-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-5-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:08 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where networking ioctls are defined and update
> the ranges of function numbers that are used.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D4

