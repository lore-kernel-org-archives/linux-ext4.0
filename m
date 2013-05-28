From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/6] ext3/4 data integrity fixes
Date: Tue, 28 May 2013 13:18:55 +0400
Message-ID: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:30406 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933615Ab3E1JTN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 05:19:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here is updated patch set for various data integrity issues.

TOC:

jbd2: optimize jbd2_journal_force_commit
ext4: fix data integrity for ext4_sync_fs
jbd: optimize journal_force_commit
ext3: fix data integrity for ext4_sync_fs
ext4: Fix fsync error handling after filesystem abort.
ext3: Fix fsync error handling after filesystem abort.
