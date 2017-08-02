From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: How to install set_encpolicy for xfs_io
Date: Wed, 2 Aug 2017 13:25:58 +0200
Message-ID: <20170802112558.bogzbht7n7dlfpzk@hades.localdomain>
References: <20170802084855.52xnbunchkggipbz@linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dai Xiang <xiangx.dai@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752958AbdHBL0C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 2 Aug 2017 07:26:02 -0400
Content-Disposition: inline
In-Reply-To: <20170802084855.52xnbunchkggipbz@linux>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> Hi!
> 
> When i do test with xfstests using ext4 fs, a issue occur and do not
> find how to fix:
> 
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 local 4.13.0-rc3
> MKFS_OPTIONS  -- /dev/sda8
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda8 /fs/scratch
> 
> ext4/024	 [not run] xfs_io set_encpolicy support is missing
> <===
> Not run: ext4/024
> Passed all 0 tests
>

set_encpolicy was added to xfsprogs 4.10, I don't know if your distro ships it
already, if not, you'll need to compile it by yourself from:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

cheers.

> I use v4.7 xfsprogs and xfstests commit is a00c51a0.
> 
> How can i install set_encpolicy?
> 
> Thanks
> Xiang

-- 
Carlos
