From: Ted Ts'o <tytso@mit.edu>
Subject: Re: new ext4 filesystem vs. converted ext3
Date: Mon, 6 Jun 2011 16:20:48 -0400
Message-ID: <20110606202048.GC20818@thunk.org>
References: <87tyc6pov6.fsf@algae.riseup.net>
 <20110604030949.GB2614@thunk.org>
 <87lixeoqqp.fsf@algae.riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: micah anderson <micah@riseup.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53938 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1FFUUv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 16:20:51 -0400
Content-Disposition: inline
In-Reply-To: <87lixeoqqp.fsf@algae.riseup.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 06, 2011 at 12:43:10PM -0400, micah anderson wrote:
> 
> Through munin graphs, unfortunately we don't have a lot of data from
> before the change, but you can see the jump early on in this graph,
> where the change was made:
> 
> http://lackof.org/~taggart/tmp/willet-cpu-year.png
> 
> I'll note that we also moved to squeeze from lenny at this
> time. Basically we decided to move to squeeze and then convert to ext4,
> so that throws in some other variables here too.
> 
> As I mentioned before, this is a high traffic mailing list system, which
> does a lot of I/O. We're also seeing lots of rescheduling interrupts
> after the upgrade to the squeeze kernel:
> 
> http://lackof.org/~taggart/tmp/willet-irqstats-year.png

Oh, I bet I know what's going on.  Ext3 defaults to barriers being
off.  Ext4 defaults to barriers turned on, which is safer if you have
power drops.  If you have a UPS and are confident that the UPS
monitoring software is properly setup so the system will go through a
controlled, clean shutdown when the UPS power is running low, then you
could consider disabling barriers on ext4 without committing
professional sysadmin malpractice.  :-)

Since mail systems tend to be very fsync() happy, and fsyncs()
translate to barriers, that's probably the explanation of what's going
on here.

							- Ted
