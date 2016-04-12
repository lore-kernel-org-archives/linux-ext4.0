From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 2/5] ext4: call dax_get_unmapped_area() for DAX pmd mappings
Date: Tue, 12 Apr 2016 14:39:29 -0600
Message-ID: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
Cc: linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@linux.intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	<linux-ext4@vger.kernel.org>
To: akpm@linux-foundation.org, dan.j.williams@intel.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:41196 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964798AbcDLUsN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Apr 2016 16:48:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To support DAX pmd mappings with unmodified applications,
filesystems need to align an mmap address by the pmd size.

Call dax_get_unmapped_area() from f_op->get_unmapped_area.

Note, there is no change in behavior for a non-DAX file.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: <linux-ext4@vger.kernel.org>
---
 fs/ext4/file.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index fa2208b..2abc57b 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -708,6 +708,9 @@ const struct file_operations ext4_file_operations = {
 	.open		= ext4_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
+#ifdef CONFIG_FS_DAX
+	.get_unmapped_area = dax_get_unmapped_area,
+#endif
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ext4_fallocate,
