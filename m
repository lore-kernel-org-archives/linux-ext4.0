Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED2D37DAD5
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991248; cv=none; b=SjqtOlOvWJodvGVf09q5xLkRJJ7pVMQhLTc2gbRnzS2mSy1meshsVtLjt5iO4cnipGC4yXXUnfBigFAbGQsHMJtXnPfTgJ+zwqSgOKaFNtf0pPNi0b1LUyL00t/h4tFIaf5bfxCuzkyDEHUHxEzWYhhGF9Xqrto3bTjwoM0xtLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991248; c=relaxed/simple;
	bh=vpHLp5jfniwMimCHBWAAF5hBURDlDss1azWugKlI2Tc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZG7k0/1tAwBsYFiTmpIgrYQohRXFotfHH+PCbhHe6fElNX3EJx2N0YDlIT6GcjAlraF8NBrDNyCO92SccCg3j8A56/CsJiiYpMOCVfLxDAcG0ZpA29ZBHJTqEAULJQxC4dYlZ3cHzzKq67ZGQB31ryHuE+yFVD6iPwa1Smask/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mShQn/Ld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mShQn/Ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4141F000FF;
	Sat,  3 Oct 2026 01:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991247;
	bh=vpHLp5jfniwMimCHBWAAF5hBURDlDss1azWugKlI2Tc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mShQn/LdoGt603GAu2y3/uqQ4+D8e1sdj3kkPGeAmdpMM+ioU0q0fJxxqMpN1aTQ/
	 JcKAMk0wQ/baJgbT4oiCxldiAoIsFtUCQYuCxrrDe1Vyu25AiI3Sg6IRoj08036zVn
	 eIldxx01feyuCs/PMnltrIcw5LkxvMADXbwhSQnrHhpHjYs5UKmzys8fpizxyeuIne
	 +FRQA4RflKSmSuUF3DK0TCqPBz8l4Zh3hXV0Nqx5sENCP+DCeb+OD5GeaL53Yeuobz
	 LGtizmb2bBkogwfygY6qRmcrwM93lZK5m466xg/ti3/kSZu+1GW9wfaAsHxIP0I3X7
	 wgvubSpDOV04w==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 10/21] xfs: don't report dio_mem_align
 and dio_offset_align for fsverity files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: tytso@mit.edu, dsterba@suse.cz, linux-ext4@vger.kernel.org
In-Reply-To: <20261002223705.2175542-11-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-11-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:06 +0000
Message-Id: <20261003013407.0E4141F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Sashiko.dev reported that while fsverity files falls back to the
> buffered IO for Direct I/O, they should not report non-zero values in
> dio_mem_align and dio_offset_align, meaning it's not supported.
>=20
> The STATX_DIOALIGN | STATX_DIO_READ_ALIGN flags are used to explicitly
> report if DIO is supported or not. They can not indicate that fallback
> to the buffered IO is used in this case. The zero alignment values also
> mean that DIO is not supported on this file, see statx(2).
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D10

