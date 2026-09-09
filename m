Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7413C5437E0
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 11:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954765; cv=none; b=Wjh8KvloO0FJMVapTCxNOlEZWO+JU7CPxHUQ/WBaJhiJFBYZ1Uj7pXmBE2VCUirjtt0f8IhiQOICZLGQrcxUEF7jhvVviPEuvCu4ZSfmazsGDSqHoPrR7R3C2XC8qCi6yh7hLW2l+qOsxE9CYbhMeqaHvDrYkuZWP54beWCf3Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954765; c=relaxed/simple;
	bh=1PrE1GT5kNJmrgFiE0APXPuIk9ZDx/8pxPLVgP1Cays=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Pn+6knmjbwxIoOE/wlvPQaU9JukvCQnxrTDRCACfUAlRb956kc3hxKvR8YhEZpDAsm2CeWWpLj0uWp7KB5ovgfn66LsY2w2+AbNKHO6DHRyUsx0N1T73sYs+LIZfsV1NcBqC/+qwXx9itXuVo8Y/xKEVm99IlRDD+3+VfYtkSMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L4fJYeqh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L4fJYeqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE8D1F00A3D;
	Wed,  9 Sep 2026 11:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788954763;
	bh=CnsTrILbUlApZpqNFYysGW77qH5bUB/LNijG4sYRa/4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L4fJYeqhaxhEPM8BgXeNM/3F/STXn85mb6QKhGMh4hTn0gRdRmbbIYKOQy7RNGOME
	 f4FJU4ka+tqQeyaodf01tlxdL3JsfPCQvgWb+ifwCBsUqXOe/SmMOdGXi6teb5E8c6
	 jmk0hAecizrnqvuVfieNyJ/7bUgsOuuEviPVfY6qGkMnEoP8+Ko6jP2aPoVOq85me3
	 kYefa+JtZpNrgV784xM71/PnPf2urFNlDVtCf0H78lYu0f5qKiEfroJ/EQTlaUXnic
	 ReVjTWXCnHT1V3PFVyM4pAX5LkgV8cGJO2rGt0LmotLmqVddwBBGnoDvhugi9bdsKY
	 o3qhRuMZ8M1YQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: fix discard work use-after-free on failed
 mount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fan Wu" <fanwu01@zju.edu.cn>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260909113703.698544-1-fanwu01@zju.edu.cn>
References: <20260909113703.698544-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 11:52:42 +0000
Message-Id: <20260909115243.0BE8D1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-after-free of mballoc s_group_info during mount failure unwind=
ing via deferred EA inode eviction.
--

commit 08ee0a465324ade857a129840a9cb84d583a4d78
Author: Fan Wu <fanwu01@zju.edu.cn>

ext4: fix discard work use-after-free on failed mount

ext4_put_super() shuts the journal down before it releases the mballoc
structures, but the failure unwind of __ext4_fill_super() runs the two
steps in the opposite order: failed_mount6 calls ext4_mb_release(),
which flushes sbi->s_discard_work, and the journal is destroyed only
later, just above failed_mount3a.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index bca0dc87d0b7c..459f69bf1c3a3 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5776,6 +5776,12 @@ failed_mount8: __maybe_unused
>  failed_mount7:
>  	ext4_unregister_li_request(sb);
>  failed_mount6:
> +	/*
> +	 * We can have a running transaction from orphan replay or quota
> +	 * setup. Commit it so that discard work after commit runs before
> +	 * we shutdown mballoc.
> +	 */
> +	ext4_force_commit(sb);
>  	ext4_mb_release(sb);

[Severity: High]
This is a pre-existing issue, but does this lead to a use-after-free
of mballoc's s_group_info during deferred EA inode eviction?

If journal replay queues a deferred EA inode put (e.g., dropping the last
reference to an EA inode), it is placed on sbi->s_ea_inode_work. If a
subsequent initialization step fails before failed_mount9, the error
unwinding path calls ext4_mb_release() here, which frees sbi->s_group_info.

Later in the unwinding process at failed_mount_wq:

fs/ext4/super.c:__ext4_fill_super() {
	...
failed_mount_wq:
	/* Drain deferred EA inode iputs before freeing structures */
	flush_delayed_work(&sbi->s_ea_inode_work);
	...
}

This executes the deferred iput, resulting in:
ext4_evict_inode() -> ext4_free_blocks() -> ext4_mb_free_blocks()

Which dereferences the dangling s_group_info pointer:

fs/ext4/balloc.c:ext4_get_group_info() {
	...
	grp_info =3D sbi_array_rcu_deref(EXT4_SB(sb), s_group_info, indexv);
	...
}

Can this sequence occur with a crafted or corrupted filesystem image that
triggers both an EA inode eviction during journal replay and a subsequent
initialization failure?

>  	ext4_flex_groups_free(sbi);
>  failed_mount5:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909113703.6985=
44-1-fanwu01@zju.edu.cn?part=3D1
