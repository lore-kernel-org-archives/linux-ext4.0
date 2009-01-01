From: Dave Johnson <dave-lkml-01@centerclick.org>
Subject: Re: [ext3] kjournald writing after each read despite noatime,commit=nnn
Date: Thu, 1 Jan 2009 11:49:40 -0500
Message-ID: <18780.62500.100687.402706@wellington.i202.centerclick.org>
References: <18779.58377.160214.225792@wellington.i202.centerclick.org>
	<495CCCDF.3030606@samwel.tk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Bart Samwel <bart@samwel.tk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lexington.centerclick.org ([66.114.92.10]:48584 "EHLO
	lexington.centerclick.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbZAAQtn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Jan 2009 11:49:43 -0500
In-Reply-To: <495CCCDF.3030606@samwel.tk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bart Samwel writes:
> This is the defined behaviour for laptop_mode. Whenever a *physical*
> READ takes place, this is taken to indicate that the disk is spun up at
> that time. The laptop_mode functionality then takes that opportunity to
> sync any dirty data to disk, two seconds (or whatever value you put in
> /proc/sys/vm/laptop_mode) after the physical disk activity has ceased.
> The rationale behind this is that you want to sync your stuff when the
> disk is spun up, and then you want to hold back writing back stuff for a
> very long while. And the only way it can detect that the disk is spun up
> is when there is physical disk activity.
> 
> This is exactly what happens in your case. The READ activity reported by
> block_dump is *physical* read activity: some data was needed that was
> not cached in memory. block_dump does not show you what data was
> retrieved from the ext3 fs *without* having to access the disk, it only
> shows actual physical disk I/O.

Yep sounds good, but this happens even if there is no dirty data
needing a sync back to disk.

$ grep 'Dirty\|Write' /proc/meminfo 
Dirty:               0 kB
Writeback:           0 kB
WritebackTmp:        0 kB
$ cat /some/uncached/file >/dev/null 

Jan  1 11:43:49 gw kernel: cat(6615): READ block 864408 on hda1 
Jan  1 11:43:51 gw kernel: kjournald(760): WRITE block 2376 on hda1 


Note, the reason I ask is this is a SSD so just because a physical
read has taken place recently unneeded writes should be avoided.

Turning laptop_mode to 0, but leaving other settings the same
resolves the uneeded write:

$ echo 0 > /proc/sys/vm/laptop_mode 
$ grep 'Dirty\|Write' /proc/meminfo 
Dirty:               0 kB
Writeback:           0 kB
WritebackTmp:        0 kB
$ cat /some/other/uncached/file >/dev/null

Jan  1 11:47:15 gw kernel: cat(6653): READ block 864258 on hda1 


-- 
Dave
