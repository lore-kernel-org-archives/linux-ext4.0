Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F173DC4CD
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2026 14:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790346393; cv=none; b=rkTqdY2bX+sY+JCvSA8sgWdx6O0b92ty/x/Gm4Ey2Oj/opP+v8FnZeRuIzlNG01kmHFCnH5QWno13g+G9TdG8/2RWbb64u+zmPJdJv/dGpwXohgfagk34zm7mHCGGyVggo0dw2eRK77od9LM8wakwjrSNNACghi0QCEXzR1yKQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790346393; c=relaxed/simple;
	bh=fV3Jgkl/ECw7yPuLbrcfSprVubY/tQ49FdawjdY5JG8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Iibcd22W9yOPgHKUqytWnTTKr5bSuTM5xKPadumqmhfeAUezJ7Z3M0CrEikmxxnLBtqOv87STYbnnCtRaEK2EZjW9Z2a0bBVzmBZFua14EW/hq9cqF+luZ3qnaEhXz6fwMWs/G6/WQkaV8FZ0cc6C0YonVaGqzncP8mdDBpm0cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BN7jhv4Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BN7jhv4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDDF1F000FF;
	Fri, 25 Sep 2026 14:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790346392;
	bh=fV3Jgkl/ECw7yPuLbrcfSprVubY/tQ49FdawjdY5JG8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BN7jhv4Zmv7SFvNxF+QOu5RsSmrfpaEN/SckohHPsBazyHQIzc1GWKUIhoFSWOvl8
	 oytwaFgBhxAdTSCILXplnRemP6gwQM6wNjyI1yFg5XqMFz93IcusztTmfluyCtsB9j
	 BcMFRNgMWoHpZUy1xRp/7ejO551AYgKbscsth9vq6nFv6KzEdLdx/qNQxU8hLpwHsW
	 ry6zhcsD8Z2YkU6hsoJ1xm1hXJmvjzY0kKZDITmMj8YoYqwsngWgVcMPtZxH1CWHKT
	 iWdSBV7V8U3BKSVHLT8H5Cjp/HMGUZEnGrS1/Kv616w3RTbRnURyNMLalkQ+3Md6DZ
	 iKxb36Bf9AqsQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] ext4: reject encrypted inodes when block size >
 page size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alberto Garcia" <berto@igalia.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <aeb8efa8beb72721fb4b13cffe6eb22c795ec33f.1790343958.git.berto@igalia.com>
References: <cover.1790343958.git.berto@igalia.com>
 <aeb8efa8beb72721fb4b13cffe6eb22c795ec33f.1790343958.git.berto@igalia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 14:26:31 +0000
Message-Id: <20260925142632.4CDDF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Encryption is not supported when a filesystem's block size is larger
> than the page size. ext4_check_large_folio() refuses to mount a
> filesystem like that if the "encrypt" feature is already enabled, and
> ext4_set_context() refuses to create encrypted inodes if the feature
> is enabled after mounting.
>=20
> However, a corrupted or hand-crafted filesystem can still have
> encrypted inodes even if the "encrypt" feature is not set, and those
> inodes can be unlocked if they're using v1 policies.
>=20
> Check this in __ext4_iget() and reject them as corrupted.
>=20
> Fixes: 709f0f1f1bf5 ("ext4: add checks for large folio incompatibilities =
when BS > PS")
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Cc: stable@vger.kernel.org # v6.19+
> Signed-off-by: Alberto Garcia <berto@igalia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790343958.gi=
t.berto@igalia.com?part=3D2

