From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Mon, 30 Jul 2007 12:43:03 -0700
Message-ID: <20070730124303.a0620d8a.akpm@linux-foundation.org>
References: <46A8628D.6070103@clusterfs.com>
	<46A87858.40005@garzik.org>
	<20070728195114.GA5952@infradead.org>
	<20070729173035.GU5992@schatzie.adilger.int>
	<20070729192437.GB14530@infradead.org>
	<1185817755.4023.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, Alex Tomas <alex@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37671 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S939452AbXG3Tnt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2007 15:43:49 -0400
In-Reply-To: <1185817755.4023.7.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 30 Jul 2007 10:49:14 -0700
Mingming Cao <cmm@us.ibm.com> wrote:

> On Sun, 2007-07-29 at 20:24 +0100, Christoph Hellwig wrote:
> > On Sun, Jul 29, 2007 at 11:30:36AM -0600, Andreas Dilger wrote:
> > > Sigh, we HAVE a patch that was only adding delalloc to ext4, but it
> > > was rejected because "that functionality should go into the VFS".
> > > Since the performance improvement of delalloc is quite large, we'd
> > > like to get this into the kernel one way or another.  Can we make a
> > > decision if the ext4-specific delalloc is acceptable?
> > 
> > I'm a big proponent of having proper common delalloc code, but the
> > one proposed here is not generic for the existing filesystem using
> > delalloc.  
> 
> To be fair, what Alex have so far is probably good enough for ext2/3
> delayed allocation.
> 
> > It's still on my todo list to revamp the xfs code to get
> > rid of some of the existing mess and make it useable genericly.  If
> > the ext4 users are fine with the end result we could move to generic
> > code.
> > 
> 
> Are you okay with having a ext4 delayed allocation implementation (i.e.
> moving the code proposed in this thread to fs/ext4) first?  Then later
> when you come up with a generic delayed allocation for both ext4 and xfs
> we could make use of that generic implementation. Is that a acceptable
> approach? 
> 
> Andrew, what do you think?
> 

There's a decent risk that the generic implementation would never happen. 

I'd have thought that it'd be pretty tricky to make anything which is in
XFS suitable for general use, because after years of tuning and tweaking
it'll be full of xfs-specific things, but I haven't looked.

And a similar thing will happen if an ext4-specific version is merged.

The sad fact is that if we have a generic version, it turns out being a
least-common-denominator thing which never fully meets the requirements of
any of its users.  We end up filling the generic code up with
caller-selectable optional functionality for each filesystem.  (See
fs/direct-io.c).

The whole approach of making the pagecache/data handling be part of the VFS
hasn't been a great success, IMO.  It was fine for ext2 and similar (jfs,
minix, etc).  But for filesytems which do fancier things with data it
hasn't worked out well.  otoh, moving it all into the fs would have been a
bad decision too, so we just muddle through, making compromises.

So, umm, yes, on balance I do agree that we should explore doing some of
this in the VFS, and I believe that we should do it on the initial merge
rather than promising to ourselves that we'll fix it up later.  This will
devolve into the ext4 and xfs people working out which bits can and should
be moved into the VFS, and working out what they should look like.
