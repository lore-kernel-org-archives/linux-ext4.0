From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.35-r5 ext3 corruptions
Date: Tue, 20 Jul 2010 08:45:12 +1000
Message-ID: <20100719224512.GD32635@dastard>
References: <20100715105745.GI30737@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100715105745.GI30737@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 15, 2010 at 08:57:45PM +1000, Dave Chinner wrote:
> Upgrading my test vms from 2.6.35-rc3 to 2.6.35-rc5 is resulting in
> repeated errors on the root drive of a test VM:
> 
> { 1532.368808] EXT3-fs error (device sda1): ext3_lookup: deleted inode referenced: 211043
> [ 1532.370859] Aborting journal on device sda1.
> [ 1532.376957] EXT3-fs (sda1): 
> [ 1532.376976] EXT3-fs (sda1): error: ext3_journal_start_sb: Detected aborted journal
> [ 1532.376980] EXT3-fs (sda1): error: remounting filesystem read-only
> [ 1532.420361] error: remounting filesystem read-only
> [ 1532.621209] EXT3-fs error (device sda1): ext3_lookup: deleted inode referenced: 211043
> 
> The filesysetm is a mess when checked on reboot - lots of illegal
> references to blocks, multiply linked blocks, etc, but repairs.
> Files are lots, truncated, etc, so there is visible filesystem
> damage.
> 
> I did lots of testing on 2.6.35-rc3 and came across no problems;
> problems only seemed to start with 2.6.35-rc5, and I've reproduced
> the problem on a vanilla 2.6.35-rc4.
> 
> The problem seems to occur randomly - sometimes during boot or when
> idle after boot, sometimes a while after boot. I haven't done any
> digging at all for the cause - all I've done so far is confirm that
> it is reproducable and it's not my code causing the problem.

Looks like this problem was isolated to a single VM and root
filesystem. I could not reproduce it on anything other than the
one filesystem that was failing.

Unfortunately, I had a fat-fingered moment and backed up the wrong
filesystem image at the outset. So after I smashed the original
filesystem into oblivion (one failure lead to half the filesystem in
lost+found), I had nothing to restore from to continue testing.

So I re-imaged the root filesystem and the problem has not occurred
despite trying for more than a day. When it was bad, it didn't take
more than a few minutes of activity to reproduce. Hence I can only
conclude there was something wrong with the filesystem itself that
wasn't being detected, not some more generic problem....

I'll go add this to the bugzilla and close it down.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
