From: James Cloos <cloos@jhcloos.com>
Subject: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
Date: Sat, 13 Feb 2010 22:11:07 -0500
Message-ID: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Sometime between rc6 and rc7 all filesystem I/O started using 100% CPU,
usually on the order of 60% sys, 40% user.

I've tried this with each of ext4, jfs and btrfs filesystems.  All show
the same issue.

Using dd(1) to read from the block specials directly works as well and
as fast as it always has; only reading or writing to mounted filesystems
is affected.

Box is 32-bit x86, PentiumIII-M; drives are ide using libata.

If the btrfs fs is mounted, the slowdown is enought to trigger the
hung_task call trace (120s) on the btrfs-transac process.

But the regression is just as apparent when only jfs and ext4 are mounted.

The only filesystems I've found which avoid the regression are tmpfs and
devtmpfs.

I didn't have time to write up a report when I noticed this in rc7 but
had to boot back into rc6 for work.

Some of the commits since rc7 looked like they might have addressed this
regression, but it persists in rc8.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
