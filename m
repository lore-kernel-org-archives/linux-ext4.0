From: Gary Hawco <ghawco@cox.net>
Subject: (unknown)
Date: Sat, 14 Jun 2008 14:26:00
Message-ID: <3.0.6.32.20080614142600.01b28a50@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao105.cox.net ([68.230.241.41]:46397 "EHLO
	fed1rmmtao105.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650AbYFNV0D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Jun 2008 17:26:03 -0400
Received: from fed1rmimpo02.cox.net ([70.169.32.72])
          by fed1rmmtao105.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20080614212559.ZQZZ4466.fed1rmmtao105.cox.net@fed1rmimpo02.cox.net>
          for <linux-ext4@vger.kernel.org>; Sat, 14 Jun 2008 17:25:59 -0400
Subject: 
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Good afternoon,

Having two problems with the ext4-patch-queue repository.

Last night I updated my ext4-patch-queue.git repository. I saw that it had
been rebased to linux-2.6.26-rc6.

So I downloaded the 2.6.26-r6 kernel source and patched it with the updated
ext4-patch-queue. So far so good. Compiled it without issue. (I used my
.config from linux-2.6.26-rc5 which worked fine).

However, on reboot this rc6 kernel crashes in Slackware 12.1.

Any ideas why?

Problem two.

Today I decided to delete my ext4-patch-queue folder and redo it hoping to
fix the above problem.

Did this:  git clone git://repo.or.cz/ext4-patch-queue.git
and git hangs with this message:

Initialized git repository in /sda7/ext4-patch-queue/.git/
repo.or.cz[0: 62.24.64.27]: errno=Connection timed out
fatal: unable to connect a socket (Connection timed out)
fetch-pack from 'git://repo.or.cz/ext4-patch-queue.git' failed

Note: I have the same problem with this repository whether I try it using
Gentoo or Slackware 12.1

Any suggestions would be most welcome.

Thanks,
Gary Hawco
Tucson, AZ

