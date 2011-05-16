From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/4] mm: slub: Do not wake kswapd for SLUBs speculative
 high-order allocations
Date: Mon, 16 May 2011 14:10:24 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1105161410090.4353@chino.kir.corp.google.com>
References: <1305295404-12129-1-git-send-email-mgorman@suse.de> <1305295404-12129-3-git-send-email-mgorman@suse.de>
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
Received: from smtp-out.google.com ([216.239.44.51]:47428 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab1EPVK2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2011 17:10:28 -0400
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id p4GLASfj026594
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 14:10:28 -0700
Received: from pwi8 (pwi8.prod.google.com [10.241.219.8])
	by wpaz24.hot.corp.google.com with ESMTP id p4GLAQ6o012779
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 14:10:27 -0700
Received: by pwi8 with SMTP id 8so2721078pwi.36
        for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 14:10:26 -0700 (PDT)
In-Reply-To: <1305295404-12129-3-git-send-email-mgorman@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 13 May 2011, Mel Gorman wrote:

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
