Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795435346;
	b=ULZnVnBmO3W0C7Nzadx3a9tzN5x6MugsS+TOPo1D2HGNPnnDh4mhkm66LQGWJ84UrHMc
	 g586BJk0V7JoMavcO1akM5JIIF9B0//RQiS2xZxMyVZ1Z1CqIlpTtyRjifdeMBLI9pAgA
	 2wlZTvOsTvZOz6fMBYizuVna0BJWQhiUOiOZc/5rwadviRjFjD0XrZ8m5joI4noXWGFu3
	 cq1hwOa5ORiloluMqo5QBbjcQtE3jfa8vbg1ySnJRM4yYlX2Dd7lq0nZLUG/u5/Y3a2oD
	 xxKfwf1rLtTsspLgFmNv7v7tK06YItT2wUIeVtVxaugZiVnIfThgZJI/McIWEVkJIAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795435346;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yvw9HqPKoxslTQd7irRTPhkNto5i/I3BO7xtAl2wO2E=;
	b=Bm2PbOwKk2+ff5PP/FupM18fcbRWqWZh+BJy/hKFwaMxhgDe8e2YmULjlQ/dnAymHExm
	 yBxqXAKRvYHIE9iXMrQ7YwKzAUwC+4wcwNBlSblS3JmPbG2whK0ZvMGblSHIR2aWz/3mY
	 4+OCtCbrrdS7SnerjsxFqNThUzomCWZPDX/wDHMxztxwaGG0gD+vixD4K8o1LiCXnthNJ
	 NFFOnn0wrifid2LnVHgUh9UxfPI/YbBfMLwSHUng6AJSqnfvKc6NLAuLq6vCFxH9v1lux
	 Sx1LV23HG7bO76xMVT3eAdamG8AYYMkghdvD28HsByVTEkRZNSTLzx12uPnjS1CP6RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dn9TMJVf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960BC606A31E
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 12:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dn9TMJVf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC441F000C0;
	Mon, 23 Nov 2026 12:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435346;
	bh=yvw9HqPKoxslTQd7irRTPhkNto5i/I3BO7xtAl2wO2E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dn9TMJVff15LorOeevhhcBqoccn1xu5QeOgOU2txOtSCdgAKDkNRj8MPW0QQUeNRr
	 sWA61SZNCP37oVXckC6EvYXQLbRgqzz0PbeiES7W6baeDvrg/7E/fM7NT3qakvv7WN
	 lBH++ZSfpRl/T7HaORrC6+RVkkZFs/xvL5q/HLsNPZanUJ45RBRvUjdUkONrZzVZaE
	 T9KTCt2bshUpeyHhbYg1jrj1mLSDUpHbu3sei2AAbgyMGGYr5UnMAPnZJUGEIDXM0u
	 kOfHfh6+0/WR9BkusoqS9t0nuv+g3cqc3lnSp70dnTXzHTkf6pU6GRerZAHCK84L7w
	 hb0dFmUDSIgrQ==
Message-ID: <sashiko-outbox-229179@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: protect ext4_acquire_dquot against freezing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ye Bin" <yebin@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261123114602.66520-1-yebin@huaweicloud.com>
References: <20261123114602.66520-1-yebin@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 12:02:25 +0000
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
- [High] ext4: deadlock with thaw_super() in ext4_acquire_dquot() via
  Q_XGETQUOTA
--

commit f23e3eb68e6a88d3c8dec26c7efee607385b6388
Author: Ye Bin <yebin10@huawei.com>

ext4: protect ext4_acquire_dquot against freezing

This commit wraps ext4_acquire_dquot() with sb_start_intwrite() and
sb_end_intwrite() when no journal transaction is currently active to
protect quota acquisition against filesystem freezing.

Link: https://patchwork.kernel.org/project/linux-fsdevel/patch/202611121352=
45.3347102-1-yebin@huaweicloud.com/

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 359f9d4ed4479..a06d5f298c849 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -7118,11 +7118,25 @@ static int ext4_acquire_dquot(struct dquot *dquot)
>  {
>  	int ret, err;
>  	handle_t *handle;
> +	bool freeze_protected =3D false;
> +
> +	/*
> +	 * Trying to sb_start_intwrite() in a running transaction
> +	 * can result in a deadlock. Further, running transactions
> +	 * are already protected from freezing.
> +	 */
> +	if (!ext4_journal_current_handle()) {
> +		sb_start_intwrite(dquot->dq_sb);
> +		freeze_protected =3D true;
> +	}

[Severity: High]
Can calling sb_start_intwrite() here cause an ABBA deadlock between
sb->s_umount and SB_FREEZE_FS when Q_XGETQUOTA or Q_XGETNEXTQUOTA runs on
a frozen filesystem?

quotactl_cmd_write() returns 0 for Q_XGETQUOTA and Q_XGETNEXTQUOTA, so
quotactl_block() and quotactl_fd() acquire down_read(&sb->s_umount)
without waiting for the filesystem to thaw.  If the queried dquot is not
yet active in memory, dquot_get_dqblk() calls dqget() ->
ext4_acquire_dquot() with no running transaction and blocks in
sb_start_intwrite() while holding s_umount:

CPU0                              CPU1
----                              ----
down_read(&sb->s_umount)
                                  sb_freeze_unlock(sb, SB_FREEZE_FS)
sb_start_intwrite(sb)
                                  down_write(&sb->s_umount)

 *** DEADLOCK ***

CPU0: do_quotactl() -> quota_getxquota() -> dquot_get_dqblk() ->
      dqget() -> ext4_acquire_dquot()
CPU1: thaw_super() -> super_lock_excl() -> thaw_super_locked()

Once this happens, thaw_super() cannot acquire s_umount to unfreeze the
filesystem, leaving the filesystem permanently wedged.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123114602.6652=
0-1-yebin@huaweicloud.com?part=3D1
