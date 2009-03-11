From: Theodore Tso <tytso@mit.edu>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Tue, 10 Mar 2009 20:47:10 -0400
Message-ID: <20090311004709.GC15229@mit.edu>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au> <49B5D71D.1030802@redhat.com> <1236655451.30280.29.camel@kulgan.wumi.org.au> <49B5EDFE.8060405@redhat.com> <1236661371.30280.33.camel@kulgan.wumi.org.au> <20090310070915.GN3199@webber.adilger.int> <20090310144651.GC23075@mit.edu> <1236719691.16191.9.camel@kulgan.wumi.org.au> <20090310224810.GA15229@mit.edu> <20090311003845.GB3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44909 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbZCKArd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Mar 2009 20:47:33 -0400
Content-Disposition: inline
In-Reply-To: <20090311003845.GB3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 10, 2009 at 06:38:45PM -0600, Andreas Dilger wrote:
> > Actually, it's a bit more complicated than that.  I should really add
> > a hook to debugfs to automate this, but... to find the block to grab,
> > you do this.   
> 
> [many complex steps deleted]
> 
> > So now we know that the block containing inode 867 is 65+54 = 119
> 
> Or you can use imap (which Ted probably wrote in the first place. :-)
> 
> debugfs: imap some/problem/file
> Inode 867 is part of block group 0
> 	located at block 119, offset 0x0180

<Blush>

OK, now I'm embarassed.  I had completely forgotten that I had already
implemented it.  

And to think I've been doing the hard way most of the time (i.e.,
using dc and doing the calculations manually :-)

	     	     	 	  - Ted
