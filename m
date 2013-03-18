From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: "EXT4-fs error: ext4_mb_generate_buddy" errors during rsync
Date: Mon, 18 Mar 2013 17:58:51 +0800
Message-ID: <20130318095851.GA1751@gmail.com>
References: <20130318081551.GA379@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53426 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3CRJn1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2013 05:43:27 -0400
Received: by mail-pb0-f50.google.com with SMTP id up1so6229133pbc.9
        for <linux-ext4@vger.kernel.org>; Mon, 18 Mar 2013 02:43:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130318081551.GA379@x4>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 18, 2013 at 09:15:51AM +0100, Markus Trippelsdorf wrote:
> During the nightly rsync run that backups my root filesystem I got:
> 
> Mar 18 01:52:00 x4 fcron[19997]: Job /usr/bin/rsnapshot daily started for user root (pid 19998)
> Mar 18 01:56:41 x4 rsnapshot[20187]: /usr/bin/rsnapshot daily: completed successfully
> Mar 18 01:56:43 x4 fcron[19997]: Job /usr/bin/rsnapshot daily completed (mailing output)
> 
> Mar 18 01:52:21 x4 kernel: EXT4-fs error (device sda): ext4_mb_generate_buddy:749: group 6817, 7060 clusters in bitmap, 7064 in gd
> Mar 18 01:52:21 x4 kernel: JBD2: Spotted dirty metadata buffer (dev = sda, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
> Mar 18 01:56:30 x4 kernel: EXT4-fs error (device sda): ext4_mb_generate_buddy:749: group 6833, 26653 clusters in bitmap, 26656 in gd
> Mar 18 01:56:30 x4 kernel: EXT4-fs error (device sda): ext4_mb_generate_buddy:749: group 6881, 3985 clusters in bitmap, 3991 in gd
> Mar 18 01:56:30 x4 kernel: EXT4-fs error (device sda): ext4_mb_generate_buddy:749: group 6897, 5979 clusters in bitmap, 6024 in gd
> 
> e2fsck 1.42 (29-Nov-2011)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Free blocks count wrong for group #6817 (6779, counted=6775).
> Fix<y>? yes
> Free blocks count wrong for group #6833 (26575, counted=26572).
> Fix<y>? yes
> Free blocks count wrong for group #6881 (3916, counted=3910).
> Fix<y>? yes
> Free blocks count wrong for group #6897 (5987, counted=5942).
> Fix<y>? yes
> Free blocks count wrong (185850303, counted=185850245).
> Fix<y>? yes
> /dev/sdb: ***** FILE SYSTEM WAS MODIFIED *****
> /dev/sdb: 1619858/91578368 files (0.6% non-contiguous), 180434401/366284646 blocks
> 
> "smartctl -a /dev/sda" looks fine

Hi Markus,

Could you please provide more details?  Such as kernel version, `tune2fs
-l ${dev}`, etc....  I guess the kernel version is 3.9-rc2, right? :-)

Thanks,
                                                - Zheng
