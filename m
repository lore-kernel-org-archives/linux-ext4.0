From: Jan Kara <jack@suse.cz>
Subject: Re: Livelock when running xfstests generic/127 on ext4 with 3.15
Date: Wed, 25 Jun 2014 15:12:24 +0200
Message-ID: <20140625131224.GE21507@quack.suse.cz>
References: <20140620175322.GO12025@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbaFYNM1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jun 2014 09:12:27 -0400
Content-Disposition: inline
In-Reply-To: <20140620175322.GO12025@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 20-06-14 13:53:22, Matthew Wilcox wrote:
> 
> I didn't see this with 3.14, but I'm not sure what's changed.
> 
> When running generic/127, fsx ends up taking 30% CPU time with a kthread
> taking 70% CPU time for hours.  It might be making forward progress,
> but if it is, it's incredibly slow.
> 
> I can usually catch fsx waiting for the kthread:
> 
> # ./check generic/127
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 walter 3.15.0
> MKFS_OPTIONS  -- /dev/ram1
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/ram1 /mnt/ram1
> 
> generic/127 19s ...
> 
> $ sudo cat /proc/4795/stack 
> [<ffffffff8120bee9>] writeback_inodes_sb_nr+0xa9/0xe0
> [<ffffffff8120bfae>] try_to_writeback_inodes_sb_nr+0x5e/0x80
> [<ffffffff8120bff5>] try_to_writeback_inodes_sb+0x25/0x30
> [<ffffffffa01bae2a>] ext4_nonda_switch+0x8a/0x90 [ext4]
> [<ffffffffa01c49a5>] ext4_page_mkwrite+0x265/0x440 [ext4]
  Hum, apparently you are running out of space on the test partition. And
that is known to make ext4 extraordinarily slow...

								Honza

> [<ffffffff811936ed>] do_page_mkwrite+0x3d/0x70
> [<ffffffff81195887>] do_wp_page+0x627/0x770
> [<ffffffff811981a1>] handle_mm_fault+0x781/0xf00
> [<ffffffff815a8996>] __do_page_fault+0x186/0x570
> [<ffffffff815a8da2>] do_page_fault+0x22/0x30
> [<ffffffff815a5038>] page_fault+0x28/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> 
> My setup is a 1GB ram disk:
> 
> modprobe brd rd_size=1048576 rd_nr=2
> 
> local.config:
> 
> TEST_DEV=/dev/ram0
> TEST_DIR=/mnt/ram0
> SCRATCH_DEV=/dev/ram1
> SCRATCH_MNT=/mnt/ram1
> 
> 
> Hardware is an Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz with 4GB RAM,
> in case it matters.  But I think what matters is that I'm running it on
> a "tiny" 1GB filesystem, since this code is only invoked whenever the
> number of dirty clusters is large relative to the number of free clusters.
> 
> df shows:
> /dev/ram1         999320     1284    929224   1% /mnt/ram1
> /dev/ram0         999320   646088    284420  70% /mnt/ram0
> 
> So it's not *unreasonably* full.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
