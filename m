From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] e2fsprogs: update mkfs defaults
Date: Wed, 16 Feb 2011 12:12:16 -0600
Message-ID: <4D5C1380.2020602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab1BPSMS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 13:12:18 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GICIuS026248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Feb 2011 13:12:18 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1GICHHB013119
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Feb 2011 13:12:18 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Anaconda (the Fedora/RHEL installer) had been "fixing up" extN filesystems it created by setting the max mount count and check interval to 0, as well as adding user_xattr to filesystem mount options.

As part of their efforts to stop special-casing around upstream defaults, they've removed these changes upstream.

However, I'd like to at least propose that these changes be made default.

The forced fsck often comes at unexpected and inopportune moments, and even enterprise customers are often caught by surprise when this happens.  Because a filesystem with an error condition will be marked as requiring fsck anyway, I submit that the time-based and mount-based checks are not particularly useful, and that administrators can schedule fscks on their own time, or tune2fs the enforced intervals if they so choose.  Patch #1 disables the intervals by default, and I've added a new mkfs option (-C) to turn on the old behavior of random, unexpected, time-consuming fscks at boot time.  ;)

User namespace xattrs are generally useful, and I think extN is the only filesystem requiring a special mount option to enable them, when xattrs are otherwise available.  So patch #2 sets that mount option into the defaults.

Thanks,
-Eric
