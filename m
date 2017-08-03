From: Dai Xiang <xiangx.dai@intel.com>
Subject: Re: How to install set_encpolicy for xfs_io
Date: Thu, 3 Aug 2017 09:34:33 +0800
Message-ID: <20170803013433.qki2jn7jg3j4fjcs@hqi2-mobl3.ccr.corp.intel.com>
References: <20170802084855.52xnbunchkggipbz@linux>
 <20170802112558.bogzbht7n7dlfpzk@hades.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:19301 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751727AbdHCBee (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 2 Aug 2017 21:34:34 -0400
Content-Disposition: inline
In-Reply-To: <20170802112558.bogzbht7n7dlfpzk@hades.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 02, 2017 at 01:25:58PM +0200, Carlos Maiolino wrote:
> Hi,
> 
> > Hi!
> > 
> > When i do test with xfstests using ext4 fs, a issue occur and do not
> > find how to fix:
> > 
> > FSTYP         -- ext4
> > PLATFORM      -- Linux/x86_64 local 4.13.0-rc3
> > MKFS_OPTIONS  -- /dev/sda8
> > MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda8 /fs/scratch
> > 
> > ext4/024	 [not run] xfs_io set_encpolicy support is missing
> > <===
> > Not run: ext4/024
> > Passed all 0 tests
> >
> 
> set_encpolicy was added to xfsprogs 4.10, I don't know if your distro ships it
> already, if not, you'll need to compile it by yourself from:
> 
> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

I always use below link to download the xfsprogs:
git://oss.sgi.com/xfs/cmds/xfsprogs

What the difference between them? Does it mean above link has
abandoned?

Thanks

> 
> cheers.
> 
> > I use v4.7 xfsprogs and xfstests commit is a00c51a0.
> > 
> > How can i install set_encpolicy?
> > 
> > Thanks
> > Xiang
> 
> -- 
> Carlos
