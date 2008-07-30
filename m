From: Gary Hawco <ghawco@cox.net>
Subject: Ext4-patch-queue rebased to 2.6.26-rc1?
Date: Wed, 30 Jul 2008 09:46:39
Message-ID: <3.0.6.32.20080730094639.01a69df8@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao101.cox.net ([68.230.241.45]:58038 "EHLO
	fed1rmmtao101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYG3Qql (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2008 12:46:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

The latest patch in the queue errors out with "patch already applied"
error. I noticed that the patch from 073008/0301hrs GMT was rebased against
2.6.26-rc1, as opposed to what I think you meant, 2.6.27-rc1. I am sure
this is why the newest patch from today @ 0339hrs fails to patch the
2.6.27-rc1 kernel source cleanly.

Thanks,
Gary

P.S. I have a minor, weird problem involving midnight commander in both
Gentoo & Slackware that is also ext4-patch-queue related. The previous
patch I was using from 071508/2315hrs was fine. I didn't want to use the
git kernel, so I didn't update until the 072808/0005hrs GMT snapshot (Add
documentation re: mke2fs.conf label). This snapshot (and presumably all
newer ones add a continous row of symbols that resemble a nine (9) with a
longer tail to the border, top & bottom, left & right to mc in both Gentoo
& Slackware. This is while running in init3. It doesn't do it while running
in kde and opening a console and then starting mc.

I wanted to test the newest snapshot you posted to see if this problem
still exists, but again there is the patching problem.  I know there are
twelve patches between 071505/2315 & 072808/0005hrs, but I thought maybe
you an idea what would cause this mc corruption. Resetting the terminal in
init3 does not help.




