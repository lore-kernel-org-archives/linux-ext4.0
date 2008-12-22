From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Autoremoval of test_fs flag kinda sucks
Date: Sun, 21 Dec 2008 21:28:15 -0500
Message-ID: <20081222022815.GD23723@mit.edu>
References: <20081221134326.GA26216@nineveh.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53730 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbYLVC2T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Dec 2008 21:28:19 -0500
Content-Disposition: inline
In-Reply-To: <20081221134326.GA26216@nineveh.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 21, 2008 at 08:43:27AM -0500, Joseph Fannin wrote:
> This is mostly me blowing off a little steam here, so yeah.  But maybe
> it won't hurt to send out a heads up and get this in the archives:
> 
> Booting a 2.6.28-pre kernel will cause e2fsck to remove the test_fs
> flag from any filesystem it checks, presumably because "ext4dev" has
> become "ext4" in 2.6.28.  If your root fs is on ext4, this makes it
> impossible to reboot back into a older kernel (i.e. < 2.6.28) since it
> will refuse to mount an ext4dev fs without the "test_fs" flag set --
> unless you chase after e2fsck and set the flag back.

Yeah, Sorry I guess I didn't think it was going to be *that* common
for people to be going back and forth between the boundary.  It is
possible to disable this, BTW, via /etc/e2fsck.conf:

[options]
	clear_test_fs_flag = false

The assumption I made was that the number of pre-2.6.28 ext4 users
would be small, and so it would be safe to default the option to true.

      	 	       	  	   	- Ted
