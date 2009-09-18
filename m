From: Francesco Pretto <ceztkoml@gmail.com>
Subject: Does ext4 perform online update of the bad blocks inode?
Date: Fri, 18 Sep 2009 20:26:01 +0000 (UTC)
Message-ID: <loom.20090918T221210-583@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39590 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbZIRUaE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 16:30:04 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1Mok5k-0001Fe-Af
	for linux-ext4@vger.kernel.org; Fri, 18 Sep 2009 22:30:04 +0200
Received: from ip-87-238-2-119.static.adsl.cheapnet.it ([87.238.2.119])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 22:30:04 +0200
Received: from ceztkoml by ip-87-238-2-119.static.adsl.cheapnet.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 22:30:04 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Does ext4 update the bad blocks inode when a read/write failure is detected in a
mounted filesystem? If not, is safe a daily/weekly "fsck.ext4 -n -c device" on a
mounted filesystem? Would be safe even on a raid volume?

Unfortunately, still no Bad Block Relocation Target for lvm2 so I'm interested
in similar fs features.

Thanks,
Francesco

