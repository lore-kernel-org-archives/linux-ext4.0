From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: fix bigalloc regression
Date: Mon, 6 Jan 2014 13:46:19 -0500
Message-ID: <20140106184619.GB2211@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:47015 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbaAFSqY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jan 2014 13:46:24 -0500
Received: by mail-qa0-f48.google.com with SMTP id w5so3294256qac.7
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jan 2014 10:46:22 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit f5a44db5d2 introduced a regression on filesystems created with
the bigalloc feature (cluster size > blocksize).  It causes xfstests
generic/006 and /013 to fail with an unexpected JBD2 failure and
transaction abort that leaves the test file system in a read only state.
Other xfstests run on bigalloc file systems are likely to fail as well.

The cause is the accidental use of a cluster mask where a cluster
offset was needed in ext4_ext_map_blocks().

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4410cc3..3384dc4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4218,7 +4218,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 */
 	map->m_flags &= ~EXT4_MAP_FROM_CLUSTER;
 	newex.ee_block = cpu_to_le32(map->m_lblk);
-	cluster_offset = EXT4_LBLK_CMASK(sbi, map->m_lblk);
+	cluster_offset = EXT4_LBLK_COFF(sbi, map->m_lblk);
 
 	/*
 	 * If we are doing bigalloc, check to see if the extent returned
-- 
1.8.3.2

