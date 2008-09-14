From: Eric Sandeen <sandeen@redhat.com>
Subject: patches in queue but missing from series?
Date: Sun, 14 Sep 2008 14:11:08 -0700
Message-ID: <48CD7DEC.6080008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43286 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbYINVL5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Sep 2008 17:11:57 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m8ELBLMh032466
	for <linux-ext4@vger.kernel.org>; Sun, 14 Sep 2008 17:11:41 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8ELBAeF012184
	for <linux-ext4@vger.kernel.org>; Sun, 14 Sep 2008 17:11:10 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m8ELB8Q7001104
	for <linux-ext4@vger.kernel.org>; Sun, 14 Sep 2008 17:11:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Looking at what's in the patch queue, but not in the series file:

ext4-fix-hang-due-to-corrupted-jinode.patch
ext4-new-defm-options
ext4-online-resize-fix-for-group-descriptor-corruption.patch
Fix-EXT_MAX_BLOCK.patch
jbd2-dio-kjournal-race-EIO.patch
jbd-dio-kjournal-race-EIO.patch
ext2-printk-throttling
ext3_dx_readdir_hash_collision_fix.patch
ext3-printk-throttling
ext3_truncate_block_allocated_on_a_failed_ext3_write_begin.patch

Some of these are probably intentional (I think Ted has the printk
throttling stuff queued up to send) but have any of these simply gotten
lost somehow?  Or merged upstream (or obsoleted) but not removed?

At least this one seems to be already applied:

ext4-online-resize-fix-for-group-descriptor-corruption.patch

so should probably be removed from git.

Unless someone knows offhand about the others, I can dig in and see what
might be going on....

For example:

http://repo.or.cz/w/ext4-patch-queue.git?a=commitdiff;h=70e9eefe6c0178e87068f675486a61727a1a48fb

dropped the jbd2-dio-kjournal-race-EIO.patch patch but from the commit
message, it's not clear that it was intentional...?

Thanks,
-Eric


