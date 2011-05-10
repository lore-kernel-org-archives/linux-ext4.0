From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCHSET v2] ext4: removal of alloc_sem locks from block
 allocation paths
Date: Tue, 10 May 2011 15:48:58 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105101543570.17175@dhcp-27-109.brq.redhat.com>
References: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: amir73il@users.sourceforge.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab1EJNtM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 09:49:12 -0400
In-Reply-To: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 24 Mar 2011, amir73il@users.sourceforge.net wrote:

> The purpose of this patch set is the removal of grp->alloc_sem locks
> from block allocation paths.
> 
> The resulting code is cleaner and should perform better in concurrent
> allocating tasks workloads.
Hi Amir,

Do you have any performance numbers indicating performance improvement
in concurrent allocations ? The only point where I can see taking
write semaphore is in filesystem resize code. Or am I missing something ?

Thanks!
-Lukas

> 
> I ran several xfstests runs with these patches (4K and 1K block size).
> I tried several online resizes and verifyed that both in-core and on-disk
> group counters are correct.
> 
> v2->v1:
> - fix silly bug in patch 4/5 that triggers BUG_ON(incore == NULL)
> - replace get_undo_access() with get_write_access()
> - ran xfstests with block size 1K (where 2 groups share a buddy page)
> 
> [PATCH v2 1/5] ext4: move ext4_add_groupblocks() to mballoc.c
> [PATCH v2 2/5] ext4: implement ext4_add_groupblocks() by freeing blocks
> [PATCH v2 3/5] ext4: synchronize ext4_mb_init_group() with buddy page lock
> [PATCH v2 4/5] ext4: teach ext4_mb_init_cache() to skip uptodate buddy caches
> [PATCH v2 5/5] ext4: remove alloc_semp
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
