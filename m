Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774487;
	b=Gp+gV92TMSMb9JdXRk3cL1fDZ7vbyepBlALFSHOwT9+BXfS1TInw9oMnx8LEIyUYUbq0
	 Nd7xNYprYlVj9Fzs0mQ4Kq/Qteq4Gh8n3hHKHolHzxILFC3wBaR57PXKjWXxNEdpoeD60
	 KRhh58nopuXJO0iFRu8aZvFFTESbpVf5ybN0xWPTBlU7T4p7yd++i5kxyUYO00ca0w3jd
	 2TFD77WpbbHZ48ncp7a8S+i3JvDs/PBRw7JPllG3j/l5R1497kB/hwnOcII/W790encR1
	 /QPG2a5jN9I3nZXYyquq3n8q/uu+bNhwQL9qGfbXt6trvt44lQZy7IOCLuk8TQ+bFqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774487;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RWc/Hl+m9yTjFA6sAmo44EdrFLPMb+VUWPABWdt/C4M=;
	b=RScMbJFarhfKRMUOwrsz3o1Sl1U6+4c4EzXSfEovJpDbys/z164R2X/dZzEUTF84GGc5
	 GwQpuWb1ew6g+BIlBlrv/XG6XJqiOL9nPBP8iwiNIwchcrj+4rQLQYWyViS2sTMxdiCCw
	 EPnl7slJw1LHcf0vil0FYsDDoLCaksyiBFnVQhiYilI49wHVOiB3BdFCDZ+YAFXTmg/lm
	 nz/+LxCP5KU9fHypZTcGMvdNxv7bX+kGpneDEvUai3g4aFGIDlkbRxz8QZ+l9mk/0Wrkk
	 sl1QJ2ZdKiL04QfJe2WeTZAMOBoFSE88jt6b7xZxOgD6/QLVuaD63r33MJ32yg7fmdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LyNPhGSc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E226C606A895;
	Sun, 15 Nov 2026 20:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LyNPhGSc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4B71F000C6;
	Sun, 15 Nov 2026 20:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774486;
	bh=RWc/Hl+m9yTjFA6sAmo44EdrFLPMb+VUWPABWdt/C4M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LyNPhGScmYoecwqoRzwkEqFRA5owZ1t4Cccq2RG67LmGxx8gs1Nxu2S0ELySCIDih
	 lK9FEeuCzII/fvNaaWRJ5fUdOzxtYF+aEYsLWxf7xeAJANHwtoQaewtMh7cRmk6N7M
	 vqtkwCbvq91/BbPfytHoJOforVSSrYof2us/cbeNDWMkPI5IMsQb5GMtid/r3xzgiY
	 uNkXtpXzkn4epV3jKmbJAnT35t4MTxUgCPQRcApBezhXiNKz5eS1IS99s4bXclstr7
	 MYR/5vEDjKr0Xta0IZQZzpNXj3hALZJ0W9k1Fymt3vTDxRNpXXCVawJR2XRoPHjHO6
	 Pf9PfkWAC03Bw==
Message-ID: <sashiko-outbox-215812@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/12] docs: ioctl-number: update DRM entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261114202653.3113381-13-rdunlap@infradead.org>
References: <20261114202653.3113381-1-rdunlap@infradead.org>
 <20261114202653.3113381-13-rdunlap@infradead.org>
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

> Update the list of files where DRM ioctls are defined.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114202653.3113=
381-1-rdunlap@infradead.org?part=3D12

