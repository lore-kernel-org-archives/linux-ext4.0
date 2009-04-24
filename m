From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Thu, 23 Apr 2009 23:20:28 -0400
Message-ID: <20090424032028.GB7949@mit.edu>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com> <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de> <20090423204059.GM2723@mit.edu> <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54077 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbZDXDUi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Apr 2009 23:20:38 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 23, 2009 at 03:15:10PM -0700, Christian Kujau wrote:
> On Thu, 23 Apr 2009, Theodore Tso wrote:
> > Eventually I might need a raw e2image dump, i.e.:
> > 
> > 	   e2image -r /dev/md0 - | bzip2 > /var/tmp/md0.e2i.bz2
> 
> I've put the raw e2image dump on http://nerdbynature.de/bits/2.6.30-rc2/
> Do you still need the dump without the "-r"?

Nope, the raw e2image file was perfect.  This was actually a problem I
knew about, and wanted to get fixed before the e2fsprogs 1.41.5
release.  The problem was that i_file_acl_high was set and the kernel
unconditionally checks for it even though the INCOMPAT_64_BITS flag is
not set.

It's been fixed in e2fpsrogs 1.41.5, which I've only just released.
It's available on git, sourceforge, and all of the other usual places.
This should fix the problem for you.

					- Ted
