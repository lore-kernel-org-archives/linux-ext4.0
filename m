From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Fast symlinks stored slow
Date: Thu, 13 Jul 2017 09:02:13 +0100
Message-ID: <20170713080213.GO31999@redhat.com>
References: <20170712170711.GA19996@redhat.com>
 <20170712231737.nzi2dv6e6h6yvrsl@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38393 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbdGMICP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Jul 2017 04:02:15 -0400
Content-Disposition: inline
In-Reply-To: <20170712231737.nzi2dv6e6h6yvrsl@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 12, 2017 at 07:17:37PM -0400, Theodore Ts'o wrote:
> On Wed, Jul 12, 2017 at 06:07:11PM +0100, Richard W.M. Jones wrote:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=1470157
> > 
> > To cut a long story short, we were using libext2fs to create
> > filesystems where short symlinks (< 60 bytes) were stored the same way
> > as long symlinks, ie. stored as an ordinary file instead of being
> > stored in the inode.
> > 
> > I think the reason we were creating filesystems wrongly in the first
> > place is because our code has been around since about 2008, and the
> > nice ext2fs_symlink function that deals properly with fast/slow
> > symlinks wasn't added until 2013.
> 
> Thanks for the report.  I had been hesitant about making this change
> (and had been pushing back from those who were advocating for this
> change) precisely because I was afraid that this might be a situation.
> 
> What convinced me to accept the change is that (a) I had scanned all
> of the old kernels and old versions of e2fsprogs and convinced myself
> that aside from someone manually creating symlinks using low-level
> libext2fs, symlinks < 60 bytes would never be stored in external
> blocks, and (b) using the i_blocks logic to determine whether or not
> we had a slow link was getting really painful.
> 
> > It's not too much trouble for us to recreate the incorrect
> > filesystems.  Mostly we're creating one-off throwaway filesystems for
> > appliances anyway and they don't live for long.
> > 
> > But I suppose this might be a warning that other incorrect filesystems
> > exist which will break with Linux >= 4.13.
> 
> So I see this is going to break libvert and libguestfs.  So people who
> are running existing distribution userspaces and then upgrade to 4.13
> will break.
> 
> Hmm...  I suppose we could add back support to let the kernel to use
> the i_blocks logic if the ea_inode feature is not enabled.  E2fsck
> would still complain so we can try to gradually force userspace to do
> things "correctly", but at least we would be backwards compatible.
> 
> Comments?

>From my point of view it's not too much trouble to recreate these
filesystems, and we've already proposed a fix for supermin so it
creates symlinks properly[1].

I think it might be a good idea to get e2fsck to complain about these
filesystems though.  It'll at least tell you how widespread (or
otherwise) the problem might be.

Rich.

[1] https://www.redhat.com/archives/libguestfs/2017-July/msg00084.html

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
