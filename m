From: Daniel <dnlfrm@immunepc.com>
Subject: Automatic fsck behavior
Date: Thu, 17 Jul 2014 02:55:46 +0000 (UTC)
Message-ID: <loom.20140717T043842-31@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43135 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbaGQDAJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jul 2014 23:00:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1X7bvQ-0003bR-9h
	for linux-ext4@vger.kernel.org; Thu, 17 Jul 2014 05:00:04 +0200
Received: from 99-21-121-156.lightspeed.livnmi.sbcglobal.net ([99.21.121.156])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2014 05:00:04 +0200
Received: from dnlfrm by 99-21-121-156.lightspeed.livnmi.sbcglobal.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2014 05:00:04 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Had some questions about automatic boot-time fsck, following a power-loss or
hard-shutdown, etc.
All prior research (web searching, etc) on this has been inconclusive.

1) Does it do a real fsck or only a journal playback?

2) If it's a real fsck, is it done in repair mode or diagnostic mode?

Also, do the answers depend/vary according to ext4 version or anything else?

Thank you

