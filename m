From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: planning general storage capacity for y fs
Date: Sun, 26 Apr 2015 14:14:53 +0300
Message-ID: <006901d08012$3a1f97a0$ae5ec6e0$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <linux-mtd@lists.infradead.org>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40242 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbDZLO5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Apr 2015 07:14:57 -0400
Content-Language: en-us
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
I'm looking for guidelines for planning storage capacity. I understand it
strongly depended on the usage type.
I want to know at what point storage fullness is effecting performance in a
standard read/write partition. Do different File Systems (UBIFS/EXT4) have
different full-free ratio?
What about read only fs? Can I plan less free space in such cases?

I'll appreciate any input on this, for UBIFS specific and fs in general.

Thanks,
Dolev
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux
Foundation Collaborative Project


