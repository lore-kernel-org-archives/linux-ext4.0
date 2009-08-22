From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: ext4 state user question
Date: Sat, 22 Aug 2009 11:32:23 -0700
Message-ID: <4A9039B7.9040908@sandeen.net>
References: <200908221921.15949.Christian.Fischer@easterngraphics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Christian Fischer <Christian.Fischer@easterngraphics.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:23451 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933119AbZHVSc3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Aug 2009 14:32:29 -0400
In-Reply-To: <200908221921.15949.Christian.Fischer@easterngraphics.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christian Fischer wrote:
> Hello,
> 
> I have not found a ext4-user list or something similar, that's why my user 
> question goes to this development list.

I think user questions are fine here, but thanks for asking.  :)

> I had a lot of file system crashes with xfs the last time, Eric knows that, if 
> he remembers.
> 
> I look for an alternate file system for our new production servers, and I need 
> to use 2.6.29.4 for the moment due to all systems running on xen, and as far 
> as I know 2.6.29.4 xen patched ist the best solution at the moment.
> 
> I've updated all xen kernels from 2.6.18 (which is the latest official xen 
> kernel) to 2.6.29.4 because xfs tried to write to the superblock to run into 
> the next bug, a radix_tree problem with xfs over nfs. I've backported 2.6.30 
> patches to avoid the problem, that runs at the moment.
> 
> But I don't feel like waiting for the next crash.
> 
> I was never before as unshure as now which file system is to choose, IMO I 
> have the choice between zfs on solaris, xfs or ext4.
> Zfs is not really ported to linux, the stable time of xfs seems gone, and ext4 
> is relatively young.

I think the xfs problems are sorted; you hit a bad spot, but Christoph 
got it worked out.

> What do you think, is ext4 with 2.6.29.4 ready for productive work and to 
> prefer over xfs at the moment?

As for ext4, I don't know of any current problems that would stop you 
from using it for this purpose.  But had you asked about xfs a month ago 
I would have said the same thing.  :)  I can say that ext4 is the 
default for F11, and I have had very few bug reports from users.

All software has bugs, unfortunately, though we do our best.  In the 
end, testing in your environment is the only way to know for sure what 
best suits your needs, I think.

-Eric

> Best Regards
> Christian

