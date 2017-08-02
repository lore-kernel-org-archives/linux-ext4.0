From: Dai Xiang <xiangx.dai@intel.com>
Subject: How to install set_encpolicy for xfs_io
Date: Wed, 2 Aug 2017 16:48:55 +0800
Message-ID: <20170802084855.52xnbunchkggipbz@linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Xiang Dai <xiangx.dai@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:64766 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752214AbdHBItC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 2 Aug 2017 04:49:02 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

When i do test with xfstests using ext4 fs, a issue occur and do not
find how to fix:

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 local 4.13.0-rc3
MKFS_OPTIONS  -- /dev/sda8
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda8 /fs/scratch

ext4/024	 [not run] xfs_io set_encpolicy support is missing
<===
Not run: ext4/024
Passed all 0 tests

I use v4.7 xfsprogs and xfstests commit is a00c51a0.

How can i install set_encpolicy?

Thanks
Xiang
