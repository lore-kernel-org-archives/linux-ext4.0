From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH 0/5] e2fsprogs: Update man pages, usage texts, and docs.
Date: Wed, 13 Dec 2017 23:13:08 -0800
Message-ID: <cover.1513233071.git.tgnottingham@gmail.com>
Cc: linux-ext4@vger.kernel.org,
        Tyson Nottingham <tgnottingham@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33662 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdLNHOd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Dec 2017 02:14:33 -0500
Received: by mail-pg0-f67.google.com with SMTP id g7so2882024pgs.0
        for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2017 23:14:33 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These patches add missing feature descriptions and command arguments to
man pages and usage texts. They also fix some minor typos.

I'm just getting familiar with ext4, and this is the first patch series
I've sent to a mailing list, so I expect there to be issues. Please let
me know of any.

The patches are based off of the master branch of e2fsprogs. Should I be
working from a different branch? Also, I did not update any of the
localization files. Do I need to worry about handling that?

Thanks,
Tyson

Tyson Nottingham (5):
  Add missing features and mount options to ext4 man page.
  Add missing information to e2fsck man pages and usage text.
  Add missing information to debugfs man pages and usage texts.
  Add missing information to various man pages and usage texts.
  Fix minor typos in libext2fs documentation.

 debugfs/debugfs.8.in    |  49 +++++++++++++---
 debugfs/debugfs.c       |  10 ++--
 debugfs/do_journal.c    |   2 +-
 debugfs/logdump.c       |   2 +-
 debugfs/ls.c            |   2 +-
 debugfs/set_fields.c    |   4 +-
 debugfs/xattrs.c        |   2 +-
 doc/libext2fs.texinfo   |  16 +++---
 e2fsck/e2fsck.8.in      |  25 +++++----
 e2fsck/e2fsck.conf.5.in |  21 ++++++-
 e2fsck/unix.c           |   1 +
 misc/badblocks.c        |   2 +-
 misc/chattr.1.in        |   2 +-
 misc/e2image.8.in       |   2 +-
 misc/e2image.c          |   2 +-
 misc/e2undo.8.in        |  18 ++++++
 misc/e2undo.c           |   2 +-
 misc/e4crypt.8.in       |   8 +--
 misc/e4crypt.c          |   4 +-
 misc/ext4.5.in          | 146 +++++++++++++++++++++++++++++++++---------------
 misc/lsattr.1.in        |   4 +-
 misc/mke2fs.8.in        |   9 +++
 misc/mke2fs.conf.5.in   |  78 ++++++++++++--------------
 misc/tune2fs.8.in       |  33 +++++++----
 misc/tune2fs.c          |   6 +-
 resize/main.c           |   3 +-
 26 files changed, 300 insertions(+), 153 deletions(-)

-- 
2.7.4
