From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: fix unjournaled inode bitmap modification
Date: Sat, 27 Oct 2012 23:23:57 -0500
Message-ID: <508CB35D.9080102@redhat.com>
References: <87objupjlr.fsf@spindle.srvr.nix> <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
To: Nix <nix@esperi.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab2J1EYJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Oct 2012 00:24:09 -0400
In-Reply-To: <87pq48nbyz.fsf_-_@spindle.srvr.nix>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

I've tested this by mounting with journal_checksum and
running fsstress then dropping power; I've also tested by
hacking DM to create snapshots w/o first quiescing, which
allows me to test journal replay repeatedly w/o actually
power-cycling the box.  Without the patch I hit a journal
checksum error every time.  With this fix it survives
many iterations.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
cc: Nix <nix@esperi.org.uk>
---

A little more going on here to try to properly handle error
cases & moving to the next group; despite
ext4_handle_release_buffer being a no-op, I've tried
to sprinkle it in at the right places.  Double checking
on review is probably a fine idea ;)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 4facdd2..1d18fba 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -706,10 +706,17 @@ got_group:
 			continue;
 		}
 
-		brelse(inode_bitmap_bh);
+		if (inode_bitmap_bh) {
+			ext4_handle_release_buffer(handle, inode_bitmap_bh);
+			brelse(inode_bitmap_bh);
+		}
 		inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
 		if (!inode_bitmap_bh)
 			goto fail;
+		BUFFER_TRACE(inode_bitmap_bh, "get_write_access");
+		err = ext4_journal_get_write_access(handle, inode_bitmap_bh);
+		if (err)
+			goto fail;
 
 repeat_in_this_group:
 		ino = ext4_find_next_zero_bit((unsigned long *)
@@ -734,10 +741,16 @@ repeat_in_this_group:
 		if (ino < EXT4_INODES_PER_GROUP(sb))
 			goto repeat_in_this_group;
 	}
+	ext4_handle_release_buffer(handle, inode_bitmap_bh);
 	err = -ENOSPC;
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
@@ -771,11 +784,6 @@ got:
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
@@ -823,11 +831,6 @@ got:
 	}
 	ext4_unlock_group(sb, group);
 
-	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);
-	if (err)
-		goto fail;
