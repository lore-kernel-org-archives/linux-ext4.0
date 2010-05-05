From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [Bug 15906] serious performance regression in "umount" on ext4 over LVM
Date: Wed, 05 May 2010 12:27:41 +0400
Message-ID: <87ljbyhhxe.fsf@openvz.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
	<201005050728.o457SHRn012045@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:32918 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab0EEI1p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 04:27:45 -0400
Received: by bwz25 with SMTP id 25so2755935bwz.28
        for <linux-ext4@vger.kernel.org>; Wed, 05 May 2010 01:27:43 -0700 (PDT)
In-Reply-To: <201005050728.o457SHRn012045@demeter.kernel.org>
	(bugzilla-daemon@bugzilla.kernel.org's message of "Wed, 5 May 2010
	07:28:17 GMT")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bugzilla-daemon@bugzilla.kernel.org writes:

Hi Jens,

Just FYI, we have found a regression which was caused by your famous
writeback patch 03ba3782e8dcc5b0e1efe440d33084f066e38cae
I'm not allowed to add you to CC in BZ, that's why i wrote this mail.

Before the patch __sync_filesystem() called writeback_single_inode()
directly, but now it is called indirectly (from flush-X:X task)
which require a super_block in question to be pinned.
But this is impossible to pin this SB on umount because we already
hold s_umount sem for write, so effectively we already pinned that SB.
So my proposal is to treat umount similar to WB_SYNC_ALL, and skip
pining stage.

> https://bugzilla.kernel.org/show_bug.cgi?id=15906
>
>
> Dmitry Monakhov <dmonakhov@openvz.org> changed:
>
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |dmonakhov@openvz.org
>
>
>
>
> --- Comment #13 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-05-05 07:28:10 ---
> Yep. i've already know that issue. In fact it was broken by followng commit
>
> From 03ba3782e8dcc5b0e1efe440d33084f066e38cae Mon Sep 17 00:00:00 2001          
> From: Jens Axboe <jens.axboe@oracle.com>                                        
> Date: Wed, 9 Sep 2009 09:08:54 +0200                                            
> Subject: [PATCH] writeback: switch to per-bdi threads for flushing data
>
> The problem with __sync_filesystem(0) is no longer works on umount
> because sb can not be pined s_mount sem is downed for write and s_root is NULL.
>
> And in fact ext3 is also broken in case of "-obarrier=1"
> The patch attached fix the original regression, but there is one more issue
> left
>
> A delalloc option. In fact dirty inode is still dirty even after first
> call of writeback_single_inode which is called from __sync_filesystem(0)
> due to delalloc allocation happen during inode write. So it takes second
> __sync_filesystem call to clear dirty flags. Currently i'm working on that
> issue. I hope i'll post a solution today.
