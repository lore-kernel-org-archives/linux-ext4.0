From: Taras Glek <tglek@mozilla.com>
Subject: Minimizing fragmentation in ext4, fallocate not enough?
Date: Fri, 24 Sep 2010 17:05:42 -0700
Message-ID: <4C9D3CD6.9080000@mozilla.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dm-mail01.mozilla.org ([63.245.208.150]:34110 "EHLO
	dm-mail01.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab0IYAZ2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Sep 2010 20:25:28 -0400
Received: from [192.168.1.10] (v74-nslb.mozilla.org [10.2.74.4])
	(Authenticated sender: tglek@mozilla.com)
	by dm-mail01.mozilla.org (Postfix) with ESMTP id 7C700B801A
	for <linux-ext4@vger.kernel.org>; Fri, 24 Sep 2010 17:05:42 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
I noticed that several random IO-heavy Firefox files got fragmented 
easily. Our cache suffers most.
The cache works by creating a flat file and storing fixed-size entries 
in it. I though if I fallocate() the file first, then all of the writes 
within the allocated area would not cause additional fragmentation.

This doesn't seem to completely cure fragmentation with ext4 in 2.6.33. 
If I allocate a 4mb file, it gets more and more fragmented over time. 
fallocate() does reduce fragmentation, but not as much as I expected.

I assumed that writing to an fallocate()ed area will not cause 
additional fragmentation. Is my assumption incorrect?

Thanks,
Taras

ps. I'm using filefrag for measuring fragmentation.

ps2. Does running filefrag on a directory mean anything in ext4?
