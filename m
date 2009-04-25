From: Theodore Tso <tytso@mit.edu>
Subject: Re: Use of kmalloc vs vmalloc in ext4?
Date: Fri, 24 Apr 2009 23:07:03 -0400
Message-ID: <20090425030703.GD13608@mit.edu>
References: <6601abe90903110732n5c9df9b9td317be316921b7a6@mail.gmail.com> <532480950904052345m48bc5df5wcdc4c5e32778130c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38364 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbZDYDHG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 23:07:06 -0400
Content-Disposition: inline
In-Reply-To: <532480950904052345m48bc5df5wcdc4c5e32778130c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 05, 2009 at 11:45:10PM -0700, Michael Rubin wrote:
> Anyone have any comments? Or historical reasons? We operate with some
> constrained memory situations, and were wondering if a patch to move
> from kmalloc to vmalloc would be well received.

Sorry, I didn't have time to get to this until now.  I've been burning
the midnight oil getting the e2fsprogs 1.41.5 release out, as well as
catching up after the Collab Summit.

The best thing to do I think is to try using kmalloc(), and if it
fails, to fall back to vmalloc().  We can use is_vmalloc_addr() to
decide whether to use vfree() or kfree(), a trick which I picked up
from fs/ntfs/malloc.h.  I'm surprised this trick isn't used more in
the kernel.  Perhaps there should be made a general-purpose
infrastructure, but for now I'll just open-code it.

		    	    	      		- Ted
