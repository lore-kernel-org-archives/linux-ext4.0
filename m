Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793126807;
	b=2HUKcazXHntU2wuXh5bSQ1nmnZgj62Sl4vTJjmCLPRLV6jMliuJowyYwVv2Rjc18xGPj
	 TG2RPEP0oZAxt0EJjrE2z2neT3ZnC9JMJXQAVsrmpkzSTKEySRgSUDspuN543b36HYPQk
	 27/ScLXd+w33V5YOeWX8vO6I/mwobpnP7KM6CuHP3nxsEZbXMlG2EKEiN/vN5gyLKxaPS
	 ITs7djUn1b6bsxucrciIbYBMnguLOqcuLfCHwNI+oSkCXQBfrYn7rept4sir0UnigoJTb
	 +X8D0UqSmFxQAK5+hSPHiw7mAZcSOotpmiFPC3jniO2oLFZ84fpSAROEnlH0onR7q2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793126807;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/ubWw6u7Y5p0byWpDGGuFW46aghT+dHfdQL2wbsTrU4=;
	b=E4MQ7f+KhapmiFFRAbXdECa1k260wdoO6L2BzyA0oN7KIZijbJmfIxWZRLXO9ARrOaSy
	 9r2x9jOUPqsK+zpsbdnqdzTMNlw9a9yKPUixtszldL3HRghPa+KmjSR8zS2yMYmzYoDFK
	 rRZNImP0jdHk7bTiAkvB2vqj7tMhItLyIgCGj153KpYqa+mt2nKoE/+1J6bSgeGQclbhf
	 cLqXH+MQMB1Bca0DADkK/SE9BtuF402XrqOdzEdJPG6fCKhV9ZIcn2b/B83VsbSg25gPu
	 dg9pjbpoS7/Ebclg4iX6ackX7iw5FRDsdLovK5wO2W870efINzQMEUptqbhTZZNyc+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VZg5XNbz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E00606A31D
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 18:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VZg5XNbz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796A31F01828;
	Tue, 27 Oct 2026 18:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793126806;
	bh=/ubWw6u7Y5p0byWpDGGuFW46aghT+dHfdQL2wbsTrU4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VZg5XNbzeuPUIdDeqXDtWvMSTTfs3Qxl7CpbjaeyOvoVcwrguCV/NN2YxbWlspISZ
	 3vYZvrT+lnzbzwOqgLh/ed12JmveGuvuhuJ2/myM9GxB/IQ8+23MmayQw9gYFLMOJk
	 QzA+uXFCBtpyx7v6XEtqhbZULZg5IgJe8l6NYbh0maHW6ZusvCtMIsDLDPR50SIahF
	 yUaPq5lAHLHefZeDzbfq82U7+db/RvDikvptRcOSXAjXr/lpbj6eSv4Vp4/t/9rTIQ
	 SBb1KUiPxklL8VdfL/my8zuJS0enPTsIk4Uh/HRqG/Nw/Nwh3Pkofc37meYctBokE3
	 XtDn/HQQyCGzQ==
Message-ID: <sashiko-outbox-187037@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext2: only flush DIRSYNC directories on every change
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027-b4-ext2-dirsync-v1-1-3dcd012d518d@toxicpanda.com>
References: <20261027-b4-ext2-dirsync-v1-1-3dcd012d518d@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 18:46:46 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Every change of an ext2 directory is written to disk before the system ca=
ll
> returns, whether the directory is DIRSYNC or not: its pages with
> filemap_write_and_wait() and its inode with sync_inode_metadata().
>=20
> Writes which reach the device for 2000 files, and 200 directories, in a
> directory without DIRSYNC, with the flusher turned off:
>=20
>             create   rename   unlink   mkdir
>     before    4000     8000     4000     800
>     after        0        0        0       0
>=20
> In a directory with chattr +D the numbers are those of "before", before a=
nd
> after.
>=20
> commit bc943f4872a7 ("ext2: Don't flush page immediately for DIRSYNC
> directories") moved the flush from ext2_commit_chunk() to the new
> ext2_handle_dirsync().  The IS_DIRSYNC() check which was around it didn't
> move along.
>=20
> Fix by putting the check into ext2_handle_dirsync().
>=20
> Fixes: bc943f4872a7 ("ext2: Don't flush page immediately for DIRSYNC dire=
ctories")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-b4-ext2-di=
rsync-v1-1-3dcd012d518d@toxicpanda.com?part=3D1

