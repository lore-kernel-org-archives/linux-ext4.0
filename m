Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B130B46AF00
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 17:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789405655; cv=none; b=pMCubnLLPSikf8CfphQ2dF8jotFcNSaWZ4DrG1mCdbK666DZqGEEJx8dTF6ORx3QH11nlMxofNkf6BpEmZCrKY/TwSGOdJtUbsPlFlmq/2LGvZZ0rQk0l0/2bH4SpxBJzl3yu5wmKhAqQzy4v9wHVzK0NBrOtWjiYuSigsa2wHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789405655; c=relaxed/simple;
	bh=o/xRUgTCnl2N/zaDKgV3A0ACMEdl6Accvutwdb/+aKE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hF1DEwSXXDV1mhbkoBWHfTJmbFeE5lQxDAMiLm19r+AgblUJYzAV2YrMU705x6Al9mDQVT/Et72qoRmn8o4s/yjmNNWzXMFGgDNJ8dKKrjoD/w01QMzaNhxgPuSYV6Vit1hOby8oZVUCCAHJYXGSwaXnXM9oLKXzugb9/SjuhwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lT+2yOmE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lT+2yOmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DFA1F000FF;
	Mon, 14 Sep 2026 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789405653;
	bh=NjfeeR2ZwV8apWzo2NlvXOsLyQzGrF6zLFQ9HGpkR4M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lT+2yOmE6JyQY0UtQp21bJISYILIcH4oyCABm9MM0hUubp5U8zJnoSxwnqPSMzuco
	 Wu+a18D7PO+tvSzYNi0Ydw3U7bsZ7bfReZt/p92ikFVUTWSR70cqP4187sNaj/53rb
	 ra5aL2AFqL6BVi6xxCtrVShU9DgxMwBgNY6FpboW87eMg/rycV4O04M3tcVGK40mMj
	 /Y+rOXlbH7PnRxhwKBAMrVR5OloGC50gyCO4U5m3+uMMDAEO+u7Fl7C8My2vwDtTlP
	 5atAOJnaDYpOuVsKgFroget/PurDznt1vlqloC8D2P2uBcG02XRonzggudNa3fH9DZ
	 47Re++pg6YVNA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4:Fix WARNING in ext4_journalled_invalidate_folio
Reply-To: sashiko-reviews@lists.linux.dev
To: "shuo chen" <1289151713@qq.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <tencent_87F5A404ED65B0B1349C60E830C485716705@qq.com>
References: <tencent_D74F4B8A5FDC1BCFC23B8750428019635609@qq.com>
 <tencent_87F5A404ED65B0B1349C60E830C485716705@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 17:07:32 +0000
Message-Id: <20260914170733.20DFA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The WARNING in ext4_journalled_invalidate_folio can still be trigg=
ered from ext4_write_begin on error paths.
--

commit 83d8cc4138093c0b6b19db042eb3a85e72ca5b68
Author: shuo chen <1289151713@qq.com>

    ext4:Fix WARNING in ext4_journalled_invalidate_folio

This commit fixes a warning in ext4_journalled_invalidate_folio() by
calling ext4_wait_for_tail_page_commit() before truncating a failed write
in ext4_journalled_write_end(). This prevents invalidating the folio while
it is being committed.

Suggested-by: Jan Kara <jack@suse.cz>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes:https://lore.kernel.org/linux-ext4/CA+0ovCgxFN3TLpdS_O_Z48sARuQ-WR-J=
LDCqQWEmd9ELtkzddA@mail.gmail.com/T/
Signed-off-by: shuo chen <1289151713@qq.com>

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 26f0f9714f03c..960a049a67bd2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> @@ -1597,6 +1598,7 @@ static int ext4_journalled_write_end(const struct k=
iocb *iocb,
>  	if (!ret)
>  		ret =3D ret2;
>  	if (pos + len > inode->i_size && !verity) {
> +		ext4_wait_for_tail_page_commit(inode);
>  		ext4_truncate_failed_write(inode);
>  		/*
>  		 * If truncate failed early the inode might still be

[Severity: High]
This isn't a bug introduced by this patch, but it appears the same issue
might still exist on the error paths in ext4_write_begin().

When a write fails (e.g., due to ENOSPC or block allocation failure) and
extends i_size on a data=3Djournal file, does ext4_write_begin() also need
to wait for the tail page commit?

fs/ext4/inode.c:ext4_write_begin() {
	...
		ext4_journal_stop(handle);
		if (extended) {
			ext4_truncate_failed_write(inode);
	...
}

If ext4_truncate_failed_write() attempts to invalidate the folio without
waiting, jbd2_journal_invalidate_folio() could return -EBUSY because the
buffer is still committing. Could this leave the page cache in an
inconsistent state and trigger the WARN_ON in
ext4_journalled_invalidate_folio()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_87F5A404ED6=
5B0B1349C60E830C485716705@qq.com?part=3D1
