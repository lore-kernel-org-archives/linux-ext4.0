From: Eric Sandeen <sandeen@redhat.com>
Subject: dealing with out-of-tree blkid....
Date: Thu, 17 Sep 2009 15:59:23 -0500
Message-ID: <4AB2A32B.4010408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbZIQU7V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Sep 2009 16:59:21 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8HKxOof016341
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 16:59:24 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8HKxObv013554
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 16:59:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was going to hook up the geometry info we can now get from the blkid
which is in util-linux-ng, but I realized that even with
--disable-blkid, we pick up headers from the e2fsprogs tree, so can't
use the new bits.

I'm not sure what the simplest fix is; seems like maybe moving lib/blkid
to lib/local/blkid (or some other name) so that we can still -I./lib and
if we have --enable-blkid, we just add -I./lib/local?  (same probably
true for libuuid)...

I'm sure there's a more graceful way around it, is anyone more of a
buildmeister than I am? :)

Thanks,
-Eric
