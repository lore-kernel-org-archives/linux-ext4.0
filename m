From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v5 04/17] fs: add a new fstype flag to indicate how writeback errors are tracked
Date: Wed, 31 May 2017 08:45:27 -0400
Message-ID: <20170531124540.8782-5-jlayton@redhat.com>
References: <20170531124540.8782-1-jlayton@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531124540.8782-1-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Now that we have new infrastructure for handling writeback errors using
errseq_t, we need to convert the existing code to use it. We could
attempt to retrofit the old interfaces on top of the new, but there is
a conceptual disconnect here in the case of internal callers that
invoke filemap_fdatawait and the like.

When reporting writeback errors, we will always report errors that have
occurred since a particular point in time. With the old writeback error
reporting, the time we used was "since it was last tested/cleared" which
is entirely arbitrary and potentially racy. Now, we can report the
latest error that has occurred since an arbitrary point in time
(represented as a sampled errseq_t value).

This means that we need to touch each filesystem that calls
filemap_check_errors in some fashion and ensure that we establish sane
"since" values for those callers. But...some code is shared between
filesystems and needs to be able to handle both error tracking schemes.

Add a new FS_WB_ERRSEQ flag to the fstype. When mapping_set_error is
called, set mapping->wb_err if it's set, along with setting the
"legacy" AS_EIO/AS_ENOSPC flags. When calling filemap_report_wb_err,
always clear the legacy flags out as well.

This should allow subsystems to use the new errseq_t based error
reporting while simultaneously allowing the traditional semantics of
AS_EIO/AS_ENOSPC flags.

Eventually, this flag should be removed once everything is converted
to errseq_t based error tracking.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/fs.h      |  1 +
 include/linux/pagemap.h | 32 ++++++++++++++++++++++++++------
 mm/filemap.c            |  7 +++++++
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 293cbc7f3520..2f3bcf4eb73b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2021,6 +2021,7 @@ struct file_system_type {
 #define FS_BINARY_MOUNTDATA	2
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
+#define FS_WB_ERRSEQ		16	/* errseq_t writeback err tracking */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 316a19f6b635..1dbc2dd6fdd2 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -28,14 +28,34 @@ enum mapping_flags {
 	AS_NO_WRITEBACK_TAGS = 5,
 };
 
+/**
+ * mapping_set_error - record a writeback error in the address_space
+ * @mapping - the mapping in which an error should be set
+ * @error - the error to set in the mapping
+ *
+ * When writeback fails in some way, we must record that error so that
+ * userspace can be informed when fsync and the like are called.  We endeavor
+ * to report errors on any file that was open at the time of the error.  Some
+ * internal callers also need to know when writeback errors have occurred.
+ *
+ * When a writeback error occurs, most filesystems will want to call
+ * mapping_set_error to record the error in the mapping so that it can be
+ * reported when the application calls fsync(2).
+ */
 static inline void mapping_set_error(struct address_space *mapping, int error)
 {
-	if (unlikely(error)) {
-		if (error == -ENOSPC)
-			set_bit(AS_ENOSPC, &mapping->flags);
-		else
-			set_bit(AS_EIO, &mapping->flags);
-	}
+	if (likely(!error))
+		return;
+
+	/* Record it in wb_err if fs is using errseq_t based error tracking */
+	if (mapping->host->i_sb->s_type->fs_flags & FS_WB_ERRSEQ)
+		filemap_set_wb_err(mapping, error);
+
+	/* Unconditionally record it in flags for now, for legacy callers */
+	if (error == -ENOSPC)
+		set_bit(AS_ENOSPC, &mapping->flags);
+	else
+		set_bit(AS_EIO, &mapping->flags);
 }
 
 static inline void mapping_set_unevictable(struct address_space *mapping)
diff --git a/mm/filemap.c b/mm/filemap.c
index c5e19ea0bf12..97dc28f853fc 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -580,6 +580,13 @@ int filemap_report_wb_err(struct file *file)
 		trace_filemap_report_wb_err(file, old);
 		spin_unlock(&file->f_lock);
 	}
+
+	/* Now clear the AS_* flags if any are set */
+	if (test_bit(AS_ENOSPC, &mapping->flags))
+	    clear_bit(AS_ENOSPC, &mapping->flags);
+	if (test_bit(AS_EIO, &mapping->flags))
+	    clear_bit(AS_EIO, &mapping->flags);
+
 	return err;
 }
 EXPORT_SYMBOL(filemap_report_wb_err);
-- 
2.9.4
