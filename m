From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Revert  Fix-EXT_MAX_BLOCK.patch
Date: Fri, 11 Jul 2008 09:57:47 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0807110947290.31436@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
 <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker>
 <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de> <20080619110947.GB11516@mit.edu>
 <Pine.LNX.4.64.0807071047430.17563@diagnostix.dwd.de>
 <Pine.LNX.4.64.0807100804050.16071@diagnostix.dwd.de> <20080710092425.GA16451@skywalker>
 <20080710092517.GB16451@skywalker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Girish Shilamkar <Girish.Shilamkar@sun.com>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:34901 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbYGKJ5v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jul 2008 05:57:51 -0400
In-Reply-To: <20080710092517.GB16451@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 10 Jul 2008, Aneesh Kumar K.V wrote:

> Sending again with different subject.
>
> On Thu, Jul 10, 2008 at 02:54:25PM +0530, Aneesh Kumar K.V wrote:
>> On Thu, Jul 10, 2008 at 08:11:15AM +0000, Holger Kiehl wrote:
>>> On Mon, 7 Jul 2008, Holger Kiehl wrote:
>>>
>>>
>>> I did try newer patch queue (ext4-patch-queue-a5d48915447f44c3af6ce8e1c91d45b452977fcf)
>>> from today, but I immediatly hit an oops as soon as I untar a file, see below.
>>>
>>
>> I am able to reproduce this.  Revert the patch Fix-EXT_MAX_BLOCK.patch.
>>
Thanks. Reverting that patch also fixed it for me. I was able to do my
test however performance is down another 10% (compared to
ext4-patch-queue-52c8a02a8a7b7e5915b9301e9c171b4faf22b928). ext4 is getting
slower and slower :(

Also the group descriptors still get corrupted.

Holger

PS: http://repo.or.cz/w/ext4-patch-queue.git is empty, is that correct?

