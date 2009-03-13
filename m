From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix bb_prealloc_list corruption due to wrong group locking
Date: Fri, 13 Mar 2009 16:57:45 -0500
Message-ID: <49BAD6D9.3010505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38528 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbZCMV5y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2009 17:57:54 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n2DLvrTd006227
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2009 17:57:53 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2DLvrOg003971
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2009 17:57:53 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n2DLvqP4002705
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2009 17:57:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is for Red Hat bug 490026,
EXT4 panic, list corruption in ext4_mb_new_inode_pa

(this was on backported ext4 from 2.6.29)

We hit a BUG() in __list_add from  ext4_mb_new_inode_pa()
because the list head pointed to a removed item:

list_add corruption. next->prev should be ffff81042f2fe158,
but was 0000000000200200

(0000000000200200 is LIST_POISON2, set when the item is deleted)

ext4_lock_group(sb, group) is supposed to protect this list for
each group, and a common code flow is this:

    ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
    ext4_lock_group(sb, grp);
    list_del(&pa->pa_group_list);
    ext4_unlock_group(sb, grp);

so its critical that we get the right group number back for
this pa->pa_pstart block.

however, ext4_mb_put_pa passes in (pa->pa_pstart - 1) with a 
comment, "-1 is to protect from crossing allocation group"

Other list-manipulators do not use the "-1" so we have the 
potential to lock the wrong group and race.  Given how the 
ext4_get_group_no_and_offset() function works, it doesn't seem
to me that the subtraction is correct.
 
I've not been able to reproduce the bug, so this is by inspection.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.orig/fs/ext4/mballoc.c
+++ linux-2.6/fs/ext4/mballoc.c
@@ -3603,8 +3603,7 @@ static void ext4_mb_put_pa(struct ext4_a
 	pa->pa_deleted = 1;
 	spin_unlock(&pa->pa_lock);
 
-	/* -1 is to protect from crossing allocation group */
-	ext4_get_group_no_and_offset(sb, pa->pa_pstart - 1, &grp, NULL);
+	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
 
 	/*
 	 * possible race:

