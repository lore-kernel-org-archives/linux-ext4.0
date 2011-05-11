From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/3] mm: slub: Do not wake kswapd for SLUBs speculative
 high-order allocations
Date: Wed, 11 May 2011 13:38:40 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1105111304590.9346@chino.kir.corp.google.com>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de> <1305127773-10570-2-git-send-email-mgorman@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Colin King <colin.king@canonical.com>,
	Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
	Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Mel Gorman <mgorman@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:42441 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab1EKUip (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 May 2011 16:38:45 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id p4BKciEC018814
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2011 13:38:44 -0700
Received: from pvg16 (pvg16.prod.google.com [10.241.210.144])
	by wpaz37.hot.corp.google.com with ESMTP id p4BKcgC1030426
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 11 May 2011 13:38:43 -0700
Received: by pvg16 with SMTP id 16so737130pvg.1
        for <linux-ext4@vger.kernel.org>; Wed, 11 May 2011 13:38:42 -0700 (PDT)
In-Reply-To: <1305127773-10570-2-git-send-email-mgorman@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 11 May 2011, Mel Gorman wrote:

> To avoid locking and per-cpu overhead, SLUB optimisically uses
> high-order allocations and falls back to lower allocations if they
> fail.  However, by simply trying to allocate, kswapd is woken up to
> start reclaiming at that order. On a desktop system, two users report
> that the system is getting locked up with kswapd using large amounts
> of CPU.  Using SLAB instead of SLUB made this problem go away.
> 
> This patch prevents kswapd being woken up for high-order allocations.
> Testing indicated that with this patch applied, the system was much
> harder to hang and even when it did, it eventually recovered.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David Rientjes <rientjes@google.com>
