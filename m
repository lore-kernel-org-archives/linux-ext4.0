From: Radek Pazdera <rpazdera@redhat.com>
Subject: [PATCH v2 0/2] e2fsprogs: Adding itree feature/inode flags
Date: Mon, 13 May 2013 17:43:48 +0200
Message-ID: <1368459830-3651-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab3EMQoB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 12:44:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I created this very short series that adds the itree flags to e2fsprogs
mke2fs and tune2fs in case someone would like to try the itree patches.

A RFC patches were posted to linux-ext4 with this feature implemented,
however, it is still *highly* experimental. I am still working on it.

Changes from v1
===============

    * The feature + inode flag patches merged together
    * Added more detailed commit messages

-Radek

Radek Pazdera (2):
  libext2fs: Adding itree feature and inode flags
  mke2fs, tune2fs: Adding support for the itree flag

 lib/e2p/feature.c    |    2 ++
 lib/e2p/pf.c         |    1 +
 lib/ext2fs/ext2_fs.h |    2 ++
 misc/mke2fs.c        |    3 ++-
 misc/tune2fs.c       |    6 ++++--
 5 files changed, 11 insertions(+), 3 deletions(-)

-- 
1.7.7.6

