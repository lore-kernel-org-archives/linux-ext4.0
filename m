From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4: Can we talk about bforget() and metadata blocks
Date: Sat, 12 Sep 2009 13:59:26 -0400
Message-ID: <20090912175926.GC20611@mit.edu>
References: <6601abe90909091029s74465ebave932987e5fdf93ba@mail.gmail.com> <20090909225429.GB24951@mit.edu> <6601abe90909091707s1df9e71bvb4551772dc4917cb@mail.gmail.com> <20090910013540.GF24951@mit.edu> <20090910065401.GB8690@skywalker.linux.vnet.ibm.com> <6601abe90909100846x3f7f491cnabc1474056155767@mail.gmail.com> <20090910162435.GA5321@skywalker.linux.vnet.ibm.com> <20090910185826.GC23700@mit.edu> <20090912150036.GA13906@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46353 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbZILR73 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Sep 2009 13:59:29 -0400
Content-Disposition: inline
In-Reply-To: <20090912150036.GA13906@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 12, 2009 at 08:30:36PM +0530, Aneesh Kumar K.V wrote:
> 
> This does add the meta data buffer_head to the
> inode->mapping->private_list.  But ext4_sync_file is not writing
> them. I guess we need to call sync_mapping_buffers for no-journal
> mode in ext4_sync_file.

Good point, thanks for catching this.  Here's a revised patch which
adds the call to ext4_sync_file().

						- Ted

commit 6c6e80dc88568f4e49004967f8fd56b69c86e715
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Sep 12 13:41:55 2009 -0400

    ext4: Assure that metadata blocks are written during fsync in no journal mode
    
    When there is no journal present, we must attach buffer heads
    associated with extent tree and indirect blocks to the inode's
    mapping->private_list via mark_buffer_dirty_inode() so that
    ext4_sync_file() --- which is called to service fsync() and
    fdatasync() system calls --- can write out the inode's metadata blocks
    by calling sync_mapping_buffers().
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index ecb9ca4..6a94099 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -89,7 +89,10 @@ int __ext4_handle_dirty_metadata(const char *where, handle_t *handle,
 			ext4_journal_abort_handle(where, __func__, bh,
 						  handle, err);
 	} else {
-		mark_buffer_dirty(bh);
+		if (inode && bh)
+			mark_buffer_dirty_inode(bh, inode);
+		else
+			mark_buffer_dirty(bh);
 		if (inode && inode_needs_sync(inode)) {
 			sync_dirty_buffer(bh);
 			if (buffer_req(bh) && !buffer_uptodate(bh)) {
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index ab418c0..0747574 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -50,7 +50,7 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	int ret = 0;
+	int err, ret = 0;
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
@@ -79,6 +79,9 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		goto out;
 	}
 
+	if (!journal)
+		ret = sync_mapping_buffers(inode->i_mapping);
+
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
 		goto out;
 
@@ -91,7 +94,9 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 			.sync_mode = WB_SYNC_ALL,
 			.nr_to_write = 0, /* sys_fsync did this */
 		};
-		ret = sync_inode(inode, &wbc);
+		err = sync_inode(inode, &wbc);
+		if (ret == 0)
+			ret = err;
 	}
 out:
 	if (journal && (journal->j_flags & JBD2_BARRIER))
