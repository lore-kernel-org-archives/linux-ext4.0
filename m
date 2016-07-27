From: Dave Chinner <david@fromorbit.com>
Subject: Re: [4.7-rc6 ext3 corruption] ext4_mb_generate_buddy:758: group 27,
 block bitmap and bg descriptor inconsistent:
Date: Thu, 28 Jul 2016 09:57:28 +1000
Message-ID: <20160727235728.GV16044@dastard>
References: <20160712054137.GI1922@dastard>
 <20160727154843.GB1659@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:64224 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758277AbcG0X5d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jul 2016 19:57:33 -0400
Content-Disposition: inline
In-Reply-To: <20160727154843.GB1659@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 27, 2016 at 05:48:43PM +0200, Jan Kara wrote:
> Hi!
> 
> On Tue 12-07-16 15:41:37, Dave Chinner wrote:
> > Just rebooted a 4.7-rc6 test VM, and the root filesystem had the
> > journal abort a couple of seconds after mount while the system was
> > still booting:
> > 
> > [    3.043543] EXT4-fs (sda1): mounting ext3 file system using the ext4 subsystem
> > [    3.045027] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
> > [    3.046008] EXT4-fs (sda1): write access will be enabled during recovery
> > [    3.120052] EXT4-fs (sda1): recovery complete
> > [    3.121746] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> > [    3.122778] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
> > .....
> > [    5.263329] EXT4-fs error (device sda1): ext4_mb_generate_buddy:758: group 27, block bitmap and bg descriptor inconsistent: 4197 vs 4196 free clusters
> > [    5.266343] Aborting journal on device sda1-8.
> > [    5.267939] EXT4-fs (sda1): Remounting filesystem read-only
> > [    5.269129] EXT4-fs error (device sda1) in ext4_free_blocks:4904: Journal has aborted
> > [    5.271431] EXT4-fs error (device sda1) in ext4_do_update_inode:4891: Journal has aborted
> > [    5.273720] EXT4-fs error (device sda1) in ext4_truncate:4150: IO failure
> > [    5.275917] EXT4-fs error (device sda1) in ext4_orphan_del:2923: Journal has aborted
> > [    5.278325] EXT4-fs error (device sda1) in ext4_do_update_inode:4891: Journal has aborted
> > 
> > The root filesystem checked clean three reboots before this
> > occurred. e2fsck output on ro mounted fs:
> > 
> > # e2fsck /dev/sda1
> > e2fsck 1.43-WIP (18-May-2015)
> > /dev/sda1: recovering journal
> > Superblock last mount time is in the future.
> >         (by less than a day, probably due to the hardware clock being incorrectly set)
> > /dev/sda1 contains a file system with errors, check forced.
> > Pass 1: Checking inodes, blocks, and sizes
> > Pass 2: Checking directory structure
> > Pass 3: Checking directory connectivity
> > Pass 4: Checking reference counts
> > Pass 5: Checking group summary information
> > Free blocks count wrong (542319, counted=546517).
> > Fix<y>? yes
> > Inode bitmap differences:  -219131
> > Fix<y>? yes
> > Free inodes count wrong for group #27 (6720, counted=6721).
> > Fix<y>? yes
> > Directories count wrong for group #27 (9, counted=8).
> > Fix<y>? yes
> > Free inodes count wrong (341015, counted=341018).
> > Fix<y>? yes
> > 
> > /dev/sda1: ***** FILE SYSTEM WAS MODIFIED *****
> > /dev/sda1: ***** REBOOT LINUX *****
> > /dev/sda1: 283606/624624 files (3.1% non-contiguous), 1949574/2496091 blocks
> > #
> 
> Hum, interesting. So 'Free blocks count wrong' and 'Free inodes count
> wrong' messages are harmless - those entries and updated only
> opportunistically and on mount and generally do not have to match on live
> filesystem. The other three errors regarding inode and directory count are
> a fallout from aborted inode deletion. Most importantly there is *no
> problem* whatsoever with block bitmaps. So it was either some memory glitch
> (bitflip in the counter or the bitmap) or there is some race and bb_free
> can get out of sync with the bitmap and I don't see how that could happen
> especially so early after mount... Strange.

Don't think bitflips from memory glitches are likely - the VM is
running on a machine with ECC ram. Some other kernel memory
corruption that affects the page cache also seems unlikely, because
it onyl happened after hanging the kernel hard due to XFS failures
on other filesystems and storage devices and having to effectively
"cold reboot" the VM from the qemu console (oops in a kworker thread
is now a Real Bad Thing to do to the system, it appears).

It is strange that these showed up around 4.7-rc4, and the last I
wacky hang-cold reboot-ext3 in bad state issue I encountered was in
4.7-rc6. I haven't seen problems since, but that's not to say
they've gone away...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
