Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8193A4E73A4
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730792; cv=none; b=uSuesKGfDLGtyzdsb70QzI+VOpvpDaUjYHDrVuScP2b65qwDBe1a+9TVr3jXUrfdp8gtt1Yk1c744vsuEvpDfiIqFd+Ayn42ZexNb7iPudZtdcr35yaRAzEzdHFiXEbdg/sxtn/7TG6VrRCLhcSxkHGAa6ok8CLfMFWBRM/X1zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730792; c=relaxed/simple;
	bh=TnKbq+FhJVKdKrFqXWWXW4uW3FxT8m3wysOe+OIzCBk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fgH/DtIcaWwhVPfPCVGpSasIiiAqCLGVq06xmUVUXo9JFukCWAG38WnQMhGihvtSzvrvhmlmJJX6ekOWR3bxnuOhc33pzShKQ9G6bDC1QI2TL4RIxLQiYmqJzh9ZfDq8jApH0Plfv957+Xccq6sVxaYWEOMfIllyUOQYTVWasTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oZRQ0YuN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oZRQ0YuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FF61F000FF;
	Fri, 18 Sep 2026 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730787;
	bh=TnKbq+FhJVKdKrFqXWWXW4uW3FxT8m3wysOe+OIzCBk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oZRQ0YuNijhRuRN7oKpWaDSGfOu1NJOeF8lTnzXaLENB0Iu4ugBj1kv3kio9WLNnJ
	 D8VdcLJ7uOM+7UMo5eLMi4yFL/6DZHRntbuCXnG0D2PjlNVmoLV64jnd3SufNd50dF
	 r3h3BpHw/sTA/ryU1KJ4FkQLymvf0+rOsKPJ6lQ40HjBWAlUvXCI9fzxjDdSs+VoeL
	 fgHGVFadf6HqeV0yAjXFAV0ZU1dFp5UQPFkRtDlL8C9YUdskZYP/mW1Zv8GqVuW/5o
	 tMn6WAjyD3YIRfgpxi8F1MeHwqnCqosan41hlZrDZTwaqC99S7YiYcGL/p2QW91aLO
	 IP6ndpENF/6lA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 09/21] xfs: disable direct read path for fs-verity
 files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: dsterba@suse.cz, linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260918111539.1003439-10-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-10-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:26:26 +0000
Message-Id: <20260918112627.02FF61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The direct path is not supported on verity files. Attempts to use direct
> I/O path on such files should fall back to buffered I/O path.
>=20
> Add a fall back to buffered I/O at two place, in a common fast path and
> latter when lock is acquired. The second check prevents TOCTOU issue
> with reading fsverity_active() status and resetting IOCB_DIRECT flag.
>=20
> If one thread saw fsverity_active() to be false, and then second thread
> acquired XFS_IOLOCK_EXCL and enabled fsverity. The first thread will go
> through the DIO path.
>=20
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D9

