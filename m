Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F147386453
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991253; cv=none; b=U+Igpa7aMFiSsgi/21b31ZdCjCGWFumkK35hRz142Eq7BoEZ+NOsD14lCTQBxZjJX6CHKoTVeWf8o/qitl8tT6lZ5N0AyxZHSDaElxpNkkWw0CcL5t6D/HbMQY2vCA6IuLCL/o0vQQs0uR5PTh06yaIDSoAs2Bc3E84zYTdhSF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991253; c=relaxed/simple;
	bh=eBopooOWrNnJRmcfg3vqA0pA1Mpkfo2rR1lIK2/DWEg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Uuozc2QGPFvftXjonnH3tblGfBmB/cQETFO/pmo20M72ftbbQ+jTORQTLlWLjrriZlhhFcc6eEZmmmXNvL4sXlbtqVdT/p8ns+TNp59FYdL94c2+L++/F4/lYolEBXC7AZqMCsrLxO4GL05IhjHdHDUbPhUpliuWxDzd7XRXA1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mejqa70l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mejqa70l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1C91F00893;
	Sat,  3 Oct 2026 01:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991252;
	bh=eBopooOWrNnJRmcfg3vqA0pA1Mpkfo2rR1lIK2/DWEg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mejqa70lTxSfyxW0Q27N0ngkrGfMooqxBmUtAdEvaPd+junGc9uchpFTgoRkMaITk
	 25SGUzYS3HWOL3hSNOSWPw2yQmCufYFkA7BWm+vG4AMUMvJQCGOWF6oESt1GOM0v4Y
	 umtkmml05n0pXd+G2ho3UsFMwcP+fg8aIk3AhJeZv4iGKKIPn4IY512lEsrtWNw6rZ
	 /JyJhYy+m1iYM7WaSAjqZgoQBWoHLXU4Z19znJwlTJega8GCRYYIEk0J3RjVYlxFHm
	 +15WAWeQJoJhSFpksj5B1+c9IxctMFEirM3hcxEWm2MVW6Yru4VNiFq0hCRDziY+2V
	 Op4zPcjUc6vhA==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 09/21] xfs: disable direct read path for
 fs-verity files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, dsterba@suse.cz
In-Reply-To: <20261002223705.2175542-10-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-10-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:11 +0000
Message-Id: <20261003013412.2D1C91F00893@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D9

