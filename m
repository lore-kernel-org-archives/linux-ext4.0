Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDEC382F15;
	Thu,  6 Aug 2026 04:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785991325; cv=none; b=hSF/adzg1y8mCNRK0KaxImsnR2Bv4+bdbtoww2hef70sXoUKU5vnkMuw/Oxj/N44M+pPvMzTA1KO3zofebXCx2CStmGKT6iMzCLjCy43c6wmECo4deumPums6OqtZhwUuAmxLFEGAyCi18vzGyuJRMvp5BfwnLQqtq1+roloqAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785991325; c=relaxed/simple;
	bh=vkpp9fEWcT7LL+yq8Q8fXndNyAZevqk/sYF3X+fJ/kk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=DJpboOMfEtph7uAKXlOn4lv19Y2bKBK2g46OSUZN4PZqgnnk8Zqxm0j9HVOg065A5lDIA16/p4/e0z6IeBBAIzS1aSqAI9JPmWhvSCkroy6PrsH62IZC+pnwOdYkk+oFeQo4wFNs+wnsemYpJh5TahKkK6Nt7Ik68DC1sccOlqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l3rBYCba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l3rBYCba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A191F000E9;
	Thu,  6 Aug 2026 04:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785991323;
	bh=t35fSEXIIeHac5GoA5eLt45766W6yYbQue0gPYPW82M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=l3rBYCbalmTB9xoGzTurx1o/DdnJioMjhFd//2W3SF0UhdCVQ+C8cWh+XUDgFbMfQ
	 r+JMsSPtsr9edpX5rpo5pKZMejx6qaOE8qHck0eM8i8+jeVs4WLsTIFewuxqmElj1n
	 89Absnpq1Pr51zkonLqRaTP46vut4biyhR+drtcw=
Date: Wed, 5 Aug 2026 21:42:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Joseph Qi <joseph.qi@linux.alibaba.com>, Jan
 Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi
 <yi.zhang@huawei.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker
 <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 zhanxusheng@xiaomi.com, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ocfs2: fix readdir position truncation on 32-bit
 kernels
Message-Id: <20260805214202.a644393ef2f28ffb30090ff4@linux-foundation.org>
In-Reply-To: <20260806022044.167962-3-zhanxusheng@xiaomi.com>
References: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
	<20260806022044.167962-3-zhanxusheng@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  6 Aug 2026 10:20:44 +0800 Zhan Xusheng <zhanxusheng1024@gmail.com> wrote:

> In ocfs2_dir_foreach_blk_el(), the directory cookie position is
> rebuilt with
> 
> 	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;
> 
> `ctx->pos` is loff_t (signed 64-bit), while `sb->s_blocksize` is
> unsigned long.  On 32-bit kernels unsigned long is 32-bit, so the mask
> 
> 	~(sb->s_blocksize - 1)
> 
> is computed as a 32-bit unsigned value (e.g. 0xfffff000 for a 4 KiB
> block size).  In the AND expression with the 64-bit `ctx->pos`, that
> unsigned operand is zero-extended to 64 bits per the usual arithmetic
> conversions, yielding 0x00000000fffff000.  The high 32 bits of
> `ctx->pos` are silently cleared, even though directory size is
> allowed to exceed 4 GiB.
> 
> When readdir() crosses the 4 GiB boundary on a 32-bit kernel the
> position is reset back into the first 4 GiB block, making the
> re-validation path re-enumerate already-returned dirents indefinitely.
> 
> This is ocfs2_dir_foreach_blk_el(), the extent-list readdir path taken
> for all non-inline directories, so a directory large enough to cross
> 4 GiB reaches it.
> 
> This is the same class of bug that commit 3dce5bb82c97 ("exfat: Fix
> bitwise operation having different size") fixed in exfat, and the
> fix mirrors the equivalent ext4 fix in this series.  Cast the operand
> to loff_t so the mask is 64-bit before the AND:
> 
> 	ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1)) | offset;
> 
> 64-bit kernels are unaffected.

AI review had no comment on your change, but it might have found a
bunch of unrelated ocfs2 issues:

	https://sashiko.dev/#/patchset/20260806022044.167962-1-zhanxusheng@xiaomi.com
