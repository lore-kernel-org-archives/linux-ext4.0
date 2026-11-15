Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774485;
	b=lwQZB/9cdFkkXwYt55Y1dur7LV8dmjYdzPX+sNnfQPae+Oa3SdaLgsPGVAHRlutb1QyP
	 dTjqQebYiuxZd0r5akuHN15ez/de125XgaTIEU0VaoFyjQJt3WMLWw2W7Xw6ghBHuQdpH
	 D8/uDUlh4DsP5FnVtimsIKj9HQ1aeL9MrrQmkQqJsLPGnd3jB4AB3eAfhWM5f+upITT87
	 PYpRAhrN6f6J8sMfF9fbIGZoLOQweVkCD/KQUY3OFWq+E0gIlGEIuqcfRh35jTci/9tLd
	 1aY7ekW3HKhBseK+vH5vHYCFQqaeQ4CWBJJM9Mjptc2eHI/81CKpu1QuHA1jgCW6Lyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774485;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wiP0nkNI2cMH061FcrwRGOG4AeI4j/f/et0pbcLEJfY=;
	b=VYy3mu6zKjUODUigejv44V4ArVp+tEqBo7086g8AUUJkPMgvpFSmsg1JOJpdNfqxlHV9
	 Mrwxnei8+uIOhARHfzuyKpOJdn9dGHE7ugPgGsjMjtUTI0Zbhi3qtRkZE+uLFJbgNpUUb
	 dvA9ltw/dNK2vz8CBTMm2LGeF8lFg1qPtWJ97p79gadJopQYOAKpBhCyOhy/hWc89og3l
	 lp3FECIIi/IWftJEuUAWtGHB6TXS1VQFuI9USxoWZY7B4fpwcNUSUYuSiodtxTI6G5CKB
	 3KC9eeJOVmPqdnigZcc7bZ+3N5IKlz9MELv7BBUBcqH69pbcXoHTsFvdLzPwc1Hl+UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f7SrqFuF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6238606A88F;
	Sun, 15 Nov 2026 20:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f7SrqFuF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8521F000C4;
	Sun, 15 Nov 2026 20:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774485;
	bh=wiP0nkNI2cMH061FcrwRGOG4AeI4j/f/et0pbcLEJfY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f7SrqFuF/d/bSCZvpwh+R8ReX5kdgw0tXovYwF05QVgiyWjzGpvAN7JwzsOBUUnMW
	 xR/7yuVNdSqRZVrwiFbLjKc/U//G2rzq7oTOK/iVsartFd+qqutcp4D/BL3Z4I2sY3
	 L4wOUU5zL4mmXMzrC3wv/pJWKV7YcNcS29ZVN4tL8vTmR8/ICPcemf9dsF5CF4Oy7P
	 laYTV3YRbSNVpxmhJ0leM0KvTJFeWh9DeqqrU0rOtdvsmw5GBXTb7CVeLoxq9r0Pvu
	 PjHvsfNdqrG4NchdKLumnaQQb+1pVhdTPddUvzJB8olbXaJF28PqvmiQlpEl8tYJDL
	 p7CrYHE9GTEVA==
Message-ID: <sashiko-outbox-215811@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/12] docs: ioctl-number: update platform entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261114202653.3113381-12-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-12-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:28:05 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D11

