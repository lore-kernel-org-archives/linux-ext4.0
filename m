Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152976;
	b=wyuSrKG/xuZ25MGJy2HCpnmxcMMtB8jLgorFIru9k5WPHpSp3Pqk/KzfIBs0qFawplXx
	 7BPsT4SzczHSe/kamgKo77YdE7fYMb0cNQ3ZPMUFW4IDPh5FkW5SQwBYRxkQUF5VRFXxx
	 9ac7vrkgTyZLBcYeptiw532ORzMoa+sRLnpBO6KPtxHUHdKs+oV3A+NFwFo3WiXelW0O+
	 iG+yMepzdObSP3xvNw3idrEWNhpl/oRdYzDQYCCDRiyvk4AT/3mVek9if0WcxSBoQYc/z
	 PBPpgrPuXHaYplnj4BrsimtewRgmnE3PrhrWH/CxlOhpdFingvkcpFiqHgNH/HIOBVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152976;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GA+9zYrKT6IM3elFK8wKHwNmcZVXDYe7BstJNh/FcW0=;
	b=YNNC0n0nOIsjy0WpoeL1/bYpwcoM8Vrdv5gv555O+Lf1dc4LMkcP1b3+/dK3nS7g6VVS
	 ZyKLlWQOZ3wyeGcVtX1xl9UOR5s6gambBmZlMJBK73RUbce6fa0fma3XoXp8vaGFHlMPo
	 xP7J7b8F3HuG9KZfn938c1Zn19LwXuI0J5rBAYd/tjYJG6fODD6CIbBg2qQr6M8tWdjSo
	 kn+X5Guu4+nz0+CEDOcmmhx3xNq4lU4DJUGNBVhawVFKL8XqcBJEkPUqwyQ8gv4tdAcmO
	 ErqYqDac100bsDfG8LuzGLyjLGRyPYYiBDwqiF2ISKzXz3TDIi1QGyoMwSAMi3vkWjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dd9viIL5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305E4606A33A;
	Fri, 20 Nov 2026 05:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dd9viIL5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F7E1F000C6;
	Fri, 20 Nov 2026 05:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152975;
	bh=GA+9zYrKT6IM3elFK8wKHwNmcZVXDYe7BstJNh/FcW0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dd9viIL5fTQ2FEIHJSii7slm1EGInrKq/zBogTwHy3VE8VcxaL7KyrwstkVY2d8zr
	 HC2tUzWpGhTWHCWvxV2Z+2C2ufT/KnM8xmQsY1IUvbAawDReLrd4J2/VLaE87K2YDW
	 cijedsFupdEgao88sf2rV0A0WJZzRGxMaZ9m7/8dLgmPPL8kL05OfvoFKg4xp7UROD
	 qP8BsNTdSpaIZlkbq0DKUEggnShm4OAyXLqB0Afj4+PF1Zpm85i56UtMO+EZtZVCus
	 NJmd65NIGKGDdsLHMgjU73rbI09BKcViohqyCARb9+P2lXXbdMOcbwOGA2eRW0Wvv9
	 T5zMWY4UfAGRg==
Message-ID: <sashiko-outbox-224499@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/12] docs: ioctl-number: update MTD entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261119053514.255348-8-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-8-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:14 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where MTD ioctls are defined and update
> the ranges of function numbers that are used.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D7

