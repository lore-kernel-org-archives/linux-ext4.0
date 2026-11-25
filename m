Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795606253;
	b=114O/ZJsDOcZvKwj9azryAl90Rdh2AnO28gdARAOO32a5o0PtIPLpZtw0nl2/hgMEFjN
	 AObyhHnkOgCrlW6SI9UvtsLIjql0uBaCNWjVl3WMHQ1a2TXX5jSa3eUO7THip4bDrABp4
	 DvNGDKdRUjFdW2k+fQmIIkt5iOM/ZmERldxpBDKTpYdrqNpnq4jIPqBx1hVEKxhH1VYQj
	 7zIzUh2eHTkoeehIVX2n4ibuosuvmM1qeSzwHpxbj7l5VfYcOR70j5eH436NN6MgWhLaJ
	 EKfT/NQutpS8EP1dFWpGFeYKV4Km0/0fMZg0h72m4qWl2pojMLkWAyibZ9JrzrYMGpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795606253;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=h23lmsTtTYGuyv6U+oYBdWfipFPaXn3X5T6zIaLRJHI=;
	b=YvKKBE/0kW65LhqSHCBco7NJ0sK/Kwv9BV0QcMzbNFWMHi2H9zK6OCnhKbx/XMGxJtiq
	 I6t6ax/o97VLbSI9wwiOi/v5xSlpTHXUCbTmRgZ0296ipEKihptHkifJk1fKAzzHBiiBm
	 qX1ULHbXaQ+LlY8dEs8vcJPcU4PrSyLl5JAiw8vwyNluv+mQ4/FKOlRT6uWtiG2RApdES
	 mS5465Zx805xt8G/yeiuzD2ql4WbqjNH/Gqf4wrGm87eplfhz3rNWCel9JPy3IdTMI/h+
	 NeGzKFIgyy0lrirP96yVCuazZgfHRJeKbf0onb3h8ihpqBPilXw2IP1DPXNKcfc/5SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJsSV0si;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD66F606A321
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 11:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJsSV0si
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465C91F000D2;
	Wed, 25 Nov 2026 11:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795606253;
	bh=h23lmsTtTYGuyv6U+oYBdWfipFPaXn3X5T6zIaLRJHI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iJsSV0sidfagb0xiyCSMr+UVrIZ6nBlQIvw6fTmLK9LA+6CCiX8QxACt81MgnSk3c
	 N3TARDFBfrPQnxbuKPRsTVr3Ct20zSVr8hgalceL5Lrmpph8eFjUj0WHMlsiIuGwx9
	 79G1iEZDMCi2Qv7y/GWwwr4guaKKTn5BeYyRG9mg68QCCUkhSA50NtjuprgH40hYiF
	 XuIFGSE7J9GPYKuI+HC4kdBjCsC9hOnt5QgKWN0+kSNibkZKvJ8/tGDsmClBYMPo9j
	 gcX+JRIiSYkporRMcZMwvFUmoPDYFRDgYz+QZoBNxbpsugFA79uBLDERXWOW78IWVr
	 l0eInymo2QT/w==
Message-ID: <sashiko-outbox-233250@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] ext4: protect ext4_acquire_dquot against
 freezing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ye Bin" <yebin@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261125111055.3672233-3-yebin@huaweicloud.com>
References: <20261125111055.3672233-1-yebin@huaweicloud.com>
 <20261125111055.3672233-3-yebin@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 11:30:52 +0000
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
- [High] ext4: misplaced sb_end_intwrite() in ext4_write_dquot() instead
  of acquire
- [High] ext4: s_umount vs SB_FREEZE_FS deadlock in ext4_acquire_dquot()
  via vfs_ustat()
--

commit 365cb575bc6d55af6ebb9f261bcac19d705f99d4
Author: Ye Bin <yebin10@huawei.com>

ext4: protect ext4_acquire_dquot against freezing

This commit takes sb_start_intwrite() around ext4_acquire_dquot() when no
journal transaction is currently active to protect dquot acquisition
against filesystem freezing.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 880f664d6c04b..769cae2ae65ff 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -7161,6 +7161,10 @@ static int ext4_write_dquot(struct dquot *dquot)
>  	err =3D ext4_journal_stop(handle);
>  	if (!ret)
>  		ret =3D err;
> +
> +	if (freeze_protected)
> +		sb_end_intwrite(dquot->dq_sb);
> +
>  	return ret;
>  }

[Severity: High]
Was this sb_end_intwrite() hunk meant for the end of ext4_acquire_dquot()
instead of ext4_write_dquot()?  freeze_protected is not declared in
ext4_write_dquot(), breaking the build when CONFIG_QUOTA is enabled, and
ext4_acquire_dquot() never releases SB_FREEZE_FS after
ext4_journal_stop().

> @@ -7168,11 +7172,25 @@ static int ext4_acquire_dquot(struct dquot *dquot)
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
s_umount and SB_FREEZE_FS when ustat(2) runs on a frozen filesystem?

Unlike Q_XGETQUOTA, vfs_ustat() acquires s_umount for reading via
user_get_super(dev, false) without checking whether the filesystem is
frozen, then calls statfs_by_dentry(s->s_root, sbuf) -> ext4_statfs().
When the root directory has EXT4_INODE_PROJINHERIT set and project quota
limits are enabled, ext4_statfs() calls ext4_statfs_project() -> dqget().
If the root directory's project dquot is not active in cache, dqget()
invokes ext4_acquire_dquot() with no running transaction:

CPU0                              CPU1
----                              ----
down_read(&s->s_umount)
                                  down_write(&sb->s_umount)
sb_start_intwrite(dquot->dq_sb)
                                  sb_freeze_unlock(sb, SB_FREEZE_FS)

 *** DEADLOCK ***

CPU0: vfs_ustat() -> ext4_statfs() -> ext4_statfs_project() -> dqget() ->
      ext4_acquire_dquot()
CPU1: thaw_super() -> super_lock_excl() -> thaw_super_locked()

Because CPU0 blocks on SB_FREEZE_FS while holding s_umount for reading,
thaw_super() cannot acquire s_umount exclusively to unfreeze the
filesystem.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125111055.3672=
233-1-yebin@huaweicloud.com?part=3D2
