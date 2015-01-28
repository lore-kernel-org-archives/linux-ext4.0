From: Nikhilesh Reddy <reddyn@codeaurora.org>
Subject: Writes blocked on wait_for_stable_page (Writes of less than page
 size sometimes take too long)
Date: Wed, 28 Jan 2015 11:27:13 -0800
Message-ID: <54C93811.1040107@codeaurora.org>
References: <54C93169.3000600@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:45167 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761444AbbA1Umw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Jan 2015 15:42:52 -0500
Received: from [10.46.162.167] (i-global254.qualcomm.com [199.106.103.254])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: reddyn@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id 83F2D141B06
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2015 19:27:22 +0000 (UTC)
In-Reply-To: <54C93169.3000600@codeaurora.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi
I am working on a 64 bit Android device and have been trying to improve 
performance for stream based data download (for example an ftp)
The device has 3GB of ram and the dirty_ratio and dirty_background_ratio 
are set to 5 and 1 respectively.

Kernel 3.10 , Highmem is not enabled and the backing device is a emmc 
and checksumming is not enabled

I noticed when profiling writes that if we dont use streamed IO (ie. use 
write of whatever size data was read on the tcp stream) there are some 
writes that seem to get blocked on
wait_for_stable_page.

If I force the writes to be buffered in the userspace and ensure writing 
4k chunks the writes never seem to stall.

I noticed there was earlier discussion on this and idea were proposed to 
use snapshotting of the pages to avoid stalls...
For example: https://lwn.net/Articles/546658/

But this seems to only snapshot ext3 ... (unless i misunderstood what 
the patch is doing)

Is there a similar patch to snapshot the buffers to not stall the writes 
for ext4?

Please let me know.

I would really appreciate any help you can give me.


-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
