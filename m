From: Andreas Dilger <adilger@clusterfs.com>
Subject: [RFC] improving ext4 stat/unlink performance
Date: Fri, 9 Mar 2007 17:11:09 -0700
Message-ID: <20070310001109.GF5823@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: colyli@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:38501 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767679AbXCJALL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Mar 2007 19:11:11 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In recent discussions on #linuxfs with Coly Li (I hope I have the email
correct), we have ressurected the idea of improving the stat and unlink
performance of ext3 htree directories.  Coly seems interested in working
on fixing this problem, so I thought I'd start an email thread in the
list to get wider input, and also keep a record of the discussions.


This problem was exposed widely in an old thread started by Andrew Morton:
http://marc.theaimsgroup.com/?l=linux-ext4&m=105711174128574&w=4
and can be summarized as "htree directories have random readdir
order compared to inode number" (and vice versa).

And my email in that thread explains the solution relatively cleanly:
http://marc.theaimsgroup.com/?l=linux-ext4&m=105713438820870&w=4
and can be summarized as "allocate new inodes in a manner that takes
the name hash into account".


Apparently, this has become a hot topic for the kernel.org systems
because Git is fond of creating huge directories.


It should be possible to make a patch that improves the performance
of readdir+stat or readdir+unlink (for directories created under this
scheme) but does not affect the on-disk format.

Ted has also proposed the LD_PRELOAD library for doing sorting of the
readdir output in userspace before returning it to the application.
This can be helpful, but until this approach is widely available (e.g.
built into glibc or something) it will have limited benefit to users.
This is complementary with any approach taken here.



The basic goal, as discussed in my above email is to map the filename
to a goal inode number in (growing) range of inodes/blocks in the itable.
The resulting inode order is piece-wise in approximately hash order.  The
goal selection part is relatively straight forward, especially for new
directories, where we could keep a count of the number of inodes in
a directory and scale the itable window size as a function of the number
of inodes.  We would likely reserve the itable blocks for a given directory
in the same manner (and possibly even the same code) that ext3 reservation
works today.

For existing directories, the number of inodes in the directory (and hence
the itable window size) can also be approximated by the current size of
the directory divided by an average filename length.  Whether the directory
is full or not is less important, if we assume that past usage of the
directory is an indication of future usage.  It is in fact better to know
the directory size in advance because we get fewer "pieces" in the hash to
itable mapping.


What remains open for discussion (hopefully someone will have a good answer)
with existing directories is how to find the previous itable allocation
window(s) across a remount.  For directories with more than tens of
thousands of inodes in them the inodes by necessity must span multiple
block groups, and there is no guarantee that the itable ranges are
contiguous (no point in reserving a range of itable blocks that are full).

One possibility is to scan the directory leaf block that will ultimately
hold the new inode and try to allocate in the same itable block(s) that
the other entries in this leaf are using (preferring the block that is
used closest hashes in that leaf).  Drawbacks of this are that renamed
entries will have non-local inode numbers (which is a drawback of the
whole scheme, actually) and we don't store hashes with each entry.

We could also persistently store a "hint" for the itable allocation window
in the directory somewhere (e.g. the htree header by increasing the 
info_length).



Another possibility, first suggested by Ted in the same thread above,
and something I've been thinking about since the meeting in Portland
last year, is to change the directory format so that the directory leaf
blocks are actually the inode table itself.  It is complex enough that
it should go into a separate email, and is only worth considering if
we are going to have another incompatible change to the on-disk format
(though we could bundle a number of inode- and directory- specific
changes together).


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
