Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795678360;
	b=eduDqU2hN1Of8Tpd1nzfAmft37Pz86PiXqS7IXdwCGoaNODK2squjL5l8TFh3g2Iv58v
	 HKgLSGvht59hGUQdumVF/td4uIG7DxAP8RiiMihOHEw+5TpedbXXp4JM+go7unhxs3Tic
	 O1tZSp8GQ3Peg21ucj8aLXLORYgBlnWEUiDkbN5zlcy+FOmR0w5ONQl9LX+DJSnbXzmCZ
	 Lx4/8yZFokY/ivLy49FKt6W6jEf7ZQ+mcWxCln4E6iZXRvfpUDBIvS7ijnGv+YSEt7WkH
	 We4M4GLj2NFlL+xGZGhP0VVst3zZEtJdjG+pRWvQAn1vB3NkAjoIbEIqT6b7hGbEmPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795678360;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MM6uGN7jmV/u1odiDKud4M+k06rDQ2FxcMSvmC9PqW0=;
	b=yLheI2FxOyLrGY4Lzn2bgaFj1UBji/uMA8Um+Q0RCo81mJaElCNaZUlAb8fNMuFF0cqz
	 k15qQqMvybIfjyJqvTXnbs1hVE00gXupCilkVGjFjX3gf9511QHjfrfKn/n4+7s/+n/rz
	 TL7gYk3/tQzXEaEjvIDb/bccUv8dNcgdTo9HAjuHJNVLLJl+8Uo3dsFEXyxB4cliwG5zd
	 jzplDSgvqaykwiBolslGeW3owdlJa0iaXEoajN2o48BbEDiySlxpS4ii2jZgqYitR60cj
	 PsJaXvpawW7GwkzWlwy5A72rfPzk+22InYE5MXwBSaksrm5kQDsaBH/TItF+rOSbASQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Te6o0RQp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511F4606A31E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 07:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Te6o0RQp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C471F000D0;
	Thu, 26 Nov 2026 07:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795678359;
	bh=MM6uGN7jmV/u1odiDKud4M+k06rDQ2FxcMSvmC9PqW0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Te6o0RQpmMaxvKoYz4zPMYCMk8JX2RTOIzw7yjIR8EnBo2O52X8CTGF9B+Nqb1vzb
	 zE9lNwYQ+Q3vByxFoEhjnvwBSVMGPSo3REuvO1DzAwrgUP7GsPhMRIFyd0/k1shqI7
	 cXdGPQxUcittuUo6VY6HYKqNNO+tcM9YEf0jItu0odkH1vYsX55i1TKbyiqNv1GvPd
	 375tgMoB3ITDqwkMub4p+Kx7DfYEM6+fzdjun35mR+dxlNgInFbtCmkBAcmb4YzAyf
	 CgUKhpWZXr82L0F018JtvRBoabuNPf1MPyqunrRqbSinbOxotjHxDXFlT/SgOj/rVZ
	 LogkHsZSySmug==
Message-ID: <sashiko-outbox-234960@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 0/5] ext4: fix inline data conversion races
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arbab Haider" <arbabhaider649@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261126070748.272109-2-arbabhaider649@gmail.com>
References: <20261126070748.272109-2-arbabhaider649@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 07:32:38 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 5-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126070748.2721=
09-2-arbabhaider649@gmail.com
