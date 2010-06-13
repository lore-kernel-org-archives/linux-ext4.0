From: Andi Kleen <andi@firstfloor.org>
Subject: ext4 df free space reporting not reliable?
Date: Sun, 13 Jun 2010 11:38:08 +0200
Message-ID: <20100613093807.GA31407@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:45765 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab0FMJiK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jun 2010 05:38:10 -0400
Received: from basil.firstfloor.org (p5B3C97FE.dip0.t-ipconnect.de [91.60.151.254])
	by one.firstfloor.org (Postfix) with ESMTP id 6C61E1A980C3
	for <linux-ext4@vger.kernel.org>; Sun, 13 Jun 2010 11:38:09 +0200 (CEST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

I have a ext4 file system on 2.6.34 that shows 0 blocks available
in "df" (it's nearly full but never got a ENOSPC). 

But when I delete a couple of files it still shows 0 blocks.
And I can actually create small files without problem, so clearly
there is at least some space available.

So is df reporting not accurate?

Thanks,
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
