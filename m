From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] fix check_mntent_file() to pass mode for open(O_CREAT)
Date: Fri, 30 Nov 2007 18:29:48 -0500
Message-ID: <20071130232948.GB6005@thunk.org>
References: <20071109012015.GA14612@webber.adilger.int> <47503222.7020502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34650 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbXK3Xjt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2007 18:39:49 -0500
Content-Disposition: inline
In-Reply-To: <47503222.7020502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 30, 2007 at 09:54:10AM -0600, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > On my FC8 install, ismounted.c fails to build because open(O_CREAT) is
> > used without passing a mode.  The following trivial patch fixes it.
> > 
> > Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> 
> Ted, I don't yet see this in the tree, can we make sure this doesn't get
> lost?

I'm on vacation, but yes, no problem, this will be in the next 1.40.x
stable release (which will be going out soon thanks to a security
issue that will be going public probably next week).

            	   	   	 	     - Ted

P.S.  There will be a press release going out early next week that
will explain why I will have a lot more time to work on e2fsprogs in
the near future....
