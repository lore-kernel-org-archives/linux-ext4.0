From: Gary Hawco <ghawco@cox.net>
Subject: ext4 patched linux-2.6.26-rc6 kernel crashes
Date: Mon, 16 Jun 2008 10:29:47
Message-ID: <3.0.6.32.20080616102947.02418998@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao103.cox.net ([68.230.241.43]:63737 "EHLO
	fed1rmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbYFPR3w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 13:29:52 -0400
Received: from fed1rmimpo03.cox.net ([70.169.32.75])
          by fed1rmmtao103.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20080616172942.PCYN1276.fed1rmmtao103.cox.net@fed1rmimpo03.cox.net>
          for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 13:29:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Good morning,

I can't seem to get my linux kernel 2.6.26-rc6 patched with the latest
ext4-patch-queue to boot.

The patches apply fine and the kernel compiles fine. I used my .config from
-rc5 kernel which will boot fine.

This "oops" occurs in both Gentoo and Slackware 12.1. It seems to happen at
about the point when the operating systems are autoloading modules.

I am unable to take a screen shot to assist, so I was wondering if someone
could try the new kernel with the latest patches?  The source is the latest
linux-2.6.26-rc6.tar.bz2 so I am sure it's fine.

Thanks again,
Gary Hawco

