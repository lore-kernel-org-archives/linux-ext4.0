From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 00/25] e2fsprogs: Misc cleanups & fixes
Date: Fri, 16 Sep 2011 15:49:15 -0500
Message-ID: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46721 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab1IPUto (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I ran Coverity over e2fsprogs this week, hoping to find any recent-ish
flaws, but most of what it came up with seems longstanding.  I guess
that's a good sign for the recent work, anyway!

Some of these are just tidyups, some are bugfixes.  It gets the defect
count down to around 25 from 70 to start with, but I'll need to take
a deep breath before tackling the rest.

Thanks,
-Eric


