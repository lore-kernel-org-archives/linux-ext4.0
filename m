From: Bart Samwel <bart@samwel.tk>
Subject: Re: [ext3] kjournald writing after each read despite noatime,commit=nnn
Date: Thu, 01 Jan 2009 15:02:07 +0100
Message-ID: <495CCCDF.3030606@samwel.tk>
References: <18779.58377.160214.225792@wellington.i202.centerclick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Johnson <dave-lkml-01@centerclick.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from customer-vserver-jkruis-1.all2all.org ([62.58.108.47]:55363
	"EHLO jkruis.all2all.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZAAOWk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Jan 2009 09:22:40 -0500
In-Reply-To: <18779.58377.160214.225792@wellington.i202.centerclick.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dave,

Dave Johnson wrote:
> Since upgrading from 2.6.23.1 to 2.6.27.8, I'm now seeing kjournald
> perform a write 2 seconds after each read to an ext3 fs.
> 
> laptop mode is on and filesystem is mounted with noatime and a large
> commit time (6 hours).
> 
> Did I miss something or is this expected?

This is the defined behaviour for laptop_mode. Whenever a *physical*
READ takes place, this is taken to indicate that the disk is spun up at
that time. The laptop_mode functionality then takes that opportunity to
sync any dirty data to disk, two seconds (or whatever value you put in
/proc/sys/vm/laptop_mode) after the physical disk activity has ceased.
The rationale behind this is that you want to sync your stuff when the
disk is spun up, and then you want to hold back writing back stuff for a
very long while. And the only way it can detect that the disk is spun up
is when there is physical disk activity.

This is exactly what happens in your case. The READ activity reported by
block_dump is *physical* read activity: some data was needed that was
not cached in memory. block_dump does not show you what data was
retrieved from the ext3 fs *without* having to access the disk, it only
shows actual physical disk I/O.

Cheers,
Bart
