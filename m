From: Gary Hawco <ghawco@cox.net>
Subject: Using delalloc with ordered data mode
Date: Tue, 17 Jun 2008 20:01:16
Message-ID: <3.0.6.32.20080617200116.02418a50@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Mingming <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao107.cox.net ([68.230.241.39]:64044 "EHLO
	fed1rmmtao107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969AbYFRDBR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 23:01:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was reviewing your patches from 9 hours ago and was confused as to
whether delalloc still needs writeback mode.  I see the
enable-delalloc-by-default-patch that quickly followed the
delalloc-ext4-writeback mode. Does this mean that data=writeback mode must
be used, and if this condition is met, then delalloc is enabled, or is
delalloc enabled even if ordered data mode? Any clarification on this would
be most appreciated.

I am looking for the combination of features that give me the fastest ext4
system with reasonable data integrity.

Gary

