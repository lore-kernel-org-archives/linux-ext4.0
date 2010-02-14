From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
Date: Mon, 15 Feb 2010 00:12:25 +0100
Message-ID: <201002150012.25572.rjw@sisk.pl>
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net
To: James Cloos <cloos@jhcloos.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sunday 14 February 2010, James Cloos wrote:
> Sometime between rc6 and rc7 all filesystem I/O started using 100% CPU,
> usually on the order of 60% sys, 40% user.
> 
> I've tried this with each of ext4, jfs and btrfs filesystems.  All show
> the same issue.
> 
> Using dd(1) to read from the block specials directly works as well and
> as fast as it always has; only reading or writing to mounted filesystems
> is affected.
> 
> Box is 32-bit x86, PentiumIII-M; drives are ide using libata.
> 
> If the btrfs fs is mounted, the slowdown is enought to trigger the
> hung_task call trace (120s) on the btrfs-transac process.
> 
> But the regression is just as apparent when only jfs and ext4 are mounted.
> 
> The only filesystems I've found which avoid the regression are tmpfs and
> devtmpfs.
> 
> I didn't have time to write up a report when I noticed this in rc7 but
> had to boot back into rc6 for work.
> 
> Some of the commits since rc7 looked like they might have addressed this
> regression, but it persists in rc8.

I have created the bug entry at http://bugzilla.kernel.org/show_bug.cgi?id=15306
for your report.

Thanks,
Rafael
