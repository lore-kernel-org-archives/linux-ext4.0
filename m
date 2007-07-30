From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Mon, 30 Jul 2007 10:49:14 -0700
Message-ID: <1185817755.4023.7.camel@localhost.localdomain>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org>
	 <20070728195114.GA5952@infradead.org>
	 <20070729173035.GU5992@schatzie.adilger.int>
	 <20070729192437.GB14530@infradead.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>, Alex Tomas <alex@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36888 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbXG3RtR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2007 13:49:17 -0400
In-Reply-To: <20070729192437.GB14530@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 2007-07-29 at 20:24 +0100, Christoph Hellwig wrote:
> On Sun, Jul 29, 2007 at 11:30:36AM -0600, Andreas Dilger wrote:
> > Sigh, we HAVE a patch that was only adding delalloc to ext4, but it
> > was rejected because "that functionality should go into the VFS".
> > Since the performance improvement of delalloc is quite large, we'd
> > like to get this into the kernel one way or another.  Can we make a
> > decision if the ext4-specific delalloc is acceptable?
> 
> I'm a big proponent of having proper common delalloc code, but the
> one proposed here is not generic for the existing filesystem using
> delalloc.  

To be fair, what Alex have so far is probably good enough for ext2/3
delayed allocation.

> It's still on my todo list to revamp the xfs code to get
> rid of some of the existing mess and make it useable genericly.  If
> the ext4 users are fine with the end result we could move to generic
> code.
> 

Are you okay with having a ext4 delayed allocation implementation (i.e.
moving the code proposed in this thread to fs/ext4) first?  Then later
when you come up with a generic delayed allocation for both ext4 and xfs
we could make use of that generic implementation. Is that a acceptable
approach? 

Andrew, what do you think?


Regards,
Mingming
