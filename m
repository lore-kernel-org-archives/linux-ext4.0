From: Nikhilesh Reddy <reddyn@codeaurora.org>
Subject: Using Cache barriers in lieu of REQ_FLUSH | REQ_FUA for emmc 5.1
 (jdec spec JESD84-B51)
Date: Tue, 15 Sep 2015 16:17:46 -0700
Message-ID: <55F8A71A.3030001@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41189 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbbIOXRy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Sep 2015 19:17:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

The eMMC 5.1 spec defines cache "barrier" capability of the eMMC device 
as defined in JESD84-B51

I was wondering if there were any downsides to replacing the 
WRITE_FLUSH_FUA	 with the cache barrier?

I understand that REQ_FLUSH is used to ensure that the current cache be 
flushed to prevent any reordering but I dont seem to be clear on why
REQ_FUA is used.
Can someone please help me understand this part?

But as far as I understand it ... the cache barriers can be used to 
replace all the flush requests.

Please let me know if there is any downside to this ?

I know there there was a big decision in 2010 
https://lwn.net/Articles/400541/
and http://lwn.net/Articles/399148/
to remove the software based barrier support... but with the hardware 
supporting "barriers" is there a downside to using them to replace the 
flushes?
-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
