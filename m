From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH, RFC] Add new "development flag" to the ext4 filesystem
Date: Wed, 23 Jan 2008 12:26:24 -0500
Message-ID: <20080123172623.GC32663@mit.edu>
References: <20080122231707.GA21968@mit.edu> <4796BAB9.7000502@redhat.com> <20080123165307.GA32663@mit.edu> <479773A3.9000106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:47236 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757060AbYAWR1J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 12:27:09 -0500
Content-Disposition: inline
In-Reply-To: <479773A3.9000106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 23, 2008 at 11:04:35AM -0600, Eric Sandeen wrote:
> 
> I just think that ext4.ko running ext3 filesystems needs to be under
> explicit control, and not something that happens, occasionally,
> accidentally, without the user/administrator requesting it.  Least
> surprise, and all that...
> 

Well, most of the time that will happen, given that /etc/fstab
explicitly states which filesystem to use; and if the user doesn't
specify a filesystme type, mount will use blkid/vol_id, and if that
says ext3, then ext3 will be used.  The only time where it might not
happen without an explicit administrator request is on the root
filesystem automount.... and if you are using an initrd to mount the
filesystem (as all of the enterprise distros now do anyway), that
could be easily controlled form userspace as well.

						- Ted
