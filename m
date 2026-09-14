Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330C82EEE75
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 02:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789353526; cv=none; b=VKEScvNB5J1Jh5cIDYDbHnTtVWRwMuXN+ehJ1UwYtF4JH8UDtkIhINHaVt5aNzdkLK/njoFPdpGLtidpPtdePK1E7B+Qk2jOjYwOz7M6QyAZNFj0svGLq3eZ51vsYdGeV7qIT8ygt2xeSuJMxE8vnbqDsyzKHza9u8scYC3hk0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789353526; c=relaxed/simple;
	bh=NQwgCub/++tZ8zqQPl87tMDkF7g0AuysMMzG7AZOm3Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QeosXmj5+KI3Bkn4vrjziL2Tsci0g8De9xduvMtM7it5C91t9lIYudV0BiRd7+Bc5hoRdf2POPkAmCNVQJNndWlfYlzxUGeo5KSZ3hhbtSjgB+wwga9dFZCBNoZLf3qk/uLOmhWu6RUuAG9raTzT7LQhfTDNGNeuhPSuZN6UdBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OdCAg41P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OdCAg41P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99371F000FF;
	Mon, 14 Sep 2026 02:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789353524;
	bh=Cfx27GobV1vbgYt4x4Z6be3S3+mnYXl1T7ASaT9r6RY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OdCAg41Pq5Kzp+w+qDua+1H1yuvilYINX4Rd9+SRwnsZefLtGzfuY9k76V2BQ1qY1
	 oaMVJjr5XRjKYJesQIp0Ia43iNXob4nfgYLJwOBehvmh03DEtMjGCgsOC/VjK9gbXz
	 vv7cnli7m1hgiW2coFI4vh6OLWh8JkXDxEAi+ZYEezcXxjjpwQt3WOkgDJ+GSHIuPY
	 wKtyNIgmv8tvIx+1AfVUkGmbVdQQt1TAx+OqfcMF5XIJTewgyEBlM/HwVvCGyrlIJ0
	 hvCUHHUH2PWVcwrqEbvfhxLANNqhCdcmJsPV6MmyBtno4kFYQ77BxYJWwlbHWZoPNx
	 F2vpypou6tcrg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4:Fix WARNING in ext4_journalled_invalidate_folio
Reply-To: sashiko-reviews@lists.linux.dev
To: "shuo chen" <1289151713@qq.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <tencent_D74F4B8A5FDC1BCFC23B8750428019635609@qq.com>
References: <tencent_D74F4B8A5FDC1BCFC23B8750428019635609@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 02:38:44 +0000
Message-Id: <20260914023844.A99371F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ABBA deadlock between truncating thread and journal commit thread =
due to holding the folio lock while waiting for a transaction commit.
--

commit 0b3a826d64ad8fde652eef131d6bd13542e8206b
Author: shuo chen <1289151713@qq.com>

ext4:Fix WARNING in ext4_journalled_invalidate_folio

This commit modifies ext4_journalled_invalidate_folio() to handle -EBUSY
from __ext4_journalled_invalidate_folio() by waiting for the current
transaction to commit before retrying.

Closes: https://lore.kernel.org/linux-ext4/CA+0ovCgxFN3TLpdS_O_Z48sARuQ-WR-=
JLDCqQWEmd9ELtkzddA@mail.gmail.com/T/

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 26f0f9714f03c..e5e78d5551474 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3419,7 +3419,27 @@ static void ext4_journalled_invalidate_folio(struc=
t folio *folio,
>  					   size_t offset,
>  					   size_t length)
>  {
> -	WARN_ON(__ext4_journalled_invalidate_folio(folio, offset, length) < 0);
> +	tid_t commit_tid;
> +	int ret;
> +	bool has_transaction;
> +	journal_t *journal =3D EXT4_JOURNAL(folio->mapping->host);
> +
> +	while (1) {
> +		ret =3D __ext4_journalled_invalidate_folio(folio, offset, length);
> +		if (ret !=3D -EBUSY) {
> +			WARN_ON(ret < 0);
> +			return;
> +		}
> +		has_transaction =3D false;
> +		read_lock(&journal->j_state_lock);
> +		if (journal->j_committing_transaction) {
> +			commit_tid =3D journal->j_committing_transaction->t_tid;
> +			has_transaction =3D true;
> +		}
> +		read_unlock(&journal->j_state_lock);
> +		if (has_transaction)
> +			jbd2_log_wait_commit(journal, commit_tid);

[Severity: High]
Does waiting for a journal commit while holding the folio lock cause an ABBA
deadlock with the JBD2 commit thread?

The truncation thread enters this path with the folio locked. If it sleeps
here, it blocks while holding the folio lock.

Meanwhile, the main JBD2 commit thread loops over dirty folios during commi=
t:

fs/ext4/super.c:ext4_journalled_submit_inode_data_buffers() {
    ...
	while ((folio =3D writeback_iter(mapping, &wbc, folio, &error))) {
		if (ext4_journalled_writepage_needs_redirty(jinode, folio))
			folio_redirty_for_writepage(&wbc, folio);
		folio_unlock(folio);
	}
    ...
}

The writeback_iter() function internally calls folio_lock(). If it reaches
the folio held by the truncation thread, the commit thread will block
waiting for the folio lock, while the truncation thread is blocked waiting
for the commit thread to finish, leading to a complete filesystem stall.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_D74F4B8A5FD=
C1BCFC23B8750428019635609@qq.com?part=3D1
