From: Eric Sandeen <sandeen@redhat.com>
Subject: delalloc space accounting problem.
Date: Thu, 08 Nov 2007 11:45:40 -0600
Message-ID: <47334B44.8080206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759833AbXKHRqC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2007 12:46:02 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lA8Hk1Lm007291
	for <linux-ext4@vger.kernel.org>; Thu, 8 Nov 2007 12:46:01 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lA8HjprQ003334
	for <linux-ext4@vger.kernel.org>; Thu, 8 Nov 2007 12:45:51 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id lA8Hje2J009994
	for <linux-ext4@vger.kernel.org>; Thu, 8 Nov 2007 12:45:45 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It appears that delalloc lets me copy 50M of data onto a 30M filesystem;
at least I never get ENOSPC back, although I wind up with several files
that have 1M length but 0 blocks.

I've filed a bug in the kernel bug tracker, I think we could use a
central place to track issues:

http://bugzilla.kernel.org/show_bug.cgi?id=9329

I'll try to find time to look into this unless someone knows offhand
where the problem is...

Thanks,
-Eric

(p.s. should I get ext[234] bug mail routed to this list, or would that
be annoying?)
