From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs update
Date: Wed, 2 Jan 2013 11:53:43 -0500
Message-ID: <20130102165343.GB17448@thunk.org>
References: <nsxpq1ol123.fsf@closure.thunk.org>
 <20130102152757.GA17448@thunk.org>
 <50E45832.3000206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41355 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab3ABQxq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jan 2013 11:53:46 -0500
Content-Disposition: inline
In-Reply-To: <50E45832.3000206@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 02, 2013 at 09:54:26AM -0600, Eric Sandeen wrote:
> 
> Apologies for not following more closely, but is this problem 
> a new regression, an old regression, or something that has never
> worked?

I'm not 100% sure, since we had done _some_ 64-bit off-line resize
testing back when we merged 64-bit support, but it's possible that
this was a problem that had been missed.

Part of the problem is we don't have any automated regression testing
for resize2fs, since creating test file systems is slow --- doing a
complete set of tests would probably take hours and hours, and would
require having a file system capable of 64-bit logical blocknumbers
(i.e., such as XFS) mounted, and/or require using device mapper with
thin provisioning.

The much more serious problems were resizing ext4 file systems
(specifically, file systems with the flex_bg feature enabled) when we
had run out of reserved gdt blocks in the resize inode, or if there
was no resize inode at all.  There was a safety check protecting users
who fell in the latter category, but if you deliberately created a
file system with a smaller resize inode, and then tried to resize to a
file system size larger than the resize inode, the result was inode
table corruption, as George Spelvin discovered.  This specific
resize2fs problem was not unique to 64-bit file systems, but was much
more likely to trigger with large 64-bit file systems.

I'm pretty sure we have two separate problems going on at this point.
One is that in some cases, the free blocks count is corrupted after a
64-bit resize.  That one seems pretty easy to find and fix; we're
probably overflowing a 32-bit blk_t somewhere that needs to be a
blk64_t.  The other one is a mysterious problem where apparently the
blocks associated with the journal inode gets marked as cleared after
an off-line resize.  This is the one which is scarier, but thinking
about it, we can probably find this using some debugging code in the
block bitmap functions to trigger a breakpoint when those blocks get
cleared, so we can figure out what is happening at that point.

After we fix these two problem, the sort of testing we should do to
make sure off-line resizing is sane would be to fill a file system
with some test data, checksum all of the data files, run resize2fs,
and then run e2fsck on the resulting file system, recheck the
checksums of the data files to make sure nothing got crunched.

	     	      	       	    	 	 - Ted
