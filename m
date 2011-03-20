From: amir73il@users.sourceforge.net
Subject: ext4: removal of alloc_sem locks from block allocation paths
Date: Sun, 20 Mar 2011 23:32:45 +0200
Message-ID: <1300656770-14994-1-git-send-email-amir73il@users.sourceforge.net>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50341 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1CTVd0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Mar 2011 17:33:26 -0400
Received: by fxm17 with SMTP id 17so5008363fxm.19
        for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 14:33:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The purpose of this patch set is the removal of grp->alloc_sem locks
from block allocation paths.

This resulting code is cleaner and should perform better in concurrent
allocating tasks workloads.

I ran several xfstests runs with these patches (4K block only).
I tried several online resizes and verifyed that both in-core and on-disk
group counters are correct.

ext4: move ext4_add_groupblocks() to mballoc.c
ext4: implement ext4_add_groupblocks() by freeing blocks
ext4: synchronize ext4_mb_init_group() with buddy page lock
ext4: teach ext4_mb_init_cache() to skip uptodate buddy caches
ext4: remove alloc_semp
