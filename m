From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [RFC] A better solution to the HTree telldir problem
Date: Mon, 21 Jul 2008 22:57:38 -0700
Message-ID: <200807212257.38160.phillips@phunq.net>
References: <200807211411.52007.phillips@phunq.net> <20080722025638.GK28839@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, ext2-devel@lists.sourceforge.net
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from phunq.net ([64.81.85.152]:45212 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750781AbYGVF5q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2008 01:57:46 -0400
In-Reply-To: <20080722025638.GK28839@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 21 July 2008 19:56, Theodore Tso wrote:
> Even worse, since if NFS is enabled in any way, shape or form, this
> scheme is totally and completely screwed.  So we have to the old way
> of doing things if NFS is turned on.

I didn't realize it would be so difficult to detect telldir coming from
NFSD.  NFS is the entire reason for all this posturing, so if the
strategy fails for NFS then it isn't worth spending any time on it.

I wrote generic btree code for ddsnap with arbitrary depth and merge on
delete, but was never able to justify the time to port it to HTree
during my day job.  Props to clusterfs (Andreas!) for stepping up to
do this.  No doubt a commercial imperative helped achieve focus there.

But I will not use HTree for my own filesystem work, I will use a new
thing called PHTree, which is a (P)hysically stable variant of HTree,
obtained by inserting a new layer of index blocks between the index
nodes and the dirent blocks, the "terminal" index blocks.  Each
terminal index block is populated with { hash : block } pairs, each of
which indicates that there is a dirent in <block> with hash <hash>.

This requires one extra lookup per operation which is regretable, but
it solves the physical stability problem.  Directory entries will just
stay in the leaf blocks in which they are first created, and only
index nodes will ever be split.  Because leaf blocks will typically be
full instead of 75% full in HTree, the space usage ends up about the
same.  A more efficient hash algorithm can be used, and deletion and
other operations will tend to be faster due to less thrashing of the
inode table.

Free space management becomes an issue: when dirents are deleted we
need to be able to re-use them for new entries.  To support efficient
detection of available dirents of appropriate size, I will use a lazy
method of recording the maximum sized dirent available in any leaf
block.  The actual largest free direct may be smaller than that, which
will be detected when a search fails, causing the lazy limit to be
updated.  We can safely skip searching for free space in any block
for which the lazy max is less than the size we require.  One byte is
sufficient for the lazy max, so one 4K block is sufficient to keep
track of 2^12 * 2^12 bytes worth of directory blocks, a 16 meg
directory with about half a million entries.  For larger directories
this structure becomes a radix tree, with lazy max recorded also at
each index pointer for quick free space searching.

Mind you, I haven't coded this yet and it will be a good few months
before I do, so I don't have performance numbers.  I just thought I
should mention it now, because I expect it to meet or beat HTree
overall in performance while supporting brain damaged NFS semantics in
a much nicer way.  Hopefully we will find out for sure before Ext4
indexing becomes cast in stone.

Regards,

Daniel
