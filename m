From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Regression with ext4 in kernel 2.6.39-rc7? (Was: testing ext4
 master branch)
Date: Fri, 13 May 2011 10:56:08 -0400
Message-ID: <20110513145608.GA21165@thunk.org>
References: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47726 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522Ab1EMO4M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 May 2011 10:56:12 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 13, 2011 at 12:17:03PM +0300, Amir Goldstein wrote:
> 
> Can anyone try to reproduce the error with xfstest 005 and the crash
> with xfstest 232?

Xfstest #5 broke because of a change in the VFS, which now allows up
to 40 nested symlinks.  So that's a matter of your xfstests being too
old.

The version of xfstests I've been using on my KVM box is too old to
have test 232, so I haven't been able to test it.  I've been trying to
use a newer version of xfstests, but xfstests doesn't build on either
Ubuntu 10.04 (LTS), Debian stable, or Debian unstable, due to the use
of newer XFS ioctl's and xfsctl's that aren't defined in the system
header files.  The fact that it doesn't work on Ubuntu LTS and Stable
is not that surprising, I suppose, but I was a bit disappointed that
it doesn't work on Debian unstable.

Since I don't have a Fedora system handy --- which header file are
things like "struct xfs_flock64" supposed to be defined these days?

       	    	    		 	     - Ted
