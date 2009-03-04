From: Jan Kara <jack@suse.cz>
Subject: Re: ext3 warning from mark_buffer_dirty after aborting journal
Date: Wed, 4 Mar 2009 17:29:30 +0100
Message-ID: <20090304162930.GB8748@atrey.karlin.mff.cuni.cz>
References: <Pine.SOC.4.64.0903040858510.6557@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57634 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZCDQ3d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2009 11:29:33 -0500
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0903040858510.6557@math.ut.ee>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Just got this warning when running 2.6.29-rc + yesterdays git on 
> sparc64. For some yet unknown reason, scsi disk goes repeatably offline 
> during shutdown and this got a warning out of ext3. Is this an expected 
> warning or does it need some attention?
  Yes, it is an expected warning. It is a result of the fact that we mix
IO error detection with tracking which buffers contain uptodate data
(the same flag is used) and this occasionally falsly triggers some
warning.
  Thanks for report anyway.

								Honza
> 
> Please CC: as I am not subscribed to linux-ext4.
> 
> [20639.424955] sd 0:0:0:0: rejecting I/O to offline device
> [20639.488559] Aborting journal on device sda2.
> [20639.538715] sd 0:0:0:0: rejecting I/O to offline device
> [20639.607271] sd 0:0:0:0: rejecting I/O to offline device
> [20639.670515] EXT3-fs error (device sda2): ext3_find_entry: reading directory #188427 offset 0
> [20639.770755] Remounting filesystem read-only
> [20639.821110] ------------[ cut here ]------------
> [20639.876118] WARNING: at fs/buffer.c:1251 mark_buffer_dirty+0xa8/0xc0()
> [20639.954215] Modules linked in: ipv6 ext2 loop
> [20640.006202] Call Trace:
> [20640.035492]  [000000000045cd6c] warn_slowpath+0x6c/0xc0
> [20640.097999]  [0000000000508708] mark_buffer_dirty+0xa8/0xc0
> [20640.164695]  [0000000000554b58] ext3_commit_super+0xb8/0x100
> [20640.232396]  [00000000005563e8] ext3_handle_error+0x68/0xe0
> [20640.299084]  [0000000000556530] ext3_error+0x50/0x60
> [20640.358463]  [0000000000551ed4] ext3_find_entry+0x554/0x680
> [20640.425137]  [00000000005529f0] ext3_lookup+0x30/0x160
> [20640.486648]  [00000000004ebfb8] __lookup_hash+0xf8/0x140
> [20640.550159]  [00000000004ec034] lookup_hash+0x34/0x60
> [20640.610596]  [00000000004ef998] do_filp_open+0x238/0x7e0
> [20640.674154]  [00000000004e0ab4] do_sys_open+0x54/0x100
> [20640.735614]  [00000000004431bc] sparc32_open+0x1c/0x40
> [20640.797080]  [0000000000406254] linux_sparc_syscall32+0x34/0x40
> [20640.867912] ---[ end trace 747d11ba5876fcd1 ]---
> 
> 
> -- 
> Meelis Roos (mroos@linux.ee)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
