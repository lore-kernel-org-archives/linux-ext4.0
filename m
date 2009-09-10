From: Stephan Kulow <coolo@suse.de>
Subject: Re: buggy_init_scritps and e2fsprogs 1.41.9
Date: Thu, 10 Sep 2009 22:57:54 +0200
Message-ID: <200909102257.54889.coolo@suse.de>
References: <200909101455.38400.coolo@suse.de> <20090910202927.GK23700@mit.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Scott James Remnant <scott@canonical.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:45283 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753112AbZIJU5z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 16:57:55 -0400
In-Reply-To: <20090910202927.GK23700@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 10 September 2009 22:29:27 Theodore Tso wrote:
> 
> > I don't want to set buggy_init_scripts for openSUSE as the init
> > scripts are not buggy, but a live cd is a live cd and has no idea
> > what the timezone of the system is configured to and even a ro
> > mount will destroy your file system ;(
> 
> Well, you're over-dramatizing things; it doesn't destroy your
> filesystem --- it just forces an unnnecessary fsck.  And it only does
> this if the system had been uncleanly shutdown before the the boot.
> 
Yes, it doesn't destroy your file system but it forces you to do a manual
fsck and no, there is no need for a unclean shutdown, it will always happen.

The work flow is as such:
- boot into live cd, live cd thinks system is UTC, mounts sda1 (ro) 
  at 9am, umounts cleanly, updates mount time to 11am (hardware clock)
- boot into real system, time is set to CEST and hardware clock is read
  as 9am. fsck will say the file has uncorrectable errors and abort.

This does _not_ happen with 1.14.8 as PR_0_FUTURE_SB_LAST_MOUNT
contained PR_PREEN_OK and that makes it continue.
Now 1.14.9 does preenhalt on the two hour difference of mount time  
even as the problem is just as harmless - and it will not appear
on distributions with buggy init scripts.

Your kernel patch makes sense, but it won't change the problem: because the 
problem is mtime not wtime.

Greetings, Stephan
