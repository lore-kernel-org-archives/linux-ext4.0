From: Mark Lord <lkml@rtr.ca>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Sun, 05 Apr 2009 22:32:23 -0400
Message-ID: <49D969B7.8050501@rtr.ca>
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>	<alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>	<20090404135719.GA9812@mit.edu>	<20090404151649.GE5178@kernel.dk>	<alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>	<20090404173412.GF5178@kernel.dk>	<alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>	<20090404180108.GH5178@kernel.dk>	<20090404232222.GA7480@mit.edu>	<20090404163349.20df1208@infradead.org>	<20090405001005.GA7553@mit.edu>	<alpine.LFD.2.00.0904050927580.4023@localhost.localdomain>	<49D8E71F.6000703@rtr.ca>	<49D91B31.90300@garzik.org> <20090405164831.7ad01c20@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:57702 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZDFC3A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Apr 2009 22:29:00 -0400
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
.. 

Or even set to zero.  I just don't recall seeing the RPM
reported by hdparm-9.12 for Jeff's SSD.

Cheers
