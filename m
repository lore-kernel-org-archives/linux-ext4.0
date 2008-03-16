From: Andreas Dilger <adilger@sun.com>
Subject: Re: strange ext{3,4}_settattr logic
Date: Sun, 16 Mar 2008 23:22:37 +0800
Message-ID: <20080316152237.GB3542@webber.adilger.int>
References: <20080315160731.GA4186@dmon-lap.sw.ru>
 <20080315230544.GV3542@webber.adilger.int>
 <20080315235427.GA26939@webber.adilger.int>
 <20080316002300.GB26939@webber.adilger.int>
 <20080316113912.GA3118@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:47030 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYCPPXS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Mar 2008 11:23:18 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2GFNHT1022951
	for <linux-ext4@vger.kernel.org>; Sun, 16 Mar 2008 08:23:17 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXT00C01XEJC000@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 16 Mar 2008 08:23:17 -0700 (PDT)
In-reply-to: <20080316113912.GA3118@dmon-lap.sw.ru>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 16, 2008  14:39 +0300, Dmitri Monakhov wrote:
> > --- linux-2.6.24/fs/namei.c.orig	2008-02-05 07:29:57.000000000 +0800
> > +++ linux-2.6.24/fs/namei.c	2008-03-16 08:11:41.000000000 +0800
> > @@ -233,6 +233,10 @@ int permission(struct inode *inode, int 
> >  	if (nd)
> >  		mnt = nd->mnt;
> >  
> > +	/* Don't allow direct read, write, or truncate on a swapfile */
>
> Your patch disallow expand truncates (#2) which is definitely not good. 

How often is that done though?  Since this is only for a swapfile then
it isn't needed.

> In fact if file was opened before S_SWAPFILE flag was setted when it is
> possible to directly read, write from file.

I assume that is even a more rare case.  I was thinking alternately to
do a "deny_write" on the swapfile during swapon() so that this would
fail in more cases.

> > +	if (IS_SWAPFILE(inode))
> > +		return -ETXTBUSY;
> > +
> >  	if (mask & MAY_WRITE) {
> >  		umode_t mode = inode->i_mode;
> 
> BTW it is impossible to disable swapfile with your patch 
> [root@ts63 tmp]# swapoff  /vz/swap 
> swapoff: /vz/swap: Text file busy

I thought some bug like this might appear.

> IMHO S_SWAPFILE flag must be checked in ext3_setattr, see patch attached:

No, that still means every other filesystem is broken.  Since the current
filesystem code doesn't know anything about IS_SWAPFILE I'd rather keep
it that way.  I think it is better to move my proposed IS_SWAPFILE() check
into "MAY_WRITE" and "MAY_EXEC" cases.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

