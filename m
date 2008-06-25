From: Gary Hawco <ghawco@cox.net>
Subject: Segmentation Faults with latest ext4 patches
Date: Tue, 24 Jun 2008 23:07:33
Message-ID: <3.0.6.32.20080624230733.01ab9e60@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Mingming <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao101.cox.net ([68.230.241.45]:43633 "EHLO
	fed1rmmtao101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbYFYGHe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jun 2008 02:07:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Recompiled my Gentoo Kernel with latest ext4-patch-queue. Now it segfaults
when copying files or creating a tarball.

Kernel was fine until last two patches were included, those from 062408
2256GMT &  062508 0019hrs.

Was using ordered data mode. Switched to writeback mode to see if that
would help but same problem.

Sorry I wasn't able to "trap" the screen, but the errors had a lot of ext-*
& jbd-* patches if that helps.

Gary

