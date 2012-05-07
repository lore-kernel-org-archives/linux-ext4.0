From: Daniel Pocock <daniel@pocock.com.au>
Subject: ext4 barrier on SCSI vs SATA?
Date: Mon, 07 May 2012 10:35:48 +0000
Message-ID: <4FA7A584.5060902@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:54672 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2EGKnH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2012 06:43:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id 271E01586F
	for <linux-ext4@vger.kernel.org>; Mon,  7 May 2012 11:36:04 +0100 (BST)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 7YakPeREU5+p for <linux-ext4@vger.kernel.org>;
	Mon,  7 May 2012 11:35:49 +0100 (BST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



I understand that for barriers to work, the fs needs to be able to tell
the drive when to move data from hardware cache to the platter.

I notice various pages mention the SYNCHRONIZE CACHE command (SCSI) and
the FLUSH_CACHE_EXT command (ATA) as if they are equivalent.

Looking more closely, I found the SYNCHRONIZE CACHE supports a block
range, whereas it appears that FLUSH_CACHE_EXT always flushes the entire
cache (maybe 32MB or 64MB on a SATA drive)

Does ext4 always flush all of the cache contents?  Or if the system is
SCSI, does it only selectively flush the blocks that must be flushed to
maintain coherency?

