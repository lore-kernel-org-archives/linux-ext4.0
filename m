From: Greg KH <gregkh@suse.de>
Subject: [patch 74/87] ext4: add EXT4_IOC_ALLOC_DA_BLKS ioctl
Date: Tue, 09 Jun 2009 02:40:02 -0700
Message-ID: <20090609094109.747267724@blue.kroah.org>
References: <20090609093848.204935043@blue.kroah.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:55504 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760854AbZFIKVq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:46 -0400
Content-Disposition: inline; filename=ext4-add-ext4_ioc_alloc_da_blks-ioctl.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit ccd2506bd43113659aa904d5bea5d1300605e2a6)

Add an ioctl which forces all of the delay allocated blocks to be
allocated.  This also provides a function ext4_alloc_da_blocks() which
will be used by the following commits to force files to be fully
allocated to preserve application-expected ext3 behaviour.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4.h  |    3 +++
 fs/ext4/inode.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ioctl.c |   14 ++++++++++++++
 3 files changed, 59 insertions(+)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -326,7 +326,9 @@ struct ext4_new_group_data {
 #define EXT4_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8, struct ext4_new_group_input)
 #define EXT4_IOC_MIGRATE		_IO('f', 9)
+ /* note ioctl 10 reserved for an early version of the FIEMAP ioctl */
  /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
+#define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 
 /*
  * ioctl commands in 32 bit emulation
@@ -1115,6 +1117,7 @@ extern int ext4_can_truncate(struct inod
 extern void ext4_truncate(struct inode *);
 extern void ext4_set_inode_flags(struct inode *);
 extern void ext4_get_inode_flags(struct ext4_inode_info *);
+extern int ext4_alloc_da_blocks(struct inode *inode);
 extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_meta_trans_blocks(struct inode *, int nrblocks, int idxblocks);
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2816,6 +2816,48 @@ out:
 	return;
 }
 
+/*
+ * Force all delayed allocation blocks to be allocated for a given inode.
+ */
+int ext4_alloc_da_blocks(struct inode *inode)
+{
+	if (!EXT4_I(inode)->i_reserved_data_blocks &&
+	    !EXT4_I(inode)->i_reserved_meta_blocks)
+		return 0;
+
+	/*
+	 * We do something simple for now.  The filemap_flush() will
+	 * also start triggering a write of the data blocks, which is
+	 * not strictly speaking necessary (and for users of
+	 * laptop_mode, not even desirable).  However, to do otherwise
+	 * would require replicating code paths in:
+	 *
+	 * ext4_da_writepages() ->
+	 *    write_cache_pages() ---> (via passed in callback function)
+	 *        __mpage_da_writepage() -->
+	 *           mpage_add_bh_to_extent()
+	 *           mpage_da_map_blocks()
+	 *
+	 * The problem is that write_cache_pages(), located in
+	 * mm/page-writeback.c, marks pages clean in preparation for
+	 * doing I/O, which is not desirable if we're not planning on
+	 * doing I/O at all.
+	 *
+	 * We could call write_cache_pages(), and then redirty all of
+	 * the pages by calling redirty_page_for_writeback() but that
+	 * would be ugly in the extreme.  So instead we would need to
+	 * replicate parts of the code in the above functions,
+	 * simplifying them becuase we wouldn't actually intend to
+	 * write out the pages, but rather only collect contiguous
+	 * logical block extents, call the multi-block allocator, and
+	 * then update the buffer heads with the block allocations.
+	 *
+	 * For now, though, we'll cheat by calling filemap_flush(),
+	 * which will map the blocks, and start the I/O, but not
+	 * actually wait for the I/O to complete.
+	 */
+	return filemap_flush(inode->i_mapping);
+}
 
 /*
  * bmap() is special.  It gets used by applications such as lilo and by
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -262,6 +262,20 @@ setversion_out:
 		return err;
 	}
 
+	case EXT4_IOC_ALLOC_DA_BLKS:
+	{
+		int err;
+		if (!is_owner_or_cap(inode))
+			return -EACCES;
+
+		err = mnt_want_write(filp->f_path.mnt);
+		if (err)
+			return err;
+		err = ext4_alloc_da_blocks(inode);
+		mnt_drop_write(filp->f_path.mnt);
+		return err;
+	}
+
 	default:
 		return -ENOTTY;
 	}


