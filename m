From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] Copy i_flags to ext3 inode flags on write (version 2)
Date: Tue, 24 Apr 2007 15:44:18 +0000
Message-ID: <1177429458.15516.31.camel@kleikamp.austin.ibm.com>
References: <20070417103855.GB11815@duck.suse.cz>
	 <1177427677.15516.21.camel@kleikamp.austin.ibm.com>
	 <20070424153534.GB20356@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36086 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbXDXPoa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2007 11:44:30 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3OFiUPY015891
	for <linux-ext4@vger.kernel.org>; Tue, 24 Apr 2007 11:44:30 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3OFiTgr475262
	for <linux-ext4@vger.kernel.org>; Tue, 24 Apr 2007 11:44:29 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3OFiJqn030281
	for <linux-ext4@vger.kernel.org>; Tue, 24 Apr 2007 11:44:19 -0400
In-Reply-To: <20070424153534.GB20356@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-04-24 at 17:35 +0200, Jan Kara wrote:
> On Tue 24-04-07 10:14:37, Dave Kleikamp wrote:

> > I think you need a call to ext3_get_inode_flags in one more place.  In
> > ext3_ioctl(), EXT3_IOC_SETFLAGS modifies the flags based on what is in
> > ei->i_flags, so this code should make sure that ei->i_flags is in sync
> > with inode->i_flags.
>   Hmm, I don't think so. The code does:
>                 flags = flags & EXT3_FL_USER_MODIFIABLE;
>                 flags |= oldflags & ~EXT3_FL_USER_MODIFIABLE;
>                 ei->i_flags = flags;
>   So all EXT3_FL_USER_MODIFIABLE are overwritten by what user has supplied,
> which happens to be a superset of flags influenced by
> ext3_get_inode_flags(). On the other hand, from some point of view, after your
> change the code is safer (in case we add some new unmodifiable flags) so I
> don't object against adding the call. I just wanted to point out, that
> currently there's no difference...

Okay.  I see that that's the case.  I was thinking that individual flags
could be set through the ioctl, but it takes the whole set.  I don't
really see the need to keep my patch from a safety perspective, but do
what you want.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
