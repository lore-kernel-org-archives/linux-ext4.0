From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Fri, 24 Apr 2009 07:58:16 -0400
Message-ID: <20090424115816.GC7949@mit.edu>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com> <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de> <20090423204059.GM2723@mit.edu> <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de> <20090424032028.GB7949@mit.edu> <20090424070943.GR3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Kujau <lists@nerdbynature.de>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52065 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbZDXL6V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 07:58:21 -0400
Content-Disposition: inline
In-Reply-To: <20090424070943.GR3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 24, 2009 at 01:09:43AM -0600, Andreas Dilger wrote:
> On Apr 23, 2009  23:20 -0400, Theodore Ts'o wrote:
> > On Thu, Apr 23, 2009 at 03:15:10PM -0700, Christian Kujau wrote:
> > > On Thu, 23 Apr 2009, Theodore Tso wrote:
> > > > Eventually I might need a raw e2image dump, i.e.:
> > > > 
> > > > 	   e2image -r /dev/md0 - | bzip2 > /var/tmp/md0.e2i.bz2
> > > 
> > > I've put the raw e2image dump on http://nerdbynature.de/bits/2.6.30-rc2/
> > > Do you still need the dump without the "-r"?
> > 
> > Nope, the raw e2image file was perfect.  This was actually a problem I
> > knew about, and wanted to get fixed before the e2fsprogs 1.41.5
> > release.  The problem was that i_file_acl_high was set and the kernel
> > unconditionally checks for it even though the INCOMPAT_64_BITS flag is
> > not set.
> 
> Maybe I'm missing something, but how can i_file_acl_high being used
> cause a problem with the file extent maps?

It didn't; what had happened was that a garbage block had got written
into the inode table.  This caused the kernel to complain about
eh_magic being wrong in the inode table.  E2fsck 1.41.3 fixed those
problems, but it ignored i_file_acl_high because the 64 bit feature
flag was not set.  The kernel always pays attention to
i_file_acl_high, regardless of whether the 64-bit feature flag is set
or not.  Hence, the kernel was complaining and refused to touch those
inodes.   

Actually, on a 2.6.30 kernel it causes the kernel to loop forever with
kernel messages "__find_get_block_slow() failed."

In any case, with e2fsck 1.41.5, I added code to fix i_file_acl_high
getting set, and I was then able to mount the raw e2image file and not
have any problems accessing the files in question, so I'm pretty sure
that was the problem.

						- Ted
