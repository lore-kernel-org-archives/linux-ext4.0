From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Fri, 06 Oct 2006 07:50:32 -0500
Message-ID: <1160139032.8658.17.camel@kleikamp.austin.ibm.com>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	 <20061005131939.ccd1fd48.akpm@osdl.org>
	 <Pine.LNX.4.64.0610051619540.3952@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:43152 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751257AbWJFMug
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Oct 2006 08:50:36 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k96CoZj9018837
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 08:50:35 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k96CoZKc162488
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 06:50:35 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k96CoYhO018112
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 06:50:35 -0600
To: Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0610051619540.3952@g5.osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2006-10-05 at 16:25 -0700, Linus Torvalds wrote:
> 
> On Thu, 5 Oct 2006, Andrew Morton wrote:
> > 
> > Linus, what's the best way of doing this?  Will git dtrt with a patch which
> > copies files, or would a script which does the mkdir's and cp's be better?
> 
> Git should dtrt.
> 
> In fact, if you use
> 
> 	git diff -C
> 
> it should generate the appropriate "file copied" things automatically, and 
> you don't need any huge file at all, you'll get a "patch" that looks 
> something like
> 
> 	diff --git a/fs/ext3/inode.c b/fs/ext4/inode.c
> 	similarity index 100%
> 	copy from fs/ext3/inode.c
> 	copy to fs/ext4/inode.c
> 	diff --git a/fs/ext3/super.c b/fs/ext4/super.c
> 	similarity index 98%
> 	copy from fs/ext3/super.c
> 	copy to fs/ext4/super.c
> 	index xyz..zzy 100644
> 	--- a/fs/ext3/super.c
> 	+++ b/fs/ext4/super.c
> 	  .. small diff that changes "ext3" to "ext4" goes here ..
> 
> 
> ie you'll effectively get the best of both worlds: a "diff", but one that 
> is actually readable and shows what is going on.

We haven't been using git to manage ext4 so far, although in hindsight
it probably would have made things easier.  I'm assuming that you're
just suggesting this for educational purposes and that git will handle
the patches that Andrew picked up into -mm just fine.

I could re-generate the patches that do the copies from git, but I don't
believe it will be that beneficial at this point.

> I hate to beat my own drum (not really), but git really _is_ a lot better 
> than anything else out there ;)

No argument here :-)

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

