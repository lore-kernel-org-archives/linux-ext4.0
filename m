From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Check for immutable flag in fallocate path
Date: Sun, 27 Feb 2011 17:49:40 -0500
Message-ID: <20110227224940.GL2924@thunk.org>
References: <4D6221B8.9040303@gmail.com>
 <20110221124635.GA5525@infradead.org>
 <AANLkTi=bJBeR0m3xuGX_9YZPqRFuMY=bKoxZEWJt37=M@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	cluster-devel@redhat.com,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: Marco Stornelli <marco.stornelli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45437 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab1B0Xdq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Feb 2011 18:33:46 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=bJBeR0m3xuGX_9YZPqRFuMY=bKoxZEWJt37=M@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 21, 2011 at 05:50:21PM +0100, Marco Stornelli wrote:
> 2011/2/21 Christoph Hellwig <hch@infradead.org>:
> > On Mon, Feb 21, 2011 at 09:26:32AM +0100, Marco Stornelli wrote:
> >> From: Marco Stornelli <marco.stornelli@gmail.com>
> >>
> >> All fs must check for the immutable flag in their fallocate callback.
> >> It's possible to have a race condition in this scenario: an application
> >> open a file in read/write and it does something, meanwhile root set the
> >> immutable flag on the file, the application at that point can call
> >> fallocate with success. Only Ocfs2 check for the immutable flag at the
> >> moment.
> >
> > Please add the check in fs/open.c:do_fallocate() so that it covers all
> > filesystems.
> >
> >
> 
> The check should be done after the fs got the inode mutex lock.

Why?  None of the other places which check the IMMUTABLE flag do so
under the inode mutex lock.  Yes, it's true that we're not properly
doing proper locking when updating i_flags from the ioctl (this is
true for all file systems), but this has been true for quite some
time, and using a mutex to protect bit set/clear/test operations would
be like using a sledgehammer to kill a fly.

A proper fix if we want to be completely correct about updates to
i_flags would involve using test_bit, set_bit, and clear_bit, which is
guaranteed to be atomic.  This is how we update the
ext4_inode_info->i_flags (which is different from inode->i_flags) (see
the definition and use of EXT4_INODE_BIT_FNS in fs/ext4/ext4.h).

At some point, it would be good to fix how we set/get i_flags values,
but that's independent of the change that's being discussed here.

    	   	       	      	     	    	  - Ted
