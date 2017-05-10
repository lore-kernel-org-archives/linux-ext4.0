From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] mm: Fix data corruption due to stale mmap reads
Date: Wed, 10 May 2017 10:54:17 +0200
Message-ID: <20170510085419.27601-3-jack@suse.cz>
References: <20170510085419.27601-1-jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        linux-nvdimm@lists.01.org, <linux-mm@kvack.org>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49233 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752100AbdEJIy0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 May 2017 04:54:26 -0400
In-Reply-To: <20170510085419.27601-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, we didn't invalidate page tables during
invalidate_inode_pages2() for DAX. That could result in e.g. 2MiB zero
page being mapped into page tables while there were already underlying
blocks allocated and thus data seen through mmap were different from
data seen by read(2). The following sequence reproduces the problem:

- open an mmap over a 2MiB hole

- read from a 2MiB hole, faulting in a 2MiB zero page

- write to the hole with write(3p).  The write succeeds but we
  incorrectly leave the 2MiB zero page mapping intact.

- via the mmap, read the data that was just written.  Since the zero
  page mapping is still intact we read back zeroes instead of the new
  data.

Fix the problem by unconditionally calling
invalidate_inode_pages2_range() in dax_iomap_actor() for new block
allocations and by properly invalidating page tables in
invalidate_inode_pages2_range() for DAX mappings.

Fixes: c6dcf52c23d2d3fb5235cec42d7dd3f786b87d55
CC: stable@vger.kernel.org
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c      |  2 +-
 mm/truncate.c | 12 +++++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 38deebb8c86e..123d9903c77d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1015,7 +1015,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	 * into page tables. We have to tear down these mappings so that data
 	 * written by write(2) is visible in mmap.
 	 */
-	if ((iomap->flags & IOMAP_F_NEW) && inode->i_mapping->nrpages) {
+	if (iomap->flags & IOMAP_F_NEW) {
 		invalidate_inode_pages2_range(inode->i_mapping,
 					      pos >> PAGE_SHIFT,
 					      (end - 1) >> PAGE_SHIFT);
diff --git a/mm/truncate.c b/mm/truncate.c
index 706cff171a15..6479ed2afc53 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -686,7 +686,17 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 		cond_resched();
 		index++;
 	}
