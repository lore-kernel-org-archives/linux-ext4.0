From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/8] xfstests: Bunch of new tests
Date: Wed, 19 Oct 2011 14:29:41 +0400
Message-ID: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org,
	aelder@sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51243 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1JSK3y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Oct 2011 06:29:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

xfstests: fsstress should kill children tasks before exit
xfstests: add different logging option to fsstress
xfstests: add fallocate support to fsstress
xfstests: fsstress add FS_IOC_{SET,GET}FLAGS operations
xfstests: Dump inode info when possible
xfstests: add fiemap operation

# Following testcase will fail on recent kernel in case of ext4
# Some fixes are already available here:
# http://www.spinics.net/lists/linux-ext4/msg27857.html
xfstests: add new stress test

# Following testcase will fail on recent kernel in case of ext3/4 
# Fixes available here:
#  http://patchwork.ozlabs.org/patch/120581/
#  http://patchwork.ozlabs.org/patch/120582/
xfstests: add new quota stress test

P.S: ext4 still contains bugs caused by ordered_mode=>journal_mode
switch for didicated inode (chattr +j ./afile), so you temproraly
disable this test by adding "-f setattr=0" to $FSSTRESS_AVOID var.
     
