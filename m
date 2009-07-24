From: Eric Sandeen <sandeen@redhat.com>
Subject: Report of data corruption on ext4
Date: Fri, 24 Jul 2009 10:24:17 -0500
Message-ID: <4A69D221.3000609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54081 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbZGXPYS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jul 2009 11:24:18 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n6OFOJeW010763
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 11:24:19 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6OFOI1o020971
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 11:24:18 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n6OFOHa4027347
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 11:24:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

FYI:

Bug 513221 -  ext4 filesystem corruption and data loss
https://bugzilla.redhat.com/show_bug.cgi?id=513221

is a bit troubling.

Unfortunately it has a lot of false-starts in the bug comments so it
looks a little convoluted and hard to follow.

But the upshot is, he seems to swaths of null bytes in his mail files,
on 4k boundaries, not correlated with extent boundaries necessarily.
And he's not had crashes or power losses, he says.

Not a lot to go on yet, but something to keep an eye on.

-Eric
