Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1824F68C2
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 21:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790631468; cv=none; b=iCKbXfkJ4ufeFUQPAbyS63Hk+4aRFqADyWWjSqzAwRtNi1VSul4fAcHrCTcBOz+IRG/Ug0DthY0mHpnkcutFV8u6sSl7Gt/cRAY/L4hwyLO8Jl+XqPRtwc1sCEhDP5SIjKDzFXmO6WuAnu9DtgBBhtNlj+6tc/+xvmNU4MRkHlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790631468; c=relaxed/simple;
	bh=nCQPoJP0dfpN8HI75s1fNfEoo9qCeWvHzTfWSLudf/w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=updt5BOfC07Q2L8fdfSUV8ZnerKXm9q+NmjhDSPokxYHKGXSVj3FjVVTASjr+JZV2bqAhEWqZJuKnU7tywLlLqOL2FEuDDkUa7OmDIS9bpPhQri1WNICj+93mzi8u8dKsfw4PfmVfju7VyHppW3XXwRtwbTWLMDhcbJpMRS1A+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OTqITKLT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTqITKLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86371F000FF;
	Mon, 28 Sep 2026 21:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790631467;
	bh=yzc5P5ADSNKIP+QuOlTbpHT68adzBmkYh4Pzifx8/4I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OTqITKLTwjTfMNI+IrpMbuEzEMfUpDAMA89PWDwV4fpQjWzFITf1+TsmnEzaf3nw1
	 PmIk+4PlSuVVUdXsaWytfvIbJ3icnFWDLlZfhXHKXgXQjJtHX2kJc4DThRTLU7AIVX
	 fQKJjI/3DF2Git97vqjNGNvs8Vh+niIODWB0npF/mdGvmI0o/kDXg3q4txJzZzsU2a
	 DwGr140iqVaSpwb46F3uAHRjbgDTflWJbZcWf31SfcEF6qj0/KFhCJJpROcxr8al0M
	 4Fa3tObzP1Dp7aF/LtBK0qXwKGy4/z+mCptaojHqtXd4RvXG/DB99nG/nRSBVOsTUR
	 SJ65IPB5i8Brg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] ovl: Expose the filesystem encoding through sysfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gabriel Krisman Bertazi" <krisman@suse.de>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260928213155.2612039-5-krisman@suse.de>
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-5-krisman@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 21:37:46 +0000
Message-Id: <20260928213746.E86371F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> This patch reproduces the same interface from ext4/f2fs to have feature
> parity, so users don't need to rely on parsing dmesg or trying +F on a
> temporary directory just to check for support.  Note there is no
> encoding_flags file, as none are supported by ovl.
>=20
> Assisted-by: LLM
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928213155.2612=
039-1-krisman@suse.de?part=3D4

