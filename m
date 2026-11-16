Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794813892;
	b=nPw09Jvzk0St4zBJh6gNXFmm+o+znkSvo3BlcVmRjjCPX6uFAxx6B1SiK15Rxkxt4lZe
	 QPc47YgIh3v1PbOt0l+pWnwfE/TCN3MXEcBKJTz+Fp8kpau5xrcEWyKh1S1AQiS+L/J4H
	 Syqj4aBQZSFJIV5cPLCFJXej5lU/TIhz2WwSiaMuNryAfMiJchenvW58IMxbvoY1VIKsJ
	 s+IrJinxvylbAWxBuOAkHuRnCmombWNuM8XkeDnWN3oFR8UqC72GpkrIGq81orEueHcrm
	 QnZwgjvljhtb3VXIk3rQk316iRevGdkBZ1fGe9uMo1UZ/cseFK6cBbuI5ckNfu2aftg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794813892;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jIB7TH+QuWU78zPcopO9jb51mZ+lyA1653b6AfSbHXo=;
	b=xUKkX7I/i6Tzvmoz4DnulIOtcDFqV+MMvNPKniLqm6KFza+5ANDbyASC3zVO+xBfrAdi
	 8tJn3TCt68e7DW18dH2qxS3qmDWp5XP5PPmEWYZy/DLK9VwzVvOt8Erj65HHo3SASBD5o
	 Jg8YY3f0mvSJid7vlDumdY0860QVSPl2W2XHQ8TTBhMJ2apx2MtD+0+LDr8I+vuGjGfoH
	 xFE4YG54t41SZ0dudHYObEap6m0zKE73XzWT5m4W6ANxQaZ5pCFf3Afyt06fLmTWfShlP
	 1gg7jrGQHVWseM7yH9yNuaGeuXmvH8Oiwm/y/XAxdQC2YOKOO/EIy4d9sBrDJEehWDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OrgurqFw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173BF606A323
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 07:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OrgurqFw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E551F000CE;
	Mon, 16 Nov 2026 07:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794813891;
	bh=jIB7TH+QuWU78zPcopO9jb51mZ+lyA1653b6AfSbHXo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OrgurqFwqK6PNVWvnEmj3rAsAXhMON4IBXc091l0UPTbcmfJEFYwwWQJmXCOMZ3+E
	 dbnb3Iv1uBbZQkPQmGwf3RbFH2FApcAhkOX97Ji1y/lDghD4YvTrtUS06ZIjsu/a49
	 lYn5lyu9QrmFp/wWvZNb7xExdMgEKQ/JGk+K0FeJhjo/Pkq1YM/LJ6fi/9r6vik4Tp
	 a1OwjurVXublaBL96ff50s9kH+PS3kQ2I9Q54mmka3mWxwKywQGzjYB0CW1St4eaSW
	 4A6GHoM3ESq0sECVZs8VjpckXIKaixcNUZEb+sL9PKx4i5Ix/03qPJI/kQO0U+bujo
	 NWFIJBzYDQHeA==
Message-ID: <sashiko-outbox-216410@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] ext4: submit mapped buffers after fatal mapping
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261116064749.194146-1-sunjunchao@bytedance.com>
References: <20261116064404.189911-1-sunjunchao@bytedance.com>
 <20261116064749.194146-1-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 07:24:50 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] ext4: writeback loop continues with give_up_on_write set
  after fatal -ENOSPC
--

commit 582dfee51394f04b2556a1a60b05a5f6ce7a4668
Author: Julian Sun <sunjunchao@bytedance.com>

ext4: submit mapped buffers after fatal mapping errors

This commit submits already-mapped buffers in a folio when a subsequent
extent mapping or io_end_vec allocation fails, rather than discarding
the whole folio on fatal mapping errors.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6dad9eea78240..ff33ae870b359 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2600,6 +2600,7 @@ static int mpage_map_and_submit_extent(handle_t *ha=
ndle,
>  	int progress =3D 0;
>  	ext4_io_end_t *io_end =3D mpd->io_submit.io_end;
>  	struct ext4_io_end_vec *io_end_vec;
> +	bool fatal =3D false;
> =20
>  	io_end_vec =3D ext4_alloc_io_end_vec(io_end);
>  	if (IS_ERR(io_end_vec))
> @@ -2610,8 +2611,10 @@ static int mpage_map_and_submit_extent(handle_t *h=
andle,
>  		if (err < 0) {
>  			struct super_block *sb =3D inode->i_sb;
> =20
> -			if (ext4_emergency_state(sb))
> -				goto invalidate_dirty_pages;
> +			if (ext4_emergency_state(sb)) {
> +				*give_up_on_write =3D true;
> +				return err;
> +			}
>  			/*
>  			 * Let the uper layers retry transient errors.
>  			 * In the case of ENOSPC, if ext4_count_free_blocks()
> @@ -2619,18 +2622,7 @@ static int mpage_map_and_submit_extent(handle_t *h=
andle,
>  			 */
>  			if ((err =3D=3D -ENOMEM) || (err =3D=3D -EAGAIN) ||
>  			    (err =3D=3D -ENOSPC && ext4_count_free_clusters(sb))) {
> -				/*
> -				 * We may have already allocated extents for
> -				 * some bhs inside the folio, issue the
> -				 * corresponding data to prevent stale data.
> -				 */
> -				if (progress) {
> -					if (mpage_submit_partial_folio(mpd,
> -								       release_start))
> -						goto invalidate_dirty_pages;
> -					goto update_disksize;
> -				}
> -				return err;
> +				break;
>  			}
>  			ext4_msg(sb, KERN_CRIT,
>  				 "Delayed block allocation failed for "
> @@ -2644,9 +2636,8 @@ static int mpage_map_and_submit_extent(handle_t *ha=
ndle,
>  				 "be lost\n");
>  			if (err =3D=3D -ENOSPC)
>  				ext4_print_free_blocks(inode);
> -		invalidate_dirty_pages:
> -			*give_up_on_write =3D true;
> -			return err;
> +			fatal =3D true;
> +			break;
>  		}
>  		progress =3D 1;
>  		/*
> @@ -2655,10 +2646,24 @@ static int mpage_map_and_submit_extent(handle_t *=
handle,
>  		 */
>  		err =3D mpage_map_and_submit_buffers(mpd);
>  		if (err < 0)
> -			goto update_disksize;
> +			break;
>  	} while (map->m_len);
> =20
> -update_disksize:
> +	if (err < 0) {
> +		/*
> +		 * We may have already allocated extents for some bhs inside
> +		 * the folio, issue the corresponding data to prevent stale
> +		 * data.
> +		 */
> +		if (progress && mpage_submit_partial_folio(mpd, release_start))
> +			fatal =3D true;
> +
> +		if (fatal)
> +			*give_up_on_write =3D true;
> +		if (!progress)
> +			return err;
> +	}

[Severity: Medium]
Can ext4_do_writepages() keep looping with give_up_on_write set to true
after a fatal -ENOSPC?

When mpage_map_one_extent() fails with -ENOSPC and
ext4_count_free_clusters(sb) =3D=3D 0 after an earlier extent in the folio =
was
mapped, mpage_map_and_submit_extent() now submits the partial folio, sets
*give_up_on_write =3D true, and returns -ENOSPC.  However,
ext4_do_writepages() initializes give_up_on_write once outside the
writeback loop and retries -ENOSPC unconditionally:

fs/ext4/inode.c:ext4_do_writepages() {
    ...
		mpage_release_unused_pages(mpd, give_up_on_write, release_start);
		/* Submit prepared bio */
		ext4_io_submit(&mpd->io_submit);
    ...
		if (ret =3D=3D -ENOSPC && sbi->s_journal) {
			jbd2_journal_force_commit_nested(sbi->s_journal);
			ret =3D 0;
			continue;
		}
		if (ret =3D=3D -EAGAIN)
			ret =3D 0;
		/* Fatal error - ENOMEM, EIO... */
		if (ret)
			break;
	}
}

Because mpage_release_unused_pages() clears mpd->scanned_until_end when
mpd->start_pos < mpd->next_pos, the loop continues with give_up_on_write
stuck at true and release_start reset to 0.  On the next iteration, either
the same partially submitted folio is re-locked and invalidated in the same
ext4_do_writepages() call, or (in WB_SYNC_NONE while the partial folio is
still under writeback) subsequent dirty folios are processed and any unused
folios left in [mpd->start_pos, mpd->next_pos) get invalidated by the stale
give_up_on_write flag, while ext4_do_writepages() clears ret =3D 0 and
returns success.  The same happens if mpage_submit_partial_folio() fails
after a retryable -ENOSPC or -EAGAIN.

Should ext4_do_writepages() break out of the loop when give_up_on_write is
set instead of retrying -ENOSPC or clearing -EAGAIN?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116064404.1899=
11-1-sunjunchao@bytedance.com?part=3D2
