From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH 0/5] e2fsprogs: some small cleanups and fixes for journal code
Date: Thu, 10 Jul 2014 18:35:03 +0400
Message-ID: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
Cc: darrick.wong@oracle.com, adilger@dilger.ca, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:54482 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaGJOfU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 10:35:20 -0400
Received: by mail-la0-f44.google.com with SMTP id gl10so902889lab.3
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2014 07:35:18 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH 1/5] lib: add EXT2_ prefix for SUPERBLOCK_{OFFSET,SIZE}
[PATCH 2/5] journal: use consts instead of 1024 and add helper for
[PATCH 3/5] tune2fs: remove_journal_device(): use the correct block
[PATCH 4/5] tune2fs: update journal super block when changing UUID
[PATCH 5/5] tune2fs: update journal users while updating fs UUID
