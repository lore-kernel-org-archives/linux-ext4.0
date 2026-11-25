Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587542;
	b=esvBY1a7cLCfYLzGeYWpVmut64oD1FeRi6Q0CwT9gU4pBNxXrMnTMoXv+R28eyTCz+Az
	 I83yUS74Pw2oLmjCFt1DeS44GG1AgPFv3m4tYyTQUXVt4lkZzEXaLuw4JxzuMUun4EC8A
	 VOSu/grHDAUGSCk+VQtm8JQ6lK3kPrGQ0XCoZTF4Eg4Nd4Ab+wdZfvBA4Yk9FzjoWq7H6
	 MNfXXckBIP5Q1zB6MPuXL6iSn+CrQbWssYnBW2xPWLuh2RNYVjGtoAZGT8Hsivyn05wHx
	 YG4pT1Ow3UEkp6NhrZwIMvezYtx7C+psdhA47QwFEbP4h6I77/HDJJ+C55fdMCpHnlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587542;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bhEYhnaY0k23LCEXTkTBeP9S08YIh/Lzm0+NahzOiAE=;
	b=EuUCEGEvEfPUDBLO47izHO3CxN+OdTManCgjrp7Ppu2ATOOXAgp3G3OiHH9je+UF7W8r
	 WDgBIQ/rCdLf0h948Yk8JWEE2IETmGw+d3Adh8+KLKy8Qio8b/10w650LZX8SRQ+1JNSX
	 JXtN5VE7nfyf0rqzVoriLog6kIgaefZXvRipo+57qFsbPVtHiI7yfw2SobHvd45tI0CeF
	 /YLdzTG24OA6/3YOqJ3UTjDU/5AWZO0VZETiGNCAGK9Czc7BynewLOIybQuUPcOWZ+v2r
	 lF8NVo34hUWXje5/yDm1iPWEOUCXCKkXBkg10rYPJOOP6dAanoG+1JUkXE5POQBJiOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FXtlQMJe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C189606A33B;
	Wed, 25 Nov 2026 06:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FXtlQMJe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C212C1F00348;
	Wed, 25 Nov 2026 06:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795587542;
	bh=bhEYhnaY0k23LCEXTkTBeP9S08YIh/Lzm0+NahzOiAE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FXtlQMJe51CBu2bNU23ejmY+SbeiG9ipJ/s6m55Y4xTFA+zAiIeugK05F/4WlBcWt
	 RPio5qO/KfZN2TGmlbGi86WY7+cmrbfsjDWNCkOswUZ6KU5or4XR5PssdQEXSaxwpn
	 2Y0ik59VKpAzbOaQ31jBZdcyInoK42DepHgbgVg8XsGqryadcbM/C5P9z57W33gxsq
	 Nw6mVGnmuYnQlXdWKGogo69L7VjLFyu+Dhx/CV3LdMKhYq9Nnr4hmweUK2vvWyUGt7
	 TsnNXNUnSQRXvz7jAbi/pClphQcWpnPmIo6Jr94oFTL2I0bmmpHE0VpK25ERoiwUTH
	 OAr1AFuGnSvog==
Message-ID: <sashiko-outbox-232669@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 00/12] docs: ioctl-number: update entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261125061340.3402300-1-rdunlap@infradead.org>
References: <20261125061340.3402300-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 06:19:01 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 12-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125061340.3402=
300-1-rdunlap@infradead.org
