Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376606;
	b=bW5JcdlqI03562LFtAJ6E3rXUdNVvDHadzmv3Xy343BEb8NsCH82J5pFp5wTVIzkLiyu
	 +DeHq/ReqLpqzXBgovlnzQm+ncKlzeSPhTcOQacMWPkXPCreoyVt0IGCP/NpDovPJ0v31
	 QchH5nwARop/HBLzCUX9ReeDPENYpcyMk9Ryuz6IaKXPg/+sdIjwpFW/USc4lcBTubTup
	 Kg7zOTJXNlD3wU95B15gA96oedar2wTwsndwxeUkBjrRzlL55m0J279zD+11vFnVinoKE
	 ydmlRiscH7Evp051DvRc6UjWRZiUXCsdBKuhUbOqgrjeOn80plApVgdeRby+zRLjhBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376606;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OOAfxh6yWZqjoSAEiC498o24RragXpcrsB45lR5OVnQ=;
	b=C1769lbTSI4BaWQdrPZCapqquBjP9HXdBSC+VHmkSw8fPFVsScj5gUfl8OaOdYz78cOF
	 IviPMs+dry9ChYMCwHFlpqoy6XPh9/M7JPjTinPxl2SGiHo13Km3WPXkY2U7t639K6YJJ
	 Md+ZwyH38HFhL2AgUBOUjHiLKgqg/ED/peCk+DPWPlGNk0UBAnxdMW9Zl/IRjI9bw5UUb
	 txx/p7wk63wjvF1MNS2+bymUnhTF6qejC2ZORaUC24CDS+FGni+YihGa1JVptlHsPnN5l
	 wsLHVlFjj3w3kHTLVWOCVLM25Elnn767nFrwJPuC17LTfZAAMmeISQDANTx4KlEl7Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="P/gfXX5a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3220D606A325
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P/gfXX5a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CDF1F000C1;
	Fri, 30 Oct 2026 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376606;
	bh=OOAfxh6yWZqjoSAEiC498o24RragXpcrsB45lR5OVnQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P/gfXX5a1tj7QiP6JMndFjmPDS6arU2FO+9oYfpg1lHKDH1oePE7EnrXgQbk6XPJK
	 Qjim4Muk5mUYlN2fFLcekkgxLonZaqwKd4i54Bz4KgEMd23l3wg4fW1UA6hxQWmvJL
	 Kn0B/ZmjHEyDEHTnR6nToH4AcRat0cIfCbW45jLqm9ALADKUlH9Y30w52ZuCbwoW6c
	 w6BRxZJo3g5f74mE4QqG/lSdVA0zcc5HurIrnh5QoeVoAOYKdwhtZusNXcneuUzkrl
	 CsoOgX1B9bNP/G0HwHUoF5JOwbEhf8cegRawJH+sjP9W5UBwNSMHJxPxLv/hUHf/Bg
	 j2z6jXAr8xPvQ==
Message-ID: <sashiko-outbox-191239@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 20/34] ocfs2: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-20-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-20-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> With errors=3Dremount-ro, the default, ocfs2_handle_error() sets SB_RDONLY
> without holding s_umount. If that happens while the filesystem is frozen
> through bdev_freeze() thaw_super() leaves the s_writers rwsems locked.
> Writers hang and so does umount because ocfs2_shutdown_local_alloc()
> needs sb_start_intwrite().
>=20
> The soft read-only state doesn't stop modifications on its own. Every
> read-only mount sets it and those still need transactions for recovery,
> the local alloc and the truncate log. Everything else was stopped by the
> VFS because of SB_RDONLY. So call sb_set_emergency_ro() instead which
> keeps it that way, and keep setting SOFT_RO for the existing
> ocfs2_emergency_state() checks.
>=20
> The xattr and ACL setters get a check of their own because ecryptfs
> calls them without write access on the lower mount. It sits in the xattr
> handlers and not in ocfs2_xattr_set() because chmod and setfacl store
> the ACL through it after the new mode was already committed.
>=20
> Quotas aren't enabled at mount in the error state because that writes
> the quota files. ocfs2_sync_fs() doesn't flush anything anymore and a
> remount to read-only doesn't suspend quotas. Q_GETQUOTA, Q_GETNEXTQUOTA
> and Q_SYNC can still start transactions. I've left that alone.
>=20
> Writes through file descriptors opened before the error fail with EROFS
> and umount completes instead of hanging.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D20

