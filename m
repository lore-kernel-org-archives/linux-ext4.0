From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198187] jbd2_log_wait_commit hangs
Date: Wed, 24 Jan 2018 10:47:01 +0000
Message-ID: <bug-198187-13602-3N9aWJnpbL@https.bugzilla.kernel.org/>
References: <bug-198187-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42322 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932891AbeAXKrD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 Jan 2018 05:47:03 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 90779288CE
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jan 2018 10:47:03 +0000 (UTC)
In-Reply-To: <bug-198187-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198187

--- Comment #12 from Mike Snitzer (snitzer@redhat.com) ---
(In reply to Jan Kara from comment #11)
> Thanks. Mike, any idea here? It appears JBD2 submitted IO to dm-raid1 and it
> never completed. Apparently this did not happen with 4.12.8 but it does
> happen relatively regularly with 4.13.8...

git log --oneline v4.12.8^..v4.13.8 -- drivers/md/dm-raid1.c | tac
9966afa dm: fix REQ_RAHEAD handling
846785e dm: don't return errnos from ->map
1be5690 dm: change ->end_io calling convention
4e4cbee block: switch bios to blk_status_t

So just changes from Christoph to prepare for and finally switch to
blk_status_t

$ git log --oneline v4.12.8^..v4.13.8 -- drivers/md/dm.c | tac
846785e dm: don't return errnos from ->map
1be5690 dm: change ->end_io calling convention
4e4cbee block: switch bios to blk_status_t
7e026c8 dm: add ->copy_from_iter() dax operation support
abebfbe dm: add ->flush() dax operation support
011067b blk: replace bioset_create_nobvec() with a flags arg to bioset_create()
47e0fb46 blk: make the bioset rescue_workqueue optional.
93e6442 dm: add basic support for using the select or poll function
a4aa5e5 dm: fix REQ_OP_ZONE_RESET bio handling
264c869 dm: fix REQ_OP_ZONE_REPORT bio handling
1099930 dm: introduce dm_remap_zone_report()
41341af dm: don't set bounce limit
fbd08e7 bio-integrity: fix interface for bio_integrity_trim
54385bf dm: fix the second dec_pending() argument in __split_and_process_bio()
6044078 dm: fix printk() rate limiting code
bfc0ab4 dax: remove the pmem_dax_ops->flush abstraction
666cb84 dm ioctl: fix alignment of event number in the device list

Nothing in these DM core changes stand out to me as a potential source for IO
hangs.
But obviously the devil is in the details...

Could easily be something in block core is negatively influencing DM, etc.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
