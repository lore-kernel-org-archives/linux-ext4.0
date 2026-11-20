Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152976;
	b=v7gd/7gpNTtZMubfkAnDl5yqIa25k7VTsqUK6jCcHanv4utNbIBArK6gZhVzkSyd18Fc
	 UGu8Lj1ioT9fsQicoKVbk4G+PMxmbNPMbUa0lcW4bLbhgbbeWTBC4r+lHw8XDfkELcvlw
	 zDiS3A3qRFkxEGHnXKZiduDFK1MbkhsH5OlgsmcUPZuiNh+8dUl0QDCQspKmd0OAO7un8
	 pWcbosQjddtgOOJgrSC5t+uO+PPeyVCDmW2aUx08RyYGOfCNSAFxzgCnjAlfGM66nNKlO
	 8wemw6W98JEI7MqRxZctFNkVGr2qn37z/pQv/KeoOhdFBsspI3TXObdIwWTKgIbcKkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152976;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1yB5DtQ0oL8qnTNwJPZU7sgU4NJLAlEjlUuO0QZiijg=;
	b=4a84obDE5r46NvEr2rDNsrqLcA6PrwY3KdVa0o6aki60LUSKB5oxYT9IiX2LS/V7dwjc
	 wAd7RiOyfIearJgZycPM2eJmWFDWhWTYRwk7z0u1onNKT/4cHfSbMyRZ2EtZORLAR+Am0
	 dpKYPGcXz1RUGWo3O7aeLYb3roHfiU5mNfsja5AIR0bGXqDs8DKDgsqgVp4oyAm0rbux1
	 GgWugUuEiH5T/h+GyUnxQKr4GMfPRWWCsqFvKbAX5QL/HCaAevjfzptR48f/qdYIx3CoU
	 slY+GjOkB9qifROTuTq2ydltntzvlD/RCWL4pJl/y+/zRJTaj5cF/ZqpzSv9OUbULpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cr3RlTYu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ED260A2607;
	Fri, 20 Nov 2026 05:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cr3RlTYu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2411F000C4;
	Fri, 20 Nov 2026 05:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152976;
	bh=1yB5DtQ0oL8qnTNwJPZU7sgU4NJLAlEjlUuO0QZiijg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cr3RlTYu9afGBAKlsffXV5bJ/2L3t9uMqTb0u0F0fFKhSjc2A28jnuMGqOSQVGfm+
	 xkuiSMYuoeOYZozzc+enbvhw27fE5UQAKd6Gl6jCkAO5aaLSI/CZyXeKX0yeqIMU4B
	 hAnca/ETfhZVE0z/a6zNkZbfgmkM4i1fYPLz+nmjLsILhJf7cUQF284ww5ORwVvKg0
	 /jcQTOmkyXO2o4GnxrE5HyzYk+egkBqLYIpj/tiyjuSHrq/K5ZtJHP1P+Z3PNRc1lY
	 UPLLwZgqrSmmBV94AwEYKGeSZjTyqb/gPrlCG7idlcBqwJu1RDKVk6u2ix+0vyDSob
	 9V2iqCy785XhA==
Message-ID: <sashiko-outbox-224500@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/12] docs: ioctl-number: update USB entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261119053514.255348-9-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-9-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:16 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where USB ioctls are defined.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D8

