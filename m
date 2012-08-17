From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Fri, 17 Aug 2012 14:01:10 +0800
Message-ID: <20120817060110.GA28786@localhost>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62264 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab2HQGBO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 02:01:14 -0400
Content-Disposition: inline
In-Reply-To: <20120816152513.GA31346@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 16, 2012 at 11:25:13AM -0400, Theodore Ts'o wrote:
> On Thu, Aug 16, 2012 at 07:10:51PM +0800, Fengguang Wu wrote:
> > 
> > Here is the dmesg. BTW, it seems 3.5.0 don't have this issue.
> 
> Fengguang,
> 
> It sounds like you have a (at least fairly) reliable reproduction for
> this problem?  Is it something you can share?  It would be good to get

Right, it can be easily reproduced here. I'm running these writeback
performance tests:

        https://github.com/fengguang/writeback-tests

Which is basically doing N parallel dd writes to JBOD/RAID arrays on
various filesystems. It seems that the RAID test can reliably trigger
the problem.

> this into our test suites, since it was _not_ something that was
> caught by xfstests, apparently.
> 
> Can you see if this patch addresses it?  (The first two patch hunks
> are the same debugging additions I had posted before.)
> 
> It looks like the responsible commit is 968dee7722: "ext4: fix hole
> punch failure when depth is greater than 0".  I had thought this patch
> was low risk if you weren't using the new punch ioctl, but it turns
> out it did make a critical change in the non-punch (i.e., truncate)
> code path, which is what the addition of "i = 0;" in the patch below
> addresses.

Yes, I'm sure the patch fixed the bug. With the fix, the writeback
tests have run flawlessly for a dozen hours without any problem.

Thanks,
Fengguang
