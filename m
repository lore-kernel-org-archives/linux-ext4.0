Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794597321;
	b=AZtM/xdOUhopIeAkOfwpKcLpYx4aIgSNC5sGLUrx62HUmiTDPwT8ZyyN1+fKT6XljyYt
	 XPgDlHAraAe1KBKa6uAm0u0wUI/rEjGJNRoeyRz/dQsnnBPp0l1//tqQ9gfkijUAczcCy
	 mqBKzhNm+544iuxhbf7FGOxx22OGel7yTsrkcFYlyQOB9fEOVGtUeir+2dK9HV+cdgR3/
	 LTXXkgHl5XFGOt5XWCeTELW2Sitox/FMlE/k7b0fyOClwsTM6TRukANEuhQ1u+iH2jWRG
	 wwIWgNaFtBx3Ysb3RYggOA+ybgTciUvnwv3qv8flb+iGyVnL1lO+ggg60um9q+QqmbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794597321;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=clqAyK6aE8EGdsdYsDJ/LGg0AmDPEBnwtadnONDepSs=;
	b=fds5KUfizQEn9oRsxQ5vzwzsW8eAx7AcCIm5Swkk4dPMe7zeFf0TMS6cevdJ/zyOpEMx
	 gbHDoM1HMfPW4yb+9+7bWgYn3Cx8+WsOZhCWjugAHs/YjuMArK0EzRBHWG3pAWiEWufhd
	 hocHUTZWsCg4Q0GF96XGliK/LHGXKmFG4nrrxbIe5X3R36eBT7zE6TVYC+CaxabufYmCf
	 p+ZQ1I4s1JmCc4m7FDFZ63LkywvEGUHKU1aiL6t4AJDbwdRRdeJe/esfhXjBONXQPTEuH
	 IbzVZMX67uftBVWtQevrP++1973RFYvvIyXlrDco1C0qCsTcqcyE+NGFoEJLkx3FdvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XTLBR2oW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A97606A327
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 19:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XTLBR2oW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670611F000C4;
	Fri, 13 Nov 2026 19:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597321;
	bh=clqAyK6aE8EGdsdYsDJ/LGg0AmDPEBnwtadnONDepSs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XTLBR2oWx+J5ULlKB70zHYzJp/Ukndm1FADDntBKCulggZhr/OfgLdl6/7gsDauG3
	 n2o2QUpz8PIlUNtshOAQJO2l6mi5EdKccM8J7jAa9l8C3J7TRSWi7hobE7GdUnIDlr
	 u4Bi9YO7bS19ZDOFqtb2fISgDAj5BmZ7RAFphDGy4AY+qUmpnUI4Jx7xlZMR70poCZ
	 DnWZNoMDaiFrQx5zD158c1exc1P/oUG7nuoPJHeVU7zpnGLmwaWOrkrp0TbBFxpYsr
	 fkmP+Cvg9pVjPRl5obl7adLh5TCAf2Oasj6jDGfGUVhAFor7uLLES7+fLxMKKlYWgK
	 A2Gr2rngVvicw==
Message-ID: <sashiko-outbox-213530@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: don't use the kiocb after a direct read was
 queued
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261113-work-ext4-dio_read_kiocb-v1-1-172a88be803c@kernel.org>
References: <20261113-work-ext4-dio_read_kiocb-v1-1-172a88be803c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 19:15:20 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4_dio_read_iter() calls file_accessed(iocb->ki_filp) after it
> submitted the direct read. But once the read was queued the kiocb
> belongs to the completion handler. If the read completes before
> ext4_dio_read_iter() gets to file_accessed() and the completion handler
> frees the kiocb it reads freed memory.
>=20
> aio and io_uring hold a reference to the kiocb until the submission
> returned so they don't have that problem. The fileio backend of the
> scsi target with fd_async_io=3D1 frees the kiocb in the completion
> handler:
>=20
>   BUG: KASAN: slab-use-after-free in ext4_dio_read_iter+0x5e1/0x690
>   Workqueue: target_submission target_queued_submit_work
>   Call Trace:
>    <TASK>
> [ ... ]
> Remember the file before the read is submitted. xfs avoids the same
> problem by calling file_accessed() before it submits the read.
>=20
> Fixes: b1b4705d54ab ("ext4: introduce direct I/O read using iomap infrast=
ructure")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-ext4-=
dio_read_kiocb-v1-1-172a88be803c@kernel.org?part=3D1

