From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH -V4] ext4: Fix lockdep recursive locking warning
Date: Sat, 22 Nov 2008 21:49:11 -0500
Message-ID: <20081123024911.GG9150@mit.edu>
References: <1227285646-16263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081122204625.GF9150@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49014 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199AbYKWEoT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Nov 2008 23:44:19 -0500
Content-Disposition: inline
In-Reply-To: <20081122204625.GF9150@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 22, 2008 at 03:46:25PM -0500, Theodore Tso wrote:
> On Fri, Nov 21, 2008 at 10:10:46PM +0530, Aneesh Kumar K.V wrote:
> > Indicate that the group locks can be taken in loop.
> 
> I've been looking at this patch more closely, and I think there's a
> major problem here.

OK, after looking at this in yet more detail (and having changed
planes in Dallas :-), I am more than ever convinced this patch is not
rightq.  We have an rw_sem for each block group, grp->alloc_sem, which
is allocated in groups of meta blockgroups.  The whole reason why we
should worry about keeping them in the same class is we should worry
about is if for some reason, the multiblock allocator happens to
allocate two block group's alloc_sem, but one does them out of order
(say, bg 4, then bg 2, while another does bg 2, then 4), we would get
a dead lock.

I'm guessing that what caused the problem for you was
ext4_mb_init_group(), which if you are using 1k filesystems, tries to
grab multiple grp->alloc_sem's.  In each place where we find those, we
need to use down_write_nested --- see Documentation/lockdep-design.txt.  

If there are any other places in mballoc.c which grabs multiple
alloc_sem's at the same time, we'll have to use define new subclasses.

						- Ted
