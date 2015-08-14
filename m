From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 errors with full filesystem
Date: Thu, 13 Aug 2015 22:42:27 -0400
Message-ID: <20150814024227.GC26095@thunk.org>
References: <20150813082307.GA32614@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58098 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751AbbHNCmc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Aug 2015 22:42:32 -0400
Content-Disposition: inline
In-Reply-To: <20150813082307.GA32614@aepfle.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 13, 2015 at 10:23:07AM +0200, Olaf Hering wrote:
> 
> I just got the output below in syslog with a full filesystem.
> Should I be worried about inconsistent filesystem now, or is that just an
> overly verbose message about ENOSPC?  This is a 4.1.5 kernel.

You don't need to worry about an inconsistent file system, but it's an
error that isn't supposed to to happen.  The warning message indicates
that writes issued got a success return code, but for which ran out of
space, and so some number of pages got lost and couldn't be saved to
disk.  We keep track of how many data blocks have been committed, and
we have a reserved amount of space for metadata blocks which _should_
be enough.

For more details, see:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=27dd43854227bb0e6ab70129bd21b60d396db2e7

I'm curious about your workload.  How big is your file system, and how
fragmented is your file system per e2freefrag?  And how quickly was
various programs writing to the file system at the time when you ran
out of space, and what sort of files and what was the average size
that was getting dumped into the file system?  Oh, and how much memory
did you have in your system?

Thanks,

       		    	    	 	    - Ted
