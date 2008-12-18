From: Jan Kara <jack@suse.cz>
Subject: Re: EXT3 way too happy with write errors
Date: Thu, 18 Dec 2008 18:07:14 +0100
Message-ID: <20081218170714.GA6797@atrey.karlin.mff.cuni.cz>
References: <20081015002256.GD25662@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Simon Kirby <sim@netnation.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38459 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYLRRHP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 12:07:15 -0500
Content-Disposition: inline
In-Reply-To: <20081015002256.GD25662@hostway.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  This was quite a long time ago but it seems nobody replied yet :).

> While attempting to track down failed write error at a device layer,
> I noticed that EXT3 seems to behave strangely after a single block I/O
> failure.
> 
> I would expect that upon the first failed request, it would abort the
> journal and remount-ro (if errors=remount-ro is specified).  Instead, it
> seems to happily plonk along until I inject a few more failures (testing
> with the fault injection framework), until it eventually fails enough to
> abort the journal.  However, by then, "fsck" will show corruption --
> sometimes severe.  If I force only one or two of write failures and 
> then unmount, I can reproduce consistency corruption that shows up
> with "fsck -f" even though the file system is not marked "errors"!
> 
> Why is this?
  What kernel version is this? Originally, we aborted a journal only if
we spotted a write error in filesystem metadata. If we spotted an error
in data, we just complained but continued. This seems to be exactly the
thing you are hitting. Latest Linus's tree (i.e. 2.6.28-rc5 or so) should
have the patches that allow tuning the behavior in data=ordered mode - i.e.
you can tell the filesystem by data_err=abort and data_err=ignore option
whether it should abort the filesystem or ignore write error in fs data.

> Example:
> 
> Oct  9 19:57:31 nas02 kernel: kjournald starting.  Commit interval 5 seconds
> Oct  9 19:57:31 nas02 kernel: EXT3 FS on etherd/e3.0p1, internal journal
> Oct  9 19:57:31 nas02 kernel: EXT3-fs: mounted filesystem with ordered data mode.
> Oct  9 20:00:18 nas02 kernel: FAULT_INJECTION: forcing a failure
> Oct  9 20:00:18 nas02 kernel: Buffer I/O error on device etherd/e3.0p1, logical block 5186046
> Oct  9 20:00:18 nas02 kernel: lost page write due to I/O error on etherd/e3.0p1
> Oct  9 20:00:37 nas02 kernel: FAULT_INJECTION: forcing a failure
> Oct  9 20:00:37 nas02 kernel: Buffer I/O error on device etherd/e3.0p1, logical block 410322
> Oct  9 20:00:37 nas02 kernel: lost page write due to I/O error on etherd/e3.0p1
> Oct  9 20:00:40 nas02 kernel: FAULT_INJECTION: forcing a failure
> Oct  9 20:00:40 nas02 kernel: EXT3-fs error (device etherd/e3.0p1): read_block_bitmap: Cannot read block bitmap - block_group = 18, block_bitmap = 589824
> Oct  9 20:00:40 nas02 kernel: Aborting journal on device etherd/e3.0p1.
> Oct  9 20:00:40 nas02 kernel: FAULT_INJECTION: forcing a failure
> Oct  9 20:00:40 nas02 kernel: Buffer I/O error on device etherd/e3.0p1, logical block 1545
> Oct  9 20:00:40 nas02 kernel: lost page write due to I/O error on etherd/e3.0p1
> Oct  9 20:00:40 nas02 kernel: Remounting filesystem read-only
> 
> [sroot@nas02:/]# fsck -C /mnt/web00
> fsck 1.40-WIP (14-Nov-2006)
> e2fsck 1.40-WIP (14-Nov-2006)
> /dev/etherd/e3.0p1: recovering journal
> /dev/etherd/e3.0p1 contains a file system with errors, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> Inode 49153, i_blocks is 2942528, should be 2942520.  Fix<y>?
> Pass 2: Checking directory structure                                           
> Pass 3: Checking directory connectivity                                        
> Pass 4: Checking reference counts                                              
> Pass 5: Checking group summary information                                     
>                                                                                 
> /dev/etherd/e3.0p1: ***** FILE SYSTEM WAS MODIFIED *****
> /dev/etherd/e3.0p1: 126254/24690688 files (0.1% non-contiguous), 1778971/49359704 blocks
> 
> Shouldn't it be the case that the first request failure should
> remount-ro?  Assuming the fault merely denied a single read or write
> request, it should then be possible to reboot or remount,rw after the
> fault is fixed and have consistency after just a journal replay...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
