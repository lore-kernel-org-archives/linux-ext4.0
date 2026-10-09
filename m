Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5751D4BF932
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791543834; cv=none; b=pZzZD5pEFYSq6Cc3Yz2h6NEJtEcNITikIM5jgfzORYghfS421QtTjDyFO1zXX1mPNQ1LtDLeSBxe2t/Te2FMLDicDFETeqv9hE/nBBcuRIxouCyZIrIipfZM8FaCQK+JtPjJLv9XfgvBUfDh5GFEXl+p2OEUYa3H4lLUWkWWh5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791543834; c=relaxed/simple;
	bh=6TwTuyiqRzxh1RXOqwyhVsp8lcfm9lVi98Nyjnj6vig=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=CU5bqk8Id2qYyk2GHw4yhIke0+PrZ35TvLp1Afj8+KS0LzAdD60i+Hyg/KnYZY5pYUuincZ9NNmuM05asFILusz3PZIAvDKeDvXCKibM8Vku/q4Gozecp6rNdZ5bF4qh5ANXXdJOsOVAQCAsKKM2v2AaOkmm93VS6l+zRUYSLWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TsGujhTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TsGujhTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19381F000FF;
	Fri,  9 Oct 2026 11:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791543827;
	bh=IRa95CUB35h74wb6RTCwR8mNZmbQ29IDISNjJwXgm7c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TsGujhTZnK+WJy6nFSCxZLqkA4C1B/p5L0RGJNi0ITQWkIBz5UgbtnQ239KhhDsKR
	 L0btIrz8wLlZVK+hIxeG8tRGTYHvUSjmdkogw1jBIgzPgS5l+DWzVdXEALX3Q1w4gR
	 R1XokbxFE014Few3i+RE9dqPeps7xsA3onhxYtp7Dy0+j4rirsmOodNZhVkc5pui9r
	 fxQSCHT5e3UnBGXjCteMtQxrKAvwa50xvh7UYkZMrMMqafPBHMGcn1N5CL5EgzQm2k
	 5o4ZIcbq7t/OUeCD2l9VNzI/4Nk4c9CPlAAaai5HSvi2EPWCNkwiIbspMqJFolvwOp
	 93WhCFsmRaxnw==
Message-ID: <sashiko-outbox-165305@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 19/31] ext4: add block mapping tracepoints for iomap
 buffered I/O path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009103033.2920530-20-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-20-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:03:46 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ext4: information leak of uninitialized map->m_pblk in trace_ext=
4_iomap_buffered_write_begin
--

commit 63eb0e998a7a12aca902166168b720bc244eba71
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: add block mapping tracepoints for iomap buffered I/O path

This commit adds tracepoints for iomap buffered read, write, partial block
zeroing, and writeback operations. This helps debug the iomap buffered I/O
path.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 35767c3a7ffff..1c7083a9293e9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
[ ... ]
> @@ -4052,6 +4054,8 @@ static int ext4_iomap_buffered_do_write_begin(struc=
t inode *inode,
>  	if (ret < 0)
>  		return ret;
> =20
> +	trace_ext4_iomap_buffered_write_begin(inode, &map, offset, length,
> +					      flags);

[Severity: Medium]
Could this tracepoint leak uninitialized stack memory?

In ext4_iomap_buffered_do_write_begin(), the local variable
struct ext4_map_blocks map is declared on the stack without
zero-initialization.

When ext4_iomap_map_blocks() is called with EXT4_GET_BLOCKS_DELALLOC_RESERVE
(when delalloc is true), the mapping resolution routes to ext4_da_map_block=
s().
If this hits a cached delayed extent or inserts a new one, it returns 0
without initializing map.m_pblk.

>  	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>  	return 0;
>  }

> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 7028a28316fa3..bcf80f518e61d 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
[ ... ]
> +	TP_fast_assign(
> +		__entry->dev		=3D inode->i_sb->s_dev;
> +		__entry->ino		=3D inode->i_ino;
> +		__entry->m_lblk		=3D map->m_lblk;
> +		__entry->pblk		=3D map->m_pblk;

[Severity: Medium]
Does this assignment unconditionally copy the potentially uninitialized
map->m_pblk to the trace ring buffer?

Since ext4_fsblk_t is 8 bytes, this would leak 8 bytes of uninitialized
kernel stack memory into the trace buffer on delayed allocation paths,
which is accessible to users with tracing privileges.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D19
