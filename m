Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794340560;
	b=YmjnvzRO+Bo49Gp9CrRgeGHuCWI1PiKLMldMHAI5AczGgV/0BNrjsMhLmfcethv7w23n
	 a13WtCL+8D/l18hdNWc/2Uz4P+X5eg8LLqUJ9rfitlgirZd0GoQ4QDZ91rtaI1CabxeKC
	 SZ6Z1HZtj3sueeqf4Nl9ONnWzX6NdZ57AnhrzfKm+K69wzsA+NyKfMeSGpXHQqYiACBfz
	 hhOSyEFEjzTHPH/uWB+zOQntys7BXtNeel2JWSU0XNh0t0rttio5t84fY92rcasg1n6jk
	 9I0hx1jGIbFa08UkpabO6Vr4GS7nA+D8+o0yNcWJHlA6vC6BInDPwTVhW2fgV2lU9Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794340560;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vFS0qXvAVZiIRjaOk+6jBL/SQm5Uyzpbh89L7epnJHE=;
	b=HeZuZuE5Q9OsyJw8j26sUhbCIfSAsCFEL8WYs7RvCWbDvy4fwb1lxaq+lLCp9KscQDa+
	 YxWdUo65swvAkBqJxVnJftixzcJsiLd1R7Q6xcIEdf+uzH9sB4+72nqG0u2zPZlyYUz0s
	 i2Ei/DfABCZeVU6ERKsnXF6tHT7hO9spFwv5Y1+9PcLF8uXsXTfzREqaC8tbmQg7EKHZ3
	 XvUe0+xWjWA/d8YJSy0PXrAFMvHAHoXQavn5IAgK4VEguARIlAQIBu5/uEeiA0uEiXDBa
	 wxs0RuU5M3fnnUG1NilFTXOB2+ItQqKJtnQtfW3acIsnOWWeyw7w3p9ioInbup+/cfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IHXuO6c0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE91606A336
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 19:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IHXuO6c0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6931F008A5;
	Tue, 10 Nov 2026 19:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794340559;
	bh=vFS0qXvAVZiIRjaOk+6jBL/SQm5Uyzpbh89L7epnJHE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IHXuO6c0cbGcJ/EELdmxEYY/rPEy5CWBIQ6aJBh2KjHHiAf77lNnX8cDWnQkvIq0M
	 zeMJkQ2+KJRBUvuT/gOwqHm07Qnxl6jWSUNr4sbolgtWhNN+JM+lqH38RPeaUFRBpr
	 7t+2qvYBNT1o0me68HE6F4JFWxJ4kj30iY9sPSeDnWiWboWQrDOJLXB06nLsTPgHrL
	 Iluek1IE9I5AhOxBLw99sFARM0ZdYNi+NqZxzQWOeMDA9Uuz06ToqcyEAH7d4IsX/P
	 QLxRBVfK13SC19UEI1jeAb9gUo+oTBPzupdenFaILxRWkpYoV2/QLTr6FdAQfE+PgC
	 NybhqPqqDVrdw==
Message-ID: <sashiko-outbox-207690@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 09/11] xfs: test for always COW after the dio write
 checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261110190417.32650-11-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-11-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 19:55:58 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> A direct write to a zoned file from vectors that are not block aligned
> can silently corrupt the file's data, if the realtime flag is cleared
> and set again while the write starts.
>=20
> Every bio of an always COW write has to cover whole blocks, so
> xfs_file_dio_write_aligned() passes IOMAP_DIO_FSBLOCK_ALIGNED for such
> an inode. But it tests for always COW before it takes the IOLOCK, and
> the realtime flag of a file with no blocks can change until then:
>=20
>     xfs_file_dio_write_zoned()            FS_IOC_FSSETXATTR
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D            =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     xfs_zoned_write_space_reserve()
>                                           clears the realtime flag
>     xfs_file_dio_write_aligned()
>       xfs_is_always_cow_inode() is false
>                                           sets the realtime flag
>       xfs_ilock_iocb_for_write()
>       xfs_file_write_checks()
>       iomap_dio_rw()
>         splits a bio inside a block
>=20
> The fix used here is to test for always COW once the IOLOCK is held.
>=20
> Before commit 8caec6c9fef7 ("xfs: support sub-block aligned vectors in
> always COW mode"), xfs_file_dio_write() made the same test with no lock
> held, to send such vectors down the unaligned path. So v6.15 to v6.18
> have the same race, and need a different version of this fix.
>=20
> Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110190417.3265=
0-1-mason@kernel.org?part=3D9

