From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Thu, 14 Sep 2006 16:06:40 +0200
Message-ID: <20060914140640.GF28663@openx1.frec.bull.fr>
References: <20060913164202.GA14838@openx1.frec.bull.fr> <1158171071.6072.10.camel@lade.trondhjem.org> <45095D1B.8040201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53192 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1750747AbWINOGs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Sep 2006 10:06:48 -0400
To: Peter Staubach <staubach@redhat.com>
In-Reply-To: <45095D1B.8040201@redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 14, 2006 at 09:46:03AM -0400, Peter Staubach wrote:
> Trond Myklebust wrote:
> >On Wed, 2006-09-13 at 18:42 +0200, Alexandre Ratchov wrote:
> >  
> >>hello, 
> >>
> >>here is a small patch that adds the "change attribute" for ext3
> >>file-systems;
> >>
> >>the change attribute is a simple counter that is reset to zero on
> >>inode creation and that is incremented every time the inode data is
> >>modified (similarly to the "ctime" time-stamp).
> >>    
> >
> >I would really have preferred a full-blown 64-bit counter as per
> >RFC3530, but I suppose we could always combine this change attribute
> >with the high word from ctime in order to make up the NFSv4 change
> >attribute. That should keep us safe until someone develops a ramdisk
> >with < 1 nsecond access time.
> 
> Wouldn't the generation count work better than ctime to differentiate 
> between
> instances of files using the same inode number?  That way, there wouldn't be
> a clock resolution issue.

Yes, and afaik it's already used for that purpose by NFSv{2,3}. 

Note that the change attribute is for counting changes of the same instance
of a file using a given inode (as opposed to the generation counter that's
used to count the number of files that have used a given inode).

-- Alexandre
