From: Theodore Ts'o <tytso@mit.edu>
Subject: More thoughts about xattrs, journal credits, and their location
Date: Sat, 8 Jul 2017 11:30:48 -0400
Message-ID: <20170708153048.3lrrcd43ptx5yuy3@thunk.org>
References: <20170706023819.32272-1-tahsin@google.com>
 <20170706023819.32272-2-tahsin@google.com>
 <20170708050900.afuwwia7c4izliir@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Tahsin Erdogan <tahsin@google.com>,
        Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59346 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752794AbdGHPav (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 8 Jul 2017 11:30:51 -0400
Content-Disposition: inline
In-Reply-To: <20170708050900.afuwwia7c4izliir@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 08, 2017 at 01:09:00AM -0400, Theodore Ts'o wrote:
> I've applied the following change to this patch in order to better
> calculate the credits needed by ext4_new_inode....

So I've been thinking about this some more, and why we can't use
extend_transaction because it might break up what needs to be single
transaction for ext4_new_inode().  And I think I may have come up with
an interesting solution.  It adds extra complexity, so it may not be
worth it, but I'll throw it out for general consideration.

What we could do is have ext4_new_inode check to see if there are
enough credits to do add the xattr's (if necessary) in a single
commit.  If not, what we could do is to add the inode to the orphan
list, and then set an inode state flag indicating we have done this.
At this point, we *can* break the ext4_new_inode() operation into
multiple commits, because if we crash in the middle the inode will be
cleaned up when we do the orphan list processing.

The downsides of this approach is that it causes the orphan list to be
a bottleneck.  So we would definitely not want to do this all time.
And the extra complexity of tracking whether the inode is on the
orphan list might not make it worth it.


The other thing that we might want to do is to establish a priority
weight system so we can indicate which xattrs should have preference
to be stored in the inode (no seeks to access), in the xattr block
(requires an extra seek to access), or an ea_inode (requires 2-3 seeks
to access).  In rough order

* Security xattrs -- they are smallest, are needed the most often (you
  might need them even to see if you are allowed to stat the inode).
* Encryption xattr, Acl and Rich Acl's --- needed whenever you
  access the inode.
* In-line data
* Everything else

Within each priority tier, the smaller xattrs should get preferential
treatment since the are more likely to leave space for other xattrs in
the storage area.

One of the other things we could do is to implement a further
optimization where once we decide that an xattr in an xattr block
should have its value moved to an ea_inode, , if there is space to
move the xattr from the xattr block to the extra space in the inode.
This could be done in a separate transaction, or even via a workqueue,
since it's an optimization of the on-disk encoding of the inode'x
xattr.  It's not clear the complexity is worth it (maybe it's
something we do in e2fsck first, the way we can optimize directories,
and from there we can decide if it's worth implementing in the
kernel).

					- Ted
