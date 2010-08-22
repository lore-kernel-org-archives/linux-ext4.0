From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Updated test case
Date: Sun, 22 Aug 2010 07:42:28 -0400
Message-ID: <20100822114228.GB6329@thunk.org>
References: <E1OlvNi-00063m-09@tytso-glaptop>
 <20100821201146.GF10450@thunk.org>
 <4C7071EA.3040503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40038 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab0HVLmy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Aug 2010 07:42:54 -0400
Content-Disposition: inline
In-Reply-To: <4C7071EA.3040503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 21, 2010 at 07:40:10PM -0500, Eric Sandeen wrote:
> I'll send an xfstest but it'd be really great if could could work
> inside the xfstests framework when devising testcases...

If you could put together an xfstests, that would be great.  I hadn't
because Mike's been trying to remind me that I really need to delegate
to others :-), and we do have someone at Google who can put the
xfstest script together.  You can probably do it faster than he can,
though.

I didn't use xfs_io because I don't know how to use it, and because
it's not one of those things which is regularly on our production
machines that we use for testing.  I probably start exploring all of
the things that can be done with it, though!

> Ted, is just checking for fs corruption is enough or do you think a
> test needs the debugfs stat inspection step?  It'd be easy enough
> to special-case a debugfs step for ext4.

Well, if we end up suppressing the EOFBLOCKS_FL test e2fsck (which is
what we've already done as an emergency workaround) we can't count on
e2fsck detecting the problem, which is why I phrased this the way I
did for Aditya's benefit.

> > What I normally do is run it something like this:
> > 
> > mount /scratch ; pushd /scratch; ~/testcase <opts>; popd ; umount /scratch ; debugfs /dev/sdc1 -R "stat test-file"
> > 
> > What to look for is whether the flags field is either 0x480000 or
> > 0x80000.  The 0x400000 flag is the EOFBLOCKS_FL flag.  If last extent
> > is uninitialized, then the EOFBLOCKS_FL flag should be set.  
> 
> only if that last extent is past i_size, though...

Good point, and I guess I did have at least one test case where that
wasn't true.

						- Ted
