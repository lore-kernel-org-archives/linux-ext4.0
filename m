From: Dai Xiang <xiangx.dai@intel.com>
Subject: Re: How to install set_encpolicy for xfs_io
Date: Fri, 4 Aug 2017 09:49:27 +0800
Message-ID: <20170804014927.edt3ulvqi22qsbem@haikuoyu-mobl4.ccr.corp.intel.com>
References: <20170802084855.52xnbunchkggipbz@linux>
 <20170802112558.bogzbht7n7dlfpzk@hades.localdomain>
 <20170803013433.qki2jn7jg3j4fjcs@hqi2-mobl3.ccr.corp.intel.com>
 <c2c93913-9d4e-8a50-f7d3-1c88db7595f2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5441 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751811AbdHDBt3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 3 Aug 2017 21:49:29 -0400
Content-Disposition: inline
In-Reply-To: <c2c93913-9d4e-8a50-f7d3-1c88db7595f2@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 03, 2017 at 09:27:34AM +0300, Nikolay Borisov wrote:
> 
> 
> On  3.08.2017 04:34, Dai Xiang wrote:
> > On Wed, Aug 02, 2017 at 01:25:58PM +0200, Carlos Maiolino wrote:
> >> Hi,
> >>
> >>> Hi!
> >>>
> >>> When i do test with xfstests using ext4 fs, a issue occur and do not
> >>> find how to fix:
> >>>
> >>> FSTYP         -- ext4
> >>> PLATFORM      -- Linux/x86_64 local 4.13.0-rc3
> >>> MKFS_OPTIONS  -- /dev/sda8
> >>> MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda8 /fs/scratch
> >>>
> >>> ext4/024	 [not run] xfs_io set_encpolicy support is missing
> >>> <===
> >>> Not run: ext4/024
> >>> Passed all 0 tests
> >>>
> >>
> >> set_encpolicy was added to xfsprogs 4.10, I don't know if your distro ships it
> >> already, if not, you'll need to compile it by yourself from:
> >>
> >> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > 
> > I always use below link to download the xfsprogs:
> > git://oss.sgi.com/xfs/cmds/xfsprogs
> > 
> > What the difference between them? Does it mean above link has
> > abandoned?
> 
> SGI have essentially abandoned all xfs-related infrastructure hosting.
> As a result the mailing list got moved to kernel.org infrastructure and
> the development branches as well. I'd suggest to always use the xfs
> repos hosted on git.kernel.org

I want to install xfsprogs to a specified path but i do not find
configure but configure.ac, how can i use it?

Thanks
> 
> > 
> > Thanks
> > 
> >>
> >> cheers.
> >>
> >>> I use v4.7 xfsprogs and xfstests commit is a00c51a0.
> >>>
> >>> How can i install set_encpolicy?
> >>>
> >>> Thanks
> >>> Xiang
> >>
> >> -- 
> >> Carlos
