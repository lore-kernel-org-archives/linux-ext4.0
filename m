Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D584C9561
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730843; cv=none; b=UNR/ypVuQpxhSf7q+Uj4A/rqrf+mQA9dtGvRxIb5tub33toCOgGI7Gro1CkqkDcoKok69mkIMapSocCBHbiDm+gJf8rFB7sP3F9WZKEn/C3kx2WcmgbQ8qlXrqrzUoy4vbfF9qc+TNQqyglLA5b3G5G0ZjHQAEnTPtnxqzsGWq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730843; c=relaxed/simple;
	bh=JNTH9appiV1ifWWj9LguDaOeHQkyvq/E/rT/MXRuPiM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DOMqSuRicc69SCRihPM2eVkejhg1wyNR43qzRP3wCV2OHD8nTIiOEXnIFUIF97o8eZMK3a/Z0YBWBXA9eX2EUqrZ0oxoQkY3ZjFeGg7Mqxc7iSMqtGdIB5/xNEAwveBcsukYeVA8xpgpIZLQ96VnfzsbAz4jZoFaYwkAx8afNGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dn4//NMv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dn4//NMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE841F00898;
	Fri, 18 Sep 2026 11:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730834;
	bh=JNTH9appiV1ifWWj9LguDaOeHQkyvq/E/rT/MXRuPiM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dn4//NMvUB6wnkYdB8zjiKun+F1//dMPGDTnZssVq5/5VstL76Yw4xM6cqXpebmGH
	 3dQ01n7rpAj/bm+i7w7VF85NCmY3/5P+U55rFfJF7KIWeKjbAoaAZk1HWnz/4YFx9z
	 CWG9c0enmKS17Xp04cNdcpEy57Jr5IYepFWFFlT2fB66Ufkmkfugl5Af6lx9caJJ3X
	 xvqj49eTR1lN9OI99WDc8YWNixzr+HUZY4q/6WHlMLjOAZFcGfx9Hpt3aB9lMdkjgo
	 1K0lnNoJXilJ4xK6DCfZzoXr+SdlTvIBPiVDl+CYlq593aDMCu5Kl8XEoeRYrzW+SX
	 47dlUBvs7LLuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 01/21] fsverity: report validation errors through
 fserror to fsnotify
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20260918111539.1003439-2-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-2-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:27:13 +0000
Message-Id: <20260918112714.6FE841F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Reported verification errors to fsnotify through recently added fserror
> interface.
>=20
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D1

