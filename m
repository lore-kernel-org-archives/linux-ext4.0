From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/9] ext4: Fix races between buffered IO and collapse /
 insert range
Date: Wed, 18 Nov 2015 16:16:56 +0100
Message-ID: <20151118151656.GG6097@quack.suse.cz>
References: <1447185059-16166-1-git-send-email-jack@suse.com>
 <1447185059-16166-4-git-send-email-jack@suse.com>
 <94D0CD8314A33A4D9D801C0FE68B40295BE2820A@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Cc: Jan Kara <jack@suse.com>, Ted Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"Boylston, Brian" <brian.boylston@hpe.com>
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbbKRPRA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Nov 2015 10:17:00 -0500
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BE2820A@G4W3202.americas.hpqcorp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 18-11-15 01:39:37, Elliott, Robert (Persistent Memory) wrote:
> 
> > -----Original Message-----
> > From: linux-ext4-owner@vger.kernel.org [mailto:linux-ext4-
> > owner@vger.kernel.org] On Behalf Of Jan Kara
> > Sent: Tuesday, November 10, 2015 1:51 PM
> > Subject: [PATCH 3/9] ext4: Fix races between buffered IO and collapse /
> > insert range
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> >  	/*
> > -	 * Prevent page faults from reinstantiating pages we have released from
> > +	 * Prevent page faults from reinstantiating we have released from
> >  	 * page cache.
> 
> I don't think you meant to delete that word...

Right. Thanks for catching that. Attached is a fixed version of the patch.

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--sdtB3X0nJg68CQEu
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-races-between-buffered-IO-and-collapse-inse.patch"

>From f01b71d438aa8c3dc4c8eeb54c82595ecd93c5c3 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.com>
Date: Fri, 16 Oct 2015 13:55:06 +0200
Subject: [PATCH] ext4: Fix races between buffered IO and collapse / insert
 range

Current code implementing FALLOC_FL_COLLAPSE_RANGE and
FALLOC_FL_INSERT_RANGE is prone to races with buffered writes and page
faults. If buffered write or write via mmap manages to squeeze between
filemap_write_and_wait_range() and truncate_pagecache() in the fallocate
implementations, the written data is simply discarded by
truncate_pagecache() although it should have been shifted.

Fix the problem by moving filemap_write_and_wait_range() call inside
i_mutex and i_mmap_sem. That way we are protected against races with
both buffered writes and page faults.

Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/ext4/extents.c | 59 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 65b5ada2833f..4b105c96df08 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5487,21 +5487,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 			return ret;
 	}
 
-	/*
-	 * Need to round down offset to be aligned with page size boundary
-	 * for page size > block size.
-	 */
-	ioffset = round_down(offset, PAGE_SIZE);
-
-	/* Write out all dirty pages */
-	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
-					   LLONG_MAX);
-	if (ret)
-		return ret;
-
-	/* Take mutex lock */
 	mutex_lock(&inode->i_mutex);
-
 	/*
 	 * There is no need to overlap collapse range with EOF, in which case
 	 * it is effectively a truncate operation
@@ -5526,6 +5512,27 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	 * page cache.
 	 */
 	down_write(&EXT4_I(inode)->i_mmap_sem);
+	/*
+	 * Need to round down offset to be aligned with page size boundary
+	 * for page size > block size.
+	 */
+	ioffset = round_down(offset, PAGE_SIZE);
+	/*
+	 * Write tail of the last page before removed range since it will get
+	 * removed from the page cache below.
+	 */
+	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset, offset);
+	if (ret)
+		goto out_mmap;
+	/*
+	 * Write data that will be shifted to preserve them when discarding
+	 * page cache below. We are also protected from pages becoming dirty
+	 * by i_mmap_sem.
+	 */
+	ret = filemap_write_and_wait_range(inode->i_mapping, offset + len,
+					   LLONG_MAX);
+	if (ret)
+		goto out_mmap;
 	truncate_pagecache(inode, ioffset);
 
 	credits = ext4_writepage_trans_blocks(inode);
@@ -5626,21 +5633,7 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 			return ret;
 	}
 
-	/*
-	 * Need to round down to align start offset to page size boundary
-	 * for page size > block size.
-	 */
-	ioffset = round_down(offset, PAGE_SIZE);
-
-	/* Write out all dirty pages */
-	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
-			LLONG_MAX);
-	if (ret)
-		return ret;
-
-	/* Take mutex lock */
 	mutex_lock(&inode->i_mutex);
-
 	/* Currently just for extent based files */
 	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
 		ret = -EOPNOTSUPP;
@@ -5668,6 +5661,16 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 	 * page cache.
 	 */
 	down_write(&EXT4_I(inode)->i_mmap_sem);
+	/*
+	 * Need to round down to align start offset to page size boundary
+	 * for page size > block size.
+	 */
+	ioffset = round_down(offset, PAGE_SIZE);
+	/* Write out all dirty pages */
+	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
+			LLONG_MAX);
+	if (ret)
+		goto out_mmap;
 	truncate_pagecache(inode, ioffset);
 
 	credits = ext4_writepage_trans_blocks(inode);
-- 
2.1.4


--sdtB3X0nJg68CQEu--
