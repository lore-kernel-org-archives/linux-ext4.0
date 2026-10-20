Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792461071;
	b=UbKqlMeQWJe+LfRP/q6ANKKRupEEXCX2V8G+W/AjH7ao/LQMD/eREYwtbUOzAOMixv+n
	 E/oIzmy+5eJSCiVlr5niPNEu/54kg5h06/gMhUeIpwOqV5uE/K+J3OmtLK07RdkHpEx/m
	 E+DynihTzhR9tBZBbKqbrnkyhIeae2iZdBpsoFDgUv1Hyod5nHQPGhv2svuJG0US0j2Dv
	 +mCM6T5dcYTYuPA8ZCHuRGoA2sjUJ0xMJshg0vOoK127xLE6/vVknqquz9FZqeaHdjQGJ
	 CLvv1b7EbXcchTvZ4f5zmwCaCrehmPYzUqVNQVZsJqE5Ky299vvRikVP7gUCjHvJniw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792461071;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Content-Transfer-Encoding:Message-Id:References:To:X-Mailer;
	bh=GkUROnuuq3GQnIlFVFlBip9eGtoY+U0f5TO49V3vauk=;
	b=iLNKlMtDyxd0xCQWQWUVp5peeaNrl7NuYioI7vDV0lQJSJkkckQ1iVx7YSnvWD/jaiK9
	 fROex6trFzWs5gHArqr24GL1JUhObM2NgV5WbZcuOV11H+GNb6PsmODtMFzKMuIINVmSw
	 gH8DQY1KTfTunpu4VA/HbU+7rcR3K4YrGvzlWikgSO+N5nhkNYPSoMHCAImKtIZQAI8h5
	 WoDMx+7/lN7sdWrPcEqtC4yOLS0+UBoJqSnRb068iAja9LWfLFDMdACutbYeM3TdlAc1c
	 iv3N6QgGgdu9mfbF4tyBjlPsToYpBvA3ME00gjLPVqZem8qb+eoSS3GIoZoSf8sa6TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dilger.ca;
	spf=pass smtp.mailfrom=dilger.ca;
	dkim=pass header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=GoBbALlJ;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3257F606A32A
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2026 01:51:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3257F606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=GoBbALlJ
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ea1e7fad99so1409195ad.1
        for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 18:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1792461069; x=1793065869; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GkUROnuuq3GQnIlFVFlBip9eGtoY+U0f5TO49V3vauk=;
        b=GoBbALlJgfwGSsoPzUYYckdkHBmwzQiNFNMfG88oQ5xhOvJ/lkNr4aGcOBMZMIPDES
         b3aDcRH2T8OGpJwVbaMtiKIury01fPNG9VmfkPGOA1vlNXb7f8Yy93V7GROYXpaBS4NP
         uNj9uNXmLNLVe9m7FPOU74t+eUdfS5/XwOGm5bn0rDKBj5zfwdKcYa/plbrPDi/ipt0T
         KSRK9GEyJXsAJ7DaIAyV7SSiVACZhxwqlqCRU+noYCGisFKKK13txgLQWFsNjAHdmASo
         LUIDeMzFINHMi5aBJ4nqLYbbnSthO30HMPDVuzt5FPknUCzUrWUKc5xc1epe24EyU35z
         T0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792461069; x=1793065869;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GkUROnuuq3GQnIlFVFlBip9eGtoY+U0f5TO49V3vauk=;
        b=ENvl7ucOeF45SaCqbXmiZhx44VmFxg48ytpdfDsCkg4UbgGyCjZSJK/YpAqwOYXS83
         C3ReAs03P0nHp74FyFVje/cM/1hNxF6lKPz+xm25p2shseaUKpoF8KDT1E/E7GMfDWqx
         v3FOGnRKCRqqOLbkyksn96IZyQlGb6pe3A4r+e0HVDfvYrafpt2iVP7xlCZcODFiKLiB
         vQNee9r7R7XumHmKKGlWP06q/3dU/pQgulKKkMAEeSU9Tn8A9odWu7jQfIRiS0ZI1l4I
         x7emDOdTAL2nfew0NfR0vCpKo8nNOahSVczRLmQBM/VBKnYR9pVztASvQ0vH+dvmH0N8
         lwwQ==
X-Forwarded-Encrypted: i=1; AKwUvBxKANcesR9BTxf8Dv9BZAmxg3MT3BkTKCGugVAEmTG8gZHaJE4b8kiVX6J8VfRLzN1BVCLujwv4x5Ks@vger.kernel.org
X-Gm-Message-State: AFq9FYI3EV0OiSrKJ5dGuP0KLzyRLEacOQwdr/pXWg1dOG7tHH4vXRv+
	e6YLuixGC6HwI/dBhrlBI1E3lgf2v4oM1ck6KUoLEwUnQBwpq8Do75A1AN3XsFAzLpufMgTLNFf
	XSgiyAdQ=
X-Gm-Gg: AYBFou26hk+T1HHIBYXuor2h4hSVCmoYmIjcZmnklBRUNPwQS6ZOW8QEmYFOcS+mre/
	Bh75Mk6Me5Ct6aAEqZMHYmAZyRlwWyjaPa8+t9FVCXVf6XFy2DntaKBRDjpkcy6fHx9Eu0COeYl
	Pmf+aRNYtPhG9K6p9VSkq9k9zy/WPbn4u3HAuhTyL6hwn8gEyeBwWVfNK718JCPLWqgj6wQuoIU
	AndicBz+GKKrS4scEHpsVdWmlyGbQBf9oJkbvHJgM1QlUjw97tS41vKWl2dRWjb+9PpOtnqUro4
	y3tPrVP8ypiN7TFPX3hA72KBKAnRkim7Xx4HZoOs1WxhSvDVt+zewlzHBMODL/jcLZVMsscLKrA
	dKQiBWPEyqXuWSHy8G71sUC5RuuISafzXrWZvDxhSG3YSAX/gbQtQK6bdm+mICRGsI5h3p/p/4O
	T1ocRe7ClhMz1q3XmICO05Xvg03reSCFhx/i0KKjax2N6nEv7BSIK8Qymb55aedQAZCN7R/Tej+
	S2OjDPiFCjjaIZvH1/5+zQ0KcLH7JTamZ0sytG18cfHv1QROSWfQT0k8BLl2R9H+CfSlHauZfl6
	NbZ/zsHUUzMFD9btSSXYGflzroYbB9yYR4o=
X-Received: by 2002:a17:902:f603:b0:2e5:70cd:b606 with SMTP id d9443c01a7336-2e9a705c7c9mr72997865ad.56.1792461069403;
        Mon, 19 Oct 2026 18:51:09 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [24.64.171.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea1502971csm6928475ad.51.2026.10.19.18.51.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2026 18:51:09 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.3\))
Subject: Re: ext4 data=journal deprecation: long-standing industrial use case
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <AM0PR03MB5714FB8241C13A499E7D5155DE982@AM0PR03MB5714.eurprd03.prod.outlook.com>
Date: Mon, 19 Oct 2026 19:50:57 -0600
Cc: Theodore Tso <tytso@mit.edu>,
 Gabriele Moabiti <gabmoa@gmail.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4FAF6F56-F054-474C-8538-92D8309FAC08@dilger.ca>
References: <CAAbJaeALOrZwWs++mz9Wv0pfvyDoHmfzPKyVHR0v6TwnzLkYGw@mail.gmail.com>
 <as0U-lfet5slrD8o@mit.edu>
 <AM0PR03MB5714FB8241C13A499E7D5155DE982@AM0PR03MB5714.eurprd03.prod.outlook.com>
To: "Korber, Markus" <markus.korber@anton-paar.com>
X-Mailer: Apple Mail (2.3864.700.51.1.3)

On Oct 19, 2026, at 02:51, Korber, Markus <markus.korber@anton-paar.com> =
wrote:
>=20
> On Mon, Oct 12, 2026, Theodore Tso wrote:
>> Given that there is no guarantees of what writes will be persisted
>> with respect to program execution, it's unclear exactly what your
>> deployments are requiring or assuming.
>=20
> I'd like to add another data point in support of Gabriele's use case.
>=20
> We also use ext4 data=3Djournal on embedded systems where unexpected
> power loss is possible. Our main concern is not losing the most recent
> few seconds of data. That is acceptable for our use case. What we want
> to avoid is corruption of file contents after an unexpected power =
loss.
>=20
> We performed repeated hard power-cut tests using both data=3Dordered =
and
> data=3Djournal. With data=3Dordered we observed, among other expected
> failure modes, files containing NULs and partially written files where
> the unwritten part contained NULs. These failure modes are =
particularly
> difficult for applications to recover from.
>=20
> With data=3Djournal we still observed lost recent files, zero-length
> files and truncated current writes, but we did not observe those
> NUL-filled corruption patterns.
>=20
> So at least for our use case, the useful property of data=3Djournal is
> not primarily reducing the amount of recent data that can be lost.
> It is the different failure behavior when power is removed during file
> I/O.

Hi Markus,
are you running with delalloc disabled when testing ordered mode?  That =
might be the source of NULs in recently written files.

Cheers, Andreas





