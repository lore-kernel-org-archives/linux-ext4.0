From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/4] ext4: ioc_move_ext fixes
Date: Mon, 24 Sep 2012 16:23:50 +0400
Message-ID: <1348489434-22778-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, a-fujita@rs.jp.nec.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50631 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2IXMYB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 08:24:01 -0400
Received: by lbbgj3 with SMTP id gj3so6602143lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 05:24:00 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currenty EXT4_IOC_MOVE_EXT is very dangerous call because anyone who
has write perm is able to call it and trigger kernel panic. Even more
all kernel since v2.6.30-6558-g748de67 are affected, so current
Debian and Redhat server solutions are dangerous.

Tests are available here:
http://www.spinics.net/lists/linux-fsdevel/msg58316.html
Or here:
https://github.com/dmonakhov/xfstests/tree/ce8e3adab629b2a9be8ba2e73db7dad49eb46614
288'th test

This patchset attempt to close all known bugs, so it survived after
all tests i know.

TOC:
ext4: move_extent code cleanup
ext4: online defrag is not supported for journaled files
ext4: basic bug shield for move_extent_per_page V2
ext4: reimplement uninit extent optimization for move_extent_per_page V2

