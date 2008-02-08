From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH, E2FSPROGS] blkid: Automatically chose between ext4 and
	ext4dev as appropriate
Date: Fri, 8 Feb 2008 18:20:38 -0500
Message-ID: <20080208232038.GL11923@mit.edu>
References: <E1JNboG-0000IP-8D@closure.thunk.org> <47ACDCBD.8040009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59976 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbYBHXV1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2008 18:21:27 -0500
Content-Disposition: inline
In-Reply-To: <47ACDCBD.8040009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 08, 2008 at 04:50:37PM -0600, Eric Sandeen wrote:
> Theodore Ts'o wrote:
> > I plan to release this in an upcoming 1.40.6 release, along with code
> > that allows "tune2fs -E test_fs" to work on ext4 filesystems.  The idea
> > is that if I can get this into community distro's, it will make it
> > easier for them to experiment with ext4/ext4dev, with the appropriate
> > forward compatibility when sometime (hopefully 2.6.26 or 2.6.27?) we
> > rename ext4dev to ext4.
> > 
> > Any comments before I push this change out to the maint branch?
> 
> Seems logically correct to me... although it also seems like this has
> gotten fairly complex by now, what with blkid rummaging around in
> modules.dep, /proc files, etc...

True, but the good thing is that we only need to do this in one
location, and it does the right thing.  It also means that in the
future, even after ext4 is in production, if we want to do some
testing for some new optimizations or other ehancements in ext4, it's
a lot easier for us have both ext4 and ext4dev modules built at the
same time, where ext4dev would have our test code, and then once it's
stable and we're sure it's OK, we can commit it to mainline.  This
makes life much more convenient for an ext4 developer who wants to
both use it in production as well as having an alternate "crash and
burn" ext4dev code that he or she is trying out.

So one of the things that this does mean, is after we do the
ext4dev->ext4 transition, we have some way for users to give us
permission to disable the test_fs bit --- so that in the future, when
we have need of that bit, we can use it again and not have to worry
about old filesystems that are now in production but still have the
test_fs bit set.

						- Ted
