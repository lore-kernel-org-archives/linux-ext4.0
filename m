From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: (resend) extent header problems following shrink with resize2fs
Date: Thu, 25 Dec 2008 23:14:11 -0500
Message-ID: <20081226041411.GM9871@mit.edu>
References: <87abanbfvo.fsf@burly.wgtn.ondioline.org> <20081223061833.GQ23723@mit.edu> <877i5ozprb.fsf@burly.wgtn.ondioline.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Paul Collins <paul@burly.ondioline.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53692 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbYLZEOP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Dec 2008 23:14:15 -0500
Content-Disposition: inline
In-Reply-To: <877i5ozprb.fsf@burly.wgtn.ondioline.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 25, 2008 at 08:18:48PM +1300, Paul Collins wrote:
> Theodore Tso <tytso@MIT.EDU> writes:
> > Yeah, resize2fs needs to be fixed to handle extents correctly.  At the
> > moment it can screw them up pretty badly.
> 
> In the meantime, perhaps something like the patch below is appropriate?

Actually, I think the following patch should fix things up nicely.  I
need to create a test case so I can be sure this fixes the problem,
but I think this should address the root cause of theproblem you
reported.

						- Ted

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index abe05f5..65398a6 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1188,6 +1188,16 @@ static int process_block(ext2_filsys fs, blk_t	*block_nr,
 	return ret;
 }
 
+static int process_block_ind(ext2_filsys fs, blk_t *block_nr,
+			     e2_blkcnt_t blockcnt, blk_t ref_block, 
+			     int ref_offset, void *priv_data)
+{
+	if (blockcnt >= 0)
+		return 0;
+	return process_block(fs, block_nr, blockcnt, ref_block, ref_offset,
+			     priv_data);
+}
+
 /*
  * Progress callback
  */
@@ -1302,6 +1312,18 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 		if (ext2fs_inode_has_valid_blocks(inode) &&
 		    (rfs->bmap || pb.is_dir)) {
 			pb.ino = ino;
+			if (inode->i_flags & EXT4_EXTENTS_FL) {
+				/*
+				 * With extent-based files, we have
+				 * to translate all of the interior
+				 * node blocks first.
+				 */
+				retval = ext2fs_block_iterate2(rfs->old_fs,
+						ino, 0, block_buf,
+						process_block_ind, &pb);
+				if (retval)
+					goto errout;
+			}
 			retval = ext2fs_block_iterate2(rfs->old_fs,
 						       ino, 0, block_buf,
 						       process_block, &pb);
