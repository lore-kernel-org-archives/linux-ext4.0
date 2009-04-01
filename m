From: David Howells <dhowells@redhat.com>
Subject: (unknown)
Date: Wed, 1 Apr 2009 19:23:41 -0400
Message-ID: <200904012323.n31NNfTp006379@ns3.rdu.redhat.com>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60074 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935594AbZDAXXo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Apr 2009 19:23:44 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n31NNgqe027969
	for <linux-ext4@vger.kernel.org>; Wed, 1 Apr 2009 19:23:42 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n31NNgZG027564
	for <linux-ext4@vger.kernel.org>; Wed, 1 Apr 2009 19:23:43 -0400
Received: from warthog.cambridge.redhat.com (kibblesnbits.boston.devel.redhat.com [10.16.60.12])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n31NNfTp006379
	for <linux-ext4@vger.kernel.org>; Wed, 1 Apr 2009 19:23:41 -0400
Received: from [127.0.0.1] (helo=redhat.com)
	by warthog.cambridge.redhat.com with esmtp (Exim 4.69 #1 (Red Hat Linux))
	id 1Lp9mW-0007hn-3s
	for linux-ext4@vger.kernel.org; Thu, 02 Apr 2009 00:23:40 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>From dhowells  Thu Apr  2 00: 05:36 2009
Return-Path: dhowells@redhat.com
Received: from localhost.localdomain [127.0.0.1]
	by warthog.procyon.org.uk with IMAP (fetchmail-6.3.8)
	for <dhowells@localhost> (single-drop); Thu, 02 Apr 2009 00:05:36 +0100 (BST)
Received: from zmta01.collab.prod.int.phx2.redhat.com (LHLO
 zmta01.collab.prod.int.phx2.redhat.com) (10.5.5.31) by
 mail06.corp.redhat.com with LMTP; Wed, 1 Apr 2009 19:05:18 -0400 (EDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zmta01.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id B8AE891C7F
	for <dhowells@redhat.com>; Wed,  1 Apr 2009 19:05:18 -0400 (EDT)
Received: from zmta01.collab.prod.int.phx2.redhat.com ([127.0.0.1])
	by localhost (zmta01.collab.prod.int.phx2.redhat.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DvM0JhYhuu-z for <dhowells@redhat.com>;
	Wed,  1 Apr 2009 19:05:18 -0400 (EDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by zmta01.collab.prod.int.phx2.redhat.com (Postfix) with ESMTP id 9356691C7C
	for <dhowells@mail.corp.redhat.com>; Wed,  1 Apr 2009 19:05:18 -0400 (EDT)
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n31N5IVw024801;
	Wed, 1 Apr 2009 19:05:18 -0400
Received: from warthog.cambridge.redhat.com (kibblesnbits.boston.devel.redhat.com [10.16.60.12])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n31N5GuT004603;
	Wed, 1 Apr 2009 19:05:16 -0400
Received: from [127.0.0.1] (helo=warthog.procyon.org.uk)
	by warthog.cambridge.redhat.com with esmtp (Exim 4.69 #1 (Red Hat Linux))
	id 1Lp9Uh-0007SW-8W; Thu, 02 Apr 2009 00:05:15 +0100
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/43] CacheFiles: Add a hook to write a single page of data
	to an inode [ver #46]
To: viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org,
    linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 02 Apr 2009 00:05:15 +0100
Message-ID: <20090401230515.28177.73948.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk>
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.58 on 172.16.27.26
Resent-To: linux-ext4@vger.kernel.org
Resent-Date: Thu, 02 Apr 2009 00:23:40 +0100
Resent-Message-ID: <29622.1238628220@redhat.com>
Resent-From: David Howells <dhowells@redhat.com>

Add an address space operation to write one single page of data to an inode at
a page-aligned location (thus permitting the implementation to be highly
optimised).  The data source is a single page.

This is used by CacheFiles to store the contents of netfs pages into their
backing file pages.

Supply a generic implementation for this that uses the write_begin() and
write_end() address_space operations to bind a copy directly into the page
cache.

Hook the Ext2 and Ext3 operations to the generic implementation.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/ext2/inode.c    |    2 ++
 fs/ext3/inode.c    |    3 +++
 include/linux/fs.h |    7 ++++++
 mm/filemap.c       |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 73 insertions(+), 0 deletions(-)


diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index b43b955..5d17070 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -817,6 +817,8 @@ const struct address_space_operations ext2_nobh_aops = {
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
 	.migratepage		= buffer_migrate_page,
+	.write_one_page		= generic_file_buffered_write_one_page,
+	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 /*
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index d897033..a2e5fef 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1803,6 +1803,7 @@ static const struct address_space_operations ext3_ordered_aops = {
 	.direct_IO		= ext3_direct_IO,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
+	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 static const struct address_space_operations ext3_writeback_aops = {
@@ -1818,6 +1819,7 @@ static const struct address_space_operations ext3_writeback_aops = {
 	.direct_IO		= ext3_direct_IO,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
+	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 static const struct address_space_operations ext3_journalled_aops = {
@@ -1832,6 +1834,7 @@ static const struct address_space_operations ext3_journalled_aops = {
 	.invalidatepage		= ext3_invalidatepage,
 	.releasepage		= ext3_releasepage,
 	.is_partially_uptodate  = block_is_partially_uptodate,
+	.write_one_page		= generic_file_buffered_write_one_page,
 };
 
 void ext3_set_aops(struct inode *inode)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 61211ad..df93cdf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -532,6 +532,11 @@ struct address_space_operations {
 	int (*launder_page) (struct page *);
 	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
 					unsigned long);
+
+	/* write the contents of the source page over the page at the specified
+	 * index in the target address space (the source page does not need to
+	 * be related to the target address space) */
+	int (*write_one_page)(struct address_space *, pgoff_t, struct page *);
 };
 
 /*
@@ -2119,6 +2124,8 @@ extern ssize_t generic_file_direct_write(struct kiocb *, const struct iovec *,
 		unsigned long *, loff_t, loff_t *, size_t, size_t);
 extern ssize_t generic_file_buffered_write(struct kiocb *, const struct iovec *,
 		unsigned long, loff_t, loff_t *, size_t, ssize_t);
+extern int generic_file_buffered_write_one_page(struct address_space *,
+						pgoff_t, struct page *);
 extern ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
 extern ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
 extern int generic_segment_checks(const struct iovec *iov,
diff --git a/mm/filemap.c b/mm/filemap.c
index 3c55c1a..d766c2f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2320,6 +2320,67 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 }
 EXPORT_SYMBOL(generic_file_buffered_write);
 
+/**
+ * generic_file_buffered_write_one_page - Write a single page of data to an
+ *	inode
+ * @mapping - The address space of the target inode
+ * @index - The target page in the target inode to fill
+ * @source - The data to write into the target page
+ *
+ * Write the data from the source page to the page in the nominated address
+ * space at the @index specified.  Note that the file will not be extended if
+ * the page crosses the EOF marker, in which case only the first part of the
+ * page will be written.
+ *
+ * The @source page does not need to have any association with the file or the
+ * target page offset.
+ */
+int generic_file_buffered_write_one_page(struct address_space *mapping,
+					 pgoff_t index,
+					 struct page *source)
+{
+	const struct address_space_operations *a_ops = mapping->a_ops;
+	struct page *page;
+	unsigned len;
+	loff_t isize, pos;
+	void *fsdata;
+	int ret;
+
+	pos = index;
+	pos <<= PAGE_CACHE_SHIFT;
+
+	len = PAGE_CACHE_SIZE;
+	isize = i_size_read(mapping->host);
+	if ((isize >> PAGE_CACHE_SHIFT) == index)
+		len = isize & (PAGE_CACHE_SIZE - 1);
+
+	ret = pagecache_write_begin(NULL, mapping, pos, len,
+				    AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
+	if (ret < 0)
+		goto sync;
+
+	copy_highpage(page, source);
+
+	ret = pagecache_write_end(NULL, mapping, pos, len, len, page, fsdata);
+	if (ret < 0)
+		goto sync;
+
+	balance_dirty_pages_ratelimited(mapping);
+	cond_resched();
+
+sync:
+	/* the caller must handle O_SYNC themselves, but we handle S_SYNC and
+	 * MS_SYNCHRONOUS here */
+	if (unlikely(IS_SYNC(mapping->host)) && !a_ops->writepage)
+		ret = generic_osync_inode(mapping->host, mapping,
+					     OSYNC_METADATA | OSYNC_DATA);
+
+	/* the caller must handle O_DIRECT for themselves */
+
+	return ret;
+}
+EXPORT_SYMBOL(generic_file_buffered_write_one_page);
+
 static ssize_t
 __generic_file_aio_write_nolock(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t *ppos)

