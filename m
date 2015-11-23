From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: fix race aio-dio vs freeze_fs
Date: Mon, 23 Nov 2015 20:02:48 +0400
Message-ID: <1448294568-20892-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:18631 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbbKWQDG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2015 11:03:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After freeze_fs was revoked (from Jan Kara) pages's write-back completion
is deffered before unwritten conversion, so explicit flush_unwritten_io()
was removed here: c724585b62411
But we still may face deferred conversion for aio-dio case
# Trivial testcase
for ((i=0;i<60;i++));do fsfreeze -f /mnt ;sleep 1;fsfreeze -u /mnt;done &
fio --bs=4k --ioengine=libaio --iodepth=128 --size=1g --direct=1 \
    --runtime=60 --filename=/mnt/file --name=rand-write --rw=randwrite
NOTE: Sane testcase should be integrated to xfstests, but it requires
changes in common/* code, so let's use this this test at the moment.

In order to fix this race we have to guard journal transaction with explicit
sb_{start,end}_intwrite()  as we do with ext4_evict_inode here:8e8ad8a5

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3a6197a..4cba944 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5040,6 +5040,12 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 	max_blocks = ((EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits) -
 		      map.m_lblk);
 	/*
+	 * Protect us against freezing - AIO-DIO case. Caller didn't have to
+	 * have any protection against it
+	 */
+	sb_start_intwrite(inode->i_sb);
+
+	/*
 	 * This is somewhat ugly but the idea is clear: When transaction is
 	 * reserved, everything goes into it. Otherwise we rather start several
 	 * smaller transactions for conversion of each extent separately.
@@ -5083,6 +5089,7 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 	}
 	if (!credits)
 		ret2 = ext4_journal_stop(handle);
+	sb_end_intwrite(inode->i_sb);
 	return ret > 0 ? ret2 : ret;
 }
 
-- 
1.7.1

