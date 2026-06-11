Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1423E15687D
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 08:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781165949; cv=none; b=EeUDpA1ONUfj5FzyW/jcsTasXtgl+sIIXp+MPlehXyWj/Eil/8h0TgUIE+1aIRWRe7JJ73K4fmuRUjzgT22Wm3WZHhaeeAJrxidTq2VmfESp0ufaYMNLCXjsjWzAeN/M1CIsp/auGAHIIpfKeV4qNbXvndCfP8g2cTOhMbrzyMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781165949; c=relaxed/simple;
	bh=KpvD5Ga5eWMXKTTFjrheibc4Y300NeDX7vc+4EY3b5s=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CKZo0WVDzrKoUJc2Ket1PJoJEeqCmM/w3ggTdouCALsjtmZ0xZ2tY78tcK3L8U0pW6Am4dsStvHpHuQbd1JPJeDZsKrE21fl27JLqXMJf5Hq6KkPX5tXT+AOp53+FE12CMFtHq4xgt0l0ixNXN/3KAPxqIq6uu/bxgVWOB+f1wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=Uz3Yq0V9; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="Uz3Yq0V9"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c8584e80bd9so3014507a12.3
        for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 01:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1781165946; x=1781770746; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tVxEqKn6ocLrzuV33iOVBCRnoOTfHEw6HV1JNOcCxk=;
        b=Uz3Yq0V9ukV3LgXKrqH2HdTjOQdeDccHZlIwQIpHhV+Ehh0S+SnI2JOZBMIpxLlsau
         A5HdUXRxuA0FCtkc0yYkutgWs04dFU/Cox7XH4RWyNw4cwNBaDy/wAz65tB3YqIDXbJP
         7jtuB0o/GhPnFKDTlZqkED0OKIFvSsg50ElqMgoOJT2y5nBzQlX/5bQIRSbVRe4V6A0B
         4CBUxFD4sjQujnFgnrxeU3kdVmz4pfoAPDGmvVyEz364BvWzeJ9BtQ31OcO/VaZFSi+h
         f+5KRg6cVk236UHKDOveZNtMQT3P/bIr9edTSWwQbhF2oSFBv5ON3Vpp+mFBDCqeMlEX
         Z6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781165946; x=1781770746;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1tVxEqKn6ocLrzuV33iOVBCRnoOTfHEw6HV1JNOcCxk=;
        b=Uuz9AKDtLELngUCTKO/YvOrhnZInqMHkpafnDLyw15nYDNDvnHSoYWsiFPtD5HmG+U
         1P1mfmbiux99Rm2j48JUckbpV8CyGJ4CWHRjGcVFG3Ibaoc9go9RwsedXHXSCvpUZVcL
         c2KGrDefVLWYF/DF1E01XIPkinNCoYSz2ZgK4m6+2iUM0H6iFBM81bk0DbNLxUi4CCdT
         am8EUbxhpl2IAAbrhE4b4/dKxZT30snB4/QwcrqISEShnILp9FjIvIeWtkc43/XjuuAC
         rHkSyij4KkhPlK5N2LpZekwBZoLe03HjI7QFIwsq5imbsx8mUfsrJ0gWiIKQ9ztLvduU
         mM3g==
X-Gm-Message-State: AOJu0YxKR3ibHntHywEJJG6McGvesWujnf57+LNXKAIiL+Pxo52EFdCf
	dakFYz0xiVgyr7Se5YoTfrqfpce7FpMFpqrmsjvaPqQiAZmU28SGWi0y9IZph34JLlDpcgpYpti
	CCU68JdM=
X-Gm-Gg: Acq92OGMi01jhnzpVMhP2ISuqId0SOh3vB0LJCMQSZILurP0Hr0bWpl1Vi+wq3muB/d
	aRLpw3RrHTH/Wmw8DsEHhZoKRGxN3HPELyc7UGvaJLUcpM20sMfS16cvr0yvjcTOPKQ1ZGZJDx4
	R7DrFaq+WdOyBpccXcGAauzH1oyotxbJGYp4NJQs4hbJZOzAlxtGFT6UREsRQu7mflLZtUsphtZ
	+MQbVm1IzLJE4Q5JARuQPTkesiTc7p0zbFbber+pbZxSmJojaSVD3M0afoF3QuPJLzrCV7JUAFS
	yMn7eP04ly0X4et/43xFdx3Z4n/HzlzTiVKrFQO+zTRaTjQ68vwCepMW1IwBIutet2rgi99UdAv
	IW+jD3WpDlPGMFYbKmnMcwQTvT42SMI/dnDLLUAxgI3Z1AwGurmWeIsuYr7+BThCtZInAOLNGSq
	06P70DUWt+jdNGHyVv+wbfp9uKQk/8t8STmFs/mN70XXh3y1yNdawVvzXNLyyGaxNswZM99ibXE
	+cM404LZKA2oqvrFrRG4ONFPag=
X-Received: by 2002:a05:6a21:7a8b:b0:3b4:7b3d:179e with SMTP id adf61e73a8af0-3b5e319191dmr2012906637.8.1781165946236;
        Thu, 11 Jun 2026 01:19:06 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c865880a1aasm986407a12.22.2026.06.11.01.19.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2026 01:19:05 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH][e2fsprogs] build: use correct subst variable
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260611035236.307622-1-dongyangli@ddn.com>
Date: Thu, 11 Jun 2026 02:18:54 -0600
Cc: linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7E56AA97-286E-4C13-8571-E6783CFE1E1D@dilger.ca>
References: <20260611035236.307622-1-dongyangli@ddn.com>
To: Li Dongyang <dongyangli@ddn.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jun 10, 2026, at 21:52, Li Dongyang <dongyangli@ddn.com> wrote:
>=20
> ifNotGNUmake was changed to ifnGNUmake but test/Makefile.in still uses
> the old variable name.
> make fullcheck fails on some platforms:
> make[2]: Entering directory =
`/var/lib/jenkins/workspace/e2fsprogs-reviews/arch/x86_64/distro/el7/_topd=
ir/BUILD/e2fsprogs-1.47.4/tests'
> Makefile:387: *** missing separator.  Stop.
> make[2]: Leaving directory =
`/var/lib/jenkins/workspace/e2fsprogs-reviews/arch/x86_64/distro/el7/_topd=
ir/BUILD/e2fsprogs-1.47.4/tests'
> make[1]: *** [fullcheck-recursive] Error 1
>=20
> Fixes: b7d1ab3376 "Update configure/configure.ac/aclocal.m4 to use =
autoconf 2.72"
> Change-Id: Iec3cacfca7206bf785381664b7d7bded8c70113c
> Signed-off-by: Li Dongyang <dongyangli@ddn.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> tests/Makefile.in | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/tests/Makefile.in b/tests/Makefile.in
> index 678cc3268c..8f7a072f45 100644
> --- a/tests/Makefile.in
> +++ b/tests/Makefile.in
> @@ -48,7 +48,7 @@ test_data.tmp: $(srcdir)/scripts/gen-test-data
> always_run:
>=20
> @ifGNUmake@TESTS=3D$(wildcard $(srcdir)/[a-z]_*)
> -@ifNotGNUmake@TESTS !=3D echo $(srcdir)/[a-z]_*
> +@ifnGNUmake@TESTS !=3D echo $(srcdir)/[a-z]_*
>=20
> SKIP_SLOW_TESTS=3D--skip-slow-tests
>=20
> --=20
> 2.52.0
>=20
>=20


Cheers, Andreas





