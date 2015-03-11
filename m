From: Li Xi <pkuelelixi@gmail.com>
Subject: [PATCH 0/2] add project quota support
Date: Wed, 11 Mar 2015 12:37:55 +0900
Message-ID: <1426045077-1264-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38273 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbbCKDiH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2015 23:38:07 -0400
Received: by pdbfl12 with SMTP id fl12so7576052pdb.5
        for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2015 20:38:07 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

An implementation of project quota support for ext4 has been
proposed. And the following patches provide project quota
support for e2fsprogs.

Any comments or feedbacks are appreciated.

Regards,
                                         - Li Xi

Li Xi (2):
  quota: cleanup codes for new quota type.
  quota: add project quota support

 debugfs/set_fields.c     |    2 +
 e2fsck/pass1.c           |   28 ++++++++++--
 e2fsck/quota.c           |   28 +++++-------
 e2fsck/unix.c            |   26 +++++-----
 lib/e2p/feature.c        |    2 +
 lib/e2p/ls.c             |   31 ++++++++++---
 lib/e2p/pf.c             |    1 +
 lib/ext2fs/ext2_fs.h     |   12 +++--
 lib/ext2fs/ext2fs.h      |    3 +-
 lib/ext2fs/swapfs.c      |    2 +
 lib/quota/mkquota.c      |  110 +++++++++++++++++++++++++++------------------
 lib/quota/quotaio.c      |   82 +++++++++++++++++++++++-----------
 lib/quota/quotaio.h      |   72 ++++++++++++++++++++++--------
 lib/quota/quotaio_tree.c |    2 +-
 misc/chattr.c            |    3 +-
 misc/ext4.5.in           |    5 ++
 misc/mke2fs.c            |   13 +++--
 misc/tune2fs.c           |   88 +++++++++++++++++++++---------------
 18 files changed, 331 insertions(+), 179 deletions(-)

