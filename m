From: norritt@t-online.de
Subject: Ongoing data reorganization/defragmentation?
Date: Wed, 12 Sep 2012 18:36:24 +0200
Message-ID: <5050BA08.80709@bytefortress.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout10.t-online.de ([194.25.134.21]:50856 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2ILQz1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Sep 2012 12:55:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ongoing data reorganization/defragmentation?

In my efforts to optimize an ext4 for usage on SSDs, I have found 
information on the web about ext4 I've not been able to verify.

 From what I've found out it's a good idea to:
- mount with noatime, discard (if drive supports trim)
- put /tmp and maybe /var on a tempfs
- set vm.swappiness=1, vm.vfs_cache_pressure=50 (to utilize RAM rather 
than the disk)

Another proposal found is to disable journaling what I personally won't do.

I also know from the ext4 dcumentation, that ext4 is written to support 
online defragmentation. I've read several rumours on forums and blogs 
that indicate ext4 is doing some kind of "ongoing data reorganisations 
or defragmentation" in the background, in case the mechanisms to prevent 
fragmentation in the first place failed for some reason (i.e. when a fs 
is running out of free space). I did not find any credible information 
to back up these claims, that ext4 is actively reorganizing data, but I 
didn't find any information that prove these claims wrong either.

So my question is, does ext4 reorganize data when it encounters 
fragmented files? If so, is there a way to disable that feature which 
would not do any good on SSDs? Is there anything else to consider when 
using ext4 on SSDs, except the things I mentioned above?

Please cc me since I'm not subscribed, thanks!

Regards Nor

