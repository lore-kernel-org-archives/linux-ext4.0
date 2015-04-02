From: Joseph Qi <joseph.qi@huawei.com>
Subject: Issue in ext4 rename
Date: Thu, 2 Apr 2015 18:49:07 +0800
Message-ID: <551D1EA3.1050202@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [119.145.14.65] ([119.145.14.65]:25989 "EHLO
	szxga02-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbbDBKtv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Apr 2015 06:49:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,
In ext4_rename_delete, it only logs a warning if ext4_delete_entry
fails.
IMO, it may lead to an inode with two entries (old and new), thus
filesystem will be inconsistent.
The case is described below:
ext4_rename
	--> ext4_journal_start
	--> ext4_add_entry (new)
	--> ext4_rename_delete (old)
		--> ext4_delete_entry
			--> ext4_journal_get_write_access
			*failed* because of -ENOMEM
	--> ext4_journal_stop
Does anyone have an idea to resolve this issue?

