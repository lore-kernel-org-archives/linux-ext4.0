From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup
	blocks...
Date: Mon, 20 Apr 2009 08:48:10 -0400
Message-ID: <20090420124810.GT19186@mit.edu>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org> <20090420113534.GR19186@mit.edu> <alpine.LFD.2.00.0904201237500.17316@xpc17.ast.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59723 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbZDTMsQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 08:48:16 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904201237500.17316@xpc17.ast.cam.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 20, 2009 at 12:43:37PM +0100, Jeremy Sanders wrote:
> It takes a day or two to do the sync. I've only done it twice (one with  
> the old kernel, once with the new fedora testing kernel) and it happened  
> both times. I'm afraid the statistics are rather low number here.
>
> I did a different faster test (just copying my home directory lots of  
> times), but I wasn't able to get it to fail. That test didn't use much  
> disk space, however. Maybe it's worth just dd'ing a few TB of data onto  
> the device and seeing whether that fails.
>
> I didn't reboot this time - I did last time. I just unmounted the file  
> system and fsckd it. The filesystem is 8.2TB and the data is around 
> 2.5TB.

That's that's useful data.  I wish we could make it fail more quickly
on a smaller rsync, but the fact that you didn't need to reboot is
definitely useful information.

And this is a fresh rsync so no files were being deleted, rsync should
have just been writing new files to .filename.XXXXX and then renaming
the filename to filename.XXXXX when it is done, right? 

OK, let me think about this a little.  I think we can create a patch
which checks for writes to the block group descriptors and dumps a
stack trace.  That would allow us catch the failing code in question
in the act, and maybe figure out what is going on.

					- Ted
