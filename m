From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Null pointer dereference of s_chksum_driver  in ext4_chksum
Date: Sun, 3 May 2015 17:37:00 -0400
Message-ID: <20150503213700.GL10014@thunk.org>
References: <5543D8AB.4030606@codeaurora.org>
 <5546810E.7070607@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, darrick.wong@oracle.com
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42366 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbbECVhC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 May 2015 17:37:02 -0400
Content-Disposition: inline
In-Reply-To: <5546810E.7070607@codeaurora.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 03, 2015 at 01:11:58PM -0700, Nikhilesh Reddy wrote:
> Please find additional details below:
> 
> This occurred in while de-referencing the sbi->s_chksum_driver member of
> the superblock info.
> 
> This occurs during a bootup mount
> 
>  10.216919:   <6> EXT4-fs (mmcblk0p22): mounted filesystem with ordered
> data mode. Opts: barrier=1,discard
>     10.225032:   <6> SELinux: initialized (dev mmcblk0p22, type ext4),
> uses xattr
>     10.235901:   <6> EXT4-fs (mmcblk0p29): Ignoring removed
> nomblk_io_submit option
>     10.341141:   <6> Unable to handle kernel NULL pointer dereference
> at virtual address 00000000

I'd have to actually see the full file system to understand what is
going on, but what I suspect is happening is that the file system has
been corrupted in at least two different ways.  The first is that
there the journal inode is corrupted; this is what's causing the call
to ext4_error_inode() from a call to jbd2_journal_bmap().

The *second* thing which is going on is that before we noticed the
corrupted journal inode, the journal contained a copy of the
superblock which we replayed that _set_ the metadata checksum feature
flag.  Since it wasn't set originally when file system was initially
mounted, s_chksum_driver wasn't initialized, and this cuases the NULL
pointer deference.

Avoiding the kernel crash was fixed by accident in 3.18 with the
following commit: 9aa5d32ba269 ("Replace open coded mdata csum feature
to helper function"), since instead of actually checking to see if the
metadata checksum field is set, it uses as its primary mechanism
checking to see if s_chksum_driver is non-NULL.  There is a
WARN_ON_ONCE that will trip in the situation where the feature flag is
set and s_chksum_driver is NULL, but that really is a "should never
happen" situation.  The only scenario I can think of where this might
have happened is the one I described above, where it was enabled by a
journal replay.

This should be sufficient to avoid the crash, but I haven't had the
chance to try creating a file system corrupted the way I conjecture it
was corrupted, and see whether it we correctly fail the mount (which
is clearly what should happen if we discover a corrupted journal inode
while replaying the journal during the mount.)

      		    	    	       - Ted
