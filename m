Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BCA314A9E;
	Mon, 28 Sep 2026 21:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632144; cv=none; b=kzIN/R2bmA+OIxWTfxMAZbsXriQHaQduZ7YPeI11aEcqKZCjYL5BdgGZTIJ96HMlR0wgnLmDgEW+CQpg3xh3CkEftMeZmU41KCQvfeNCRhKwVDvSR6oNWs20fzaYtcNjrMGfopbf708otS0gPiG3u3uXG6jBY8AodYU5BxySXHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632144; c=relaxed/simple;
	bh=GkUe7x1Gfs2UOgJi1TE93T6PLIDHRRPQLINRi151jQA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Pu+G3yUfPykYSsiAWrIUgGDNLVMV3xUBZ7gnJVy64kLX9odMbH09xiJky/LzQoWjsMEYWHZgYk43w7DnC0cmNney1+/ib4n8pgqmyi/GZRDcqGhOJwabYTftwGtlnylVg3sxw1sE8xuJX7gOMayhOusEVEkoOsKvKxgOwQpUadU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=feAestUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="feAestUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC331F000FF;
	Mon, 28 Sep 2026 21:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632143;
	bh=3WIlg48jq+OdGmyFTLD0q+UgVG01A/J3xfyeSMGXSDw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=feAestUulsqsuBSPGIlO2VX//eoNiX6ebVnMrzOQrXC75XaMaoleISH7l/f/opQWS
	 QyQ459/S4JGQ3RVgtFsXV3jfjtlNz/3L6ancyAJo3rjmIY4c88NqNg04H3na4WNZes
	 fycVDEgUJtOlEWNKO3tSDXJ4ZMptbzGbPlhHp4Zg=
Date: Mon, 28 Sep 2026 14:49:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hughd@google.com,
 baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
 ziy@nvidia.com, bfoster@redhat.com, joannelkoong@gmail.com,
 djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
Subject: Re: [PATCH v5 0/4] mm/truncate: fix data loss when truncating
 straddling large folios
Message-Id: <20260928144901.83cc90357c9a488e94fd6785@linux-foundation.org>
In-Reply-To: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Sep 2026 20:08:29 +0800 Zhang Yi <yi.zhang@huaweicloud.com> wrote:

> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Hello,
> 
> This is the fifth version fixing data loss when truncating straddling
> large folios caught on the upcomming ext4 + iomap buffered I/O
> conversion.

Thanks.

> When truncate_inode_pages_range() punches a hole or truncates a file,
> truncate_inode_partial_folio() splits a large folio so that the caller
> can drop the in-range sub-folios while keeping the out-of-range tail
> intact.  This series fixes three distinct problems in that path that
> can each lose the valid out-of-range tail of a straddling folio, plus a
> follow-up that clarifies the return value semantics.
> 
> Patch 01 aligns the truncation boundaries inwards to the mapping minimum
> folio order in truncate_inode_pages_range().  With a non-zero min_order,
> folio_split() stops at min_order instead of order 0, so a boundary
> computed at page granularity can land inside a min-order-aligned
> sub-folio and the truncate loop drops that whole chunk, valid tail
> included, causing data loss.
> 
> Patch 02 looks the end-edge straddler up by its page index through
> __filemap_get_folio() in truncate_inode_partial_folio().  After the
> first split the straddler is unlocked and only transiently ref'd in the
> page cache, so the page pointer derived from the original folio can be
> freed and reallocated as a different folio in the same mapping, and the
> mapping check cannot catch it, which may cause incorrect splitting and
> potential data loss.
> 
> Patch 03 reworks the contract between truncate_inode_partial_folio() and
> its callers.  If the second split of the straddler fails, the function
> reported success unconditionally, and the leftover incorrect end
> position could cause the truncate loop to drop that valid tail.  After
> rework, it tells the caller the exact page range safe to discard via new
> pstart/pend out-parameters, so the truncate loop never touches a
> straddling folio that still holds valid out-of-range data.
> 
> Patch 04 clarifies the return value semantics to "at least one split
> succeeded", which is all the shmem caller needs to decide whether to
> reset its scan loop.
> 
> The second patch fixes a pre-existing race issue that is reachable
> today, so it is Cc'd to stable.  Patches 01 and 03 require a dirty large
> folio that carries no filesystem private data, so they are not reachable
> on current filesystems.  They were found while developing the upcoming
> ext4 iomap buffered I/O path. [1]

Can you confirm that [2/4] will work correctly when backported into
-stable kernels?  That is has no dependency on the other three?


