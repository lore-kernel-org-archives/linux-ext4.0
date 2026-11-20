Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152980;
	b=r04hbpQxIVtgrob45Vcqcd5c1zevmkupCmiDfZKs68WC2D1/a8/19BjPT1fmKJ/dywvu
	 XjGLnYi66R1nPPgzMlfmMVIaXgLttjw/Zi9mKZ+c30sjex+xXANMQnlcLeQyZbiO6BuLK
	 YtvM4xvuaNltIJZtUNA6CE4A13T+W/fRCkv5zYw2Kr+vOs3AZg5gv2Fh7NUPJvz80tUkg
	 rUvWDUDqqIoM4Rh6raAAudvGf5hxpe6lYTesQYleBP7DBIDF1Fbjui0aOODQdVh6lSTna
	 6XDpavd6oBFToA5eYvu20EyfKv1U0IxNRx51K2TFjjMg/rmJPBRpU/rbRAApXgG5Iiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152980;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9dGUGs/h5djo3+JIVnQpgajt9z2ewAvfBGaeqQHMinQ=;
	b=xWtrt5Lk3YJ6jE1HacejhwD1hVvCYm6q6IcsN2dM6ICi4U6cBiOI9R/ZszL10IaJviyM
	 T4vmqm9Hj/hhmCC0ze36H89KVcqXJnrvwC1FOhuwAM1qiNjOgfPyUkXtZ2yFqSG0U7/Sa
	 sohLqgKojfzBqUimMSDFVodxAWDLvsKomDKAE2yaPTSpG6IHV9FdXJgKGQkOb/cfz1YhH
	 qQASyDNH8psopqVov2JG+QId9FNx67POHe+eyT9AIgW8r18MBxjbwTPsDVWzmNYLkHGcA
	 PmvzScmKCKF4MnfPN3EG2Mq9ak5btpoWNau4CaM7cSn7cVUytDas5Yg44rvyqGA4OuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=duXa9r0S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082E360A2622;
	Fri, 20 Nov 2026 05:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=duXa9r0S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF131F000CA;
	Fri, 20 Nov 2026 05:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152979;
	bh=9dGUGs/h5djo3+JIVnQpgajt9z2ewAvfBGaeqQHMinQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=duXa9r0SOb8ZEl+YRVH+/r54qi4knUogxZIzh7tdfzQ6GlMiv5t5vKPnWT7lz/pWc
	 sdP0aZShMI5jCQXbaWvG0pvR3F779i8UsT4aNozZmdMMh4u6e96J5Rts9DFHOVN9N9
	 77T7k/NEd8rSHm6kWmDKxBWZ/zca/MLfUsp/1uoZs8+negK5IelesouWdi5c9puSDw
	 +Qyc/QlEuvjzN7mGIVuOT775Ud4hUHWsIytAjOX3eu7B62ikSNSbywV55oucNYHPl3
	 bx8MKPnuHpVrypOW4fknLTkcu0d6beD9RTzLP53yDa+cbm2IOv9cbxdoNHv9/n8Izy
	 2ovSxKsdY2OdQ==
Message-ID: <sashiko-outbox-224503@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/12] docs: ioctl-number: update platform entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261119053514.255348-12-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-12-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:19 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of platform/ files where ioctls are defined and update
> the ranges of function numbers that are used.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D11

