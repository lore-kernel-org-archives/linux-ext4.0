From: <gregkh@suse.de>
Subject: patch ext4-add-missing-unlock-in-ext4_check_descriptors-on-error-path.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:55:49 -0800
Message-ID: <20081203185913.E6B2A48D91@coco.kroah.org>
References: <1226851540-8032-5-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: lizf@cn.fujitsu.com, gregkh@suse.de, linux-ext4@vger.kernel.org,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60898 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751596AbYLCS7O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:14 -0500
In-Reply-To: <1226851540-8032-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: add missing unlock in ext4_check_descriptors() on error path

to the 2.6.27-stable tree.  Its filename is

    ext4-add-missing-unlock-in-ext4_check_descriptors-on-error-path.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 09:57:50 2008
From: Li Zefan <lizf@cn.fujitsu.com>
Date: Sun, 16 Nov 2008 11:05:24 -0500
Subject: ext4: add missing unlock in ext4_check_descriptors() on error path
To: stable@kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>
Message-ID: <1226851540-8032-5-git-send-email-tytso@mit.edu>


From: Li Zefan <lizf@cn.fujitsu.com>

(cherry picked from commit 7ee1ec4ca30c6df8e989615cdaacb75f2af4fa6b)

If there group descriptors are corrupted we need unlock the block
group lock before returning from the function; else we will oops when
freeing a spinlock which is still being held.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1626,8 +1626,10 @@ static int ext4_check_descriptors(struct
 			       "Checksum for group %lu failed (%u!=%u)\n",
 			       i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
 			       gdp)), le16_to_cpu(gdp->bg_checksum));
-			if (!(sb->s_flags & MS_RDONLY))
+			if (!(sb->s_flags & MS_RDONLY)) {
+				spin_unlock(sb_bgl_lock(sbi, i));
 				return 0;
+			}
 		}
 		spin_unlock(sb_bgl_lock(sbi, i));
 		if (!flexbg_flag)


Patches currently in stable-queue which might be from lizf@cn.fujitsu.com are

queue-2.6.27/cpuset-fix-regression-when-failed-to-generate-sched-domains.patch
queue-2.6.27/cgroups-fix-a-serious-bug-in-cgroupstats.patch
queue-2.6.27/ext4-add-missing-unlock-in-ext4_check_descriptors-on-error-path.patch
