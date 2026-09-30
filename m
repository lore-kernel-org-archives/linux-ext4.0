Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6287E3939D0
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2026 07:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790752917; cv=none; b=VfyTabqz8SKYpg3VNNZK0fcgqOo8PHs1bPM4VSjtVTbQo10v7qWxPecHQ/xsAiwPqPcLtsIiSdnBpH7HdXb8TvSMdDcvRNZzCqDjidZs00gXHRhUfGTqkp00jv24m8CmCKMtQ4/vPdr/xGKorliIKhknhoGkVGak8I/oIo90Gjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790752917; c=relaxed/simple;
	bh=eH66kRdNUvSmVFHpZQk1XgWgS+r7+Ieznwjbtkvo4AE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XgV72rDMk0NsXdVfPkPtwKUklnJRSeZIUJKhEULKiC1C5Hg1akqmHOX7qp70mMfa+bk5HCdnzYudnlRRiUpIK4T9RJUcUE/vE4LLNVlCttAj8xIMkQUcVo3uIXvwOfyAe2fjvvUG7xlKPT01Lpj8midLDzSojTq5RZOG2iz6cIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TsvICXLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TsvICXLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9483F1F000FF;
	Wed, 30 Sep 2026 07:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790752915;
	bh=2LxJvGsO5XoUBwB17f3Tpy6kkU2ocYtgait7qoKLPaw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TsvICXLxXQqCmxYeBjrOYxN0clYtWIWj7f2LGAlyLzmdUiKwmc8lmSC+Zs+bQIwp9
	 TWkppAkqP9WrlnKyZ5P8M001wHbdCoQqRnlWexMUaSoLPPKZACtbH9KdVw8UFXsg4I
	 iYy37wWG2FpMryZPP6QpbWcSV+SU1rqrJ3qV+cgJueyoCFnm+8LPs8q2GRKt3k7bR7
	 uheFMux4H8SVZ248yWtJ5As8KAl1IlXFoxtf4NKNMfb7T9Sgp3Q6vijrqY2slTNteu
	 9zoRlhoGLJiM6CD+MIs3WR/WoLVuOQxJ0mMuk9vVcilpEvS8JwDqP9FdB2RcECW1eg
	 4F+1aqt8gFFTA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] ext4: fix shrinker scan budget accounting in
 ext4_es_scan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260930-fix-ext4-es-scan-nr-scanned-v3-1-9aef0be87d21@gmail.com>
References: <20260930-fix-ext4-es-scan-nr-scanned-v3-0-9aef0be87d21@gmail.com>
 <20260930-fix-ext4-es-scan-nr-scanned-v3-1-9aef0be87d21@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 07:21:55 +0000
Message-Id: <20260930072155.9483F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: premature SHRINK_STOP in ext4_es_scan() breaks LRU reclaim
--

commit 38269e532034036f670a12b2f9dedde4248280c0
Author: Qiliang Yuan <odys.yuan@gmail.com>

ext4: fix shrinker scan budget accounting in ext4_es_scan()

The extents_status shrinker's count_objects() callback reports the number of
shrinkable extent_status objects via a percpu counter. This patch returns
SHRINK_STOP when __es_shrink() frees nothing to prevent burning through the
scan budget against a stale freeable count.

> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 6e4a191e82191..d88af807d36e7 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -1783,6 +1783,16 @@ static unsigned long ext4_es_scan(struct shrinker =
*shrink,
> =20
>  	ret =3D percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
>  	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
> +
> +	/*
> +	 * es_stats_shk_cnt is a percpu counter, so it can stay positive
> +	 * after sbi->s_es_list has nothing left to give. Stop this reclaim
> +	 * pass once a call frees nothing, instead of burning through
> +	 * do_shrink_slab()'s scan budget against a stale count.
> +	 */
> +	if (nr_shrunk =3D=3D 0)
> +		return SHRINK_STOP;

[Severity: High]
Does this prematurely abort the shrinker when scanning referenced items?

If __es_shrink() processes a full batch (e.g., 128 items) but all of them a=
re
referenced, it clears their referenced bit (aging them) but frees none,
resulting in nr_shrunk =3D=3D 0.

For example, in es_do_reclaim_extents():

	(*nr_to_scan)--;
	node =3D rb_next(&es->rb_node);

	if (ext4_es_must_keep(es))
		goto next;
	if (ext4_es_is_referenced(es)) {
		ext4_es_clear_referenced(es);
		goto next;
	}

Because scanning referenced or unfreeable extents correctly consumes the sc=
an
budget without incrementing nr_shrunk, won't this conflate "scanned a batch=
 of
hot items" with "the cache is empty", breaking the second-chance LRU algori=
thm
under memory pressure?

>  	return nr_shrunk;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930-fix-ext4-e=
s-scan-nr-scanned-v3-0-9aef0be87d21@gmail.com?part=3D1
