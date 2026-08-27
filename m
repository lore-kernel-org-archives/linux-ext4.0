Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033B0332917
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 07:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817074; cv=none; b=gIAXvTQUmAM9a+ajjbBFBCHq/uFZbi/hj9h7cf1v/4fNLa6Ykjcj5jaFNi1iLb6pW5WQtqEc7EZDkIoK9VRPUqdLbX7b+goH+AKO0YoHl2/gzjJAdAqQ5p+6/Ce/FBKtlf3DtOvFLrmP7wE/UCIXmeGp2eqjmL1hdWhG6PnTC5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817074; c=relaxed/simple;
	bh=IJwJj/CDWmfCumX3i+DlAamzbrr4kEXS/F59FNpj7hU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Mn98mIJOyWvVwtQXcLuo06sAKmLESziLKISPYS0V50A6ZnIdIrYeBih3IM6/yHPrrdoEWc+kCvRtDuvBw/QHLtB/KKqAEvMoGkZwV7zjlAh+4Tc+itfWdkP/6VtrnJXQjV15m4efSFV4FSHEv7Z3JeAUzXmVaoIIo1zqa+TYWbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F3rsAEvA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F3rsAEvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C3E1F000E9;
	Thu, 27 Aug 2026 07:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787817072;
	bh=5iWkkz7i+mMgS6MVq/nVuLR78XFYm6Lkm1/1lN2vabo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F3rsAEvAl/Yis0yQDQ3qYIjMoZv0PE4Qkx0/69/M3OUsyfdBCb5lgHOWy0SWeCXhX
	 yHr5p555RZGAS4DpSidaMOleBVI+lVfTRd/NrM8JIM/YuqkMm3d5M6P82K6b/G9qh0
	 0pQPY+WA3OpzOGyoFKrq0PD5W1ElFYVrQwv78vcjQamHSQZwloNXsiOtgv2PJcR5sm
	 nBNna0SDakCdHxaFJ/IPazMemh16+bJovG5XOupeQXMRiql4zEWSejkSlNtHZFAYkW
	 efZ4KeJ6/kYMFhpX9FzDE++ZhJRWDY2oQ4vWSJYSi9ECkv14gu20y7UWqCNUa2a6Nt
	 siPvilMFkfMMg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] ext4: cacheline-align inode cache to avoid false
 sharing
Reply-To: sashiko-reviews@lists.linux.dev
To: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260827074334.616360-1-jonaszhou-oc@zhaoxin.com>
References: <20260827074334.616360-1-jonaszhou-oc@zhaoxin.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 07:51:12 +0000
Message-Id: <20260827075112.B0C3E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Fragile performance optimization relying on configuration-depend=
ent struct layout
--

commit 7acd8c0fa63f737f049b6c32ef756e22fa1aeabb
Author: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>

ext4: cacheline-align inode cache to avoid false sharing

This patch adds SLAB_HWCACHE_ALIGN to the ext4 inode cache creation flags.
The goal is to align the embedded vfs_inode.i_rwsem to a cache-line boundary
to avoid false sharing with other metadata.

Link: https://lore.kernel.org/linux-fsdevel/CAGudoHFgtM8Px4mRNM_fsmi3=3DvAy=
CMPC3FBCzk5uE7ma7fdbdQ@mail.gmail.com/

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index bca0dc87d0b7c..49ac97af19945 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1519,7 +1519,8 @@ static int __init init_inodecache(void)
>  	ext4_inode_cachep =3D kmem_cache_create("ext4_inode_cache",
>  				sizeof(struct ext4_inode_info),
>  				&args,
> -				SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT);
> +				SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT |
> +				SLAB_HWCACHE_ALIGN);

[Severity: Medium]
Will this reliably align i_rwsem to a cache-line boundary across different
kernel configurations?

The offset of i_rwsem within struct ext4_inode_info is highly dependent on
kernel configurations. Options like CONFIG_LOCKDEP or CONFIG_DEBUG_SPINLOCK
can alter the sizes of preceding spinlock_t and struct rw_semaphore fields.

While SLAB_HWCACHE_ALIGN ensures the start of struct ext4_inode_info is
cache-line aligned, the varying internal offset of i_rwsem means it may sti=
ll
arbitrarily span cache-line boundaries or share a line with heavily modified
metadata in other builds.

Does this optimization risk uniformly imposing memory overhead while failin=
g to
provide the performance benefit on varying configurations?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827074334.6163=
60-1-jonaszhou-oc@zhaoxin.com?part=3D1
