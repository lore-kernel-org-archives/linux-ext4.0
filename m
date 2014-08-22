From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/5] i_size/i_disksize update fixes and cleanup series
Date: Fri, 22 Aug 2014 15:32:22 +0400
Message-ID: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org>
Cc: lczerner@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:42707 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049AbaHVLcy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2014 07:32:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

#First two patches are simply cleanups
use ext4_update_i_disksize instead of opencoded ones
move i_size, i_diskzie update routines to helper function
# Simple fix found during code review
ext4_zero_range fix incorect journal credits reservation
# Fixes i_size,i_disksize,mtime,ctime update issues
# primary test: xfstest generic/019
fix transaction issues for fallocate and zero_range
update sync i_disksize coherently with block allocation

In fact last two issues can be fixed by inserting inode to orphan list
during file grow, but this turns to be a problem for ext4_writepages because
orhpan list is protected by i_mutex.

BTW: May be it is reasonable serialize orhpan list manipulations by i_data_sem?
