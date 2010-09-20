From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Is it deliberate that the device mapper is not passing the
 DISCARD ioctls
Date: Mon, 20 Sep 2010 13:40:43 -0400
Message-ID: <20100920174043.GA29057@redhat.com>
References: <E1OxgCu-0000XW-29@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dm-devel@redhat.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab0ITRkw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Sep 2010 13:40:52 -0400
Content-Disposition: inline
In-Reply-To: <E1OxgCu-0000XW-29@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Mon, Sep 20 2010 at  9:14am -0400,
Theodore Ts'o <tytso@mit.edu> wrote:

> Hi there,
> 
> I was just testing discard support in mke2fs, and I was surprised that
> although the dm layer appears to pass discard requests through to the
> underlying block device driver when submitted through the bio layer
> (i.e., from kernel file systems), apparently the discard ioctls (i.e.,
> BLKDISCARD, BLKDISCARDSEC, BLKDISCARDZEROES) are not currently wired up
> in the dm layer.

After enabling scsi tracing:
# mount -t debugfs none /sys/kernel/debug
# cd /sys/kernel/debug/tracing/
# echo "scsi:*" > set_event
# cat trace_pipe

I'm not seeing a problem with BLKDISCARD (via mkfs.ext4) for either
request-based DM (this is on a 2.6.36-rc4 kernel w/ the FLUSH+FUA patchset):

     kworker/0:1-21    [000] 6046573.148416: scsi_dispatch_cmd_start: host_no=3 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(UNMAP regions=1 raw=42 00 00 00 00 00 
00 00 18 00)
          <idle>-0     [000] 6046573.152001: scsi_dispatch_cmd_done: host_no=3 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(UNMAP regions=1 raw=42 00 00 00 00 00 00 00 18 00) result=(driver=DRIVER_OK host=DID_OK message=COMMAND_COMPLETE status=SAM_STAT_GOOD)
...

or bio-based DM:

     kworker/0:1-21    [000] 6046158.384097: scsi_dispatch_cmd_start: host_no=2 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(UNMAP regions=1 raw=42 00 00 00 00 00 
00 00 18 00)
          <idle>-0     [000] 6046158.405034: scsi_dispatch_cmd_done: host_no=2 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(UNMAP regions=1 raw=42 00 00 00 00 00 00 00 18 00) result=(driver=DRIVER_OK host=DID_OK message=COMMAND_COMPLETE status=SAM_STAT_GOOD)
...

> Is this deliberate, or an oversight?

DM should implicitly supports the BLKDISCARD* ioctls -- just like any
other block device ioctl.

Mike
