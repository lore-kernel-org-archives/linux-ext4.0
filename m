From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: Livelock when running xfstests generic/127 on ext4 with 3.15
Date: Wed, 25 Jun 2014 10:17:56 -0400
Message-ID: <20140625141756.GS12025@linux.intel.com>
References: <20140620175322.GO12025@linux.intel.com>
 <20140625131224.GE21507@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14244 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbaFYOSG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jun 2014 10:18:06 -0400
Content-Disposition: inline
In-Reply-To: <20140625131224.GE21507@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 25, 2014 at 03:12:24PM +0200, Jan Kara wrote:
> > $ sudo cat /proc/4795/stack 
> > [<ffffffff8120bee9>] writeback_inodes_sb_nr+0xa9/0xe0
> > [<ffffffff8120bfae>] try_to_writeback_inodes_sb_nr+0x5e/0x80
> > [<ffffffff8120bff5>] try_to_writeback_inodes_sb+0x25/0x30
> > [<ffffffffa01bae2a>] ext4_nonda_switch+0x8a/0x90 [ext4]
> > [<ffffffffa01c49a5>] ext4_page_mkwrite+0x265/0x440 [ext4]
>   Hum, apparently you are running out of space on the test partition. And
> that is known to make ext4 extraordinarily slow...

Okay ... but why is it so much worse in 3.15 than 3.14?

And does ext4 think of "running out of space" as a percentage
free, or an absolute number of blocks remaining?  From the code in
ext4_nonda_switch(), it seems to be the former, although maybe excessive
fragmentation has caused ext4 to think it's running out of space?

> > My setup is a 1GB ram disk:
> > 
> > modprobe brd rd_size=1048576 rd_nr=2
> > 
> > local.config:
> > 
> > TEST_DEV=/dev/ram0
> > TEST_DIR=/mnt/ram0
> > SCRATCH_DEV=/dev/ram1
> > SCRATCH_MNT=/mnt/ram1
> > 
> > 
> > Hardware is an Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz with 4GB RAM,
> > in case it matters.  But I think what matters is that I'm running it on
> > a "tiny" 1GB filesystem, since this code is only invoked whenever the
> > number of dirty clusters is large relative to the number of free clusters.
> > 
> > df shows:
> > /dev/ram1         999320     1284    929224   1% /mnt/ram1
> > /dev/ram0         999320   646088    284420  70% /mnt/ram0
> > 
> > So it's not *unreasonably* full.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
