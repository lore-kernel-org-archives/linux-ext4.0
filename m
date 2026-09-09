Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E854F6463;
	Wed,  9 Sep 2026 23:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788995679; cv=none; b=cmPBECRS+jpkQflCXiJMR5gZScyIDj9D2kc1Nl46diMc2qihabBnNrt78ikHyztWyWb1lYD7/M7DvQtMMV1egg5B/van1ZjzR1xkm+el4jzrEo49aceHd7TtPnejUidpaayo5/PkaFOm0g14oF3YKkh6aUP3UM59SKVwd0wywnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788995679; c=relaxed/simple;
	bh=k/p4fw0coVyzoSxQl9afWV1RZ922Qu9ejokKOfUonjQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=PbCflQEEvCTNqrE53OggQd+XS8LilK7n6LcS7UtSg+oQ347SwpEkjWlj0AcwC3kxT99WA3yzE8Fv454bgKVSzgkXAnLnwlangafXk4QSVyJLku1TEK+EukcmfYuy6qOxlClsotq+TJmgM1mDtMRw7TaQboMae4BM+cuG91bZoIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v+a2ECut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v+a2ECut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779FD1F000FF;
	Wed,  9 Sep 2026 23:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788995674;
	bh=dkruSTAugRIXgigmDvmANzyJdRXpZQBA7ft2oJiqxSA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=v+a2ECutAdelnbekynA/hQfWWeSGE/n4kGildm2vZBVtWBHjXrP9wFmxcyPvBwb90
	 y5ouZrgcb2X3mFepZwjXCeV0rhIUsZwQ39vQ7hqRnm4UcpNwS9hFx24JjTcDZ/I+7F
	 N4GtF6583H4YaDenL369MuTyoefuSjs7xHVvYB8k=
Date: Wed, 9 Sep 2026 16:14:33 -0700
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
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating
 straddling large folios
Message-Id: <20260909161433.d96c67399ccac8de27499925@linux-foundation.org>
In-Reply-To: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  9 Sep 2026 14:23:39 +0800 Zhang Yi <yi.zhang@huaweicloud.com> wrote:

> From: Zhang Yi <yi.zhang@huawei.com>
> 
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
> 
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
> 
> For example, a 4-page order-2 folio punched from offset 0 to the middle
> of the last page:
> 
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()      # same_folio == true
>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>       folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>       2nd split of folio2 fails / cannot lock
>       return true                       # BUG: caller keeps default end
>     end = 3
>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
> 
> This became reachable after commit 7460b470a131 ("mm/truncate: use
> folio_split() in truncate operation") replaced the atomic split_folio()
> with folio_split(), whose non-uniform split can partially split a folio
> and leave the end edge merged.
> 
> It has gone unnoticed because a dirty large folio normally carries the
> filesystem's private data, for example buffer_head, so
> filemap_release_folio() -> iomap_release_folio() returns false on a
> dirty folio and folio_split() aborts with -EBUSY before any split,
> leaving the straddler safely unsplit. The bug is only reachable on paths
> that produce dirty large folios without filesystem private data, and it
> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
> attached.

So is there any way of being hit by these issues in 7.2 and earlier?

>  mm/internal.h |  4 +--
>  mm/shmem.c    | 13 +++-----
>  mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
>  3 files changed, 67 insertions(+), 38 deletions(-)

I hope not, because that's quite a lump of code to be backporting.

Thanks.  I'll queue it for testing and shall await your response to Zi
Yan's questions.

I see you've received Sashiko's feedback.  Please let us know if
there's any validity to it.

	https://sashiko.dev/#/patchset/20260909062339.473816-1-yi.zhang@huaweicloud.com


