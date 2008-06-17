From: Gary Hawco <ghawco@cox.net>
Subject: Ordered data mode vs. writeback mode
Date: Mon, 16 Jun 2008 22:59:30
Message-ID: <3.0.6.32.20080616225930.01b86a60@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao102.cox.net ([68.230.241.44]:50901 "EHLO
	fed1rmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYFQF7c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 01:59:32 -0400
Received: from fed1rmimpo03.cox.net ([70.169.32.75])
          by fed1rmmtao102.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20080617055928.BEGQ1150.fed1rmmtao102.cox.net@fed1rmimpo03.cox.net>
          for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 01:59:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Noticed that the newest set of patches in ext4-patch-queue has ordered data
mode as the default mode again. Tune2fs is now able to switch modes again.

What is the preferred mode for a home desktop system with ext4? Is
writeback still the fastest, but ordered data has more data integrity?  And
does delalloc only work when writeback is enabled? And does the commit=XX
seconds still only work with writeback mode, ala ext3, or is it a valid
option with ordered data mode?

Trying to get an idea of the plethora of new options available with ext4.

Keep up the good work!

Gary



