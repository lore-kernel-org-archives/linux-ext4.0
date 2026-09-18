Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54E34A13B9
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730766; cv=none; b=LC/VLTBjVMP3k+04bI6L61U+In6wPh+TzewhFMmeUSNSBgWPTQiwPCStUeXoMHFKdJ6wz3a+PKd3kfZlrYTao/ojU/axyIl+e/fb6L5dDehyDi4r9VDBjHz1xjobd94rWoUEmAXRlmV36jgmonhIRpMzIU4bYF9aPZcp2sHX1CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730766; c=relaxed/simple;
	bh=DzdHjBxP0kWU6Qfwx2uEdh8E4BRF/PaWAYR7HSVVXqI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A+eSDxGlQoGorusQQ7Y+8rlqsd3YyOYGsVb3CQBuXnZWJ7oLeJlAMJgL+aA75aYoVO/sD7mZbj8Yz33Bb0qUq+QmdCB7BumDtrDzqL14YWe4jucXjfuSUwx+aHDkZjyd1zOOlzAGOoGCeKDpkD7tUVJHjdAqN0rSTUVwLubJ+Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EATrF4Rq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EATrF4Rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255011F000FF;
	Fri, 18 Sep 2026 11:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730761;
	bh=DzdHjBxP0kWU6Qfwx2uEdh8E4BRF/PaWAYR7HSVVXqI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EATrF4Rqyf8bcyh22YucE0HZEZkO8rZuu3Shx9gAesQ8qu4vjfFhFAcQrUpX40LTQ
	 /dunwdgWy7EISRHAiH3oFr4j0CTMQ6CSPLWd1U3lfQ0Ep51/E+letZULTiJgDRNK5o
	 RxsqghhKivv6I1W9IwhiymdnJB/a3A3W8+YCW2f2JlZKvUynMXnuNeLzdzLH/ddMzY
	 MRD3C7aVOY4hPPDlf9wv/IHC/JfTjR9lwoUuIZeaCyASvheqP1XLJzTJlaotp+uXrV
	 gtNsL82L6SzPuyB+TTyMI/j6zA6ZP4G6v5y1MZSHF4FRu2zJt2sxdN/g2Kju8e4dBH
	 wAr3X6qBsgTGA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 10/21] xfs: don't report dio_mem_align and
 dio_offset_align for fsverity files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20260918111539.1003439-11-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-11-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:26:00 +0000
Message-Id: <20260918112601.255011F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D10

