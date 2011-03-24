From: amir73il@users.sourceforge.net
Subject: [PATCHSET v2] ext4: removal of alloc_sem locks from block allocation paths
Date: Thu, 24 Mar 2011 18:58:08 +0200
Message-ID: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35792 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1CXQ62 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Mar 2011 12:58:28 -0400
Received: by bwz15 with SMTP id 15so226774bwz.19
        for <linux-ext4@vger.kernel.org>; Thu, 24 Mar 2011 09:58:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The purpose of this patch set is the removal of grp->alloc_sem locks
from block allocation paths.

The resulting code is cleaner and should perform better in concurrent
allocating tasks workloads.

I ran several xfstests runs with these patches (4K and 1K block size).
I tried several online resizes and verifyed that both in-core and on-disk
group counters are correct.

v2->v1:
- fix silly bug in patch 4/5 that triggers BUG_ON(incore == NULL)
- replace get_undo_access() with get_write_access()
- ran xfstests with block size 1K (where 2 groups share a buddy page)

[PATCH v2 1/5] ext4: move ext4_add_groupblocks() to mballoc.c
[PATCH v2 2/5] ext4: implement ext4_add_groupblocks() by freeing blocks
[PATCH v2 3/5] ext4: synchronize ext4_mb_init_group() with buddy page lock
[PATCH v2 4/5] ext4: teach ext4_mb_init_cache() to skip uptodate buddy caches
[PATCH v2 5/5] ext4: remove alloc_semp

