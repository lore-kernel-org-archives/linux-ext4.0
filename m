From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: do not change root dir ownership
Date: Mon, 13 May 2013 09:37:31 -0400
Message-ID: <20130513133731.GC4845@thunk.org>
References: <1367875316-3089-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48012 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab3EMNhe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 09:37:34 -0400
Content-Disposition: inline
In-Reply-To: <1367875316-3089-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 06, 2013 at 05:21:56PM -0400, Mike Frysinger wrote:
> If you use `mke2fs` on a file, the code will automatically chown the root
> dir to the active uid/gid.  It doesn't do this to any other files though.
> 
> I can't see where this would really be desirable: you still need root in
> order to mount, and the lost+found dir is owned by root.  It means if you
> want to generate a rootfs as a non-root user, you first have to run it
> through sudo or manually run `chown 0:0` after you've mounted it.

Yeah, this was something that we've been doing in e2fsprogs since 0.5b
(i.e., dating back to 1997).  I agree that the behavior is a bit silly
and we should probably change it.  It *is* a behavioural change,
though, so I'm going to make it something that changes in 1.43, as
opposed to a 1.42.x maintenance release.

A workarond that I'd recommend (since we will have lots of people
creating file systems for various mobile/embedded systems, and they
will have scripts that need to work on existing versions of e2fsprogs)
is to do something like this:

   mke2fs -t ext4 /tmp/foo.img 16384
   debugfs /tmp/foo.img -R "set_inode_field / uid 0"
   debugfs /tmp/foo.img -R "set_inode_field / gid 0"

   	   		   		      	  - Ted
