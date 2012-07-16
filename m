From: Kevin Shanahan <kmshanah@disenchant.net>
Subject: Re: Ext4 external journal UUID mismatch?
Date: Mon, 16 Jul 2012 19:30:10 +0930
Message-ID: <20120716100010.GC2562@tuon.disenchant.local>
References: <20120715234058.GA2562@tuon.disenchant.local>
 <20120716025610.GB2562@tuon.disenchant.local>
 <11FEA6E4-EF75-4CD9-B2B6-78E42410027B@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:28481 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522Ab2GPKAQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2012 06:00:16 -0400
Content-Disposition: inline
In-Reply-To: <11FEA6E4-EF75-4CD9-B2B6-78E42410027B@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 15, 2012 at 10:32:01PM -0600, Andreas Dilger wrote:
> On 2012-07-15, at 20:56, Kevin Shanahan <kmshanah@disenchant.net> wrote:
> 
> > On Mon, Jul 16, 2012 at 09:10:58AM +0930, Kevin Shanahan wrote:
> >> I have created some filesystems with external journals, and after
> >> reboot (clean shutdown) these will not mount anymore. I see in dmesg:
> >> 
> >>  [42214.365496] EXT4-fs (dm-10): journal UUID does not match
> >> 
> >> However, the UUIDs look fine when viewed with dumpe2fs:
> >> 
> > Here is what e2fsck said about it.
> > 
> > # e2fsck -p -j /dev/ssdvg/jnl-kvmhost0 /dev/it8/nfs-kvmhost0
> > /dev/it8/nfs-kvmhost0: Superblock hint for external superblock should be 0xfd0d.  FIXED.
> > /dev/it8/nfs-kvmhost0: clean, 43229/983040 files, 303609/3932160 blocks
> > 
> > I guess that is the "Journal Device" field? Mount worked fine after
> > that and the data looks okay.
> > 
> > Any idea how this might have happened across all three fs with
> > external journals?
> 
> Because LVM changed the block device numbers after the reboot, and
> the device number used previously for the external journal was
> different.
> 
> The lookup of the journal by UUID (instead of relying on the "device
> hint" in the superblock) _should_ be handled by mount, but I don't
> recall if we ever got a mount.ext4 to handle this or not. It would
> also be possible for the "fast e2fsck" check to verify the journal
> UUID before mounting the filesystem, but again I'm not sure if this
> is done yet, and I can't check right now.

Ok, thanks. For now I can ask LVM to make the major/minor number
persistent.

Assuming it's not already done, do you think adding the UUID lookup
would be a reasonable project for a newbie or is it likely to be a bit
complicated?

I'm assuming support is not there, at least for the versions in Arch:

$ pacman -Q e2fsprogs util-linux
e2fsprogs 1.42.4-1
util-linux 2.21.2-5

Cheers,
Kevin.
