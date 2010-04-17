From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Sat, 17 Apr 2010 20:43:27 +0200
Message-ID: <201004172043.27906.bernd.schubert@fastmail.fm>
References: <20100416123526.GW21495@skl-net.de> <201004171855.36874.bernd.schubert@fastmail.fm> <20100417181912.GC25507@skl-net.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51771 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946Ab0DQSna (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Apr 2010 14:43:30 -0400
In-Reply-To: <20100417181912.GC25507@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Saturday 17 April 2010, Andre Noll wrote:
> On 18:55, Bernd Schubert wrote:
> > > > To update the default timeout value (30 seconds) for commands
> > > > submitted to /dev/sdn to 60 seconds:
> > > >
> > > >         $ echo 60 > /sys/block/sdn/device/timeout
> > >
> > > I will re-run the stress test with a 60 seconds timeout value and
> > > follow up if this did not help.
> >
> > That will not help if the command is "SYNCHRONIZE_CACHE", as that ignores
> > device settings, but uses scsi default timeout (30s), which is far too
> > small for SATA based raid units. Scsi maintainers ignored that and a
> > couple of other patches I wrote to improve error handling with Infortrend
> > units. Will send the patches again soon.
> 
> Please CC me when you do so. The machine I am having trouble with is
> only our fallback server. I can use it freely for testing and am willing
> to give your patches a try.

There is actually not much to test, as the patches had been the only solution 
to stabilize a large Lustre environment with dozens of Infortrend Raids. I 
spent months to debug Infortrend Raids, scsi stack and the LSI MPT fusion 
driver. Nowadays some patches are also used for DDN customers. 
I'm just always out of time to forward port it to more recent linux-git and to 
resend.


Cheers,
Bernd

