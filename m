From: Markus <M4rkusXXL@web.de>
Subject: Dirty ext4 blocks system startup
Date: Fri, 04 Apr 2014 12:35:45 +0200
Message-ID: <4785109.JJCKTTZWOe@f209>
References: <1459400.cqhC1n3S74@f209>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:55847 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaDDKfr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Apr 2014 06:35:47 -0400
Received: from f209.localnet ([141.70.81.136]) by smtp.web.de (mrweb101) with
 ESMTPSA (Nemesis) id 0MEVYz-1WGwOW3lyD-00FhaN for
 <linux-ext4@vger.kernel.org>; Fri, 04 Apr 2014 12:35:45 +0200
In-Reply-To: <1459400.cqhC1n3S74@f209>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

I have a dirty ext4 volume. The system just hangs at startup. After removing that volume from fstab the system starts.

Mount and e2fsck just flood with "Invalid checksum recovering block 1152 in log" messages.

(Mounting with ro,noload let me access most files.)

I also tried the e2fsck from current git.

debugfs just fails with "Block bitmap checksum does not match bitmap while reading block bitmap". (catastrophic mode does work)

Three points:
- e2fsck should not get into an endless loop, blocking the system.
- mount should not get into an endless loop, blocking the system and flooding the system log.
- At least e2fsck should fix the filesystem.


Any help or hints?


Thanks,
Markus


PS: Original lkml-mail:
https://lkml.org/lkml/2014/4/1/467
