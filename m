From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCHSET v2] ext4: removal of alloc_sem locks from block
 allocation paths
Date: Tue, 3 May 2011 18:47:17 +0300
Message-ID: <BANLkTi=xo=w=i9E-Pj4mrbuQeuRbaRRdtw@mail.gmail.com>
References: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34318 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1ECPrT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 11:47:19 -0400
Received: by eyx24 with SMTP id 24so66280eyx.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 May 2011 08:47:18 -0700 (PDT)
In-Reply-To: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Ping ^2 on these patches.
You have asked me for mballoc cleanup and I gave you mballoc cleanup...
Do you still have them or do you want me to resend?

Yongqiang is working on cleaning up the snapshot patches and merging
his extent split
refactoring patches with Allison's punch hole patches.

We would like to start rebasing our patches on top of your big alloc patches.
Are the patches in ext4-patch-queue in good shape for testing (with
BIG_ALLOC feature off)?

Thanks,
Amir.

On Thu, Mar 24, 2011 at 7:58 PM,  <amir73il@users.sourceforge.net> wrote:
> The purpose of this patch set is the removal of grp->alloc_sem locks
> from block allocation paths.
>
> The resulting code is cleaner and should perform better in concurrent
> allocating tasks workloads.
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
>
