Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1454A37187B
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 08:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791880468; cv=none; b=ngqs9mEJ+GPrrQZUEmx0N+rWc+k47BwIWbi4I2pNnnpRJCpgp0UyAOP98bu4JnMoT8W+m0OqOR12HhNv0wm5q4wI+1heOljizatri3p3GC8r0wfQHdBTvf3qBvZwIPVINWU0nr4tyg3QoVU6EZMx7P2xXewkxwIlwehugCSSFUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791880468; c=relaxed/simple;
	bh=TRXhLw42yI2l1RJrpHIwqDrVox4TLbPsF/1iCXnGZw8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=sfisu+Fb+jsIcBvfOD/XDq8FwWsjG2E5Tsy+1F0mILx72GFuh1HxnvFSf7O7VMWAuZtzJkbWsuKd49V8aLqPjRlfXWkF7i1cP+CGSuH84o7ilW0Gr0J6tcTKjqyyz6UGt5dhVPurTxN9rn2KRrAjxnXGB/D32civR6gXYfFJyl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=miiplMOF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="miiplMOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B021F00893;
	Tue, 13 Oct 2026 08:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791880466;
	bh=jfZAeIC/CiBSOFRUhcbnwg5ZfqGFzPzUDsdIWQS/2uc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=miiplMOFPRx8y6/5WMKgUMLylOl+bFlqa9RJZN3oyb6W+ApYD/A2MKQDesp7LPC/H
	 YGp2eSpJnD6UJ1Q6l7bzJezCp+oRrN32kojHBkstRkhdfYixgn9xhbPKSs/wLFkm9x
	 6YvUsxgOAmnWgoojfQuEiPPwooKi7iyO7yXH/L7tNrGlX/TNeXPwPwXPnLBWogO3AT
	 11FaXkwa0D5hDX7QGGpKEwn0DnUF+aa/zmOT6Fvutnlj1j4QMhGwa0B7OhTDj7ek2c
	 FnFdcRXr1YcLpjkHCIJkwB/WEp2uJCZUDx0DYZ29SdreD/DUtdbJkv/qx3CYmVB+PX
	 W+gvoER507lHA==
Message-ID: <sashiko-outbox-169259@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] ext4: check return value of blkdev_issue_flush()
 when starting a fast commit
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261013082331.2089623-3-guolingxing@tju.edu.cn>
References: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
 <20261013082331.2089623-1-guolingxing@tju.edu.cn>
 <20261013082331.2089623-3-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 08:34:26 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When the file system device differs from the journal device, a cache
> flush is issued on the file system device before fast commit blocks
> are written, but the return value is ignored.  If the cache flush
> fails, the fast commit blocks are written and the fast commit
> completes anyway, even though the updates covered by the preceding
> transactions may not be on stable storage yet, so the fast commit may
> provide guarantees it cannot keep.
>=20
> Check the return value of blkdev_issue_flush() and abort the fast
> commit if the cache flush fails.  ext4_fc_commit() will then fall back
> to a full journal commit, so the caller still gets the expected
> durability guarantees.
>=20
> Since a cache flush failure now aborts the fast commit, also issue
> the flush only when the journal barrier option is enabled, consistent
> with the file system device flush issued during a full journal commit
> and with the fast commit tail block flush.  This keeps file systems
> mounted with nobarrier working on devices with failing cache flushes.
>=20
> Fixes: da0c5d2695265 ("ext4: issue fsdev cache flush before starting fast=
 commit")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013082331.2089=
623-1-guolingxing@tju.edu.cn?part=3D2

