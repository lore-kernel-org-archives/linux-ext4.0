From: Dave Chinner <david@fromorbit.com>
Subject: Re: [4.3-rc1, regression] ext2 vs ext3/ext4 fs probing issues
Date: Sat, 26 Sep 2015 09:51:26 +1000
Message-ID: <20150925235126.GW19114@dastard>
References: <20150921070715.GL26895@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150921070715.GL26895@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ping?

On Mon, Sep 21, 2015 at 05:07:15PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> The first of my test VMs that I upgraded to 4.3-rc1 from 4.2 has
> been behaving rather strangely w.r.t. boot hangs and ext3
> filesystems.
> 
> One the first cold boot of a new kernel, the boot appears to hang.
> What i've discovered (which took a long time thanks to the shitpile
> that is systemd) is that it appears to be doing a e2fsck on the root
> device, and that is failing resulting in systemd outputing:
> 
> [FAILED] Failed to start File System Check on Root Device.
> 
> systemd then goes to shutting down the system and reboot but that
> fail because it's still starting other stuff up and simultaneously
> shutting shit down tha the stuff starting up depends on. It fucks up
> badly, with teh last concole entries looking like it has hung
> waiting for lvm/md devices to appear.
> 
> I can't tell you what the e2fsck failure is, because systemd oh so
> helpfully overwrites the console output from fsck with all the other
> shit that it is doing concurrently. it also fails to log it anywhere
> because this has happened before A) the console logging has been
> started and b) the the root fs is still only mounted RO at this
> point.
> 
> Hence I have absolutely zero output apart from seeing the "checking
> xxx%" update on the bottom line of the screen occasionally before it
> is immediately overwritten by systemd logging something else.
> 
> So, warm reboot the VM (via system_reset in the qemu console), and
> the system comes up. No fsck is run, but the filesystem is mounted
> as ext2, not ext3.  What I see is this in dmesg:
> 
> [    2.322798] EXT2-fs (sda1): warning: mounting ext3 filesystem as ext2
> [    2.325123] VFS: Mounted root (ext2 filesystem) readonly on device 8:1.
> 
> It's definitely an ext3 filesystem, but the interesting point is
> that it has a clean journal so can be mounted as ext2:
> 
> $ sudo blkid /dev/sda1
> /dev/sda1: UUID="b21615e5-fe8a-4ffc-ab80-c24cdc8b740a" SEC_TYPE="ext2" TYPE="ext3" PARTUUID="000efa91-01"
> $ sudo dumpe2fs -h /dev/sda1 | grep -i feature
> dumpe2fs 1.42.13 (17-May-2015)
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype sparse_super large_file
> Journal features:	journal_incompat_revoke
> $
> 
> So, I change the kernel config from:
> 
> CONFIG_EXT2_FS=y
> # CONFIG_EXT4_USE_FOR_EXT2 is not set
> 
> to
> 
> # CONFIG_EXT2_FS is not set
> CONFIG_EXT4_USE_FOR_EXT2=y
> 
> And what I see is this:
> 
> [    2.228894] EXT4-fs (sda1): mounting ext3 file system using the ext4 subsystem
> [    2.238832] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> 
> Which tells me that there's a problem with fstype probe ordering
> regressions w.r.t ext2 and ext3 as a result of removing the ext3
> module. It also doesn't fail fsck checks now, so boots successfully
> every time. I suspect the "boot hang" problem is that e2fsck sees a
> dirty journal, fixes everything and then asks for a reboot, which
> fails.
> 
> So, suspecting this, I switched back to the original
> CONFIG_EXT2_FS=y build:
> 
> [    2.254213] EXT2-fs (sda1): error: couldn't mount because of unsupported optional features (4)
> [    2.257076] EXT4-fs (sda1): mounting ext3 file system using the ext4 subsystem
> [    2.259712] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
> [    2.261740] EXT4-fs (sda1): write access will be enabled during recovery
> [    2.336798] EXT4-fs (sda1): orphan cleanup on readonly fs
> [    2.338492] EXT4-fs (sda1): 2 orphan inodes deleted
> [    2.339922] EXT4-fs (sda1): recovery complete
> [    2.346063] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [    2.348349] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
> 
> Which makes it pretty clean that if the journal was clean it would
> have mounted as an ext2 filesystem, not ext3.  Basically, we need to
> ensure that the ext4 module probes filesystems before the ext2
> module when CONFIG_EXT2_FS=y is set so that ext3 filesystems are
> correctly mounted....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com
