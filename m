From: Dave Johnson <dave-lkml-01@centerclick.org>
Subject: Re: [ext3] kjournald writing after each read despite noatime,commit=nnn
Date: Thu, 1 Jan 2009 14:35:20 -0500
Message-ID: <18781.6904.837987.584032@wellington.i202.centerclick.org>
References: <18779.58377.160214.225792@wellington.i202.centerclick.org>
	<495CCCDF.3030606@samwel.tk>
	<18780.62500.100687.402706@wellington.i202.centerclick.org>
	<495D12A8.9030703@samwel.tk>
	<18781.5890.617086.393467@wellington.i202.centerclick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Bart Samwel <bart@samwel.tk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lexington.centerclick.org ([66.114.92.10]:34510 "EHLO
	lexington.centerclick.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074AbZAATfZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Jan 2009 14:35:25 -0500
In-Reply-To: <18781.5890.617086.393467@wellington.i202.centerclick.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Johnson writes:
> Bart Samwel writes:
> > This looks like it's a generic property of syncing an ext3 file system.
> > Try turning off laptop_mode and then running "sync". You will probably
> > see the same behaviour.
> 
> yep, every sync() causes a gratuitous write to disk N seconds later
> even when no data has been read or written since the last sync().

Woops, correction, every sync() call causes a single gratuitous write,
no delay.

$ for n in 1 2 3 4 5; do sync; done

Jan  1 14:32:54 gw kernel: kjournald(760): WRITE block 2682 on hda1 
Jan  1 14:32:54 gw kernel: kjournald(760): WRITE block 2684 on hda1 
Jan  1 14:32:54 gw kernel: kjournald(760): WRITE block 2686 on hda1 
Jan  1 14:32:54 gw kernel: kjournald(760): WRITE block 2688 on hda1 
Jan  1 14:32:54 gw kernel: kjournald(760): WRITE block 2690 on hda1 

-- 
Dave
