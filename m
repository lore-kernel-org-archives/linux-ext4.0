From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/7] ext4: Bunch of DIO/AIO fixes
Date: Sun,  9 Sep 2012 21:27:07 +0400
Message-ID: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37543 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751885Ab2IIR1U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Sep 2012 13:27:20 -0400
Received: by lagy9 with SMTP id y9so659795lag.19
        for <linux-ext4@vger.kernel.org>; Sun, 09 Sep 2012 10:27:18 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are number of races exist caused by lack of synchronization
between DIO workers and truncate/fsync/punch_hole routines
This patch series try to optimize and fix existing DIO/AIO code

TOC:
# first one is simply a cleanup
ext4: ext4_inode_info diet
# Cleanup and bug fixes
ext4: completed_io locking cleanup
ext4: serialize dio nonlocked reads with defrag workers V2
ext4: fsync should wait for DIO writers
ext4: serialize unlocked dio reads with truncate
ext4: endless truncate due to nonlocked dio readers V2
ext4: serialize truncate with owerwrite DIO workers V2

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
