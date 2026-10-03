Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27AC388868
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991256; cv=none; b=I2FaSmUgGcxqI23R0EFlrZ/Ve2rkKQt/r9PxaJw5j844D/cA0Q7NJyKeSm9TiFOhQsf3XijK+PM9epqFRBDWk69A3Zm3Kz2DBg4WmfypbyC1BvSVuJqUyrf3ksqUPVQu2qD4BRxtJ5VTmM5uH5ypVGoyokoMFJh1Vp+qJl654NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991256; c=relaxed/simple;
	bh=Y4AUZLPXpgOsjd6bjSO3Q6zfsW8HSqS/0PjyH26fbXg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Wy0d8HyrzOEUcBkJBLim3fJRrEwxN32cgHx74291fLIqhiEj7fCv5uWULy6eNbGPdAfx0TyzNZIQnz6o3uj4zsDcrngKC9bta20YzE1eyH2fPlwwGqLokej4SFfr2ZIAduEhsgQ3VF70cw02xeJU38NlFor2sCc40o08c15TlkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+TggBh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+TggBh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B26D1F000FF;
	Sat,  3 Oct 2026 01:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991255;
	bh=Y4AUZLPXpgOsjd6bjSO3Q6zfsW8HSqS/0PjyH26fbXg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a+TggBh/LWQN5KAFUEx7NofBC+xrPNIA4Pr1i5xjeomxILgrehkfH96eMlb6Me1wB
	 ZyTVLz+junuKD1472eDvGcdaZITXaGMtVxwp5CkNNHRMyXtfQr+vAdKFe/ou7ZS+Hn
	 4eaeLYO2I74JsH2MhKi73ZzvTdogHZ8hlod+IXEwZLx1kxTCvtlhGATQzT1kK+ACT6
	 /5ZXG8SfmRXzXV4P2U4EKd8/XjCuRFmhJxpE6CcoV83S/3jzzSM/5ydH6B/ydxXSNh
	 1GlzY72gFEdCeRMToCYolRYbOWz4Ky1Nul+DO5F6KnINnqE2qVl72edhLVGDVwDAnp
	 kR9yvcbc9CVGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 08/21] xfs: don't allow to enable DAX on fs-verity
 sealed inode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20261002223705.2175542-9-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-9-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:14 +0000
Message-Id: <20261003013415.4B26D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
> inodes which already have fs-verity enabled. The opposite is checked
> when fs-verity is enabled, it won't be enabled if DAX is.
>=20
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D8

