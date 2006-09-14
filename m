From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Thu, 14 Sep 2006 03:23:18 -0600
Message-ID: <20060914092318.GA18911@schatzie.adilger.int>
References: <20060913164202.GA14838@openx1.frec.bull.fr> <1158171071.6072.10.camel@lade.trondhjem.org> <20060913183001.GA1702@moule.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:42931 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1751504AbWINJX0
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Sep 2006 05:23:26 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060913183001.GA1702@moule.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 13, 2006  20:30 +0200, Alexandre Ratchov wrote:
> On Wed, Sep 13, 2006 at 02:11:11PM -0400, Trond Myklebust wrote:
> > On Wed, 2006-09-13 at 18:42 +0200, Alexandre Ratchov wrote:
> > > the change attribute is a simple counter that is reset to zero on
> > > inode creation and that is incremented every time the inode data is
> > > modified (similarly to the "ctime" time-stamp).
> > 
> > I would really have preferred a full-blown 64-bit counter as per
> > RFC3530, but I suppose we could always combine this change attribute
> > with the high word from ctime in order to make up the NFSv4 change
> > attribute. That should keep us safe until someone develops a ramdisk
> > with < 1 nsecond access time.
> 
> do you mean something like "(ctime.tv_sec << 32) | change_attribute"? this
> would allow 2^32 inode changes per second.

It might be preferrable, since we are depending on the ctime here anyways,
is to combine this with the nsec-resolution ctime, and kill two birds with
one field in the inode.

The implementation would be to update the ctime+nsec field as normal, but
in the unlikely case that both the second+nsec ctime is the same as before
the nsec value would be incremented by 1.  This could happen in case of
low-resolution kernel timers, and would also handle the future case where
the inode is modified more than once in the same nanosecond.

The other benefit is that it allows comparisons between two different
inodes to be more meaningful, instead of just using the seconds + random
version number.

It would be possible/desirable to make the nsec ctime field be part of the 
small inode (using the proposed reserved field) instead of the large inode,
since that is a requirement for working with existing ext3 filesystems.  The
previous nsec timestamp patch would only need trivial modifications to make
this work, just #define i_ctime_extra to be l_i_reserved1 I believe.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

