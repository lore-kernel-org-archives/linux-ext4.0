From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v5 07/17] mm: add filemap_fdatawait_range_since and filemap_write_and_wait_range_since
Date: Wed, 31 May 2017 08:45:30 -0400
Message-ID: <20170531124540.8782-8-jlayton@redhat.com>
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

Add new filemap_*wait* variants that take a "since" value and return an
error if one occurred since that sample point.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/fs.h |  9 ++++++++
 mm/filemap.c       | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2f3bcf4eb73b..7d1bd3163d99 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2516,12 +2516,21 @@ extern int write_inode_now(struct inode *, int);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
 extern int filemap_fdatawait(struct address_space *);
+extern int filemap_fdatawait_since(struct address_space *, errseq_t);
 extern void filemap_fdatawait_keep_errors(struct address_space *);
 extern int filemap_fdatawait_range(struct address_space *, loff_t lstart,
 				   loff_t lend);
+extern int filemap_fdatawait_range_since(struct address_space *mapping,
+				   loff_t start_byte, loff_t end_byte,
+				   errseq_t since);
 extern int filemap_write_and_wait(struct address_space *mapping);
+extern int filemap_write_and_wait_since(struct address_space *mapping,
+					errseq_t since);
 extern int filemap_write_and_wait_range(struct address_space *mapping,
 				        loff_t lstart, loff_t lend);
+extern int filemap_write_and_wait_range_since(struct address_space *mapping,
+				   loff_t start_byte, loff_t end_byte,
+				   errseq_t since);
 extern int __filemap_fdatawrite_range(struct address_space *mapping,
 				loff_t start, loff_t end, int sync_mode);
 extern int filemap_fdatawrite_range(struct address_space *mapping,
diff --git a/mm/filemap.c b/mm/filemap.c
index 97dc28f853fc..38a14dc825ad 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -431,6 +431,14 @@ int filemap_fdatawait_range(struct address_space *mapping, loff_t start_byte,
 }
 EXPORT_SYMBOL(filemap_fdatawait_range);
 
+int filemap_fdatawait_range_since(struct address_space *mapping, loff_t start_byte,
+				  loff_t end_byte, errseq_t since)
+{
+	__filemap_fdatawait_range(mapping, start_byte, end_byte);
+	return filemap_check_wb_err(mapping, since);
+}
+EXPORT_SYMBOL(filemap_fdatawait_range_since);
+
 /**
  * filemap_fdatawait_keep_errors - wait for writeback without clearing errors
  * @mapping: address space structure to wait for
@@ -476,6 +484,17 @@ int filemap_fdatawait(struct address_space *mapping)
 }
 EXPORT_SYMBOL(filemap_fdatawait);
 
+int filemap_fdatawait_since(struct address_space *mapping, errseq_t since)
+{
+	loff_t i_size = i_size_read(mapping->host);
+
+	if (i_size == 0)
+		return 0;
+
+	return filemap_fdatawait_range_since(mapping, 0, i_size - 1, since);
+}
+EXPORT_SYMBOL(filemap_fdatawait_since);
+
 int filemap_write_and_wait(struct address_space *mapping)
 {
 	int err = 0;
@@ -501,6 +520,31 @@ int filemap_write_and_wait(struct address_space *mapping)
 }
 EXPORT_SYMBOL(filemap_write_and_wait);
 
+int filemap_write_and_wait_since(struct address_space *mapping, errseq_t since)
+{
+	int err = 0;
+
+	if ((!dax_mapping(mapping) && mapping->nrpages) ||
+	    (dax_mapping(mapping) && mapping->nrexceptional)) {
+		err = filemap_fdatawrite(mapping);
+		/*
+		 * Even if the above returned error, the pages may be
+		 * written partially (e.g. -ENOSPC), so we wait for it.
+		 * But the -EIO is special case, it may indicate the worst
+		 * thing (e.g. bug) happened, so we avoid waiting for it.
+		 */
+		if (err != -EIO) {
+			int err2 = filemap_fdatawait_since(mapping, since);
+			if (!err)
+				err = err2;
+		}
+	} else {
+		err = filemap_check_wb_err(mapping, since);
+	}
+	return err;
+}
+EXPORT_SYMBOL(filemap_write_and_wait_since);
+
 /**
  * filemap_write_and_wait_range - write out & wait on a file range
  * @mapping:	the address_space for the pages
@@ -535,6 +579,29 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 }
 EXPORT_SYMBOL(filemap_write_and_wait_range);
 
+int filemap_write_and_wait_range_since(struct address_space *mapping,
+				 loff_t lstart, loff_t lend, errseq_t since)
+{
+	int err = 0;
+
+	if ((!dax_mapping(mapping) && mapping->nrpages) ||
+	    (dax_mapping(mapping) && mapping->nrexceptional)) {
+		err = __filemap_fdatawrite_range(mapping, lstart, lend,
+						 WB_SYNC_ALL);
+		/* See comment of filemap_write_and_wait() */
+		if (err != -EIO) {
+			int err2 = filemap_fdatawait_range_since(mapping,
+						lstart, lend, since);
+			if (!err)
+				err = err2;
+		}
+	} else {
+		err = filemap_check_wb_err(mapping, since);
+	}
+	return err;
+}
+EXPORT_SYMBOL(filemap_write_and_wait_range_since);
+
 void __filemap_set_wb_err(struct address_space *mapping, int err)
 {
 	errseq_t eseq = __errseq_set(&mapping->wb_err, err);
-- 
2.9.4
