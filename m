From: Dai Xiang <xiangx.dai@intel.com>
Subject: How to install xfs_scrub
Date: Thu, 3 Aug 2017 11:09:38 +0800
Message-ID: <20170803030938.okiqdakxrhlqwu3i@hqi2-mobl3.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Xiang Dai <xiangx.dai@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:51224 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751188AbdHCDJj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 2 Aug 2017 23:09:39 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!
When i do xfstests with ext4 fs, one case fail as below:

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 local 4.13.0-rc3
MKFS_OPTIONS  -- /dev/sda8
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda8 /fs/scratch 

ext4/023         [not run] xfs_scrub not found <===
Not run: ext4/023
Passed all 0 tests

It is clear that i do not have xfs_scrub cmd.
I have read related docs but do not find where or how can i get it.
I use v4.7 xfsprogs and xfstests commit is a00c51a0.
Could you help me?

Thanks

Xiang
