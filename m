Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66479381EB9;
	Thu,  6 Aug 2026 04:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785991188; cv=none; b=hHMHLtu+DiRLzzZJ9p16DK0Go1zA/dD5ga7sOvOobYU5M64UMOpuar4u9TwztwfT9yY4Xd1EMEOV5Fmpq3/SP3f+gibbawtDYBWxAOgCxQz8ZyqApFzC8KDuXxjNMQxXCa5bceQgXhjaNOdYduonB/UuFd+BmMYRhtvEkHLSzMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785991188; c=relaxed/simple;
	bh=nOmMUt8uPUnfM6hQ41aGH02ZTsgujafN0cIUiOf/mk8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=bpEvaBzEMyeS3BxJmoNGpuKNOILYaTkQ2BI3puFdzhTZSN47WNAZ6KmlI+OaFTsQF8Kx/8sPfUXZqrcU8sCHqIqDldAgsYKd8ibnASKrS0fAFiTcHyGIefLyPhLuKhI38LFFbZllS/lb5YB94tPks7BsBQILt0vEObTfNdRRsbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GCTMoQ2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GCTMoQ2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C031F000E9;
	Thu,  6 Aug 2026 04:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785991187;
	bh=+oho6OshhoeK91nNB5sltboqhuymPXUcVNmnTeSCiio=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GCTMoQ2dfeQeu/K7s5MqpWbwEW0BkcR8LTK1cqzusqS93+kT0j0uLAVpz5bbL5pCr
	 concd0SF0Xi711ZRrovbzLd4FXG0Ke20M/KsG8IlMrgBAtFiHd1sRc3ouxmg/olFQf
	 tP6sw8k69k0V+9y6tCIe0BVBLL2M2nWD3SDXANlE=
Date: Wed, 5 Aug 2026 21:39:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Joseph Qi <joseph.qi@linux.alibaba.com>, Jan
 Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi
 <yi.zhang@huawei.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker
 <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 zhanxusheng@xiaomi.com
Subject: Re: [PATCH 0/2] fs: fix readdir position truncation on 32-bit
 kernels
Message-Id: <20260805213946.88284a99d4e6e7410101de73@linux-foundation.org>
In-Reply-To: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
References: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  6 Aug 2026 10:20:42 +0800 Zhan Xusheng <zhanxusheng1024@gmail.com> wrote:

> Both ext4 and ocfs2 rebuild the directory cookie in ->iterate with
> 
> 	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;
> 
> ctx->pos is loff_t (64-bit) but sb->s_blocksize is unsigned long. On
> 32-bit kernels unsigned long is 32-bit, so ~(sb->s_blocksize - 1) is a
> 32-bit value (e.g. 0xfffff000 for 4 KiB) and, under the usual arithmetic
> conversions, is zero-extended to 0x00000000fffff000 in the AND with the
> 64-bit ctx->pos. The high 32 bits of ctx->pos are silently cleared even
> though a directory may exceed 4 GiB.
> 
> When readdir() crosses the 4 GiB boundary on a 32-bit kernel the position
> is reset back into the first 4 GiB, and the re-validation path then
> re-enumerates already-returned dirents indefinitely.
> 
> These are the block-offset (non-hashed) readdir paths: ocfs2's
> extent-list path (ocfs2_dir_foreach_blk_el(), used for all non-inline
> directories) and ext4's linear path (non-indexed directories, or the
> ext4_dx_readdir() ERR_BAD_DX_DIR fallback).
> 
> This is the same class of bug that commit 3dce5bb82c97 ("exfat: Fix
> bitwise operation having different size") fixed in exfat. Cast the mask
> operand to loff_t so the AND is performed in 64-bit. 64-bit kernels are
> unaffected.

I'm suspecting that AI was used in this work.  If so, please see the
"Assisted-by" info in Documentation/process/submitting-patches.rst.

> The two filesystems are independent; they are sent together only because
> the bug and the fix are identical, so each maintainer can pick the
> relevant patch. The truncation was verified with a freestanding 32-bit
> test mirroring the expression; not reproduced on a live 32-bit >4 GiB
> directory.

Yeah, probably best to send these as separate standalone patches.

No matter, I'll grab the ocfs2 patch and shall await maintainer review.
 
