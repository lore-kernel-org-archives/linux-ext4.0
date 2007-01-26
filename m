From: Theodore Tso <tytso@mit.edu>
Subject: Re: support freeze operation like xfs_freeze
Date: Fri, 26 Jan 2007 16:22:08 -0500
Message-ID: <20070126212208.GA9897@thunk.org>
References: <20070125172818.GA25037@swszl.szkp.uni-miskolc.hu> <45B907CA.70309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vitez Gabor <vitezg@niif.hu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55660 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbXAZVWY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Jan 2007 16:22:24 -0500
Content-Disposition: inline
In-Reply-To: <45B907CA.70309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 25, 2007 at 01:40:58PM -0600, Eric Sandeen wrote:
> on an lvm volume.  So, I think ext[34] are perfectly capable of being
> frozen, there's just no generic userspace utility to point at a generic
> block device to do that freezing.  xfs's collection of ioctls to do this
> directly got grandfathered in, I guess.  :)

xfs's collection of ioctls do the right thing if the program which
freezes the filesystems exits without unfreezing the filesystem
(closing the file descriptor used by the freeze ioctl should unfreeze
the filesystem, I hope)?  And I assume that if a setuid program which
freezes filesystems forgets to catch SIGTSTP, and a hostile user types
^Z at the wrong time, that's considered a buggy setuid program?  :-)

One of the reasons why direct exposire to the freeze routines was
always considered a little dangerous, and my guess is that's why we
don't have a first class VFS interface.  Then again, XFS managed to
get an exemption from some of the standard kernel merging rules,
including allowing the IRIX compatibility layer, and I'm guessing the
xfs collection of ioctls snuck in that way too.  :-)

					- Ted
