From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Thu, 05 Oct 2006 13:23:30 -0500
Message-ID: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:61114 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751390AbWJESXf
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Oct 2006 14:23:35 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k95INXT6026129
	for <linux-ext4@vger.kernel.org>; Thu, 5 Oct 2006 14:23:33 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k95INXhP339082
	for <linux-ext4@vger.kernel.org>; Thu, 5 Oct 2006 12:23:33 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k95INWML018897
	for <linux-ext4@vger.kernel.org>; Thu, 5 Oct 2006 12:23:32 -0600
To: Andrew Morton <akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I have rebuilt the ext4/jbd2 patches against linux-2.6.19-rc1.  The
patch set is located at
ftp://kernel.org/pub/linux/kernel/people/shaggy/ext4/2.6.19-rc1/ext4-patches-2.6.19-rc1.tar.gz

Broken out patches in
ftp://kernel.org/pub/linux/kernel/people/shaggy/ext4/2.6.19-rc1/ext4-patches

The patches begin with exact copies of the rc1 version of ext3 and jbd,
so there are no ext3/jbd patches currently in mainline that need to be
applied to the new code.  I'll continue to watch ext3/jbd for patches
that need to be ported to ext4/jbd2.
-- 
David Kleikamp
IBM Linux Technology Center

