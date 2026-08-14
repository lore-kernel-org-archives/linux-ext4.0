Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A3F45D5F3
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702779; cv=none; b=dOussyoex40wGlEItBNPtkRijTy124NZRR9tTftaNJfZ45o7IpR+TJPBjQJ8vQYGX33gq0vVukIL7EQNuShYaGg+FO42lEJE4kIgGePpzqqjyP3xeVyIUuppZmkp9Roc38JmBuZ6OqbWWpXtApwbIGLHhkh//tTuDXu5DLzZ0/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702779; c=relaxed/simple;
	bh=QIJ+zL/TA9DbcG66LAPLEYwrLzcjlPLrn7h0fCPyrLE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hY+qrwW0LknrgyEB/GJYZW5zApvWjY2tKZbVulXyvTq5pviVWMyYrqR+1lPE16qrRC8+58NtVGI+FEq6JzkGuTlQQkzE9yZnHXx1FUZRTxC7Q+Xw5+wrjaSpUQ14FKVp/ZfODdXPo0pdnMXuSZ6BC30qwNTPqjpxYf6Qiia2iQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FyUGm0bi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyUGm0bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94F51F000E9;
	Fri, 14 Aug 2026 10:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702768;
	bh=csxZ2Ig6IM/kB0D1UZzPL5LNWetuI5YiIKlZ+1dXrbQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FyUGm0biFVV+rSVqsQ7R4dSO7N3fcrqhIpFvcZL19fwdjbMV8cT8SYpz2X++u5sl7
	 Sc70YvcxLVjlJksqWTMiV7ZfDzTDHGKQVFSnImH31dwMJ0lUgQBKbM4noJGdPpvDnC
	 z9xuYw88yCZdhOXjzN6Ha+5zRUTkmc4nD15ZJMxppYlRffkn6MVSULvB0HbTpyOFpy
	 2N5px/b5VikSpnfZHmVsnjz9xOOXHGM8Ub9w2N4zLUTQ5b+wLMaJGtogV89EdmQ/RY
	 A3H9N9RB1Zxzuygr1q4VS3yplw+wTpYcwGyF0QrsXeUKcTFXGaaa/cRPzrz7zEQMU2
	 GyOotWBl9UT5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 30/32] ext4: add tracepoints for EOF block
 zeroing and disksize-grow I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-31-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-31-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:19:27 +0000
Message-Id: <20260814101927.E94F51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Calling `i_size_read()` from the block I/O completion context (sof=
tirq) inside the `ext4_iomap_wb_disksize_pending` tracepoint class causes a=
 hard lockup on 32-bit SMP systems.
--

--- Patch [30]: [PATCH -next v5 30/32] ext4: add tracepoints for EOF block =
zeroing and disksize-grow I/O ---
commit 9f6116e7039af778ef1701a210ea9b800dcc543c
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: add tracepoints for EOF block zeroing and disksize-grow I/O

Add tracepoints to track the disksize-grow-pending lifecycle in the
writeback path and the block-zero-EOF entry point.

> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 4f1176b9332f2..4464eb03c9728 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c

[ ... ]

> @@ -729,8 +735,11 @@ void ext4_iomap_end_bio(struct bio *bio)
>  	 * state set in ext4_block_zero_eof() and wake up all waiters
>  	 * that will update the inode i_disksize.
>  	 */
> -	if (io_mode =3D=3D EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO)
> +	if (io_mode =3D=3D EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO) {
> +		trace_ext4_iomap_wb_disksize_pending_complete(ioend->io_inode,
> +				ioend->io_offset, ioend->io_size);
>  		ext4_iomap_clear_disksize_pending(ioend->io_inode);
> +	}

> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 4539ef8e5f86c..c9259c2a3e364 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h

[ ... ]

> +/* disksize pending I/O tracepoints for iomap Buffered I/O path */
> +DECLARE_EVENT_CLASS(ext4_iomap_wb_disksize_pending,
> +	TP_PROTO(struct inode *inode, loff_t io_offset, size_t io_size),
> +	TP_ARGS(inode, io_offset, io_size),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(u64, ino)
> +		__field(loff_t, io_offset)
> +		__field(size_t, io_size)
> +		__field(loff_t, i_size)
> +		__field(loff_t, i_disksize)
> +	),
> +	TP_fast_assign(
> +		__entry->dev =3D inode->i_sb->s_dev;
> +		__entry->ino =3D inode->i_ino;
> +		__entry->io_offset =3D io_offset;
> +		__entry->io_size =3D io_size;
> +		__entry->i_size =3D i_size_read(inode);

[Severity: High]
Does this code introduce a deadlock on 32-bit SMP systems?

The tracepoint ext4_iomap_wb_disksize_pending_complete is called from
ext4_iomap_end_bio(), which executes in softirq context. This happens
because ext4_iomap_writeback_submit() clears the BIO_COMPLETE_IN_TASK flag.

When TP_fast_assign() evaluates i_size_read(inode), it uses a read sequence
lock on 32-bit SMP systems via read_seqcount_begin(&inode->i_size_seqcount).

If i_size_write() is executing concurrently in process context on the same
CPU, it holds the sequence lock without disabling softirqs. If the softirq
interrupts the i_size_write() section, i_size_read() will spin infinitely
waiting for the sequence count to become even.

Is there a way to avoid reading the inode size in this softirq context, or
a safer way to sample it here?

> +		__entry->i_disksize =3D READ_ONCE(EXT4_I(inode)->i_disksize);
> +	),
> +	TP_printk("dev %d:%d ino %llu io_offset %lld io_size %zu i_size %lld i_=
disksize %lld",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->ino, __entry->io_offset, __entry->io_size,
> +		  __entry->i_size, __entry->i_disksize)
> +);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D30
