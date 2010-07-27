From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/3 v3] Batched discard support for Ext3/Ext4
Date: Tue, 27 Jul 2010 14:41:51 +0200
Message-ID: <1280234514-10287-1-git-send-email-lczerner@redhat.com>
Cc: jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab0G0Mmz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jul 2010 08:42:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

since my last post I have changed those patches slightly. Ext3 patch does
not introduce DISCARD/NODISCARD mount option, so there is just FITRIM
ioctl which can be invoked only by user with CAP_SYS_ADMIN.

Ext3 patch also involves journaling because as Jan pointed out not using
journal can cause problems when system crashes. Jan please look at this
I hope it is ok now. Also I am not sure if it would not be better to close
the journal after allocating free space and then start new one after
the TRIM (this was proposed by Josef Bacik).

Ext4 patch does not remove old "online" discard implementation and does not
check for DISCARD mount option. To avoid journaling I have used alloc_sem
semaphore to prevent allocations from the group while it is being trimmed.
It seems sufficient to me.

The general idea of batched discards stays the same. So when FITRIM ioctl
is invoked upon the mount point, it walks through all allocation groups
searching for free extents bigger than minlen, then trim those extents. In
ext3 consistency is assured by allocating these free extents in alloc. group
(with journal involved). In ext4 consistency is assured by use of alloc_sem
semaphore.

-Lukas

[PATCH 1/3] Add ioctl FITRIM.
[PATCH 2/3] Add batched discard support for ext3
[PATCH 3/3] Add batched discard support for ext4
