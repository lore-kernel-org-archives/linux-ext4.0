From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to install xfs_scrub
Date: Wed, 2 Aug 2017 23:56:08 -0400
Message-ID: <20170803035608.yk5dxgf6rcf2xxsj@thunk.org>
References: <20170803030938.okiqdakxrhlqwu3i@hqi2-mobl3.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dai Xiang <xiangx.dai@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60112 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752294AbdHCD4N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 2 Aug 2017 23:56:13 -0400
Content-Disposition: inline
In-Reply-To: <20170803030938.okiqdakxrhlqwu3i@hqi2-mobl3.ccr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 03, 2017 at 11:09:38AM +0800, Dai Xiang wrote:
> Hi!
> When i do xfstests with ext4 fs, one case fail as below:
> 
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 local 4.13.0-rc3
> MKFS_OPTIONS  -- /dev/sda8
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda8 /fs/scratch 
> 
> ext4/023         [not run] xfs_scrub not found <===
> Not run: ext4/023
> Passed all 0 tests
> 
> It is clear that i do not have xfs_scrub cmd.
> I have read related docs but do not find where or how can i get it.
> I use v4.7 xfsprogs and xfstests commit is a00c51a0.
> Could you help me?

That's not a failure; it's just a skipped test.  (The check script
reports "Not run" separately from "Failures".)

xfs_scrub is something which is still in development.  It's in
Darrick's development tree in his xfsprogs-dev git tree on kernel.org,
but it's not in an officially supported release of xfsprogs yet, as
near as I can tell.

So it's not a big deal; you can just ignore the fact that it was
skipped.

Cheers,

					- Ted
