From: Dave Johnson <dave-lkml-01@centerclick.org>
Subject: Re: [ext3] kjournald writing after each read despite noatime,commit=nnn
Date: Thu, 1 Jan 2009 14:18:26 -0500
Message-ID: <18781.5890.617086.393467@wellington.i202.centerclick.org>
References: <18779.58377.160214.225792@wellington.i202.centerclick.org>
	<495CCCDF.3030606@samwel.tk>
	<18780.62500.100687.402706@wellington.i202.centerclick.org>
	<495D12A8.9030703@samwel.tk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Bart Samwel <bart@samwel.tk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lexington.centerclick.org ([66.114.92.10]:60544 "EHLO
	lexington.centerclick.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZAATSb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Jan 2009 14:18:31 -0500
In-Reply-To: <495D12A8.9030703@samwel.tk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bart Samwel writes:
> This looks like it's a generic property of syncing an ext3 file system.
> Try turning off laptop_mode and then running "sync". You will probably
> see the same behaviour.

yep, every sync() causes a gratuitous write to disk N seconds later
even when no data has been read or written since the last sync().

$ while sleep 5; do sync; done
^C
$ 

Jan  1 14:09:31 gw kernel: kjournald(760): WRITE block 2662 on hda1 
Jan  1 14:09:36 gw kernel: kjournald(760): WRITE block 2664 on hda1 
Jan  1 14:09:42 gw kernel: kjournald(760): WRITE block 2666 on hda1 
Jan  1 14:09:47 gw kernel: kjournald(760): WRITE block 2668 on hda1 
Jan  1 14:09:52 gw kernel: kjournald(760): WRITE block 2670 on hda1 

> > Note, the reason I ask is this is a SSD so just because a physical
> > read has taken place recently unneeded writes should be avoided.
> > 
> > Turning laptop_mode to 0, but leaving other settings the same
> > resolves the uneeded write:
> 
> For your SSD I guess you need to get rid of the
> sync-after-disk-activity, but keep the other VM behaviours of
> laptop_mode (such as avoiding swapping out pages / writing back dirty
> pages in order to free memory as long as it is also possible to just
> drop pages that are not dirty).
> 
> You can probably achieve this by:
> - having a large commit interval etc., like you have now
> - setting laptop_mode to a very large value, e.g. a couple of hours.
> That will trigger a sync if and only if there has been *no* disk
> activity at all for hours on end -- i.e., pretty much never. And the
> other write-reducing VM features of laptop_mode will still be enabled.
> 
> It would perhaps be a good thing to split these mechanisms into separate
> knobs. Write batching (the sync-after-disk-activity stuff and also the
> dirty_ratio / dirty_background_ratio changes) are a completely separate
> mechanism from write avoidance (the other mechanism I mentioned).

I'm going to run without laptop mode for a while to see how this
goes.  This system is a small router/firewall with most writes going
to a tmpfs so the number of writes to the ext3 fs is only a few a
month (provided no one logs into the system to do a config change).

Thanks for the help.

-- 
Dave
