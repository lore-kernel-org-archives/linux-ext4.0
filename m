From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Fri, 16 Apr 2010 10:43:53 -0500
Message-ID: <4BC885B9.2000902@redhat.com>
References: <20100416123526.GW21495@skl-net.de> <4BC87BF6.2040104@redhat.com> <20100416153024.GY25507@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-driver@qlogic.com,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758123Ab0DPPoC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Apr 2010 11:44:02 -0400
In-Reply-To: <20100416153024.GY25507@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/16/2010 10:30 AM, Andre Noll wrote:
> On 10:02, Eric Sandeen wrote:
> 
>>> I'm seeing the following errors when writing to an ext4 file system:
>>>
>>> 	qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 fa6a73 2002.
>>> 	end_request: I/O error, dev sda, sector 7812771880
>>
>> Sounds like a hardware failure
> 
> Yes, or a problem with the qla2xxx driver. However, it's a bit
> surprising that the hardware survived the stress test for more than
> one day and went south just at the moment the fs was completely filled.

Hm, that's true.

Well, the error was on sector 7812771880 of the device ...

can you reliably write directly to that sector w/o the filesystem in
between?

-Eric

> My first guess was that the problem might be caused by a reported
> device size which is slightly larger than the actual size. But then
> 
> 	ddrescue -i 7440Gi /dev/zero /dev/sda
> 
> would have resulted in a similar error. This command completed without
> errors though.
> 
> Thanks
> Andre

