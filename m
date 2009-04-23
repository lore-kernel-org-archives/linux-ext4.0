From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Thu, 23 Apr 2009 16:40:59 -0400
Message-ID: <20090423204059.GM2723@mit.edu>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com> <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58685 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbZDWUlM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Apr 2009 16:41:12 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 23, 2009 at 12:04:38PM -0700, Christian Kujau wrote:
> On Thu, 23 Apr 2009, Eric Sandeen wrote:
> > I'd have expected fsck to find that, I think.  I'd first suggest using
> > 1.41.4 or 1.41.5 (probably released very soon) and see if that catches
> > it (I don't remember offhand if there is a relevant change since 1.41.3
> > but the check should be easy...)
> 
> Yes, in fact I _did_ have the latest e2fsprogs.git checkout [0] in 
> place, but did not use it. OK, compiled that, e2fsck still present itself 
> as "1.41.4" (which tree do I have to follow to get the 1.41.5 one?) but
> was not able to fix the errors either. Again, I do not expect e2fsck to 
> actuall fix it, because the damage I did to the fs was probably too 
> severe. But when fsck exits with code 0, I'd "expect" it to be clean. So, 
> I guess what I want is fsck to tell me to get my backups ready, as the fs 
> is damaged too heavily...

Hmm, it really should have detected it.  OK. if you still have the
filesystem around, can you first start by sending me an e2image file:

e2image /dev/md0 /tmp/md0.e2i

This is will dump out the superblock, block group descriptors, and
inode table, and it will allow me to take a look at the inodes in
question.

I tried corrupting the eh_magic field in a test filesystem, and e2fsck
caught it no problem.

Eventually I might need a raw e2image dump, i.e.:


	   e2image -r /dev/md0 - | bzip2 > /var/tmp/md0.e2i.bz2

but such things are very large, and reveal more information, since it
also includes directory names.  But let's see if a simple e2image file
is enough for me to get started.

Thanks,

					- Ted
