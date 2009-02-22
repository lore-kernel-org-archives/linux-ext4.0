From: Theodore Tso <tytso@mit.edu>
Subject: Re: kernel BUG at fs/ext4/extents.c:2738!
Date: Sat, 21 Feb 2009 23:31:26 -0500
Message-ID: <20090222043126.GE17066@mit.edu>
References: <1235115642.22702.2.camel@localhost.localdomain> <499ECF5C.7020509@redhat.com> <1235155713.22702.25.camel@localhost.localdomain> <20090220193013.GA28530@mini-me.lan> <1235276519.7599.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41386 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbZBVEbb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Feb 2009 23:31:31 -0500
Content-Disposition: inline
In-Reply-To: <1235276519.7599.7.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 22, 2009 at 05:21:59PM +1300, Andreas Friedrich Berendsen wrote:
> Tso,
> 
> I used fsck many times but an error as identified at a certain block and
> fsck was aborting with a Segment fault error. I had to fix all the
> errors manually (not using -p or -y), skipping this specific problem.

What version of e2fsck were you using, and what was the failure?
*Please* don't ignore stuff like this.  Report it, and mention it when
you report kernel problems.  It really helps get to the bottom of
things.

I'm going to guess you were using something older than e2fsprogs
1.41.4, and you were running into the bug which was fixed in this
e2fsprogs commit.

commit 7518c176867099eb529502103106501861a71280
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Dec 25 22:42:38 2008 -0500

    e2fsck: Fix an unhandled corruption case in scan_extent_node()
    
    A corrupted interior node in an extent tree would cause e2fsck to
    crash with the error message:
    
    Error1: Corrupt extent header on inode 107192
    Aborted (core dumped)
    
    Handle this and related failures when scanning an inode's extent tree
    more robustly.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


A corrupted extent could very easily have explained the symptoms you
reported.  (No, the kernel still shouldn't have flagged a BUG(), but
the fact of the matter is the filesystme was corrupted.)

> Anyway, the problem seems to be under control but I'm not sure. The new
> kernel (2.6.28.7) has a long list of ext4 errors corrected and I'm
> compiling it right now. Let's see what happens next :)

I'd recommend making sure you're running the latest version of
e2fsprogs and use e2fsck to make sure the filesystem is fully
consistent.

If e2fsck ever core dumps, please report it as a bug.  The e2fsck man
page has a section, REPORTING BUGS, that goes into details about how
to send a useful bug report about an e2fsck failure.

   	  	     	    	  - Ted
