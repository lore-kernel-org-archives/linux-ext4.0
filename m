From: Theodore Tso <tytso@mit.edu>
Subject: Re: Call traces on console from a test machine
Date: Fri, 14 Nov 2008 12:09:30 -0500
Message-ID: <20081114170930.GI25117@mit.edu>
References: <491CC6E3.7070808@hq.newdream.net> <491CDF90.8070802@hq.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kelly Kane <kelly@hq.newdream.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34498 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751159AbYKNRJe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 12:09:34 -0500
Content-Disposition: inline
In-Reply-To: <491CDF90.8070802@hq.newdream.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2008 at 06:16:48PM -0800, Kelly Kane wrote:
> /liamsito1234/cibercomics.com/wp-content/cache/supercache/www.cibercomics.com/2008/10/05 
> (2152305) has
>                deleted/unused inode 2901322.  Clear? yes
> /dev/sdb1: e2fsck canceled.
> e2fsck: aborted
>
> Same block group each run through, different inode.

That's very strange...  and it's also strange that it would be
constantly changing.  What version of e2fsprogs are you using?

> I ran e2image and produced the following file:
>
> http://ext4dev.dreamhosters.com/watanabe-home-2008-11-13-1712.e2image.bz2

Unfortunately, I need a raw image dump in order to be able to debug
this.  Can you create it using:

e2image -r /dev/sdXX -  | bzip2 > /tmp/sdXX.e2i.bz2

... and send it to me?

What's the underlying hardware for this filesystem, and I hate to ask
it, but are you sure it's not a hardware problem?

One thing you can do is to use e2image to create a sparse file on
another filesystem:

e2image -r /dev/sdXX /u2/sdXX.e2i

And then try to use e2fsck to check the raw e2image file.  If it is
successful, then but yet you keep getting failures with different
block groups and different inodes, it may be a hardware problem.

Regards,

					- Ted
