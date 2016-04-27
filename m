From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4 2/3] ext4: fix races between changing inode journal
 mode and ext4_writepages
Date: Wed, 27 Apr 2016 01:05:31 -0400
Message-ID: <20160427050531.GD30021@thunk.org>
References: <1457922900-30367-1-git-send-email-daeho.jeong@samsung.com>
 <1457922900-30367-2-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45892 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbcD0FFg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Apr 2016 01:05:36 -0400
Content-Disposition: inline
In-Reply-To: <1457922900-30367-2-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 14, 2016 at 11:34:59AM +0900, Daeho Jeong wrote:
> Now, in ext4, there is a race condition between changing inode journal
> mode and ext4_writepages(). While ext4_writepages() is executed on
> a non-journalled mode inode, the inode's journal mode could be enabled
> by ioctl() and then, some pages dirtied after switching the journal
> mode will be still exposed to ext4_writepages() in non-journaled mode.
> To resolve this problem, we use fs-wide per-cpu rw semaphore by
> Jan Kara's suggestion because we don't want to waste ext4_inode_info's
> space for this extra rare case.
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Hi Daeho,

This patch is causing a regression for xfstests generic/231 when using
a 1k block size (this case tests what happens when the blocksize <
page size, such as if you are using a 4k blocksize on a Power PC
system).

If you have kvm-xfstests or gce-xfstests[1] installed you can
reproduce it like this:

	gce-xfstests -c 1k -C 10 generic/231

(Or use kvm-xfstests if you don't want to get a GCE account).

[1] http://thunk.org/gce-xfstests

You will get this:

BEGIN TEST 1k: Ext4 1k block Wed Apr 27 00:48:01 EDT 2016
DEVICE: /dev/mapper/xt-vdd
MK2FS OPTIONS: -q -b 1024
MOUNT OPTIONS: -o block_validity
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 xfstests-201604270046 4.6.0-rc4-ext4-00010-geed525e
MKFS_OPTIONS  -- -q -b 1024 /dev/mapper/xt-vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/mapper/xt-vdc /xt-vdc

generic/231 64s ...	[00:48:03] [00:49:44] [failed, exit status 1] - output mismatch (see /results/results-1k/generic/231.out.bad)
    --- tests/generic/231.out	2016-04-27 00:15:36.000000000 -0400
    +++ /results/results-1k/generic/231.out.bad	2016-04-27 00:49:44.701895666 -0400
    @@ -4,13 +4,10041 @@
     Comparing user usage
     Comparing group usage
     === FSX Standard Mode, Memory Mapping, 4 Tasks ===
    -All 20000 operations completed A-OK!
    -All 20000 operations completed A-OK!
    -All 20000 operations completed A-OK!
    -All 20000 operations completed A-OK!
    ...
    (Run 'diff -u tests/generic/231.out /results/results-1k/generic/231.out.bad'  to see the entire diff)
Ran: generic/231
Failures: generic/231
Failed 1 of 1 tests

I'm going to drop patch 2 and 3 of your patch series from the ext4
tree for now.   Could you take a closer look?

Thanks,

						- Ted
						
