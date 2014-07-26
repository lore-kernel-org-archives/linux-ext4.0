From: Vlad Dobrotescu <vlad@dobrotescu.ca>
Subject: Question: errors=continue behaviour for failed external journal device
Date: Sat, 26 Jul 2014 23:07:59 +0000 (UTC)
Message-ID: <loom.20140727T010632-633@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41053 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbaGZXKH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 19:10:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1XBB6L-0006bC-5P
	for linux-ext4@vger.kernel.org; Sun, 27 Jul 2014 01:10:05 +0200
Received: from CPE0014bf20c105-CMbc140122c850.cpe.net.cable.rogers.com ([99.224.129.89])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jul 2014 01:10:05 +0200
Received: from vlad by CPE0014bf20c105-CMbc140122c850.cpe.net.cable.rogers.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jul 2014 01:10:05 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If this isn't the proper place for this question, please point me in 
the right direction.

I couldn't find any description on Ext4's behaviour when mounted 
with errors=continue and external journal if the journal block device 
is unavailable at mount time (or becomes unavailable at some point).

I would be using CentOS 7 (kernel 3.10.0-123.4.4.el7 x86_64) and 
(probably) full data journaling on a SSD. Can someone help?

