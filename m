From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] BIG_BG vs extended META_BG in ext4
Date: Tue, 3 Jul 2007 11:55:57 -0600
Message-ID: <20070703175557.GA6578@schatzie.adilger.int>
References: <20070629170958.13b7700c@gara> <D5D3223C-4EB0-413B-A81A-05F6DDC0FEEB@bull.net> <20070630234011.38b4bb22@gara> <20070701163153.GB5419@schatzie.adilger.int> <20070702093903.77e0f947@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laurent Vivier <Laurent.Vivier@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:50496 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbXGCR4A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2007 13:56:00 -0400
Content-Disposition: inline
In-Reply-To: <20070702093903.77e0f947@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 02, 2007  09:39 -0500, Jose R. Santos wrote:
> On Sun, 1 Jul 2007 12:31:53 -0400
> Andreas Dilger <adilger@clusterfs.com> wrote:
> > This turns out not to be true, and in fact we need to change the
> > unwritten extents patch a tiny bit.  The reason is that we have
> > limited the maximum extent size to 2^16-1 = 32767 blocks.  The
> > current maximum for the number of blocks in a group is 65528, so that
> > we can always fit the "free blocks" count into a __u16 if the bitmaps
> > and inode table are moved out of the group.  Moving the bitmaps and
> > itable will hit the max extent length.
> 
> I miss this while looking at the extent code.  I thought that the
> extents limit was caused by being unable to allocate enough contiguous
> blocks due to the small block groups.
> 
> Are there no plans to support very large extents?

At some point, there may be a desire to move to full 64-bit extents in
order to allow gigantic files (over 2^32 blocks = 16TB@4kb, 256TB@16kb),
but I don't think this will happen for a while yet).

> Aside from some possible alignment issues with the structure, what else
> would keep would keep ee_len from being larger?

There just isn't any free space in the extents structure for ee_len.

> > There are still other benefits to moving the metadata together.
> > 
> > Now, the one minor problem with the unwritten extent patches is that
> > by using the high bit of the ee_len this limits the extent length to
> > 2^15-1 blocks, but it would be MUCH better if this limit was 2^16
> > blocks and it fit evenly into an empty group, consecutive extents
> > were aligned, etc. It also doesn't make sense to have an
> > uninitialized 0-length extent, so I think the unwritten extent
> > (fallocate) patch needs to special case the ee_len = 65536 to be a
> > "regular" extent instead of "unwritten"

The extent-to-group alignment problem is definitely an issue once
we get past 2^15 blocks per group and/or move all the metadata out of
the group.  Otherwise, we will be stuck allocating 2^15-1 or 2^15-256
blocks per extent, and mballoc will not like this very much.

The change I'm asking for is fairly simple at this stage, but would be
much more complex later:

-#define EXT_MAX_LEN ((2^15) - 1)
+#define EXT_MAX_LEN (2^15)

 static inline void ext4_ext_mark_uninitialized(struct ext4_extent *ext)
 {
+	BUG_ON(le16_to_cpu(ext->ee_len) & ~0x8000 == 0);
 	ext->ee_len |= cpu_to_le16(0x8000);
 }

 static inline int ext4_ext_is_uninitialized(struct ext4_extent *ext)
 {
-	return (int)(le16_to_cpu(ext->ee_len) & 0x8000);
+	return (le16_to_cpu(ext->ee_len) > 0x8000);
 }

 static inline int ext4_ext_get_actual_len(struct ext4_extent *ext)
 {
-	return (int)(le16_to_cpu(ext->ee_len) & 0x7FFF);
+	return (le16_to_cpu(ext->ee_len) <= 0x8000 ? le16_to_cpu(ext->ee_len) :
+					  (le16_to_cpu(ext->ee_len) - 0x8000));
 }

Hmm, but now I'm not sure how to mark an uninitialized extent of length
2^15 blocks...  I suppose it would be possible to limit uninitialized
extents to 2^14 blocks (since uninitialized extents will be a much rarer
case than initialized extents), or teach mballoc/delalloc to allocate
even-sized extents like (2^15-s_raid_stripe) blocks or something.

> I was referring to the locality of block bit maps and the actual free
> blocks.  If we move the block bitmaps out of block group, wouldn't we 
> be promoting larger seeks on operations that heavily write to both the
> bitmaps and blocks?

I don't think this is necessarily true.  The block bitmaps are usually
read from disk only rarely and cached after that.  When they are written
they are written first to the journal and only later to disk, so there is
little coherency between the data writes and the bitmap writes.  I would
expect that putting the metadata together would _improve_ performance
because the journal checkpoint could avoid many seeks when flushing the
bitmap/itable to disk.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
