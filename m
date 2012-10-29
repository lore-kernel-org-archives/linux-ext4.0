From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v3] ext4: fix unjournaled inode bitmap modification
Date: Sun, 28 Oct 2012 22:30:34 -0400
Message-ID: <20121029023034.GA9365@thunk.org>
References: <87objupjlr.fsf@spindle.srvr.nix>
 <20121023013343.GB6370@fieldses.org>
 <87mwzdnuww.fsf@spindle.srvr.nix>
 <20121023143019.GA3040@fieldses.org>
 <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <508CB35D.9080102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nix <nix@esperi.org.uk>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58195 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261Ab2J2Can (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Oct 2012 22:30:43 -0400
Content-Disposition: inline
In-Reply-To: <508CB35D.9080102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 27, 2012 at 11:23:57PM -0500, Eric Sandeen wrote:
> A little more going on here to try to properly handle error
> cases & moving to the next group; despite
> ext4_handle_release_buffer being a no-op, I've tried
> to sprinkle it in at the right places.  Double checking
> on review is probably a fine idea ;)

Sorry, I didn't see your newer version of your patch.  I'm not
convinced it's worth it to try to get the calls to
ext4_handle_release_buffer() right.  There are plenty of other places
where we're not calling ext4_handle_release_buffer(), and I'm not
convinced it would ever be useful to make it be something other than a
no-op.  In order to make it be useful, we'd have to enforce a rule
that every single get_write_access() was matched with either a
handle_dirty_metadata() or a handle_release_buffer().  That would be
tricky; worse, we'd have to keep track of a refcount on each bh, which
would cost us on the scalability front.  The main benefit would be
that might be able to be able to reclaim bh's where we called
get_write_access() and then changed our mind, but that's relatively
rare, and I think it's easier to simply be more careful about calling
get_write_acceess() until we're sure we're going to need write access.

Hence in my version of the patch, I've waited until right before the
call to ext4_lock_group() before calling get_write_access().  Note
that it's safe to call get_write_access() on a bh twice; the second
time the jbd2 layer will notice that the bh is already a part of the
transaction.

Also, leaving out the calls to ext4_handle_release_buffer() makes the
patch easier to understand and reason about.

What do you think of this version?

						- Ted

commit 67d725143e9e7ea458a0c1c4a6625657c3dc7ba2
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sun Oct 28 22:24:57 2012 -0400

    ext4: fix unjournaled inode bitmap modification
    
    commit 119c0d4460b001e44b41dcf73dc6ee794b98bd31 changed
    ext4_new_inode() such that the inode bitmap was being modified
    outside a transaction, which could lead to corruption, and was
    discovered when journal_checksum found a bad checksum in the
    journal during log replay.
    
    Nix ran into this when using the journal_async_commit mount
    option, which enables journal checksumming.  The ensuing
    journal replay failures due to the bad checksums led to
    filesystem corruption reported as the now infamous
    "Apparent serious progressive ext4 data corruption bug"
    
    [ Changed by tytso to only call ext4_journal_get_write_access() only
      when we're fairly certain that we're going to allocate the inode. ]
    
    I've tested this by mounting with journal_checksum and
    running fsstress then dropping power; I've also tested by
    hacking DM to create snapshots w/o first quiescing, which
    allows me to test journal replay repeatedly w/o actually
    power-cycling the box.  Without the patch I hit a journal
    checksum error every time.  With this fix it survives
    many iterations.
    
    Reported-by: Nix <nix@esperi.org.uk>
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@vger.kernel.org

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 4facdd2..3a100e7 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -725,6 +725,10 @@ repeat_in_this_group:
 				   "inode=%lu", ino + 1);
 			continue;
 		}
+		BUFFER_TRACE(inode_bitmap_bh, "get_write_access");
+		err = ext4_journal_get_write_access(handle, inode_bitmap_bh);
+		if (err)
+			goto fail;
 		ext4_lock_group(sb, group);
 		ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
 		ext4_unlock_group(sb, group);
@@ -738,6 +742,11 @@ repeat_in_this_group:
 	goto out;
 
 got:
+	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);
+	if (err)
+		goto fail;
+
 	/* We may have to initialize the block bitmap if it isn't already */
 	if (ext4_has_group_desc_csum(sb) &&
 	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
@@ -771,11 +780,6 @@ got:
 			goto fail;
 	}
 
-	BUFFER_TRACE(inode_bitmap_bh, "get_write_access");
-	err = ext4_journal_get_write_access(handle, inode_bitmap_bh);
-	if (err)
-		goto fail;
-
 	BUFFER_TRACE(group_desc_bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, group_desc_bh);
 	if (err)
@@ -823,11 +827,6 @@ got:
 	}
 	ext4_unlock_group(sb, group);
 
-	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);
-	if (err)
-		goto fail;
