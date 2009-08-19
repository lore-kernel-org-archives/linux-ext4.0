From: Theodore Tso <tytso@mit.edu>
Subject: Re: Block allocation failed
Date: Wed, 19 Aug 2009 12:20:54 -0400
Message-ID: <20090819162054.GG17488@mit.edu>
References: <87iqgk8jal.fsf@newton.gmurray.org.uk> <20090819135006.GB17488@mit.edu> <87zl9vhnfa.fsf@newton.gmurray.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Graham Murray <graham@gmurray.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50051 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbZHSQU5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Aug 2009 12:20:57 -0400
Content-Disposition: inline
In-Reply-To: <87zl9vhnfa.fsf@newton.gmurray.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 19, 2009 at 03:46:01PM +0100, Graham Murray wrote:
> Sorry, but I do not remember all the errors, it was late at night. The
> first were some sort of block error with lots of block numbers in ()
> which I responded 'y' to fix. Then there were a number of files with
> multiply-claimed blocks which I responded 'y' to clone. There were files
> containing unallocated or deleted inodes. A number of files were
> recovered to Lost+Found. A number of inode reference counts were
> wrong. There may have been other errors, but I do not remember what they
> were. 

Hmm... if I had to guess, a portion of the inode table was written to
the wrong location on disk -- on top of another part of the inode
table.  That is the most common cause of a large number of multiply
cliamed blocks.  Was there more than half-dozen or so such inodes?
And were they numerically contiguous?

> >> Aug 18 23:50:07 newton EXT4-fs error (device sdb3): ext4_mb_generate_buddy: EXT4-fs: group 35: 3499 blocks in bitmap, 3243 in gd
> >> Aug 18 23:50:07 newton Aborting journal on device sdb3:8.
> >
> > Was this right after you mounted the filesystem, or did some time
> > take place before these errors started showing up?
> 
> It was about 90s after the message showing the filesystem mounted

Hmm, the most likely cause for that would be if the block group
descriptors had an incorrect number of free blocks.  But you had just
run e2fsck -f.

You might want to try running e2fsck -f twice, back to back, saving
the output of buth e2fsck runs.  If the second e2fsck finds problems,
then we either have an e2fsck bug, or there is some kind of hardware
problem.  Was this filesystme on some kind of RAID system by any chance?

	      	   	      	      	   - Ted
