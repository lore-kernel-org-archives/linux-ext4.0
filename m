From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: take i_mutex in ext4_symlink to eliminate a
 warning from ext4_truncate
Date: Wed, 27 Mar 2013 22:04:56 +0800
Message-ID: <20130327140456.GB4316@gmail.com>
References: <1364390347-4360-1-git-send-email-wenqing.lz@taobao.com>
 <20130327134110.GI5861@thunk.org>
 <20130327140250.GA4316@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:56794 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3C0NtN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Mar 2013 09:49:13 -0400
Received: by mail-da0-f47.google.com with SMTP id s35so4114896dak.20
        for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 06:49:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130327140250.GA4316@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 10:02:50PM +0800, Zheng Liu wrote:
> On Wed, Mar 27, 2013 at 09:41:10AM -0400, Theodore Ts'o wrote:
> > On Wed, Mar 27, 2013 at 09:19:07PM +0800, Zheng Liu wrote:
> > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > 
> > > After applied this commit (8e4061cb), we will get a warning from
> > > ext4_truncate when i_mutex isn't taken.  Here the assumption is that
> > > i_mutex should be taken when we do a truncation.  In ext4_symlink we
> > > could need to call ext4_truncate to trim some blocks beyond i_size, but
> > > the i_mutex isn't taken.
> > 
> > Hmm, and this is why I added the warning.  Even after looking your
> > patch, I'm having trouble finding the codepath that results in
> > ext4_truncate() getting called from __page_symlink().  Can you send
> > the stack trace from the WARN_ON, just so I can see what I missed?
> 
> Here it is.
> 
> kernel: ------------[ cut here ]------------
> kernel: WARNING: at fs/ext4/inode.c:3803 ext4_truncate+0x36/0x2d7 [ext4]()
> kernel: Hardware name: OptiPlex 780
> kernel: Modules linked in: ext4(O) jbd2 crc16 cpufreq_ondemand ipv6
> dm_mirror dm_region_hash dm_log dm_mod parport_pc parport dcdbas
> acpi_cpufreq mperf serio_raw button pcspkr i2c_i801 sg ehci_pci
> ehci_hcd e1000e ptp pps_core ext3 jbd sd_mod ahci libahci libata
> scsi_mod uhci_hcd radeon ttm drm_kms_helper drm hwmon i2c_algo_bit i2
> c_core [last unloaded: crc16]
> kernel: Pid: 4152, comm: fsstress Tainted: G W  O 3.9.0-rc4+ #6
> kernel: Call Trace:
> kernel: [<ffffffff82031e14>] warn_slowpath_common+0x85/0x9f
> kernel: [<ffffffff82031e48>] warn_slowpath_null+0x1a/0x1c
> kernel: [<ffffffffa044b789>] ext4_truncate+0x36/0x2d7 [ext4]
> kernel: [<ffffffffa044c9a5>] ext4_write_begin+0x35f/0x3b9 [ext4]
> kernel: [<ffffffff820af514>] pagecache_write_begin+0x1c/0x1e
> kernel: [<ffffffff820f5f80>] __page_symlink+0x6d/0x10f
> kernel: [<ffffffffa0450806>] ?  ext4_orphan_add+0x1ea/0x219 [ext4]
> kernel: [<ffffffffa0451a7f>] ext4_symlink+0x1ca/0x33e [ext4]
> kernel: [<ffffffff820f8c41>] vfs_symlink+0x7c/0xd6
> kernel: [<ffffffff820fb634>] sys_symlinkat+0x68/0xb9
> kernel: [<ffffffff820fb69b>] sys_symlink+0x16/0x18
> kernel: [<ffffffff8238fac2>] system_call_fastpath+0x16/0x1b
> kernel: ---[ end trace 05d179cc296c4f3a ]---

Sorry, maybe you want to reproduce this warning.  xfstests #083 can
trigger it.

Regards,
                                                - Zheng
