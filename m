From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsck not fixing deleted inode referenced errors?
Date: Tue, 30 Sep 2014 15:54:08 -0400
Message-ID: <20140930195408.GD17142@thunk.org>
References: <542AEED4.5050303@bitsync.net>
 <20140930183012.GA9942@birch.djwong.org>
 <542AF9B8.2090800@bitsync.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Zlatko Calusic <zcalusic@bitsync.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57350 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaI3TyP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Sep 2014 15:54:15 -0400
Content-Disposition: inline
In-Reply-To: <542AF9B8.2090800@bitsync.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 30, 2014 at 08:43:04PM +0200, Zlatko Calusic wrote:
> Full error message from the kernel log, together with data check I did in
> the evening:
> 
> Sep 29 05:07:51 atlas kernel: ata2.00: exception Emask 0x10 SAct 0x0 SErr
> 0x4010000 action 0xe frozen
> Sep 29 05:07:51 atlas kernel: ata2.00: irq_stat 0x00400040, connection
> status changed
> Sep 29 05:07:51 atlas kernel: ata2: SError: { PHYRdyChg DevExch }
> Sep 29 05:07:51 atlas kernel: ata2.00: failed command: FLUSH CACHE EXT
> Sep 29 05:07:51 atlas kernel: ata2.00: cmd
> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0\x0a         res
> 40/00:f4:e2:7f:14/00:00:3a:00:00/40 Emask 0x10 (ATA bus error)
> Sep 29 05:07:51 atlas kernel: ata2.00: status: { DRDY }
> Sep 29 05:07:51 atlas kernel: ata2: hard resetting link
> Sep 29 05:07:57 atlas kernel: ata2: link is slow to respond, please be
> patient (ready=0)
> Sep 29 05:08:00 atlas kernel: ata2: SATA link up 3.0 Gbps (SStatus 123
> SControl 300)
> Sep 29 05:08:00 atlas kernel: ata2.00: configured for UDMA/133
> Sep 29 05:08:00 atlas kernel: ata2.00: retrying FLUSH 0xea Emask 0x10
> Sep 29 05:08:00 atlas kernel: ata2: EH complete

That looks really bad; it sounds like you have a hardware error on at
least one of your disks.  Have you tried running running badblocks on
both disks to make sure the disk isn't flagging more bad blocks, and
then resynchronizing the RAID 1 array?   Then try running e2fsck again.

     		     	      		 - Ted
