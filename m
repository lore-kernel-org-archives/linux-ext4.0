From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Ininitial e2fsprogs TODO list (please expand)
Date: Mon, 21 Apr 2008 09:11:17 -0400
Message-ID: <20080421131117.GE9700@mit.edu>
References: <20080415115216.1f6868de@gara.konoha.net> <20080420234707.GB9700@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45431 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757977AbYDUNSS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 09:18:18 -0400
Content-Disposition: inline
In-Reply-To: <20080420234707.GB9700@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 20, 2008 at 07:47:07PM -0400, Theodore Tso wrote:
> Some of the items marked "DONE" are in my tree and haven't been pushed
> out yet, but I'll make sure that happens by Monday.  Note that I am
> taking the red eye from Sao Paulo tonight, and if all goes well, am
> scheduled to arrive in Boston at 10:15am Eastern.  If the flight gets
> delayed, there is a chance that I may end up being late or missing the
> ext4 call.

Unfortunately, we were delayed in Sao Paulo for over three hours;
something about a problem with one of the fuel pumps....  So I've been
rebooked onto another flight which means I'll be in the air at the
time of the ext4 call.

While I was stuck on the airplane, I spent some time doing more fixups
on the uninit_bg code to make it much cleaner and more robust, and I
also started rototilling the undo_mgr patches.  

In addition to fixing numerous style and usability problems, I also
found the design problem which caused it to be so slow.  It is using
the first blocksize used to write to the device as the tdb_data_size.
For mke2fs, this is 512 bytes, which means that for every single 4k
inode table clock write, *eight* entries were getting made into the
tdb database and the old contents of the filesystem were getting
stored in 512 byte chunks.  No wonder it was so slow!!  I was able to
show significant speedups by forcing the tdb_data_size to be the
filesystem blocksize, and I suspect that for mke2fs, if it is
initializing the inode table, using a tdb_data_size of something like
32k or 64k would be even better.

Unfortunately I haven't made any progress on doing quality checking
the patches in the patch queue, since I found so much new code that
just screamed out for fixing in e2fsprogs.  Eric, if you have time,
could you look through the patch queue and help out with
sanity-checking the patches and making sure the patch descriptions are
suitably well-written without version control logs, XXX FIXME
comments, or other things that would make Linus vomit?  If you could,
I'd really appreciate it.  Thanks!!

	      	 	   	       	   - Ted
