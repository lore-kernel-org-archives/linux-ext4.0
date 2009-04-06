From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Mon, 06 Apr 2009 01:47:33 -0400
Message-ID: <49D99775.9030104@garzik.org>
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>	<alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>	<20090404135719.GA9812@mit.edu>	<20090404151649.GE5178@kernel.dk>	<alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>	<20090404173412.GF5178@kernel.dk>	<alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>	<20090404180108.GH5178@kernel.dk>	<20090404232222.GA7480@mit.edu>	<20090404163349.20df1208@infradead.org>	<20090405001005.GA7553@mit.edu>	<alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>	<49D8E71F.6000703@rtr.ca>	<49D91B31.90300@garzik.org> <20090405164831.7ad01c20@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mark Lord <lkml@rtr.ca>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40537 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbZDFFsH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Apr 2009 01:48:07 -0400
In-Reply-To: <20090405164831.7ad01c20@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Arjan van de Ven wrote:
> On Sun, 05 Apr 2009 16:57:21 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
>> We set it in libata-scsi.c:ata_scsi_dev_config() based on
>> ata_id_is_ssd()
>>
>> That hueristic probably assumes Intel SSDs or something :/
> 
> you mean the "rpm" set to '1' ?
> I was pretty sure that that was industry standard...

A -new- industry standard.  You can certainly create a compliant SSD 
while only conforming to ATA-7, for example.  Some older IDE flash 
devices pretend they are normal hard drives in almost every respect, too.

	Jeff



