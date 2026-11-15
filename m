Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774474;
	b=2bQTO9S1kU6l1tek0gV78V23oZd+qpt8RtrwPO5oABN634LQpAloXsRnRcuO2mM8T24E
	 VHsAgluYXTjc29OwJb8tHsuGo/NDthT2TC/8fnvmjN14OUH3wEK4I2l1Wb9/QC+PTMjzU
	 YoqYECOWCaXOBvYi8NZw6tazelpV/XxPsigP3pa7DhIbOfvwbs5pki6yOYVI4qd7eB09E
	 fEED7xAqpfoQzE/q778/WAwVo9CKEW8DqXiXPOWN8B4VsYC748QLsFM369CHevQ1Erbzf
	 pwLefNSwpivQ59W3cK+9GkzvBNk2KIw7Fwj+qrbMoACciqMRETXETZjCmdurzNWqS/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774474;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hBSgvfWNvJCthbjdW1nz5di6PD/8JDUir7Adz4W79pM=;
	b=IbpA+y2M14AIBsDS2BdrmGLCfQLJfl7BvpslnQQK6G2m/sE5EhN3jviCpCWcMkxRD3D7
	 NpZ3sflzT7hv4i6Tt6ADiGH4Xi5lV1L6yDx6ycxOFarbE+EZv749OdtcbdLnsISR/D2JZ
	 cqwaQQO4wMUuAwRXgcCR551PV5nFqtuLoLp2L9fs4r0DHdhGbfJkilxJUmtmQBRcfesDj
	 UvDgYe4yuljlKYaymn6JWE4G7EbqClU9MdFCgKyzip0yQrNd7Go8C3jMV3HFg8MiD0vRJ
	 1VpC4I0JppgC+CXIkw2XG8ewGBJ1phQlqvukiwNx+rtbjswYw+dXAq8yqqy+7q2G9dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="I/QCvQJ3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A8760A2601;
	Sun, 15 Nov 2026 20:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I/QCvQJ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35D81F000C5;
	Sun, 15 Nov 2026 20:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774474;
	bh=hBSgvfWNvJCthbjdW1nz5di6PD/8JDUir7Adz4W79pM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I/QCvQJ3gm/MLlBJi+KPtbH8SqpHUAj9oFH+KxU7s2j9P2gXdcrziv9sPKqkhBvs9
	 YoOv8qmjK+TU8+B21h7ZoMHchRbETwp5n8DQUDyMqgTmCiDiv2hlxs7/n1qzteJAaY
	 w9KoKqdNuQgunG1N5hnM3tt3Lt5q/gIwfBRidfQ/8+oox27wr6CEEvJ1snEVQbnmUz
	 LVNIM2+1yZXkSfaUTqunu0GRX0fIH/WZJrcfntD69qFF44lRyLov2hR3rJ4WqLAmNU
	 o7eQ/wHtCeIiALeLaYJLgYuMrWsBrK9h5os0yM5KLtdfxNbWjghb51xr7CY81sn4yT
	 a4eYzwspjznWg==
Message-ID: <sashiko-outbox-215809@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/12] docs: ioctl-number: update virtualization entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261114202653.3113381-10-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-10-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:27:53 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where virtualization ioctls are defined.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D9

