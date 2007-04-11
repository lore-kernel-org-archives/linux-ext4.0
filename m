From: Eric Sandeen <sandeen@redhat.com>
Subject: debugfs fill_bgs command?
Date: Wed, 11 Apr 2007 15:17:26 -0500
Message-ID: <461D4256.6020509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965233AbXDKUUA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2007 16:20:00 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l3BKK09n009665
	for <linux-ext4@vger.kernel.org>; Wed, 11 Apr 2007 16:20:00 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l3BKJxkP020508
	for <linux-ext4@vger.kernel.org>; Wed, 11 Apr 2007 16:19:59 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l3BKJvXc031959
	for <linux-ext4@vger.kernel.org>; Wed, 11 Apr 2007 16:19:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I was wondering if others think it would be useful to have a "fill_bgs"
command in debugfs; this would (minimally) mark the lower X bgs as full
for both inodes & blocks (possibly either/or), to allow testing the
higher block groups.  I'm using a hacked up version of this to do a
little ext3 testing above 8T.  Given that this would really only be a
testing option in nature, would it be accepted into e2fsprogs?  I'd
probably need some sort of "unfill" command as well, to put the bg
counters back where they should be; probably by actually reading the
bitmaps.  This way fsck would still find a consistent filesystem...

I had originally written a set_bg_field function too, to go with inode &
sb variants, though for marking the first few thousand bg's it was going
to get a bit tedious... :)

Thoughts?

Thanks,
-Eric
