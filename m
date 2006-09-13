From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Wed, 13 Sep 2006 20:30:01 +0200
Message-ID: <20060913183001.GA1702@moule.localdomain>
References: <20060913164202.GA14838@openx1.frec.bull.fr> <1158171071.6072.10.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moule.caoua.org ([213.41.141.163]:20086 "EHLO moule.caoua.org")
	by vger.kernel.org with ESMTP id S1750829AbWIMSaZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Sep 2006 14:30:25 -0400
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Content-Disposition: inline
In-Reply-To: <1158171071.6072.10.camel@lade.trondhjem.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 13, 2006 at 02:11:11PM -0400, Trond Myklebust wrote:
> On Wed, 2006-09-13 at 18:42 +0200, Alexandre Ratchov wrote:
> > hello, 
> > 
> > here is a small patch that adds the "change attribute" for ext3
> > file-systems;
> > 
> > the change attribute is a simple counter that is reset to zero on
> > inode creation and that is incremented every time the inode data is
> > modified (similarly to the "ctime" time-stamp).
> 
> I would really have preferred a full-blown 64-bit counter as per
> RFC3530, but I suppose we could always combine this change attribute
> with the high word from ctime in order to make up the NFSv4 change
> attribute. That should keep us safe until someone develops a ramdisk
> with < 1 nsecond access time.
> 

do you mean something like "(ctime.tv_sec << 32) | change_attribute"? this
would allow 2^32 inode changes per second.

For ext3 it's hard to find unused bits in the on-disk inode structure, but
ext4 inode may become larger in the future, allowing a 64bit counter.

-- Alexandre
