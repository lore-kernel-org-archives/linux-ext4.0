From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 0/4]ext4: Bug fixes for EXT4_IOC_MOVE_EXT ioctl
Date: Fri, 30 Oct 2009 16:41:43 +0900
Message-ID: <4AEA98B7.2080104@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40498 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZJ3Hmd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 03:42:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This patch series is related to EXT4_IOC_MOVE_EXT ioctl.
The first one is a patch I sent before but not be included in
the ext4 patch queue yet, so I resend it.

1/4 [RESEND] Fix block count in EXT4_IOC_MOVE_EXT failure
2/4 Fix lock order problem in ext4_move_extents()
3/4 Fix possible recursive locking warning in EXT4_IOC_MOVE_EXT
4/4 Fix comment typo in move_extents.c

These patches are applies to 2.6.31-git17 with the latest ext4 patch queue
(4504d7f7fff06501c517a3e2eb87a1381ecbc539).

Regards,
Akira Fujita
