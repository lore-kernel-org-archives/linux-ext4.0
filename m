From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4 corruption
Date: Mon, 6 Jun 2011 00:19:50 -0400
Message-ID: <20110606041950.GH7180@thunk.org>
References: <87pqmrobix.fsf@algae.riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Micah Anderson <micah@riseup.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53804 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab1FFETx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 00:19:53 -0400
Content-Disposition: inline
In-Reply-To: <87pqmrobix.fsf@algae.riseup.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 05, 2011 at 11:59:34PM -0400, Micah Anderson wrote:
> 
> I previously wrote about a recent conversion from ext3 to ext4 (on
> Debian Squeeze), which went well. However, I seem to be having problems
> with the ext4 filesystem.

Are you using the 2.6.32 kernel (the Debian squeeze default)?  Try
updating to 2.6.39.1, and see if that stablizes things.  There have
been a huge number of bug fixes since 2.6.32, and no one has been
really backporting patches to such an ancient kernel.  This is one of
the ways in which Debian Obsolete^H^H^H^H^H^H^H^H Stable can be
somewhat of a disadvantage.  Unlike the RHEL kernels, no one is
backporting ext4 bugfixes to older Debian stable kernels, and ext4 was
still getting a lot of bug fixes in the 2.6.32 days.

That being said, you're seeing some pretty severe inode *and* block
allocation bitmap problems, and that doesn't sound like anything I
remember even back in the 2.6.32 days.  It does make me wonder about
the stability of the hardware and of the software raid code...

   	      	     	      	     	 	       - Ted
