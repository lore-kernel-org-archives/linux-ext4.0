Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152970;
	b=YL0ORf58EHNSBhbGZBQAZ5b3ouQ7k8VNG13eOwTvAXZMR0W7bC86BmufdXMJCA1Oituh
	 ri7Z+wroXISMva/PIJc7zZqRFXLOqYOArswV8asDN1rpQ3ERKbzPAf6O2Xv0AVyn0ItaA
	 MNXDyNFYy1Q6aMS9VKobRgITCF2F059N2Ptq84R8VF22Vw+hhBihvgTGyMBcDtPZjG6jr
	 duqep9IK02dJfSs2528c1wcrj+bqMKOca7E9gd2RWOdXBHcj+MObhivyl2HEtqcrgHthu
	 HpINbE5pEMDjPuRa+kloVk09Q6ltd7kPsbqsE1H4ga59suVRu0gzrBC1h289Ylgp5Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152970;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=P/dcN3Qzoeg2vf+4IvObgBnrXQDK/oXAeEjlXpZi21o=;
	b=nXSbg3fdVtrPsEVz/bHdV9OSOmVy1ie1Ou8gkXc4x9dk1e9Ao96IclPah8CTa7qjm4Ml
	 JlmG0YtvvFHhrCKlbyDgJZS4jref4mQxL67+fgIwzga3moQoXr4Lhf6tMBuyCsGYZBmFi
	 uMfN2f6THmLvMJqoMHYyB9n97DkfzNwIoVmqw+AOctbNSh2S36VftZFc9Lxs+9EZnlYvj
	 bhwzLtEphr4Q0K/lpIwPe55YX6x6q+McX5HfiUZSVh17HgSho5GBqY086sKY4sxBwBl21
	 LS1OqGzLACnBxgi+MOfw94D2L1PU3tLVEezKAs4b8sxjf6gxEW41Ub4PfU+aAo8QBOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="OLa7PE/T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA7A606A33F;
	Fri, 20 Nov 2026 05:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OLa7PE/T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA5D1F000CA;
	Fri, 20 Nov 2026 05:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152970;
	bh=P/dcN3Qzoeg2vf+4IvObgBnrXQDK/oXAeEjlXpZi21o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OLa7PE/T4qTU77Zal8DkyqvQfAH49pQc3vNWr9wWSOXZCPD2NV6T+o1VotPfcrkQI
	 fo66O2C8v1+wduXYmpNG+/f0o/a8YvXMI7Ufgu6ct4Rczl7WsjepnDz/HqIsgw9vhS
	 kZKdqqZIFA16sSwc3u2sWxDW23nH+dRcDngfDdhO3Vgq8BXnTjgMCLtJraGiydRkLj
	 u0+kaWB5NB0ycmbiX4BT293KR6FaGbGEtaoW7gR7UwfYuoTZlNyJYWixREtF9B6H5F
	 jroCZAC+JfgqEd4qNANzxJWZN4lNeGfJoSCkzzzofN/kqQXuCKMIdDwD0UcBvbmvJB
	 SAQWiz4/KEl/A==
Message-ID: <sashiko-outbox-224497@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/12] docs: ioctl-number: update video/fbdev entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261119053514.255348-6-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-6-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:09 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where video or fbdev ioctls are defined and
> update the ranges of function numbers that are used.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D5

