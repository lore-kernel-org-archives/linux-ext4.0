From: Theodore Tso <tytso@mit.edu>
Subject: Re: zero out blocks of freed user data for operation a virtual
	machine environment
Date: Mon, 25 May 2009 08:06:36 -0400
Message-ID: <20090525120636.GB25908@mit.edu>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Thomas Glanzmann <thomas@glanzmann.de>, tytso@thunk.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58014 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZEYMGt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2009 08:06:49 -0400
Content-Disposition: inline
In-Reply-To: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 24, 2009 at 07:00:45PM +0200, Thomas Glanzmann wrote:
> Hello Ted,
> I would like to know if there is already a mount option or feature in
> ext3/ext4 that automatically overwrites freed blocks with zeros? If this
> is not the case I would like to know if you would consider a patch for
> upstream? I'm asking this because I currently do some research work on
> data deduplication in virtual machine environments and corresponding
> backups. It would be a huge space saver if there is such a feature
> because todays and tomorrows backup tools for virtual machine
> environments work on the block layer (VMware Consolidated Backup, VMware
> Data Recovery, and NetApp Snapshots). This is not only true for backup
> tools but also for running Virtual machines. The case that this future
> addresses is the following: A huge file is downloaded and later delted.
> The backup and datadeduplication that is operating on the block level
> can't identify the block as unused. This results in backing up the
> amount of the data that was previously allocated by the file and as such
> introduces an performance overhead. If you're interested in real live
> data, I'm able to provide them.

If you are planning to use this on production systems, forcing the
filesystem to zero out blocks to determine whether or not they are in
use is a terrible idea.  The performance hit it would impose would
probably not be tolerated by most users.  

It would be much better to design a system interface which allowed a
userspace program to be given a list of blocks that are in use given a
certain block range.  That way said userspace program could easily
determine whether or not a particular block is in use or not.

	  	     	   	      	    - Ted
