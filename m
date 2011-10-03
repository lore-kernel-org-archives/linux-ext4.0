From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [BUG] copy file result with zero
Date: Mon, 3 Oct 2011 17:51:57 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110031751010.4447@dhcp-27-109.brq.redhat.com>
References: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com> <20111001143900.GH28234@thunk.org> <CABqxG0eiRiCSirXi5rBB0bJ2AJSQjF2dje2BcjbVYEYWgf-zpw@mail.gmail.com> <A2FF8835-2386-47F9-AFF8-4E09BEC4F80E@oracle.com>
 <89E75765-AC24-4EF4-9547-6EE7A1A38B5A@dilger.ca> <CAGBYx2ZwCQDis-M0-qbdpBgbq34BR-OStMrcCK_+4u20CemXzg@mail.gmail.com> <alpine.LFD.2.00.1110031500430.4447@dhcp-27-109.brq.redhat.com> <20111003141823.GA6684@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Andreas Dilger <aedilger@gmail.com>,
	Jeff liu <jeff.liu@oracle.com>,
	Dave Young <hidave.darkstar@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab1JCPwI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 11:52:08 -0400
In-Reply-To: <20111003141823.GA6684@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 3 Oct 2011, Ted Ts'o wrote:

> On Mon, Oct 03, 2011 at 03:11:30PM +0200, Lukas Czerner wrote:
> > 
> > Oops, you're right. I think that the best solution would be to revert
> > the commit
> > 
> > c03f8aa9abdd517477c2021ea1251939b4da49e6
> > ext4: use FIEMAP_EXTENT_LAST flag for last extent in fiemap
> > 
> > and then fix the original problem with your delayed extent tree
> > solution, where we can easily check not only for next allocated extent,
> > but also for next delayed extent to see if the current one is last or
> > not.
> > ...
> >
> > I do not know how "ready" are your patches..Is it possible to wait for
> > them to be ready and fix it in your patch set ? That means, revert the
> > mentioned commit and reimplement fiemap with delayed extent tree.
> 
> Sigh, yeah, we need to fix this to avoid the hang in xfstests #252 but
> users losing data even if the coreutils release was only out there for
> 13 days is bad juju.
> 
> I'm working on reviewing the kernel patch backlog this week, and I'll
> give this series one priority.

Actually the series needs to be changed to to fix the problem. I'll
comment the appropriate patch.

Thanks!
-Lukas
> 
> Thanks to Yongqiang and Lukas for looking into this!
> 
> 							- Ted
