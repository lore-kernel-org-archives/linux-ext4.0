From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151511] New: BUGON at fs/ext4/inode.c line :2245
Date: Fri, 05 Aug 2016 03:42:33 +0000
Message-ID: <bug-151511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52932 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758500AbcHEDmh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2016 23:42:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 356F7203EB
	for <linux-ext4@vger.kernel.org>; Fri,  5 Aug 2016 03:42:35 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 153DC203B5
	for <linux-ext4@vger.kernel.org>; Fri,  5 Aug 2016 03:42:34 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151511

            Bug ID: 151511
           Summary: BUGON at fs/ext4/inode.c line :2245
           Product: File System
           Version: 2.5
    Kernel Version: 3.14.74
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: 35445233@qq.com
        Regression: No

I hit the BUG_ON after munmap a file.

BUGON at fs/ext4/inode.c line :2245
mpage_prepare_extent_to_map
...
head = page_buffers(page); //bug on at here


when io err happened at ext4_writepages->mpage_map_and_submit_extent,ext4
return err from mpage_map_and_submit_extent->mpage_map_one_extent.
Then ext4 set give_up_on_write  be true to discard  dirty pages to avoid
infinite loops.
But in mpage_release_unused_pages(&mpd, give_up_on_write), ext4 didn't clean
the pte->dirty.
when page munmaped,unmap_page_range->zap_pud_range->zap_pte_range
set_page_dirty again will cause the bugon at fs/ext4/inode.c line :2245.

    root/mm/memory.c
    zap_pte_range
    1145:        if (pte_dirty(ptent))
    1146:            set_page_dirty(page); //set again cause bugon


I  clear_page_dirty_for_io  in mpage_release_unused_pages can solve the bugon. 

                      if (invalidate) {
+                                       if (page_mapped(page)) 
+                                       {
+                                       clear_page_dirty_for_io(page);
+                                       )
                                block_invalidatepage_range(page, 0,
                                                           PAGE_CACHE_SIZE);
                                ClearPageUptodate(page);
but i am not sure the patch is ok.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
