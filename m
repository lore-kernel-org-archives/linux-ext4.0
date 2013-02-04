From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Subject: Maximum number of directories
Date: Mon, 04 Feb 2013 10:55:54 +0000
Message-ID: <17001225.1MS6YREEfJ@deuteros>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from claranet-outbound-smtp06.uk.clara.net ([195.8.89.39]:49984 "EHLO
	claranet-outbound-smtp06.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007Ab3BDL3V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2013 06:29:21 -0500
Received: from 110.100.155.90.in-addr.arpa ([90.155.100.110]:38662 helo=deuteros.localnet)
	by relay06.mail.eu.clara.net (relay.clara.net [213.253.3.46]:1025)
	with esmtps (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	id 1U2JiN-0001Ry-JQ  for linux-ext4@vger.kernel.org
	(return-path <tvrtko.ursulin@onelan.co.uk>); Mon, 04 Feb 2013 10:55:55 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi all,

What is the maximum number of directories ext4 can hold in a tree layout with 
a depth of ~160 and each directory node having then a couple to couple dozen 
subdirectories?

I was creating such a (crazy?) tree and hit -ENOSPC at ~31 million directories 
created in total with df showing only 40% use:

Filesystem                 1K-blocks       Used  Available Use% Mounted on
/dev/mapper/data           477277612K 177766152K 275621952K  40% /data

Some lines from tune2fs made me think it should hold more, but obviously I was 
mistaken? Or it is a bug?

Inode count:              29868032
Free inodes:              29848131

Regards,

Tvrtko

