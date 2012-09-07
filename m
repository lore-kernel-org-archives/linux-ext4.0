From: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: Tracking down suspend/resume ext3/mmc issues on imx233
Date: Fri, 7 Sep 2012 14:05:54 +0800
Message-ID: <20120907060552.GL26709@S2101-09.ap.freescale.net>
References: <CAEOSq-O3SfuAEhMsjX1y1ZgQuWBKef+XZzMR1b4yJhKhaRdymA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux-Arm-Kernel <linux-arm-kernel@lists.infradead.org>,
	linux-ext4@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Mike Thompson <mpthompson@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34280 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760137Ab2IGGFk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Sep 2012 02:05:40 -0400
Received: by dady13 with SMTP id y13so1582580dad.19
        for <linux-ext4@vger.kernel.org>; Thu, 06 Sep 2012 23:05:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAEOSq-O3SfuAEhMsjX1y1ZgQuWBKef+XZzMR1b4yJhKhaRdymA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Copy a few more lists to get wider audience ...

Regards,
Shawn

On Thu, Sep 06, 2012 at 10:03:35PM -0700, Mike Thompson wrote:
> Hi,
> 
> I'm working on adding power management support for the imx233 on
> 3.6-rc2.  In general I'm working on porting the pm.c file from the
> Freescale 2.6.35 kernel for both "standby" and "mem" suspend/resume.
> I'm making pretty good progress on porting the code, but I'm running
> into an issue outside the immediate code I'm working on.
> 
> Right now I'm just testing out imx233 suspend/resume functionality by
> implementing a dummy "standby" function that just returns rather than
> putting the SoC into a low power state.  I believe this should have
> the kernel go through suspend operations, hit my dummy function which
> does nothing and then go through resume operations.  Unfortunately,
> upon resume I'm getting ext3 file system errors in that nothing can be
> read from the root file system on the SD card.  A trace of the
> suspend/resume cycle is show below:
> 
> root@olinuxino:~# echo standby > /sys/power/state
> [   90.080000] PM: Syncing filesystems ... done.
> [   90.110000] mmc0: card aaaa removed
> [   90.330000] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [   90.360000] Freezing remaining freezable tasks ... (elapsed 0.01
> seconds) done.
> [   90.400000] mxs_mmc_suspend()
> [   90.400000] PM: suspend of devices complete after 19.531 msecs
> [   90.410000] PM: late suspend of devices complete after 2.843 msecs
> [   90.420000] PM: noirq suspend of devices complete after 4.531 msecs
> [   90.430000] PM: noirq resume of devices complete after 1.906 msecs
> [   90.440000] PM: early resume of devices complete after 1.843 msecs
> [   90.450000] mxs_mmc_resume()
> [   90.500000] PM: resume of devices complete after 51.062 msecs
> [   90.510000] Restarting tasks ... done.
> [   90.640000] mmc0: host does not support reading read-only switch.
> assuming write-enable.
> [   90.650000] mmc0: new high speed SD card at address aaaa
> [   90.670000] mmcblk0: mmc0:aaaa SU02G 1.84 GiB
> [   90.680000]  mmcblk0: p1 p2
> [   90.700000] EXT3-fs error (device mmcblk0p2): ext3_find_entry:
> reading directory #15970 offset 0
> [   90.710000] Aborting journal on device mmcblk0p2.
> [   90.720000] JBD: Error -5 detected when updating journal superblock
> for mmcblk0p2.
> [   90.730000] EXT3-fs (mmcblk0p2): error: remounting filesystem read-only
> [   90.730000] EXT3-fs (mmcblk0p2): I/O error while writing superblock
> [   90.740000] EXT3-fs error (device mmcblk0p2): ext3_find_entry:
> reading directory #2 offset 0
> udevd[1309]: failed to execute '/sbin/modprobe' '/sbin/modprobe -b
> mmc:block': No such file or directory
> [   90.790000] EXT3-fs error (device mmcblk0p2): ext3_find_entry:
> reading directory #15970 offset 0
> udevd[1310]: failed to execute '/sbin/blkid' '/sbin/blkid -o udev -p
> /dev/.tmp-block-179:8': No such file or directory
> udevd[1311]: failed to execute '/sbin/blkid' '/sbin/blkid -o udev -p
> /dev/.tmp-block-179:10': No such file or directory
> udevd[1312]: failed to execute '/sbin/blkid' '/sbin/blkid -o udev -p
> /dev/.tmp-block-179:9': No such file or directory
> root@olinuxino:~#
> root@olinuxino:~# ls
> [  432.780000] EXT3-fs error (device mmcblk0p2): ext3_find_entry:
> reading directory #55890 offset 0
> [  432.790000] EXT3-fs error (device mmcblk0p2): ext3_find_entry:
> reading directory #55891 offset 0
> [  432.800000] EXT3-fs error (device mmcblk0p2): ext3_find_entry:
> reading directory #55890 offset 0
> [  432.810000] EXT3-fs error (device mmcblk0p2): ext3_find_entry:
> reading directory #15970 offset 0
> [  432.820000] EXT3-fs error (device mmcblk0p2): ext3_find_entry:
> reading directory #7985 offset 0
> [  432.840000] EXT3-fs error (device mmcblk0p2): ext3_find_entry:
> reading directory #55890 offset 0
> -bash: ls: command not found
> root@olinuxino:~#
> 
> The first reported error is in the ext3 filesystem buffer code where
> the file system buffers aren't being filled by the underlying block
> device.  At least that's how I'm interpreting the portion of the ext3
> file system code that is failing.  However, the mmc device is
> correctly reporting finding p1 and p2 partitions on the device which
> it would indicate the partition data is being read from the SD card.
> 
> I'm hoping others might have suggestions on how I should go about
> tracking down why the ext3 file system can no longer read from the mmc
> device upon resume.  For instance, useful places to put some tracing
> code to understand what might be failing, or how to determine what
> differences there might be before suspend and after resume that might
> point to the failure.
> 
> Thanks,
> 
> Mike Thompson
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
