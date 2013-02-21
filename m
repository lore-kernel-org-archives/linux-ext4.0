From: Eric Sandeen <sandeen@redhat.com>
Subject: Another resize issue - corruption case
Date: Thu, 21 Feb 2013 10:25:20 -0600
Message-ID: <51264A70.3010106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab3BUQZW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2013 11:25:22 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1LGPL4Q019492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2013 11:25:21 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r1LGPKfN001950
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2013 11:25:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Again, for posterity, and in case anyone starts to dig into resize soon:

Bug 913245 - resize2fs w/ large block & inode count is going badly 
https://bugzilla.redhat.com/show_bug.cgi?id=913245

Contains a fair bit of weirdness, but the outright problematic bug is that it's allowing the number of inodes to grow past 2^32.  Loopback reproducer is in the bug.

The fs ends up quite corrupt, as well, and seems to not be growing by the correct amount, etc.

Seems like resize needs a lot of love still.

-Eric
