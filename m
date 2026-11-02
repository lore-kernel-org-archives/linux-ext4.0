Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601245;
	b=zQxcECto9+Mzr0AJ8flubiNX1pZc5kovKDItr9odriS3iNKwqTKoqKnlmLB21p242jGm
	 TS2EEpuFuKRHRe6Zfqt2J+6USjBL+332RNyuouC3CGKuu5vkeVMPmquZPTJGFlLBRXuUK
	 trUo2S4WIbQsQWk1A9jc7KNDJEUwxeEUBCZOqW4RwY3seUkgztPIUTkSQnSW1iCD1rzzD
	 J5lSrvrkSJtbzD+RnFnzEpHXdVipfin+bhiDapykeYB7ToVgBJasrTQvrLori5n+FPLGG
	 x4pDTXpmhzA3Vy2bpkZnFjYL4+mvumtXUjWE0gPqUf7nwaDeDLGrm+b9wIN803R8gMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601245;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=r4/yOwmx+E2pCyDCmzTPFuMXJCwLTF8FzUfHrLbpwGY=;
	b=Zll05VBUALBr6R78uq5xlfGC5UxWuXaqttHIIX8UFgIB3YG6ojm6yF0aXSUebuz+gUvz
	 gP+XqNN+bWDqTE4FovW8cbJd6aVEo/1Ca14RUAuPNsmDliZ70MPeUZX55noLmTclWwdvT
	 bgCTXDfxv4kpU/7x0Kwq5HdylBHAsmYIzzIGX1F/pTAVaDkuqf6qs+5sPEWIzXpgHsREs
	 lHQHJv2oVxpbrJV9Iq3iVTRBSYoOzVjQIqwv3VMus6tzaTBX1x+Ntwx4iEA6B5shgyD1u
	 Vr7U9hVP2+SjRANJmWp6pzPJ19qyCv7J4JJ0SojjgIGJINlqCBjteSmtpStBt8QV8Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eVxuscmU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64630606A324
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 06:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eVxuscmU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90B91F000C1;
	Mon,  2 Nov 2026 06:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793601244;
	bh=r4/yOwmx+E2pCyDCmzTPFuMXJCwLTF8FzUfHrLbpwGY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eVxuscmUOsJgQXdAVDKF26JPiK5BVGMJMX9x/Wr9qz5jxabYr18o/USqO2KJuKAXK
	 x7oxI89Sp/A6utWbYe8JxIXk0KJLw8GVOB0LNRKnEJ3Q2r2wNciDGVEHyRalFpSBYq
	 tWY9xW5wxrTBgz+IZtLqKJKtqaO7KZ8mJk+qxpyVpSssAjcD+OkJ1t91/T+c2DwOPo
	 zGXI82fGqJdWh77PBeXTrFui5UgFPyGPq9113aPMQvs0VmjzZ+eJiahKJw4rwSbXTR
	 1a6ZqK5uZTI2PDAdXnMn94hd1fN/ZQ60vWKKVyKtnazsrJkqKa+2XuubzvFh6RyshC
	 bYTGBMSpBmrfA==
Message-ID: <sashiko-outbox-192961@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext2: preserve completed DIO bytes when buffered
 fallback fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hungyu Lin" <dennylin0707@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261102061555.55183-1-dennylin0707@gmail.com>
References: <20261102061555.55183-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 06:34:04 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext2_dio_write_iter() can complete part of a direct write before
> falling back to buffered I/O for a hole inside i_size. If
> generic_perform_write() then fails, its error overwrites the completed
> direct-I/O byte count.
>=20
> For example, on a full filesystem, an 8 KiB write to a file with an
> allocated 4 KiB prefix and a 4 KiB hole overwrites the prefix but returns
> ENOSPC and leaves the file position unchanged. GNU dd with oflag=3Ddirect
> consequently reports zero bytes written.
>=20
> Preserve a positive direct-I/O result and return the buffered error
> when no bytes were direct-written. This restores the fallback policy of
> generic_file_write_iter(), which ext2 used before its iomap conversion.
>=20
> Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102061555.5518=
3-1-dennylin0707@gmail.com?part=3D1

