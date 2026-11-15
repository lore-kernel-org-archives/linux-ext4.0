Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774459;
	b=fwfZ5to+UTc/unRce0EmsZaLewCK5QoKIBlEJI6sDAd+bVYT2ggoczwlb7VQb9rTkQql
	 iR3nlqt7YuIIXd2ByjrV04ktjce/VqBMPzJwk1oJC47u/OeMMaRnjvNmFE7spvLcPc3Ps
	 wHooEWT2E2sMqxWnu7f26YGqVDJ5VolKDfCVIrFDGAQNJwdhkPbY2MKqptvWmU/inZnqQ
	 4mi80U5VStxa5CXIJnPMz0OBtNCgHNsIdyQUoTGhvoLyXnsDxv/L4lNLSt0tHw9cCSjrU
	 r9dltazUD+dUmqhB4bbYWqpBrMUb7S2e64HrllycoetdEjdBEQU7hhXtmi8FS0mXCZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774459;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZkaPm7sPTICjS1BJ21ksfk12GsMu7KWSLnZgV3D6/9k=;
	b=XN56XrLSCUgK5u8sENumlHn79klwJPGXC6QJVUL/nl2Od8pM7DV8OkVF/Cfuvxy9kOvk
	 SfN8tpoqEn3C1FUnJ4i2wUdhAGNmy6fAkKXnB6CBW9SQqysHVIp7XSgcLEy7BwXHLj/CA
	 yx6eDJ0TMFBn1TiiNiPfQmfV/6Y8TS2PShM0AbQPfK9tsZ9PEc2spFrBX3L067TKk+HVb
	 UCkXLS2xLf3S1xCX8wdYYIqb+Y0EKrwOEu3+CiEnGspKnhIa3q+UQEs+wJ+uyZzPISUo1
	 UV7Ghr3oiDvC7qLtXtShDrsNo/FakHV6iWFJx+bW5HYy+badXeS/8emBTbgSKTkhMTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Ukvi/2Dc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7D0606A881;
	Sun, 15 Nov 2026 20:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ukvi/2Dc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3C31F000C5;
	Sun, 15 Nov 2026 20:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774459;
	bh=ZkaPm7sPTICjS1BJ21ksfk12GsMu7KWSLnZgV3D6/9k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ukvi/2DcfDpXfNfA6Zz7+SmJ5rE2OmdZArTCjsXEPsnTAwJr0c1+uu1T2miIV4bu+
	 IFsbBvxzjyxw5B0GYVVWmxB4qTYLZOzSJ8q6a9tW5W0HteXJ+mjkL2gk7ZfoHue1JR
	 3N/+A+Jxx/IdHkUZwb2rB5JqSXJzDxYrRCSaoWVfeEnOXmiX9Pr8ncFwhmHwwCPrKV
	 vwTgIsKxOdZ6KtMvKMuyyVx3twC6iqZegUSsPnoroPbU6+oUgypd4bU8YN1eH/XA6t
	 CxnF9aBodNP7REFtytfG8D7BMo3qE6r/AAfAYNa/X2qhwXY+GYYolDhR55HpfvnDy2
	 P1Fnp4jT8+JQQ==
Message-ID: <sashiko-outbox-215801@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/12] docs: ioctl-number: update MM entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261114202653.3113381-2-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-2-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:27:38 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add ioctl number entries for test_hmm_uapi and gup_test.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D1

