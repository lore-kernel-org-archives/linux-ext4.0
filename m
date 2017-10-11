From: Jan Kara <jack@suse.cz>
Subject: [PATCH 15/19] ext4: Simplify error handling in ext4_dax_huge_fault()
Date: Wed, 11 Oct 2017 22:05:59 +0200
Message-ID: <20171011200603.27442-16-jack@suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Ted Tso <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20171011200603.27442-1-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If transaction starting fails, just bail out of the function immediately
instead of checking for that condition throughout the function.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3cec0b95672f..208adfc3e673 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -302,16 +302,17 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
 		down_read(&EXT4_I(inode)->i_mmap_sem);
 		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
 					       EXT4_DATA_TRANS_BLOCKS(sb));
+		if (IS_ERR(handle)) {
+			up_read(&EXT4_I(inode)->i_mmap_sem);
+			sb_end_pagefault(sb);
+			return VM_FAULT_SIGBUS;
+		}
 	} else {
 		down_read(&EXT4_I(inode)->i_mmap_sem);
 	}
-	if (!IS_ERR(handle))
-		result = dax_iomap_fault(vmf, pe_size, NULL, &ext4_iomap_ops);
-	else
-		result = VM_FAULT_SIGBUS;
+	result = dax_iomap_fault(vmf, pe_size, NULL, &ext4_iomap_ops);
 	if (write) {
-		if (!IS_ERR(handle))
-			ext4_journal_stop(handle);
+		ext4_journal_stop(handle);
 		up_read(&EXT4_I(inode)->i_mmap_sem);
 		sb_end_pagefault(sb);
 	} else {
-- 
2.12.3
