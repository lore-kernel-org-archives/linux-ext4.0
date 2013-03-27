From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Eric Whitney's ext4 scaling data
Date: Wed, 27 Mar 2013 15:21:02 +0800
Message-ID: <20130327072101.GA10346@gmail.com>
References: <nsxhajyzu6n.fsf@closure.thunk.org>
 <20130327033322.GB9887@gmail.com>
 <20130327033554.GE5861@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:45487 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3C0HFU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Mar 2013 03:05:20 -0400
Received: by mail-pb0-f49.google.com with SMTP id um15so1374629pbc.8
        for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 00:05:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130327033554.GE5861@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 26, 2013 at 11:35:54PM -0400, Theodore Ts'o wrote:
> On Wed, Mar 27, 2013 at 11:33:23AM +0800, Zheng Liu wrote:
> > 
> > Thanks for sharing this with us.  I have an rough idea that we can create
> > a project, which have some test cases to test the performance of file
> > system.....
> 
> There is bitrotted benchmarking support into xfstests.  I know some of
> the folks at SGI have wished that it could be nursed back to health,
> but having not looked at it, it's not clear to me whether it's better
> to try to add benchmarking capabilities into xfstests, or as a
> separate project.

The key issue that we add test case into xfstests is that we need to
handle some filesystem-specific feature.  Just like we had discussed
with Dave, what is an extent?  IMHO now xfstests gets more compliated
because it needs to handle this problem. e.g. punch hole for
indirect-based file in ext4.

> 
> The real challenge with doing this is that it tends to be very system
> specific; if you change the amount of memory, number of CPU's, type of
> storage, etc., you'll get very different results.  So any kind of
> system which is trying to detect performance regression really needs
> to be run on a specific system, and what's important is the delta from
> previous kernel versions.

Yes, the test depends on the specific system.  That means that if
someone want to make sure there is no performance regression, they need
to have a baseline result, and run this test again on the same machine.
So everyone has their own result.  But it doesn't affect us to highlight
a performance regression.  If I run a test and find a regression, I will
post it in mailing list, and other folks can notice it, run the same
tests in their own environment, and get the result.  I think it is
reproducible on other environments if it is a regression.

> 
> The other thing I'll note is that Eric's results were especially
> interesting because he had (in the past) access to a system with a
> combination of a fast storage (via a large RAID array), and a large
> number of CPU cores, which is useful for testing scalability.

Yes, in a internet company, we don't have any high-end mahcine.  We just
have a lot of commodity x86 servers. :-(

> 
> These days, a fast PCIe attached storage can someone replace a large
> RAID array, but most of us don't necessarily have access to a very
> large (4 or more CPU sockets) system.

Yeah, we couldn't test all kinds of devices.  That is impossible.

Regards,
                                                - Zheng
