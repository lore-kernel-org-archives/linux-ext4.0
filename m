From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] e2fsprogs: fix build w/o quota
Date: Thu, 24 Oct 2013 11:20:48 -0200
Message-ID: <20131024132047.GB27701@orion.maiolino.org>
References: <52615CC0.7010007@redhat.com>
 <20131023125147.GA31449@orion.maiolino.org>
 <20131023152251.GC21448@thunk.org>
 <5267F952.5040402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab3JXNUx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Oct 2013 09:20:53 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9ODKq3L024374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 24 Oct 2013 09:20:53 -0400
Received: from orion.maiolino.org (ovpn-113-27.phx2.redhat.com [10.3.113.27])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r9ODKnrA000585
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 24 Oct 2013 09:20:51 -0400
Content-Disposition: inline
In-Reply-To: <5267F952.5040402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, Oct 23, 2013 at 11:29:06AM -0500, Eric Sandeen wrote:
> On 10/23/13 10:22 AM, Theodore Ts'o wrote:
> > On Wed, Oct 23, 2013 at 10:51:48AM -0200, Carlos Maiolino wrote:
> >> Hey Eric,
> >>
> >> I did a test here building the e2fsprogs -next tree without quota support and I
> >> didn't have any problems configuring and compiling it. Can you share the test
> >> you did and failed?
> >>
> > 
> > I've been able to replicate the problem. You may need to rm -rf your
> > build directory and then run from scratch to see it.
> 
> yes, make clean doesn't remove it, even git clean doesn't; it's in
> .gitignore (why?)
> 

Yes, that's why it wasn't failing :)

Thanks guys

> > Sorry for not responding sooner; I'm in Edinburgh this week and in
> > conference mode.
> 
> no problem, I guess that's why I asked :)
> 
> > The reason why we have continud building libquota even when libsupport
> > is not defined is because the plan is to rename libquota to libsupport
> > once 1.42.x is released.  Libquota/libsupport is desinged to never be
> > built as a shared library, and the idea is to move things like
> > e2fsck/profile.c which is used by e2fsck and mke2fs, into libsupport.
> > The rational for that is that the functions in libquota are already
> > horribly e2fsprogs specific and aren't really set up to be usable as a
> > generic quota support library.  So we might as well make it be a
> > standardized place for internal support functions used by multiple
> > e2fsprogs programs.
> > 
> > I'll try to find a fix that minimizes deltas between the maint branch
> > and the next branch.
> 
> Maybe just revert part of "quota: fix disabling quota, add quota tests" ?
> 
> Did that actually do more good than harm?
> 
> -Eric
> 
> > Cheers,
> > 
> > 					- Ted
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
