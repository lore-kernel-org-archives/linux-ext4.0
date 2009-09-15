From: Theodore Tso <tytso@mit.edu>
Subject: Re: Question on readdir implementation
Date: Tue, 15 Sep 2009 14:38:49 -0400
Message-ID: <20090915183849.GB15101@mit.edu>
References: <20090915095724.GA8440@zhanghuan.nrchpc.ac.cn> <20090915145337.GB23118@mit.edu> <87ocpcf5wv.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zhang Huan <zhhuan@gmail.com>, linux-ext4@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58372 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbZIOSiw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Sep 2009 14:38:52 -0400
Content-Disposition: inline
In-Reply-To: <87ocpcf5wv.fsf@mid.deneb.enyo.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 15, 2009 at 05:56:32PM +0000, Florian Weimer wrote:
> * Theodore Tso:
> 
> > So this is something we could do in the future.  In practice, no one
> > has complained about this as far as NFS is concerned, so it's not high
> > priority for me to pursue.  Were you worried about this as a practical
> > matter, or as a theoretical one?
> 
> readdir returning entries in essentially randomized order is a
> practical performance problem for many things, from grep -r to tar. 8-(
> (My recent FIBMAP/FIEMAP question was related to that, too.)

Well, it's not _that_ hard for applications to sort the directory
entries by inode number.  I've written a LD_PRELOAD, called
spd_readdir() for people who want to use it.  The mutt application
does this natively, and it makes the problem go away.

We could do this in the kernel, but for very large directories, you
will end up pinning large amounts of memory --- and if an application
holds a directory fd open for a long time, the memory needs to be kept
pinned until the dfd is closed.  Still, for moderate sized
directories, it's a possibility.

						- Ted
