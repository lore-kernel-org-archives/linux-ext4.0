From: Ted Ts'o <tytso@mit.edu>
Subject: Re: sane fsck default behavior for "Entry ... in ... has
 deleted/unused inode ....  Clear? yes"
Date: Sun, 5 Feb 2012 19:03:53 -0500
Message-ID: <20120206000353.GA13391@thunk.org>
References: <1AB9AC11-F9E9-4F52-8CBC-D050B056D013@mit.edu>
 <1328377990.1636.YahooMailClassic@web29504.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@users.sourceforge.net,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Hin-Tak Leung <htl10@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43403 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003Ab2BFADy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Feb 2012 19:03:54 -0500
Content-Disposition: inline
In-Reply-To: <1328377990.1636.YahooMailClassic@web29504.mail.ird.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 04, 2012 at 05:53:10PM +0000, Hin-Tak Leung wrote:
> 
> Fair enough - I just thought the interaction between usb-storage and
> lvm2 would warrant some wider discussion.

If device driver thinks the device has disappeared, and then it
reappears so that it gets a new identity (i.e. sdb -> sdc), the
problem is below LVM2.  It's either a problem with the hardware
actually disconnecting from the USB bus, or the with the device
driver.  But the people who have expertise with the USB device driver
and the USB hardware aren't going to be on fs-devel.

> That files are lost forever I understand, but from a user's point of
> view, the most important thing is preserving data, or at least, when
> lost is inevitable, know that they are lost and hope to recover that
> somewhere. Is it possible to offer that - i.e. prompt for a log file
> - when such a decision is needed, when run interactively?

If you know that fsck has failed with the automatic (preen) pass, such
that you are running fsck interactively by definition you know there
will be some decision that will be required.  So why not always use
the script command when you're running e2fsck interactively?

We could replicate the functionality of script in e2fsck, but given
that script is a perfectly good implementation, it's not clear it's
worth it.

> > It may very well be the SATA->USB enclosure is reporting some
> > error much worse than a read error as a result of the error.
> 
> Thanks. The curious thing is that running hdparm -a0/-A0 can get
> around the reset, so it seems to be a performance related issue.

Well, we don't know that.  This is why you really need to get the USB
storage folks involved, and they don't hang out on fs-devel.

	      		    	       	    - Ted
