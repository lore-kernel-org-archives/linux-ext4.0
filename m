Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C960838F64D
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 11:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792149350; cv=none; b=LzBAFv6A6za0sOxyWYXkTZiqIvC7btkgJe2xK478tsSbichCoBJCax/dQ5tBCAtHsQwoDLZXEASN80BuOd4isVp96W/bXy+BMbMCj/g2GnsbzpCOps8q1djYXVO3IPgMMtaT8xdiitXMBQxMwj1lkcUI9cxLcFyKfJ1BouOlnDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792149350; c=relaxed/simple;
	bh=F48/NPnVPxrqazuUtZQ1JwcPIDnKP9MWhRupAx72PKQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Lpl3Sjs/XxBwklkiRK+Tz9/WZ1iSafm4gMoUbC5KxjspBD9ilQDcoPr1/noUpYhXeJ4cgo1Q7lRzJtByCeBkDnW//WTYa3fl0x6mwZ15IR4+I+UBcPa8Y6S0lva4yjNu72lJx5wGG4KO5vlhJvIQJRfJW6iUnz4zoE11wnWtQ6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pq0fwWpZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pq0fwWpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420121F000C4;
	Fri, 16 Oct 2026 11:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792149349;
	bh=8JLh/P3e29p/5XGlOJvwwXocwO4OSeE6Eou/1ke6Noo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pq0fwWpZFXxJC4ukzB7calFaqmkoVXxSktL6/aH6Yw2WsiGcf36yk1lxiOA7uFU24
	 OQC+uuGcWEZ/N0mzMSw36YLsAgmLnEoyTc/LnQpqDhUul/GOtA1SR8J/76YtcLo373
	 Dn3ssd9qD1rplp5Jj+elUG2NmZm8nJNkgar5ND/+GiQSvBQnZ9wI5E8g1qKKwOwLNj
	 h8VzwQRi8gpwpQDbDtYI/wo4Na3Q1AdbF29JifTlG07+I1AbdzVEJ6CArm6LvS0fwi
	 LPRKj5qBIUTXAQZTuq8wm7ZEWQ0+VzmGl0WnjWPwtkzY1bW/WKEwa3RNz6v+owAUqS
	 uaS2NRI7qFBiw==
Message-ID: <sashiko-outbox-174237@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: record writeback error when discarding pages
 on failed delalloc
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261016110311.71391-1-guolingxing@tju.edu.cn>
References: <20261016101605.4039217-1-guolingxing@tju.edu.cn>
 <20261016110311.71391-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 11:15:48 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ext4: folio reference leak on error path in mpage_submit_partial=
_folio()
--

commit 828f6b6c9cdd25b981807944a30cd22b2612d38e
Author: guolingxing <guolingxing@tju.edu.cn>
Subject: ext4: record writeback error when discarding pages on failed delal=
loc

This commit records writeback errors when block mapping fails and dirty
folios are discarded. It also scopes the give_up_on_write flag to each
writeback loop iteration to prevent transient errors from invalidating
dirty folios after a fatal ENOSPC retry.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6ede3644a738b..b3b9650b32116 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2637,6 +2637,12 @@ static int mpage_map_and_submit_extent(handle_t *h=
andle,
>  				ext4_print_free_blocks(inode);
>  		invalidate_dirty_pages:
>  			*give_up_on_write =3D true;
> +			/*
> +			 * Record the error so that a subsequent fsync()
> +			 * / errseq check can observe the data loss that
> +			 * discarding these dirty pages implies.
> +			 */
> +			mapping_set_error(inode->i_mapping, err);

[Severity: Medium]
Is there a memory leak in the error path of mpage_submit_partial_folio()?

When called from mpage_map_and_submit_extent() and jumping to
invalidate_dirty_pages:

fs/ext4/inode.c:mpage_map_and_submit_extent() {
    ...
				if (progress) {
					if (mpage_submit_partial_folio(mpd))
						goto invalidate_dirty_pages;
    ...
}

The call to mpage_submit_partial_folio() can return an error without
releasing the folio reference:

fs/ext4/inode.c:mpage_submit_partial_folio() {
    ...
	folio =3D filemap_get_folio(inode->i_mapping,
				  mpd->start_pos >> PAGE_SHIFT);
	if (IS_ERR(folio))
		return PTR_ERR(folio);
    ...
	pos =3D ((loff_t)mpd->map.m_lblk) << inode->i_blkbits;
	if (WARN_ON_ONCE((folio_pos(folio) =3D=3D pos) ||
			 !folio_contains(folio, pos >> PAGE_SHIFT)))
		return -EINVAL;
    ...
}

If the WARN_ON_ONCE bounds check fails, it returns -EINVAL early without
calling folio_put(folio). Can this prevent the folio from being freed,
potentially causing hangs during unmount, inode eviction, or memory
reclaim?

>  			return err;
>  		}
>  		progress =3D 1;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016110311.7139=
1-1-guolingxing@tju.edu.cn?part=3D1
