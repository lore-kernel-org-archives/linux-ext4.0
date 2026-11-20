Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795191713;
	b=nAz4qmKM0xy4dvRpKxTeVON1nUhMrQKZIZC3PPvOTbd+0/Krmk6FyutV596EqaaguKBE
	 rjM8lTkp71kRWIF3IgEuhCzVCXzTk4HPnBnZoOTZUvGitw9xmlbcyKJ0Md8aiYAI9ZB5I
	 QfnNDCOF5mOBnQXXH6EeC6TnsWHpAa57mYlrwfOb2TiOTUkDdPNvrqd0UubT0GICuoMHG
	 uhBHeAI6aeqjKMK9aPHKThufZBYVpw0e5WEjPL6aP/fWDUOWNrJUDjNwYtISGA1LltUcK
	 1+JYbjZ8o489T0Xq2ubFRGper2jXcVLNazHybISXkSBTY4Whr7hkmOdtz3RGfb/1XDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191713;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mKWScqfl/Y1cspf9A328ka9FjhD2e337gExwukxjT8Y=;
	b=oxn+sPBs/C4Ga9RoNQU/J6EYnhUhTJTlBxZ6I6akqjCN2X5Fhn26pSvWXg5o1Bbi+wa6
	 UtWIwQn8AluO4rJWEEhd8A60LTSub3p36IdHhY867zU6xcRZv5AjYctWWnuW1UIs5bVPo
	 UP6hmcW/9NJXYamMS71cP8SGwflbrJ3NfaAl/Xrjv1UKKiuB8jcuoo+ER7+ssb82TPzFB
	 GlGwuw5F3JhGuzTHG/ba5Q3rYLt9nRvwhVgkZevvB4NI6e9ASUJM92k4aRmN437IPj1Sq
	 sPZEvwOJT67AiXxjodK++PhJxXaOXwm7UAzbV3KcFVejer4sGx81nmBT5Fm07bkVOtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EMk+QCHL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88D3606A332;
	Fri, 20 Nov 2026 16:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EMk+QCHL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5791F000D1;
	Fri, 20 Nov 2026 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795191712;
	bh=mKWScqfl/Y1cspf9A328ka9FjhD2e337gExwukxjT8Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EMk+QCHLTF+XAQJ8OLAZeIZFLMyEIMWEe78FwzBXY+3efuBcHCyMnASvTiA5p8/kw
	 Q5RnfMJiw/OvOriXLLau6+Ge/bUpO+o0UzZC0nPfG2AZC3anIb7wRMPyPgdDjEd+q5
	 Qgugzem3HCst66yE92XpnpOLfSTm2iHjSbzg07rc9yAab/eKJufeGtobJjcCPknFra
	 5pS6O0NV1RHwgb+oxWdEKG1mpCfKllZmp5cWccnk8QNq8kGdNITkaTk1pXtW0/XxcI
	 F1IOiYW8wcbE5cVsHvula/NKPtMnGXL8XCpDPInW5458LEerG0Z/wxal5S+hX3vE7y
	 LypHwvHqqAqOQ==
Message-ID: <sashiko-outbox-225558@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/7] iomap: use fsverity_is_building() to check for
 fsverity IO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, fsverity <fsverity@lists.linux.dev>, linux-ext4 <linux-ext4@vger.kernel.org>, dsterba@suse.com, "Eric
 Biggers" <ebiggers@kernel.org>, "Christian Brauner" <brauner@kernel.org>
Cc: tytso@mit.edu, chao@kernel.org, jaegeuk@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.cz
In-Reply-To: <20261120155032.187246-5-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-5-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 16:21:51 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] iomap: inode-wide fsverity_is_building() check in
  iomap_writeback_handle_eof()
- [Low] iomap: missing Fixes trailer for broken fsverity check in
  writeback
--

commit f52ac6dc651e2b12c5452600fd41f0db8111577f
Author: Andrey Albershteyn <aalbersh@kernel.org>

> iomap: use fsverity_is_building() to check for fsverity IO
>
> Recently, inode gained new I_VERITY_BUILDING flag. This flag indicates
> that inode is undergoing fsverity metadata construction. Previously, it
> was indicated by stale iomap flag on the IO, now we can check the inode
> instead. As fsverity inodes are read-only, the only write IO happening
> during I_VERITY_BUILDING is fsverity metadata.
>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

[Severity: Low]
This fixes the check that read an uninitialized or stale wpc->iomap
before wpc->ops->writeback_range() mapped the folio.  Should it carry:

  Fixes: 63e242afa466 ("iomap: introduce IOMAP_F_FSVERITY and teach writeba=
ck to handle fsverity")

> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d6e2f1ded5ca6..4fb4136908ec5 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1930,7 +1930,7 @@ static bool iomap_writeback_handle_eof(struct folio=
 *folio,
>  	struct inode *inode =3D wpc->inode;
>  	u64 isize =3D i_size_read(inode);
> =20
> -	if (wpc->iomap.flags & IOMAP_F_FSVERITY) {
> +	if (fsverity_is_building(inode)) {
>  		WARN_ON_ONCE(folio_pos(folio) < isize);
>  		return true;
>  	}

[Severity: Medium]
Can writeback of a dirty data folio while I_VERITY_BUILDING is set hit
this WARN_ON_ONCE() and skip post-EOF tail zeroing?

enable_verity() sets I_VERITY_BUILDING without flushing pre-existing
dirty data folios in inode->i_mapping, and filesystems write back both
dirty data and verity metadata folios while I_VERITY_BUILDING is still
set (either during background writeback or in ->end_enable_verity()).
Because fsverity_is_building(inode) is an inode-wide flag checked before
comparing the folio offset against isize, any dirty regular data folio
written back during verity construction triggers WARN_ON_ONCE(folio_pos(fol=
io) < isize),
and a dirty data folio straddling isize returns early without running
folio_zero_segment() or clamping *end_pos to isize.

Should the fsverity_is_building(inode) exemption apply only when the
folio lies entirely at or beyond isize?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-1-aalbersh@kernel.org?part=3D4
