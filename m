From: Arthur Jones <ajones@riverbed.com>
Subject: [PATCH] ext3: wait on all pending commits in ext3_sync_fs
Date: Mon, 3 Nov 2008 10:44:26 -0800
Message-ID: <20081103184426.GA31894@ajones-laptop.nbttech.com>
References: <4908C951.2000309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.riverbed.com ([206.169.144.12]:39566 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYKCSo2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 13:44:28 -0500
Content-Disposition: inline
In-Reply-To: <4908C951.2000309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,   This patch fixes the problem for me, and
seems to put the buffers on the dirty list at the
place where they are put on the list during the working
case.  Despite having rooted around in the innards of
ext3 for the last few days, I cannot say that I have
any sense of whether this patch will cause problems
elsewhere or even if this is the best place to
intercede.

I post the complete patch not because I think it
should be committed as is, but rather to try
to explain the logic that brought it about.  At the
very least, this should be reviewed by the experts
here to make sure there is no collateral damage.

Arthur

-------------------
In ext3_sync_fs, we only wait for a commit to
finish if we started it, but there may be one
already in progress which will not be synced.

In the case of a data=ordered umount with pending long
symlinks which are delayed due to a long list
of other I/O on the backing block device, this
causes the buffer associated with the long symlinks
to not be moved to the inode dirty list in the second
phase of fsync_super.  Then, before they can be dirtied
again, kjournald exits, seeing the UMOUNT flag and the
dirty pages are never written to the backing block device,
causing long symlink corruption and exposing new or
previously freed block data to userspace.

This can be reproduced with a script created
by Eric Sandeen <sandeen@redhat.com>:

	#!/bin/bash

	umount /mnt/test2
	mount /dev/sdb4 /mnt/test2
	rm -f /mnt/test2/*
	dd if=/dev/zero of=/mnt/test2/bigfile bs=1M count=512
	touch
	/mnt/test2/thisisveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryverylongfilename
	ln -s
	/mnt/test2/thisisveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryverylongfilename
	/mnt/test2/link
	umount /mnt/test2
	mount /dev/sdb4 /mnt/test2
	ls /mnt/test2/
	umount /mnt/test2

To ensure all commits are synced, we flush
all journal commits now when sync_fs'ing ext3.

Signed-off-by: Arthur Jones <ajones@riverbed.com>
---
 fs/ext3/super.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 18eaa78..053659a 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2392,7 +2392,13 @@ static int ext3_sync_fs(struct super_block *sb, int wait)
 	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
 		if (wait)
 			log_wait_commit(EXT3_SB(sb)->s_journal, target);
-	}
+	} else if (wait)
+		/*
+		 * We may have a commit in progress, clear it out
+		 * before we go on...
+		 */
+		ext3_force_commit(sb);
+
 	return 0;
 }
 
-- 
1.5.4.3
