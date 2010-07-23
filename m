From: Jan Kara <jack@suse.cz>
Subject: Re: 2.6.35-r5 ext3 corruptions
Date: Fri, 23 Jul 2010 12:53:26 +0200
Message-ID: <20100723105326.GB6431@atrey.karlin.mff.cuni.cz>
References: <20100715105745.GI30737@dastard> <20100719224512.GD32635@dastard> <20100721063222.GW32635@dastard> <20100723104313.GA6431@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60075 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752683Ab0GWKx1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jul 2010 06:53:27 -0400
Content-Disposition: inline
In-Reply-To: <20100723104313.GA6431@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > On Tue, Jul 20, 2010 at 08:45:12AM +1000, Dave Chinner wrote:
> > > On Thu, Jul 15, 2010 at 08:57:45PM +1000, Dave Chinner wrote:
> > > > Upgrading my test vms from 2.6.35-rc3 to 2.6.35-rc5 is resulting in
> > > > repeated errors on the root drive of a test VM:
> > > > 
> > > > { 1532.368808] EXT3-fs error (device sda1): ext3_lookup: deleted inode referenced: 211043
> > > > [ 1532.370859] Aborting journal on device sda1.
> > > > [ 1532.376957] EXT3-fs (sda1): 
> > > > [ 1532.376976] EXT3-fs (sda1): error: ext3_journal_start_sb: Detected aborted journal
> > > > [ 1532.376980] EXT3-fs (sda1): error: remounting filesystem read-only
> > > > [ 1532.420361] error: remounting filesystem read-only
> > > > [ 1532.621209] EXT3-fs error (device sda1): ext3_lookup: deleted inode referenced: 211043
> > > > 
> > > > The filesysetm is a mess when checked on reboot - lots of illegal
> > > > references to blocks, multiply linked blocks, etc, but repairs.
> > > > Files are lots, truncated, etc, so there is visible filesystem
> > > > damage.
> > > > 
> > > > I did lots of testing on 2.6.35-rc3 and came across no problems;
> > > > problems only seemed to start with 2.6.35-rc5, and I've reproduced
> > > > the problem on a vanilla 2.6.35-rc4.
> > > > 
> > > > The problem seems to occur randomly - sometimes during boot or when
> > > > idle after boot, sometimes a while after boot. I haven't done any
> > > > digging at all for the cause - all I've done so far is confirm that
> > > > it is reproducable and it's not my code causing the problem.
> > > 
> > > Looks like this problem was isolated to a single VM and root
> > > filesystem. I could not reproduce it on anything other than the
> > > one filesystem that was failing.
> > 
> > Ok, so now I know *why* that one filesystem got busted - I built a
> > kernel without CONFIG_EXT3_DEFAULTS_TO_ORDERED set and it got a
> > forced reboot (echo b > proc/sysrq-trigger). That'll teach me for
> > trying to reproduce bugs Andrew is tripping over with his config
> > files.
> > 
> > Quite frankly, data=writeback mode for ext3 is a dangerous,
> > dangerous configuration to run by default. IMO, it shouldn't be the
> > default. Patch below.
>   data=writeback can cause larger data loss and stale data exposure but it
> actually shouldn't cause filesystem corruption about which you write in the
> changelog below. I'd much rather attribute the metadata corruption to a missing
> barrier option or barrier support in the virtualization stack. But I guess it's
> hard to tell now.
>   Anyways, I agree with you that data=ordered is a saner default so I'll
> push your change.
  I've taken the change just updating the changelog to:
ext3: default to ordered mode
    
data=writeback mode is dangerous as it leads to higher data loss and stale data
exposure when systems crash. It should not be the default, especially when all
major distros ensure their ext3 filesystems default to ordered mode. Change the
default mode to the safer data=ordered mode, because we should be caring far
more about avoiding stale data exposure than performance.

  Do you agree Dave?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
