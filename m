From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v6 15/20] fs: have call_fsync call filemap_report_wb_err if FS_WB_ERRSEQ is set
Date: Mon, 12 Jun 2017 08:23:11 -0400
Message-ID: <20170612122316.13244-20-jlayton@redhat.com>
References: <20170612122316.13244-1-jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752508AbdFLMX4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 12 Jun 2017 08:23:56 -0400
In-Reply-To: <20170612122316.13244-1-jlayton@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allow filesystems to opt-in to a final check of wb_err if FS_WB_ERRSEQ
is set. Technically, we could just plumb these calls into all of the
fsync operations, but I think this means less code, changes and churn.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/fs.h | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 17ba6284ab14..ef3feeec80b2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1742,12 +1742,6 @@ static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
 	return file->f_op->mmap(file, vma);
 }
 
-static inline int call_fsync(struct file *file, loff_t start, loff_t end,
-			     int datasync)
-{
-	return file->f_op->fsync(file, start, end, datasync);
-}
