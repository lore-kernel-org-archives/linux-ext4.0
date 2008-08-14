From: Theodore Tso <tytso@mit.edu>
Subject: Re: Dot and dotdot need to be physically present?
Date: Wed, 13 Aug 2008 23:47:01 -0400
Message-ID: <20080814034701.GC6469@mit.edu>
References: <200808131636.59436.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Daniel Phillips <phillips@phunq.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52098 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbYHNDrE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 23:47:04 -0400
Content-Disposition: inline
In-Reply-To: <200808131636.59436.phillips@phunq.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2008 at 04:36:59PM -0700, Daniel Phillips wrote:
> 
> Many years ago we had a discussion about whether or not the . and ..
> directory entries had to be physically present in htree, and I remember
> the conclusion was that they had to be, but I forget the argument and
> lost track of the email thread.  I think the VFS will happily supply
> the . and .. entries to getdents on its own.  So what was the issue?
> Something about telldir?

. and .. are needed for backwards compatibility.  If you aren't going
to do backwards compatibility, then you might as well not bother
putting the btree in the directory nodes.  Just use physically block
numbers directly.

The other reason why '..' is useful is that it helps to knit the
fliesystem back together in case of corruption.  (For example, e2fsck
uses the '..' so we can display full pathnames which is very helpful
to system administrators.)

The '.' pointer is slightly less useful, but it is helpful as an
additional sanity check.

If I were doing things all over in a completely incompatible way, I'd
probably put at the beginning of the first directory block (a) a magic
number, (b) the current inode number (as a sanity check), (c) the
parent inode number (i.e., '..'), and (d) a pointer to a physical
block which is the root of the index tree. 

      	       	   	       	     	   - Ted
