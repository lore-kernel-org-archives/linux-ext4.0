From: "George Spelvin" <linux@horizon.com>
Subject: metadata_csum + unclean shutdown = failure to boot
Date: 7 Oct 2012 01:04:27 -0400
Message-ID: <20121007050427.6711.qmail@science.horizon.com>
Cc: linux@horizon.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:19748 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750851Ab2JGFE2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Oct 2012 01:04:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Feeling a bit adventurous, I enabled metadata_csum on many of
my daily-use file systems.

I have now noticed a problem in the event of an unclean shutdown.

On reboot, the kernel complains about a bad superblock checksum, suggests
e2fsck, and then fails to mount the root filesystem.

This makes running e2fsck a bit problematic.

I can fix it manually, but it makes automatic reboots *extremely*
problematic.

Is it possible to fix the kernel code to be a bit more forgiving?
