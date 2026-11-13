Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794554715;
	b=ROAiHlQYZhuEpE5xlZAaQpLd7YZ+izpNtMa2gRGXlL2haR5win6YQDv06Fxb8JS8DNF4
	 3oOMS0+Nbka+H9vSB1rUBt3g8gn6wJGeA/9C/I7zieqR44ej3DwTgTPvuLo5rO81FzjDn
	 WzMfdq17zeAAug1YeaH9wLyKZq6dUOH087hZnatI4sxttrpgdj1loEVEE+L5zJYaXkaH7
	 joLZgtfi/sTzDGncGeqFYb6ueFh9Da0AEqDhmSgHvZMMTMEDxgeFw4R6XsWsa8d+VJkcp
	 MHX78Y2+XN2eMtOvHQmEYRWRut5c+zxUD38LhWXsEBynO/XKfgvjEnTS2vpJ9zKT6rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794554715;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ajwiPX+jV6AKXI463gQtW4uBICZf0evjdTw2WWjpWVQ=;
	b=s1xgldOCN5405psx84xOAqGJBFApOwpzt+BuW4/rHe8re8KB6PPg/hvClukVBm6fS1GB
	 j4XHhjTS65KO2t12okA2WCl0VtxqNSNt8WUEqNUDB9TCfe6k3t91pCx3QVFCcR0nssVLL
	 CLI7UPEsb5ql5+Fe7XRqeyq9F54WKpJ5azU98B8xjAOlseThnkbcYCMvnnI3/edWT+8ux
	 Zw0325iD+GZjeX9cE/NIo72nPsCEun6st7T71gnu+HiAS3zNEKn+zXrvOzflSudKzJHL7
	 TKKGuo4Bx6qwm1bVgvx1DmiAc/yfhIA+v1lgFMB+MNryF0F/iw3PrLlm7hmG2HoUrvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AeBve0fM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6574D606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AeBve0fM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68091F000C4;
	Fri, 13 Nov 2026 07:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794554714;
	bh=ajwiPX+jV6AKXI463gQtW4uBICZf0evjdTw2WWjpWVQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AeBve0fMb7UbAB6/nBt/o3mR11mqIO3oovEyQXq4P0I5yCaVroLO5TPT4Rb/DDshq
	 fhoSpmSrRCCrZzBX38WfQBUSbSUJ8mM3j+0CyHNGBXMWQMHU7mU/k9miA0WtlnWeOl
	 bB50SsB1f0pG4Sit052h6Mulb18Y79A9xrqmU71vrdQApOlZHLfP6RDaNfJ6p3tnp1
	 0Iz+2e8UODITu4SbAHMMX6suyM8fxIgEWDo7y6c+MiVZ53GFDD5YQxAvxjVXpb88k3
	 enyTRD+/0CShdh/Kg/QvxBjxWiIouUuC0IqWqsWQQqpJQSvkMlVYqY+wJ2z6AhdvrB
	 /NCMW0+jj/eKQ==
Message-ID: <sashiko-outbox-212343@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 7/8] dax: refuse dma-buf iterators in
 dax_iomap_rw()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mengmeng Zhao" <mengmeng.zhao@linux.dev>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261113070621.273953-8-mengmeng.zhao@linux.dev>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261113070621.273953-8-mengmeng.zhao@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:25:14 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
>=20
> DAX copies data through the CPU, so a dma-buf iterator has no meaning
> in the DAX I/O path and must be refused.  A DAX inode does not get
> FMODE_CAN_DMABUF_IO at open time, but DAX can be enabled later, so
> check per I/O.
>=20
> Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> Signed-off-by: Li Wang <liwang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113070621.2739=
53-1-mengmeng.zhao@linux.dev?part=3D7

