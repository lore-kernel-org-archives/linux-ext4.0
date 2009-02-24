From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: New inode/block allocation algorithms for
	flex_bg filesystems
Date: Tue, 24 Feb 2009 14:04:29 -0500
Message-ID: <20090224190429.GF5482@mit.edu>
References: <20090218154310.GH3600@mini-me.lan> <20090224085931.GA25657@skywalker> <20090224152734.GD5482@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39672 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbZBXTEj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 14:04:39 -0500
Content-Disposition: inline
In-Reply-To: <20090224152734.GD5482@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 24, 2009 at 10:27:34AM -0500, Theodore Tso wrote:
> > > +	/*
> > > +	 * If we are doing flex_bg style allocation, try to put
> > > +	 * special inodes in the first block group; start files and
> > > +	 * directories at the 2nd block group in the flex_bg.
> > > +	 */
> > 
> > Why ? Can you explain whether this placing helps any specific work load
> > ? or something where you have observed that this placement helps ?  
> 
> This was left over from when I was using the inode number to influence
> block allocation.  We're not doing this any more, so this should go
> away.   Thanks for asking the question.

Hm, I just tried taking it out, and it costs a 17% increase in e2fsck
time on my test filesystem.  The reason is pass 2, we need to check to
make sure the filetype information in the directory blocks is correct.
If the inode in question is a regular file or a directory, we can
determine that by looking at an inode bitmap.  However, if it is a
named pipe, device file, or symlink, we can only determine what it is
by reading the inode.  In the filesystem in question, which is an
Ubuntu Intrepid image, there are 5 charater device files, 1 block
device file, 5 named pipes --- and 20,613 symbolic links.  If we group
all of these inodes togehter, it saves about 3 seconds in pass 2 (13
seconds versus 17 seconds).

We can also solve this problem by caching the file type information.
For example, I could store a list of all symlink inodes, and if there
are only 20k symlinks, it will end up costing us 80k of memory.  So
this might be a problem which is better solved with some e2fsck
hacking (which has the advantage that it will speed up ext3 fsck runs
as well).

						- Ted
