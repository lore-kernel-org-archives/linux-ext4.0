From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH] e2fsprogs: journal code small cleanup and fixes
Date: Wed,  9 Jul 2014 00:41:19 +0400
Message-ID: <1404852082-1550-1-git-send-email-a3at.mail@gmail.com>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:47817 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaGHUlh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2014 16:41:37 -0400
Received: by mail-la0-f48.google.com with SMTP id el20so4405234lab.35
        for <linux-ext4@vger.kernel.org>; Tue, 08 Jul 2014 13:41:35 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi there, here is a patch set with various cleanups in e2fsprogs code for 
working journal device and fix tune2fs to update UUID for journal dev properly.
(we need to copy UUID into jsb for this)

First first two are cleanups, and the last one is UUID fix:
[PATCH 1/3] journal: use consts instead of 1024 and add helper for
[PATCH 2/3] tune2fs: remove_journal_device(): use the correct block
[PATCH 3/3] tune2fs: update journal super block when changing UUID
