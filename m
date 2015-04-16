From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fsck repair takes very long for 1,761 inodes containing
 multiply-claimed blocks on ext4
Date: Thu, 16 Apr 2015 11:00:46 -0400
Message-ID: <20150416150045.GB7445@thunk.org>
References: <CAD-ux60opdAx0+t3EmwR1GWT6t3rZv7CXhxNNbwQLKX6jz_z7Q@mail.gmail.com>
 <20150415190614.GA11592@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akos Csete <akos.csete@gmail.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42687 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbbDPPAs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Apr 2015 11:00:48 -0400
Content-Disposition: inline
In-Reply-To: <20150415190614.GA11592@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 15, 2015 at 12:06:14PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 15, 2015 at 11:18:18AM -0400, Akos Csete wrote:
> > I ran into a very long execution time, approaching 48 hours, with
> > e2fsck 1.42.9 when running e2fsck -fyv on a 7.8TB volume after
> > fsck.ext4 -nf found 1761 inodes containing multiply-claimed blocks.
> > I've been tailing the e2fsck output combined with a timestamp and
> > found progress is extremely slow.
> > Is this slow processing expected? I checked Ted's response to a 2009
> > posting for ext3 with a similar issue where he recommended selectively
> > wiping inodes with debugfs clri then restoring files as needed. Are
> > there any other options for ext4, perhaps other/faster repair
> > alternatives?
> 
> Unfortunately, the multiple-blocks cleaner runs one block at a time and is
> quite slow.  1.42.12 might improve things somewhat since I cleaned out some of
> the stranger things it would do, but it's still not fast.
> 
> (Some day in the future maybe we'll support reflink in which case this whole
> part of fsck can go away.)

Actually, reflink won't make the problem go away.  What probably
*will* make this problem much less of an issue is when the metadata
checksum code is fully supported with the relesae of e2fsprogs 1.43,
since the most common cause of the problem is when the storage device
screws up and stores blocks to the wrong location on disk.

One way of recovering from this is to take the output to date in the
pass 1b/c/d output, and to examine the inodes which are multiply
claimed. Either the inodes will look like total garbage, or more
likely, there will be a contiguous sequence of 16 or 32 inodes which
look identical to a contiguous sequence of 16 or 32 inodes somewhere
else.  So the trick is to use debugfs and figure out which contiguous
set of inodes appear to be correct, by correlating the file names of
those inodes (assuming the directory can be found) with the inode
contents and/or types and/or user/gorupownership.  Once you figure out
which set of 16 or 32 inodes are the bad copy, delete them using
debugfs's clri command.

The pass1b/c/d algorithsm are O(n**2), and since a chunk of inodes can
be resolved/eliminated at a time, after you clear up a chunk of the
inodes, you can rerun e2fsck, and hopefully the next run will take
less time.  If it still stalls out, you can take the output of e2fsck
and use it to clear out more inode numbers.

						- Ted
