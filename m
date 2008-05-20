From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Scripting e2fsck: no errors, but still exit code 1 "FILE
	SYSTEM WAS MODIFIED"
Date: Tue, 20 May 2008 08:09:53 -0400
Message-ID: <20080520120953.GO15035@mit.edu>
References: <483006F1.6080008@tuxes.nl> <20080518122853.GB31413@mit.edu> <483056DC.4060108@tuxes.nl> <48316565.1040501@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61566 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760600AbYETMK4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2008 08:10:56 -0400
Content-Disposition: inline
In-Reply-To: <48316565.1040501@tuxes.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 19, 2008 at 01:32:53PM +0200, Bas van Schaik wrote:
> 
> Does this tell you anything?
> 

Unfortunately comparing the two dumpe2fs outputs don't show anything
interesting.  It did rule out a few cases where e2fsck can silently
mark the filesystem has having been modified (setting the directory
hash hint, moving the journal inode, which it does silently without
informing the user --- and I should fix that one of these days; I'll
create some bug reports to remind myself they need to be fixed), but I
don't see why it happened for your case.

It's definitely not normal; doing a journal replay does not cause fsck
to exit with a non-zero status, if it didn't make any other changes.
I just tested that with e2fsprogs 1.40.8 just in case something had
gotten screwed up, and it worked as expected.

I know how to debug it if you are really motiviated to get to the
bottom of this.  It would involve running a modified e2fsck/e2fsprogs
which changes ext2fs_mark_changed() and ext2fs_mark_super_dirty() to
be real functions, and setting breakpoints in gdb so we can trap any
calls made to those functions and dump out a stack backtrace, and then
continuing the e2fsck run, and then reporting to me the stack
backtraces where gdb trapped calls to ext2fs_mark_changed() and/or
ext2fs_mark_super_dirty().

Andreas is right though that if you are taking a proper snapshot, the
disk really should be quiesced and no journal replay should be
required at all.  That's how a devicemapper snapshot works in LVM ---
so one good question to explore is how *are* you doing your snapshots.

       	    	     		   - Ted
