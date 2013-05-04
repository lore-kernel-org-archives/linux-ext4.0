From: Radek Pazdera <rpazdera@redhat.com>
Subject: [PATCH 0/3] e2fsprogs: Adding itree feature/inode flags
Date: Sat,  4 May 2013 23:35:07 +0200
Message-ID: <1367703310-3842-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758847Ab3EDVfe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 17:35:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This very short series that adds the itree flags to e2fsprogs mke2fs
and tune2fs in case someone would like to try the itree patches.

-Radek

Radek Pazdera (3):
  libext2fs: Adding itree feature flag
  libext2fs: Adding inode flag for itree
  mke2fs, tune2fs: Adding support for the itree flag

 lib/e2p/feature.c    | 2 ++
 lib/e2p/pf.c         | 1 +
 lib/ext2fs/ext2_fs.h | 2 ++
 misc/mke2fs.c        | 3 ++-
 misc/tune2fs.c       | 6 ++++--
 5 files changed, 11 insertions(+), 3 deletions(-)

-- 
1.7.11.7

