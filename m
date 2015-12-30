From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: ERROR Transfer event for disabled endpoint or incorrect stream ring
Date: Wed, 30 Dec 2015 18:42:06 +0100
Message-ID: <n6151e$rlm$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51355 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbbL3RmR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Dec 2015 12:42:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1aEKlJ-0002yG-CA
	for linux-ext4@vger.kernel.org; Wed, 30 Dec 2015 18:42:13 +0100
Received: from ip4d14b373.dynamic.kabel-deutschland.de ([77.20.179.115])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 30 Dec 2015 18:42:13 +0100
Received: from for-gmane by ip4d14b373.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 30 Dec 2015 18:42:13 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While copying a disk with the dd command from inside a live-CD-boot-system
the following single error has been printed:

xhci_hcd ERROR Transfer event for disabled endpoint or incorrect stream ring
@0000000212409100 00000000 00000000 0a000000 02088001

Does anybody know what these numbers mean?

But other than that, everything seems ok.
This was a backup of the whole disk.
fsck on both disks does not report any errors.

I wonder if it would be possible with the numbers to locate the affected file?


