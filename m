From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstests generic/130 hang with non-4k block size ext4 on 4.7-rc1
 kernel
Date: Tue, 31 May 2016 11:40:17 -0400
Message-ID: <20160531154017.GC5357@thunk.org>
References: <20160531140922.GM5140@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Eryu Guan <eguan@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52572 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbcEaPkW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 May 2016 11:40:22 -0400
Content-Disposition: inline
In-Reply-To: <20160531140922.GM5140@eguan.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 31, 2016 at 10:09:22PM +0800, Eryu Guan wrote:
> 
> I noticed that generic/130 hangs starting from 4.7-rc1 kernel, on non-4k
> block size ext4 (x86_64 host). And I bisected to commit 06bd3c36a733
> ("ext4: fix data exposure after a crash").
> 
> It's the sub-test "Small Vector Sync" in generic/130 hangs the kernel,
> and I can reproduce it on different hosts, both bare metal and kvm
> guest.

Hmm, it's not reproducing for me, either using your simplified repro
or generic/130.  Is there something specific with your kernel config,
which is needed for the reproduction, perhaps?

						- Ted

FSTESTVER: e2fsprogs	v1.43-25-ge2406b9 (Wed, 25 May 2016 00:30:42 -0400)
FSTESTVER: fio		fio-2.6-8-ge6989e1 (Thu, 4 Feb 2016 12:09:48 -0700)
FSTESTVER: quota		67fd9cc (Mon, 4 Apr 2016 00:32:39 -0400)
FSTESTVER: xfsprogs	v4.3.0 (Mon, 23 Nov 2015 15:24:24 +1100)
FSTESTVER: xfstests-bld	ccae8d1 (Tue, 26 Apr 2016 00:42:18 -0400)
FSTESTVER: xfstests	linux-v3.8-1036-gd22e675 (Wed, 25 May 2016 00:58:35 -0400)
FSTESTVER: kernel	4.7.0-rc1-ext4 #293 SMP Tue May 31 11:31:24 EDT 2016 x86_64
FSTESTCFG: "1k"
FSTESTSET: "generic/130"
FSTESTEXC: ""
FSTESTOPT: "aex"
MNTOPTS: ""
CPUS: "2"
MEM: "2007.43"
             total       used       free     shared    buffers     cached
Mem:          2007         93       1913          9          3         29
-/+ buffers/cache:         60       1946
Swap:            0          0          0
BEGIN TEST 1k: Ext4 1k block Tue May 31 11:33:55 EDT 2016
DEVICE: /dev/vdd
MK2FS OPTIONS: -q -b 1024
MOUNT OPTIONS: -o block_validity
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 kvm-xfstests 4.7.0-rc1-ext4
MKFS_OPTIONS  -- -q -b 1024 /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc

generic/130		[11:33:55]run fstests generic/130 at 2016-05-31 11:33:55
 [11:33:59] 4s
Ran: generic/130
Passed all 1 tests

             total       used       free     shared    buffers     cached
Mem:          2007         71       1936          9          0         16
-/+ buffers/cache:         53       1953
Swap:            0          0          0
END TEST: Ext4 1k block Tue May 31 11:33:59 EDT 2016
reboot: Power down
