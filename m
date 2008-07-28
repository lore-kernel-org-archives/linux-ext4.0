From: Gary Hawco <ghawco@cox.net>
Subject: Unable to disable barriers
Date: Mon, 28 Jul 2008 11:48:37
Message-ID: <3.0.6.32.20080728114837.02425390@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao103.cox.net ([68.230.241.43]:43499 "EHLO
	fed1rmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYG1Ssi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 14:48:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Subject pretty much says it all.

For testing purposes I tried to disable barriers in fstab (barriers=0).  On
reboot the filesystem will not mount read/write until barriers are reenabled.

This occurs whether I use ordered data mode or data writeback mode, in both
Gentoo and Slackware 12.1

Is this behavior by design (that barriers can not be disabled)?

Thanks,
Gary

