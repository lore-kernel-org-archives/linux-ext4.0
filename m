Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB52530DF0
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 13:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084896; cv=none; b=ZSJxF6CO8xo42kEKiYEsUtGg/2DI+MG6RPJTnOijkpIaptn+EgpuvtDVwRH+rAtPI6LV0Oi1XoFJeZZhBkF81JhwZ5EA4RlRMz+t7kSk5UTHp4N5uPAJjOhFCo3A9R3wKiLmgeQXNYIR9+lpC4QnE8vLZhi6gverCYJQZrhYiZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084896; c=relaxed/simple;
	bh=w10RBxsUGtOFHpPwTlagk7zihbsxVZOw5yPuLYb1AY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YP9wU99N03zwAnF6mn71fmbU/dlC+FPQujNBOjpggVg4rxz6CKiMJ3eOEzexZQOtKgR7+piCZ7vZYasQUDg4yqJ1U5q+JiZIoywsqF0aAy3q9a3ge5BffRNe2h4gH4kBuRy6kAjlatziDON3d0y6+IJA62Mb0l4mQtil/mRhlxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OZaXFQLM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OZaXFQLM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790084893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6IrbNKYXaxBgTnuatiYDHte9IqTtxWZJRiUhRvSTwak=;
	b=OZaXFQLMjOHqcZYmIAw5VgR5mVXbo9hRbkzE6iXePaAynr2TpvjQVZUmizQedNgH7L6YVC
	Bgi/Z9mtDGb0tVWSACkYy/Z+QO8ZLlfzrNOatm8GjFzGtaJXAJQnh3fx70RwL86uPpBQjf
	qmPDPsAC1Zvisi2Et3j2zrbI0Do+ww8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-299--PafZw6uO163-ZRW7g_LJA-1; Tue,
 22 Sep 2026 09:48:11 -0400
X-MC-Unique: -PafZw6uO163-ZRW7g_LJA-1
X-Mimecast-MFC-AGG-ID: -PafZw6uO163-ZRW7g_LJA_1790084888
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E1E8183090D;
	Tue, 22 Sep 2026 13:48:06 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6486930001B9;
	Tue, 22 Sep 2026 13:48:00 +0000 (UTC)
Date: Tue, 22 Sep 2026 09:47:58 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, hughd@google.com,
	baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
	ziy@nvidia.com, joannelkoong@gmail.com, djwong@kernel.org,
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
	chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH v4 0/4] mm/truncate: fix data loss when truncating
 straddling large folios
Message-ID: <arKHDqdDkQajvAk6@bfoster>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Sep 22, 2026 at 07:06:59PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Hello,
> 
> This is the fourth version fixing data loss when truncating straddling
> large folios caught on the upcomming ext4 + iomap buffered I/O
> conversion.
> 
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
> 
> The second patch fixes a pre-existing race issue that is reachable
> today, so it is Cc'd to stable.  Patches 01 and 03 require a dirty large
> folio that carries no filesystem private data, so they are not reachable
> on current filesystems.  They were found while developing the upcoming
> ext4 iomap buffered I/O path[1].
> 
> Thanks,
> Yi.
> 

Hi Yi,

Modulo Jan's comment on patch 4, this series looks good to me. FWIW:

Reviewed-by: Brian Foster <bfoster@redhat.com>

Brian

> [1] https://lore.kernel.org/linux-fsdevel/a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com/
> 
> 
> v3->v4:
>  - Move the patch that fixes data loss when min_order is non-zero to the
>    first patch position, aligning start and end in
>    truncate_inode_pages_range(). (Zi Yan)
>  - Add patch 2, fixing the invalid folio2 issue under concurrency when
>    truncate_inode_partial_folio() splits at the end position. Use
>    __filemap_get_folio() to obtain a reliable folio2. (Jan Kara)
> 
> v2->v3:
>  - Rework the folio2 validity check logic to fix the invalid
>    folio->index issue. (sashiko)
>  - Clarify the pstart and pend setting logic and the corresponding
>    comments to make it more readable. (Brian, Joanne)
>  - Split the patch into 3 small patches. (Zi Yan)
> 
> v1->v2:
>  - Export pstart as a new parameter so that the generic and shmem
>    truncate paths don't need to recompute the start value from the
>    return value. (Brian)
>  - When min_order is non-zero, align [pstart, pend] to the inner
>    boundaries of the folio to ensure they do not point into the middle
>    of a large folio, which could otherwise cause valid data within the
>    folio to be incorrectly cleared. (Joanne)
> 
> v3: https://lore.kernel.org/linux-mm/20260916092450.654408-1-yi.zhang@huaweicloud.com/
> v2: https://lore.kernel.org/linux-mm/20260909062339.473816-1-yi.zhang@huaweicloud.com/
> v1: https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@huaweicloud.com/
> 
> 
> Zhang Yi (4):
>   mm/truncate: align truncation boundaries to mapping minimum folio
>     order
>   mm/truncate: look up the end-edge straddler by index
>   mm/truncate: fix data loss when splitting straddling large folios
>     fails
>   mm/truncate: clarify return value of truncate_inode_partial_folio()
> 
>  mm/internal.h |   4 +-
>  mm/shmem.c    |  13 ++---
>  mm/truncate.c | 128 +++++++++++++++++++++++++++++++++-----------------
>  3 files changed, 91 insertions(+), 54 deletions(-)
> 
> --
> 2.54.0
> 

