From: Theodore Tso <tytso@mit.edu>
Subject: Re: zero out blocks of freed user data for operation a virtual
	machine environment
Date: Mon, 25 May 2009 08:03:20 -0400
Message-ID: <20090525120320.GA25908@mit.edu>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de> <20090524101551.57b706e9@infradead.org> <20090524173933.GD24753@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Thomas Glanzmann <thomas@glanzmann.de>,
	Arjan van de Ven <arjan@infradead.org>, tytso@thunk.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46077 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbZEYMDo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2009 08:03:44 -0400
Content-Disposition: inline
In-Reply-To: <20090524173933.GD24753@cip.informatik.uni-erlangen.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 24, 2009 at 07:39:33PM +0200, Thomas Glanzmann wrote:
> Hello,
> 
> > > tunable feature that zeroes our free data
> 
> > wouldn't it be better if the VM's would just support the TRIM command?
> 
> the resources available to me indicate that the TRIM command is a not
> yet standarized command targeted at SSD disks to indicate free disk
> space. Does ext3/4 trigger a block device layer call that could result
> in a TRIM command?

Yes, it does, sb_issue_discard().  So if you wanted to hook into this
routine with a function which issued calls to zero out blocks, it
would be easy to create a private patch.

					- Ted
