From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4: Can we talk about bforget() and metadata blocks
Date: Thu, 10 Sep 2009 14:58:26 -0400
Message-ID: <20090910185826.GC23700@mit.edu>
References: <6601abe90909091029s74465ebave932987e5fdf93ba@mail.gmail.com> <20090909225429.GB24951@mit.edu> <6601abe90909091707s1df9e71bvb4551772dc4917cb@mail.gmail.com> <20090910013540.GF24951@mit.edu> <20090910065401.GB8690@skywalker.linux.vnet.ibm.com> <6601abe90909100846x3f7f491cnabc1474056155767@mail.gmail.com> <20090910162435.GA5321@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45290 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbZIJS6b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 14:58:31 -0400
Content-Disposition: inline
In-Reply-To: <20090910162435.GA5321@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 09:54:35PM +0530, Aneesh Kumar K.V wrote:
> 
> But how would it work for fsync ? I mean 
> 
> I would expect for no journal mode ext4_sync_file  should be doing
> simple_fsync(). That should be forcing the metadata buffer_heads
> via sync_mapping_buffers. And if we reuse these meta buffers we
> drop them the inode->mapping->private_list using bforget.
> 
> But I don't see any of the above in code

Aneesh, you're addressing a different problem than the one that Curt
were trying to deal with this patch.  The problem we are worry about
is one where an inode's extent tree or indirect blocks are modified
right before the inode is deleted, and then one or more of those
metadata blocks get reallocated and written right away (most likely
this will happen via an O_DIRECT write), and then, because we didn't
use bforget(), the dirty metadata block in the buffer cache would get
written out, overwriting the O_DIRECT block.

What you're worrying about, is a different issue.  You're concerned
about the fact that since we are not associating an inode's extent
tree or indirect blocks with the inode, those blocks won't get forced
out to disk on an fsync() in ext4 no-journal mode.  This may not be a
big deal for applications which expect to recover from an unclean
using mke2fs (and thus probably don't use fsync in any case), but
here's a patch to deal with the problem you've raised.

       	       	       	    		       - Ted

commit 417cf58253fbf3e36df7b3aca11c120e8367f5e6
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Sep 10 14:58:02 2009 -0400

    ext4: Assure that metadata blocks are written during fsync in no journal mode
    
    When there is no journal present, we must attach buffer heads
    associated with extent tree and indirect blocks to the inode's
    mapping->private_list so that fsync() will write out the inode's
    metadata blocks.  This is done via mark_buffer_dirty_inode().
    
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

