From: Prasanna NAVARATNA <prasanna.navaratna@gmail.com>
Subject: help with 'discard' mount option on ext4
Date: Thu, 10 Oct 2013 08:28:20 +0000 (UTC)
Message-ID: <loom.20131010T102704-458@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50082 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab3JJIfG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Oct 2013 04:35:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1VUBi3-0005bC-Md
	for linux-ext4@vger.kernel.org; Thu, 10 Oct 2013 10:35:03 +0200
Received: from 202.122.18.226 ([202.122.18.226])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 10 Oct 2013 10:35:03 +0200
Received: from prasanna.navaratna by 202.122.18.226 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 10 Oct 2013 10:35:03 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I'm using Hynix eMMC4.41 with Linux kernel 3.4.5.

After mounting ext4 partition /userdata with 'discard' mount option enabled,
fs triggers TRIM commands to eMMC after every file deletion. With this
setup, for a continuous reboot test (5s awake and issue reboot and repeat)
with 10 or 20 iterations, i see data corruption in eMMC consistently.

mount options are :- noatime,nosuid,nodev,noauto_da_alloc,discard
encryptable="path"

What am i missing here? if 'discard' mount option is removed, then no data
corruption in eMMC for more than 200 iterations. Does TRIM needs some extra
care? BKOPS is not enabled in eMMC (is bkops mandatory if using TRIM?)
Are there any latest patches which address these corruption issues during
reboot with discard option enabled?
Please help to analyze further.

Thanks,
Prasanna NAVARATNA

