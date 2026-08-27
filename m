Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851EB22126C
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 13:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787835728; cv=none; b=JoCv1W+uuGHPcr2wiqqRc/9xxw0AHSIbq+ReCUdAvQAPP7ujTitYq4b+vUxMlkXItXIXbODFzL+hRdarzjfdjJc3W0lPYDmHbCVBXpvb3MDCA+CaD1xLARpLAUmoWRQ+Et1lzBqBgInE2Jgu1Yer2s7NuNEaXuIu+KfhQtEeb/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787835728; c=relaxed/simple;
	bh=Y8RgurfPgkToB5qMXabE2bBvnM3Q8FiXTDqO2IyEqa0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=t3rQhRLnjeuBnhxGOdbc4mI3YhR9YaEqo+VlU+piA2Bo/o+JxqbijI9b2QgP28KAfAC68KlLwP2h5DhIWAa3XaBsV2FSp3I3HlJRgTMjE6Nq53z/Nd8SZ02PYq/hxvDxkaHgcZtyOJ4AQqDIr1KZ973LpGo/WouoIbiwFqhgY5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OecAgXz/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OecAgXz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A911F000E9;
	Thu, 27 Aug 2026 13:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787835718;
	bh=YdfpP6ySX49rYP5/u6cm4keUyyS50dFYDrmTVZtzD/k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OecAgXz/cXIrm+EXiDc67MRF7NlImzqS12MyE8mWIAWMxLERXMnf9K4uM14p11e3r
	 dFl9VcmtVu6at23/+izP+M0NarJ+tuPMxi+i1JLOP5W4kD1AbjI7xl21MA+mgp08H6
	 atdZs/jTqLtvogNPYe63x3aAncduVp1cPElgWcKYwFxyyvXFVbGERErTiXJ0QeVT1+
	 Yh0sDTlDQrC69RUXu8RDYRltVh4Y8cT3lgUSWXw8M25Iy5iwszCodQBE2nYbINxHZb
	 bI6UHDSgm0QZAwPQFphi/ssAFB1eTQJgahjZLQiQDQOiViSL85x14ySmthLEyZ85w+
	 wBWqq57LKzUYw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] fs/ext4: fix ABBA deadlock in ext4_rmdir()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sergey Senozhatsky" <senozhatsky@chromium.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260827125158.4030598-1-senozhatsky@chromium.org>
References: <20260827125158.4030598-1-senozhatsky@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 13:01:57 +0000
Message-Id: <20260827130157.C5A911F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> We observe the following ABBA deadlock (casefolding enabled):
>=20
>  INFO: task jbd2/dm-13-8:447 blocked for more than 720 seconds.
>  task:jbd2/dm-13-8    state:D stack:0     pid:447   tgid:447   ppid:2
>  Call Trace:
>   <TASK>
>   __schedule+0xc2c/0xe60
>   schedule+0x40/0xe0
>   jbd2_journal_wait_updates+0x8f/0xf0
>   jbd2_journal_commit_transaction+0x321/0x1850
>   kjournald2+0xa9/0x230
>   kthread+0x226/0x2a0
>   ret_from_fork+0x101/0x1e0
>   ret_from_fork_asm+0x1a/0x30
>=20
> [ ... ]
>=20
> Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
> Co-developed-by: Sarthak Kukreti <sarthakkukreti@google.com>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827125158.4030=
598-1-senozhatsky@chromium.org?part=3D1

