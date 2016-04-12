From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 4/5] ext2: call dax_get_unmapped_area() for DAX pmd mappings
Date: Tue, 12 Apr 2016 14:39:31 -0600
Message-ID: <1460493572-31667-3-git-send-email-toshi.kani@hpe.com>
References: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
Cc: linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@linux.intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	<linux-ext4@vger.kernel.org>
To: akpm@linux-foundation.org, dan.j.williams@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

To support DAX pmd mappings with unmodified applications,
filesystems need to align an mmap address by the pmd size.

Call dax_get_unmapped_area() from f_op->get_unmapped_area.

Note, there is no change in behavior for a non-DAX file.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: <linux-ext4@vger.kernel.org>
---
 fs/ext2/file.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index c1400b1..f1b8006 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -172,6 +172,9 @@ const struct file_operations ext2_file_operations = {
 	.open		= dquot_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_fsync,
+#ifdef CONFIG_FS_DAX
+	.get_unmapped_area = dax_get_unmapped_area,
+#endif
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 };
