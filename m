From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Fri, 16 Apr 2010 09:36:54 -0700
Message-ID: <20100416163654.GD58339@plapa.qlogic.org>
References: <20100416123526.GW21495@skl-net.de>
 <4BC87BF6.2040104@redhat.com>
 <20100416153024.GY25507@skl-net.de>
 <4BC885B9.2000902@redhat.com>
 <20100416155221.GA57840@plapa.qlogic.org>
 <20100416160856.GA25507@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:15691 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab0DPQmD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Apr 2010 12:42:03 -0400
Content-Disposition: inline
In-Reply-To: <20100416160856.GA25507@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 16 Apr 2010, Andre Noll wrote:

> On 08:52, Andrew Vasquez wrote:
> > The driver here is simply reporting that the a command's timeout value
> > had been exceeded and the mid-layer began error-recovery with a request
> > to 'abort' the command.  The abort-request completed successfully:
> > 
> > 	qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 fa6a73 2002.
> > 
> > I can't explain why the storage did not complete the request in the
> > allotted time.
> 
> Ah, that's valuable information, thanks. The underlying Infortrend
> Raid System is rather old but worked without any problems for several
> years. We recently replaced its 400G disks by new 2T WD disks. Maybe
> the new disks have longer response times, could that be the reason? And
> is there a way to increase the timeout value?

To update the default timeout value (30 seconds) for commands
submitted to /dev/sdn to 60 seconds:

        $ echo 60 > /sys/block/sdn/device/timeout

-- av
