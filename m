Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6D12C15BB
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 10:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792147112; cv=none; b=fWqOfthtFz3XjB72Uf4FtjFSf6rXpSg9XFs6Wot5T20a2EcA+PM3vWQomXjmovxymQw9os3p0bEMjHJyDhmeDfck1u6DPnGT43RVlSXPUg7viAMmIWcNhpnH/F+i3+3oIP6Lu0ajRDCRX38hh//EOmHhqnaJsaPvUPwj7W/DEmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792147112; c=relaxed/simple;
	bh=4XYOFwvi/qAUgZSI3L8Ulpdra0TZJx2nHsCifz6QAF8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mySQqBtf4C3Kt0DqsLL5Ozh5xerOTWrfmPtESLE8zREcYpZDstfGpVBiLRLZlvm0jkmSMx/b6e2JLScmFJsvH8zzsNKwttGbyEmccjIoPelw1kAcI4rxv6RBeFZGo5p+6ZbgNW5KN1aTeESjn2SQoDIKguj46917B/g33ieH2o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XKn8V3xN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XKn8V3xN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9E41F000C5;
	Fri, 16 Oct 2026 10:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792147109;
	bh=3y+RpGVy0kz4Hz4gII+GM7mogh81if8yLOsgZtuFk50=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XKn8V3xNA8lhAOp11RqsAuhPFVDc+cVorrpGQJR8lainroPvEf1L/RB0pGvpenGzj
	 FSbjnAeq8zU1ftDHSSOcF+4C4XC2PEDM3kYwgOKgQRGdPT5IHhGC5J9raJZOH2MEPb
	 UHItf9lR+yrNb4PRQ73Vyu9XVF8QJMGKvEdN2k4h1WGuk9qWsg3umth39DZW5zu4Lt
	 1iwAGQNOYsLVoggPGIzC/JdN3fgz2GULvLcRpkmNAbJvIXqBZG6TySTLl54wlG0PXp
	 W19T8kLgKqNXcltJ1S3MaTTR5TP30vip6R22uSiMmOokXn+9xgrYJMFFE6VZuwPyOB
	 Gnj9XHAbfywzQ==
Message-ID: <sashiko-outbox-174186@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: record writeback error when discarding pages on
 failed delalloc
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261016101605.4039217-1-guolingxing@tju.edu.cn>
References: <20261016101605.4039217-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 10:38:28 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: data loss due to leaked give_up_on_write flag across writepa=
ges loop iterations
--

commit b95d276ed2e575cb01a2eaee0f04e704d2371b9a
Author: guolingxing <guolingxing@tju.edu.cn>

ext4: record writeback error when discarding pages on failed delalloc

When mpage_map_and_submit_extent() gives up on a failed block mapping,
it sets give_up_on_write so that mpage_release_unused_pages() discards
the remaining dirty folios. This commit calls mapping_set_error() when
deciding to give up on the write so that fsync() can report the
writeback failure.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6ede3644a738b..27640409aa97b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2637,6 +2637,12 @@ static int mpage_map_and_submit_extent(handle_t *h=
andle,
>  				ext4_print_free_blocks(inode);
>  		invalidate_dirty_pages:
>  			*give_up_on_write =3D true;

[Severity: High]
Does ext4_do_writepages() leak this true value across loop iterations?

If this hits an -ENOSPC error, give_up_on_write is set to true. In
ext4_do_writepages(), it catches the -ENOSPC, forces a journal commit,
and executes continue to retry writing further pages:

fs/ext4/inode.c:ext4_do_writepages() {
    bool give_up_on_write =3D false;
    ...
    while (!mpd->scanned_until_end && wbc->nr_to_write > 0) {
        ...
        ret =3D mpage_map_and_submit_extent(handle, mpd,
                &give_up_on_write);
        ...
        mpage_release_unused_pages(mpd, give_up_on_write);
        ...
        if (ret =3D=3D -ENOSPC && sbi->s_journal) {
            /*
             * Commit the transaction which would
             * free blocks released in the transaction
             * and try again
             */
            jbd2_journal_force_commit_nested(sbi->s_journal);
            ret =3D 0;
            continue;
        }
        ...
    }
}

Since give_up_on_write is initialized outside the loop, it isn't reset to
false. In the next iteration, if a transient error occurs (like -EAGAIN),
the leaked true value causes mpage_release_unused_pages() to aggressively
invalidate innocent unwritten folios, causing silent data loss.

Should give_up_on_write be reset per-iteration?

> +			/*
> +			 * Record the error so that a subsequent fsync()
> +			 * / errseq check can observe the data loss that
> +			 * discarding these dirty pages implies.
> +			 */
> +			mapping_set_error(inode->i_mapping, err);
>  			return err;
>  		}
>  		progress =3D 1;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016101605.4039=
217-1-guolingxing@tju.edu.cn?part=3D1
