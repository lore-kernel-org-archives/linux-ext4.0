From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Tue, 20 Apr 2010 22:09:46 +0200
Message-ID: <201004202209.46768.bernd.schubert@fastmail.fm>
References: <20100416123526.GW21495@skl-net.de> <201004201926.33908.bernd.schubert@fastmail.fm> <20100420183533.GA21495@skl-net.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51928 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754840Ab0DTUJt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Apr 2010 16:09:49 -0400
In-Reply-To: <20100420183533.GA21495@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 20 April 2010, Andre Noll wrote:
> On 19:26, Bernd Schubert wrote:
> > On Tuesday 20 April 2010, Eric Sandeen wrote:
> > I think interesting at this point would be the exact model of the
> > Infortrend device.
> 
> Here's the system information as reported by the telnet interface:
> 
> 	CPU Type             PPC750FX
> 	Total Cache Size     2048MB DDR(ECC)
> 	Firmware Version     3.42I.03
> 	Bootrecord Version   1.23A
> 	FW Upgradability     Rev. C
> 	Serial Number        6912121
> 	Battery Backup Unit  Present
> 	Base Board Rev. ID   0
> 	Base Board ID        81
> 	ID of NVRAM Defaults A16F-G2221 V6.10
> 	Controller Position  Slot A
> 
> > There are some completely broken models (IMHO), which have two
> > controllers for redundancy.
> 
> This is a 4 year old system (which does not support Raid6). It has only
> a single controller though.

I don't have any experience with that model.

> 
> > Now with enabled write-back cache, it can happen that those units run
> > into some kind of firmware bug. It then takes about 2h to flush 2GB of
> > write-back cache.  The telnet interface will show the status of the
> > cache.
> 
> Hey, I saw this once on a different (newer) infortrend system. However,
> it might still be hapening on this system as well and cause the timeout
> problems.

I think the dual-controller models that work fine have have SAS-interlink. 
Infortrend never confirmed the issue, but I guess it is related to cache-
coherency between both controllers. 
There are also other cache related firmware bugs, when it fails to flush the 
cache at all. Scsi commands then time out, it enters recovery, properly 
responds to scsi commands, resumes normal operation and fails those commands 
again. Even with software raid out of several of those hardware raids, this 
fail-recover-fail loop prevents suitable operation. Also part of my scsi 
patches to limit number of recoveries within a time limit. This issue should 
be fixed with recent firmware version, though. But depending on your model, 
those fixed version might not be available.

> 
> Guess I'll have to check if there's a more recent firmware for this
> system..

At least worth a try.

Cheers,
Bernd
