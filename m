From: Dai Xiang <xiangx.dai@intel.com>
Subject: Re: How to install set_encpolicy for xfs_io
Date: Fri, 4 Aug 2017 16:17:17 +0800
Message-ID: <20170804081717.6iqnus5tgcbodikq@haikuoyu-mobl4.ccr.corp.intel.com>
References: <20170802084855.52xnbunchkggipbz@linux>
 <20170802112558.bogzbht7n7dlfpzk@hades.localdomain>
 <20170803013433.qki2jn7jg3j4fjcs@hqi2-mobl3.ccr.corp.intel.com>
 <c2c93913-9d4e-8a50-f7d3-1c88db7595f2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27827 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751283AbdHDIRX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 4 Aug 2017 04:17:23 -0400
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

Hi, i do install as below and cp /xfsprogs to other host, i still can
not get set_encpolicy:

	make configure || return
	./configure --prefix=/xfsprogs/usr --exec_prefix=/xfsprogs/usr
	make || return
	make install
	make install-dev

I git clone newest codes and HEAD is:
commit 0602fbe880e59c3aff13a081632b79532a40a328 (HEAD -> master, tag: v4.12.0, origin/master, origin/HEAD)
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Jul 20 10:57:14 2017 -0500

    xfsprogs: Release v4.12.0
    
    Update all the necessary files for a 4.12.0 release.
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Do i miss something important?

Thanks
Xiang

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
