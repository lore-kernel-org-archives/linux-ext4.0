Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6339539657A
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2026 05:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787204674; cv=none; b=Lij6Fo+zIm+CYC9k3M96WG+xsfLVZBIYwJW+uMW57KoWjy9YkCCRqul5pavch0DhKgmoroRdDINYYVEomQMoTL8Yvj+8sBHGB/G9VKpaNkrqYXBRfNL0fYiTpbo5LIiuju2nrnzHJVWX3tnMbz0cZBBWQwwFb12DZO4+9ZexEQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787204674; c=relaxed/simple;
	bh=rYPLT94jZrEP0WnemjsztWwnvhKGHXXSrEuVkYy8fQg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WVsJKH9NHc3kinD0FHlSzvS9OwLKS5sOsqihElt605qCkSf2hmQTdaJFvC9Cg/bn+jImyg0EKyAn5PYx0KlCkof7K0+Ej98Sk4yvjMpZU0eil8TKr1tOqts628oS3erRCPxMn/2pBHwlDWC+0XT60AzQ5JyL7TQA/wb3MCzpLXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HeNw0Cyd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HeNw0Cyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2156B1F000E9;
	Thu, 20 Aug 2026 05:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787204671;
	bh=vnA/iTLJCd/hdnqjn4qpl7HJ7Vs1ytT1zBPaVoIifzs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HeNw0CydLPx4seLB8/QCDItdqFnoNxHkSkkSfCSakiQB1sUpExvWNsLEgSWMI5pnD
	 /nf9tZnS0ickhLZdiG/kPj/2PfhJfxmbz2+CMvqjqLmO4e649Y7mmGJKMIj6yHjQJw
	 bB6tI2XkfGEWPQ4L7CLbeLJwpWU6++FVoHZqkt0cZACkP+ftLXG5R0Opax7SsgiDGL
	 RBuasiKjvIOjkCL1KlmlFDt/ywln9DiV9deYPfTLA0C+wcN7Fxjz1JTw6i8Q/jq1EM
	 KORTO3emg+1XoZRAt5A+PfILhJmcdjOIR26YlW7TZtyOWcPDdLOHBgHfPLn9x8KQ2R
	 jsr3ATTcf4q9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix discard work use-after-free on failed mount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fan Wu" <fanwu01@zju.edu.cn>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260820052102.4616-1-fanwu01@zju.edu.cn>
References: <20260820052102.4616-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 20 Aug 2026 05:44:30 +0000
Message-Id: <20260820054431.2156B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Incorrect teardown ordering causes Use-After-Free of s_group_i=
nfo and unjournaled metadata modifications during mount failure.
--

--- Patch [1]: [PATCH] ext4: fix discard work use-after-free on failed moun=
t ---
commit 7b05e08bede19859144c19d2964e5f55dbc626c5
Author: Fan Wu <fanwu01@zju.edu.cn>

ext4: fix discard work use-after-free on failed mount

This commit addresses a use-after-free during a failed mount by ensuring
the journal is destroyed before ext4_mb_release() drains the discard work.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index bca0dc87d0b7c..5ec1d8f54e917 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5776,6 +5776,12 @@ failed_mount8: __maybe_unused
>  failed_mount7:
>  	ext4_unregister_li_request(sb);
>  failed_mount6:
> +	/*
> +	 * The last commit can re-arm s_discard_work, so destroy the
> +	 * journal before ext4_mb_release() flushes it.
> +	 */
> +	if (sbi->s_journal)
> +		ext4_journal_destroy(sbi, sbi->s_journal);
>  	ext4_mb_release(sb);
>  	ext4_flex_groups_free(sbi);
>  failed_mount5:

[Severity: Critical]
This is a pre-existing issue, but does this error unwind sequence leave
sbi->s_group_info exposed to a use-after-free further down the failure path?

If a filesystem mount fails after journal replay (for example, if
ext4_enable_quotas() fails), the error unwind reaches failed_mount6 and
calls ext4_mb_release(), which frees sbi->s_group_info.

The unwind then continues down to failed_mount_wq:

failed_mount_wq:
        flush_delayed_work(&sbi->s_ea_inode_work);

If journal replay had queued EA inodes for eviction, the flush worker
will process them:

ext4_evict_inode()
   ext4_truncate()
      ext4_free_blocks()
         ext4_mb_clear_bb()
            ext4_get_group_info()

Can this lead to ext4_mb_clear_bb() dereferencing the freed
sbi->s_group_info array?

Additionally, because this patch moves ext4_journal_destroy() to run before
the flush, sbi->s_journal is now NULL when ext4_evict_inode() runs. Will
this cause ext4_journal_start() to return a nojournal handle, resulting in
unjournaled metadata modifications?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260820052102.4616=
-1-fanwu01@zju.edu.cn?part=3D1
