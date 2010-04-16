From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Fri, 16 Apr 2010 08:52:21 -0700
Message-ID: <20100416155221.GA57840@plapa.qlogic.org>
References: <20100416123526.GW21495@skl-net.de>
 <4BC87BF6.2040104@redhat.com>
 <20100416153024.GY25507@skl-net.de>
 <4BC885B9.2000902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andre Noll <maan@systemlinux.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:37138 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1758229Ab0DPPwW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Apr 2010 11:52:22 -0400
Content-Disposition: inline
In-Reply-To: <4BC885B9.2000902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 16 Apr 2010, Eric Sandeen wrote:

> On 04/16/2010 10:30 AM, Andre Noll wrote:
> > On 10:02, Eric Sandeen wrote:
> > 
> >>> I'm seeing the following errors when writing to an ext4 file system:
> >>>
> >>> 	qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 fa6a73 2002.
> >>> 	end_request: I/O error, dev sda, sector 7812771880
> >>
> >> Sounds like a hardware failure
> > 
> > Yes, or a problem with the qla2xxx driver. However, it's a bit
> > surprising that the hardware survived the stress test for more than
> > one day and went south just at the moment the fs was completely filled.
> 
> Hm, that's true.
> 
> Well, the error was on sector 7812771880 of the device ...
> 
> can you reliably write directly to that sector w/o the filesystem in
> between?

The driver here is simply reporting that the a command's timeout value
had been exceeded and the mid-layer began error-recovery with a request
to 'abort' the command.  The abort-request completed successfully:

	qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 fa6a73 2002.

I can't explain why the storage did not complete the request in the
allotted time.

-- av
