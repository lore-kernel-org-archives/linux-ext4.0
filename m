Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152974;
	b=QqMWjrbhZsP1nIJ82BugcRwy0AFyPj3ZrcLUfZi+eTMdPeZezcn0HFXcYBGxeUdt8wkL
	 P2v5/NUkW5hK1cdSZpuE71ngj5La6dMONbjafGLGCwXRCCladR3Fq1znfb5Ut8aFnu75y
	 TNLrnvZxf0/VgKO+EeivkyzBnUnsDotFnO51sxUQwwRve2UxjkQd6TrOcSr8v2zTRFkBE
	 Cv8u8LeT7P1z/q3UBvzedGuJZZFo2HkjP1ovY9xeBk4wMUSjH/0pdDkv+jIVXlq+2ZL6L
	 iZAWYGDfSLsW1XxV63hXetjaOGlOIriCD4r/S/g+EQJB1KIUbvGv49fS0mP7frkubzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152974;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Kc484x702nSo+xgJgZfW1MT8EYBt2+sqNJlbHoo4tpk=;
	b=146WnhpiLWTQ3ZVfb9UxB+fC/jaZV5ENcWdwQdVX9l1Rf3xPgDp364ynqfxGrnFdv0vJ
	 LO8DYedtMCy6t/av0SO6+BEjwEuCBmNf+b2+kOoBlToECPaqo/BaYn8b3UhPEcMUlKj7T
	 Icfpe3CtX62nd+gPoKkegfAVj0yza43bVCMEInZuIoweahnT/5Eez8CC9OchUO+E+OekH
	 O1UL11UZfRWwBW2e8DWY3q2MVEzwBi4JuC0ueXsqMbny23ukDUhuwqDmT57k0HDa7YEFC
	 TrCYFwTK5mywy0XFLaRjXuT2iLtSWaTgXOCTuDJbrKRpx5OlBjkaKZ6BQeXFYgiiEWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H87X8kTO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425CA606A325;
	Fri, 20 Nov 2026 05:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H87X8kTO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B33D1F000D0;
	Fri, 20 Nov 2026 05:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152973;
	bh=Kc484x702nSo+xgJgZfW1MT8EYBt2+sqNJlbHoo4tpk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H87X8kTOtTcqfkBV5oM3htxqVOktO2zDVDL5T8UpXbSxIm+yea96OSGQHQSmuOScd
	 n1l7vI/AQRTEm0KXFm4e7gAgDiZNF4voIMR9d/c0vQxTSQUEX31t+dysSnqpywH3SN
	 k6yeCIHal3ehSjltb1ym6LmaF9BZEfSnU3W5TM/hlyrK/6Z/iCD8FUjClU9EOwVZLK
	 dRuTLjdKFMZkUgyC4vDLfTYqrCoEzLZnoVPfNSz7sbiZTawtb0ncq43dMSv14iJ/4c
	 Qnp+Ti303EcvtN+0u7FPRcuLjUOQ9MP9mF8IsLjocURpjFHWLChAYAjMKxyXTp8XIx
	 LnIWZLbbzsmmA==
Message-ID: <sashiko-outbox-224498@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/12] docs: ioctl-number: update SCSI entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261119053514.255348-7-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-7-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:10 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where SCSI ioctls are defined and update the
> ranges of function numbers that are used.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D6

