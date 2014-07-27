From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Question: errors=continue behaviour for failed external journal
 device
Date: Sat, 26 Jul 2014 20:07:33 -0400
Message-ID: <20140727000733.GV6725@thunk.org>
References: <loom.20140727T010632-633@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Vlad Dobrotescu <vlad@dobrotescu.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58892 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaG0AHi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 20:07:38 -0400
Content-Disposition: inline
In-Reply-To: <loom.20140727T010632-633@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 11:07:59PM +0000, Vlad Dobrotescu wrote:
> If this isn't the proper place for this question, please point me in 
> the right direction.
> 
> I couldn't find any description on Ext4's behaviour when mounted 
> with errors=continue and external journal if the journal block device 
> is unavailable at mount time (or becomes unavailable at some point).
> 
> I would be using CentOS 7 (kernel 3.10.0-123.4.4.el7 x86_64) and 
> (probably) full data journaling on a SSD. Can someone help?

So there are two different questions.

If you use errors=continue, there is the chance that the file system
inconsistencies that discovered could cause further file system
damage, which might lead to the loss or corruption of data files
written earlier.  So it's not really recommended for most purposes,
unless you have some scheme where you are monitoring dmesgs and having
some strategy to deal with detected file system errors, or when the
system absolutely, positively must continue running, and this is more
important than potential data loss. 

If the journal block device is not present then the file system can't
be mounted, and if the system was uncleanly shut down you won't be
able to recover from the unclean shutdown by replaying the journal.

If the journal block device is *gone*, it is possible to remove the
external journal block device, and then force a file system repair,
but if this happens after an unclean shutdown, you may very well lose
data.

Cheers,

						- Ted
