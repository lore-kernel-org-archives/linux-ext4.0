From: Asdo <asdo@shiftmail.org>
Subject: Re: ext4 barrier on SCSI vs SATA?
Date: Fri, 11 May 2012 07:08:20 +0200
Message-ID: <4FAC9EC4.1000906@shiftmail.org>
References: <4FA7A584.5060902@pocock.com.au>
 <20120509195056.GH5092@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:1025 "EHLO
	blade3.isti.cnr.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab2EKHTe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 May 2012 03:19:34 -0400
Received: from [109.52.96.21] by mx.isti.cnr.it (PMDF V6.5-x6 #31988)
 with ESMTPSA id <01OFCJB4MHKCMAUZTA@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Fri, 11 May 2012 07:08:29 +0200 (MEST)
In-reply-to: <20120509195056.GH5092@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/09/12 21:50, Jan Kara wrote:
> []

I have some troubles understanding the barriers thing, can you help me?


In the past some blockdevices would not provide / propagate the 
barriers, e.g. MD raid 5 would not.  So filesystems during mount would 
try the barrier operation and see that it wouldn't work, so they would 
disable barrier option and mount as nobarrier.

However the flush was always available (I think), in fact databases 
would not corrupt (not even above ext4 nobarrier, above a raid5 without 
barriers) if fsync was called at proper times.

So first question is : why filesystems were not using the flush as a 
barrier like databases did?

Second question is : was a nobarrier mount (ext4) more risky in terms of 
data or metadata lost on sudden power loss?

Thank you
Asdo
