From: Dmitri Monakhov <dmonakhov@openvz.org>
Subject: Re: strange ext{3,4}_settattr logic
Date: Sun, 16 Mar 2008 20:48:16 +0300
Message-ID: <20080316174816.GB3118@dmon-lap.sw.ru>
References: <20080315160731.GA4186@dmon-lap.sw.ru> <20080315230544.GV3542@webber.adilger.int> <20080315235427.GA26939@webber.adilger.int> <20080316002300.GB26939@webber.adilger.int> <20080316113912.GA3118@dmon-lap.sw.ru> <20080316152237.GB3542@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:16878 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbYCPRxy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Mar 2008 13:53:54 -0400
Content-Disposition: inline
In-Reply-To: <20080316152237.GB3542@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 23:22 Sun 16 Mar     , Andreas Dilger wrote:
> On Mar 16, 2008  14:39 +0300, Dmitri Monakhov wrote:
> > > --- linux-2.6.24/fs/namei.c.orig	2008-02-05 07:29:57.000000000 +0800
> > > +++ linux-2.6.24/fs/namei.c	2008-03-16 08:11:41.000000000 +0800
> > > @@ -233,6 +233,10 @@ int permission(struct inode *inode, int 
> > >  	if (nd)
> > >  		mnt = nd->mnt;
> > >  
> > > +	/* Don't allow direct read, write, or truncate on a swapfile */
> >
> > Your patch disallow expand truncates (#2) which is definitely not good. 
> 
> How often is that done though?  Since this is only for a swapfile then
> it isn't needed.
I hope what this technique may be used for implementing non plain device image
formats support in loop device driver, currently all such drivers implemented
in userspace ( for example qcow:
http://brick.kernel.dk/git/?p=qemu.git;a=blob;h=730ae67ed8f7095ca4d22e80aca57678be18fb6c;hb=2fd2f67411787297687e4eecbb1db76ac7d06e45;f=block-qcow.c) 
which cause bad performance and reliability.
> 
> > In fact if file was opened before S_SWAPFILE flag was setted when it is
> > possible to directly read, write from file.
> 
> I assume that is even a more rare case.  I was thinking alternately to
> do a "deny_write" on the swapfile during swapon() so that this would
> fail in more cases.
> 
> > > +	if (IS_SWAPFILE(inode))
> > > +		return -ETXTBUSY;
> > > +
> > >  	if (mask & MAY_WRITE) {
> > >  		umode_t mode = inode->i_mode;
> > 
> > BTW it is impossible to disable swapfile with your patch 
> > [root@ts63 tmp]# swapoff  /vz/swap 
> > swapoff: /vz/swap: Text file busy
> 
> I thought some bug like this might appear.
> 
> > IMHO S_SWAPFILE flag must be checked in ext3_setattr, see patch attached:
> 
> No, that still means every other filesystem is broken.  Since the current
> filesystem code doesn't know anything about IS_SWAPFILE I'd rather keep
> it that way.  I think it is better to move my proposed IS_SWAPFILE() check
> into "MAY_WRITE" and "MAY_EXEC" cases.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
