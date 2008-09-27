From: Theodore Tso <tytso@mit.edu>
Subject: Re: Block allocation
Date: Sat, 27 Sep 2008 17:50:59 -0400
Message-ID: <20080927215059.GA5025@mit.edu>
References: <19703506.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: vineetagarwal <checkout.vineet@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56523 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750938AbYI0VvE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Sep 2008 17:51:04 -0400
Content-Disposition: inline
In-Reply-To: <19703506.post@talk.nabble.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 27, 2008 at 08:07:06AM -0700, vineetagarwal wrote:
> 
> I want to allocate few blocks from a blockgroup in ext2 within a range of
> offset specified by user. Is it possible of doing so if yes then can someone
> please explain.As i know balloc.c and ialloc.c are responsible for it and
> they work on entire file system can i somehow manipulate it for ceratin
> ranges.
> 
> For Ex
> let say i provide a range 100 - 3000. Can i allocate few blocks within this
> range .

While the filesystem mounted (and accessed through the kernel) or
unmounted (and accessed via libext2fs)?  Anything is possible. if you
are willing to write some code....

Why do you need to do this, and is this for some class or problem set?

       	   	      	    	   	- Ted
