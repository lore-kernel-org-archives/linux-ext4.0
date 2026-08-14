Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5679416846
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702716; cv=none; b=gPzzXVL+NCcIb4AKGbiPgmHFetB+KWgmokcALOcrUoSk2VAnJTik0LkI+qCiwhpVd3L+1LQtB0bHpEjRKpQT7rDdoSvExyYtgvszyrQ+IP2IuPsljmU12gg6XygQcwW766Upqn0GOCEenkJKakSoWzLmvEzoVk43HdST4aUD4JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702716; c=relaxed/simple;
	bh=uPgA3TukZG9x/jUxmZvb+aID73Jtv3vysLppA62II50=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AWYUDQbcR1Otf7IT/r4b4uypkM9mS+52jMhNmfGVQkejRNkUZfEfmrdldDdiwTbn1yrQMjrw3O1nL1QhODrMkhaQQUrmNh1cCumblvXXh1Z/auZPrq7u/VQGL9g8hnFAS5jEr14Uv54Uo05ODpMj/BoKzG4OFpQC7xx+kXdokrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F1MWTwyK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1MWTwyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865151F000E9;
	Fri, 14 Aug 2026 10:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702706;
	bh=VODl+nEgRDaP3WvKlDf7OuzicM7cOq813weQuEhG08s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F1MWTwyKsaZK2D1kyrr3GdUQxxM3ZIWT/Uv4bg5jH9j3JkH5pg1zs39BaLlLHZfRY
	 QlHPvl5jOZmpy3Jz9ish9Uwfyhj0jGXO38f+gv58IcM7nIWpmwF1QkTYwlJUcXjp1l
	 H2jpxfZMYZk+gU+P+cQJz4kqIHgs/G+kAUzNgxFP4KRPUaawyRJ+GzmdDt4LhSgm+E
	 WmFaidDhuRCg2eLX8nFJ8EVvjJsLlsa+aS6TDE26kXmoksANci5JbHrX825RBjDDBa
	 N28EXEZ1FFn2QzEev0iSbzvVUKgZemF3Q/5hnZIbkfF+vOcIbOX+1xkN09KegHyNah
	 o/n48X7orooug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 29/32] ext4: add tracepoints for
 DISKSIZE_GROW_PENDING set, clear, and wait
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-30-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-30-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:18:26 +0000
Message-Id: <20260814101826.865151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Sequence counter deadlock in tracepoint when called from softirq c=
ontext on 32-bit SMP.
--

--- Patch [29]: [PATCH -next v5 29/32] ext4: add tracepoints for DISKSIZE_G=
ROW_PENDING set, clear, and wait ---
commit f14aeb9661220b55cf0eeb4ff49da9fa6a2a18ca
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: add tracepoints for DISKSIZE_GROW_PENDING set, clear, and wait
   =20
This commit adds trace events ext4_iomap_mark_disksize_pending(),
ext4_iomap_clear_disksize_pending(), and ext4_iomap_wait_disksize_pending().
These tracepoints track disksize-grow-pending state changes and waiting.

> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 69596a216dcb1..4539ef8e5f86c 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
[ ... ]
> +DECLARE_EVENT_CLASS(ext4_iomap_disksize_pending,
> +	TP_PROTO(struct inode *inode),
> +	TP_ARGS(inode),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(u64, ino)
> +		__field(loff_t, i_size)
> +		__field(loff_t, i_disksize)
> +	),
> +	TP_fast_assign(
> +		__entry->dev =3D inode->i_sb->s_dev;
> +		__entry->ino =3D inode->i_ino;
> +		__entry->i_size =3D i_size_read(inode);

[Severity: High]
Could this cause a sequence counter deadlock on 32-bit SMP architectures?

If a process executing i_size_write() is preempted by a block I/O completion
hardware interrupt, and pending softirqs are executed on return from the
interrupt, the softirq could call ext4_iomap_end_bio() in fs/ext4/page-io.c:

fs/ext4/page-io.c:ext4_iomap_end_bio() {
        ...
        if (io_mode =3D=3D EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO)
                ext4_iomap_clear_disksize_pending(ioend->io_inode);
        ...
}

This would trigger trace_ext4_iomap_clear_disksize_pending() which calls
i_size_read() here in TP_fast_assign.

Since i_size_write() disables preemption but not softirqs, the seqcount
would be odd. This would cause i_size_read() to spin indefinitely waiting
for the interrupted i_size_write() to complete on the same CPU.

> +		__entry->i_disksize =3D READ_ONCE(EXT4_I(inode)->i_disksize);
> +	),
> +	TP_printk("dev %d:%d ino %llu i_size %lld i_disksize %lld",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->ino, __entry->i_size, __entry->i_disksize)
> +);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D29
