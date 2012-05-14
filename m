From: Asdo <asdo@shiftmail.org>
Subject: Re: ext4 barrier on SCSI vs SATA?
Date: Mon, 14 May 2012 12:33:03 +0200
Message-ID: <4FB0DF5F.2060400@shiftmail.org>
References: <4FA7A584.5060902@pocock.com.au>
 <20120509195056.GH5092@quack.suse.cz> <4FAC9EC4.1000906@shiftmail.org>
 <20120514090230.GA5353@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade4.isti.cnr.it ([194.119.192.20]:4280 "EHLO
	blade4.isti.cnr.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2ENKdP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2012 06:33:15 -0400
Received: from [192.168.7.52] ([155.253.6.254])
 by mx.isti.cnr.it (PMDF V6.5-x6 #31988)
 with ESMTPSA id <01OFH1IOBCFWMEM487@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Mon, 14 May 2012 12:32:59 +0200 (MEST)
In-reply-to: <20120514090230.GA5353@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/14/12 11:02, Jan Kara wrote:
>> However the flush was always available (I think), in fact databases
>> would not corrupt (not even above ext4 nobarrier, above a raid5
>> without barriers) if fsync was called at proper times.
>    This is not true. Both cache flushes and barriers were implemented by
> the same mechanism in older kernels. Thus if the device did not properly
> propagate the barrier capability, then fsync did not provide any guarantees
> in case of power failure (if there are volalile write caches in the storage
> device).

Oh! Thanks I had not realized this.

So, if barrier IS provided by the underlying blockdevice but filesystem 
is nevertheless mounted as nobarrier (as an explicit option) would 
database flushes (fsync) for files on THAT filesystem work properly or not?

Thanks for your insight
