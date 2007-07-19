From: Zephiris <zephiris@gmail.com>
Subject: e2fsprogs-1.39-tyt3 and ext4 question
Date: Thu, 19 Jul 2007 03:55:10 -0700
Message-ID: <f7nfun$lcs$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45311 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbXGSLAL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jul 2007 07:00:11 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1IBTjm-0003VZ-3F
	for linux-ext4@vger.kernel.org; Thu, 19 Jul 2007 13:00:02 +0200
Received: from c-71-193-243-251.hsd1.or.comcast.net ([71.193.243.251])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jul 2007 13:00:02 +0200
Received: from zephiris by c-71-193-243-251.hsd1.or.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 19 Jul 2007 13:00:02 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've searched the lists and only saw a previous reference to possibly
harmless 'make check' failures on this version, so I'll just ask.
I've been trying to get ext4 running for some time,  but it appears to be
working normally lately. e4defrag and mballoc patches also appear to be
working fine (everything against 2.6.22.1). But that version of e2fsprogs
(1.39-tyt3), even with the last round of patches against it, appears to
generate many bogus errors when checking the filesystem with 'fsck -fn'.
While using 'data=journal' and other things should reduce the chance of
needing a fsck, it makes me worried.

Is there anything at current that can get around this all, or verify that
the errors it's coming up with are indeed bogus (they certainly look it,
hundreds of errors at block 0 or -1, for instance)?

For previous attempts at ext4, running that version of e2fsprogs would come
up with legitimate looking errors, then 'fix' it. But even rebooting
immediately afterwards into emergency read-only mode would generate the
same errors again. Multiple attempts to fix the errors (with probable
legitimate corruption on a few files from a bad attempt at getting e4defrag
working) effectively just shredded the filesystem. 

Ext4 is appearing rather stable right now, which is also making me think
it's fsck's fault.
