Return-Path: <SRS0=ApgQ=N6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:54772 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbeKSTka (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2018 14:40:30 -0500
Received: by mail-it1-f196.google.com with SMTP id a205-v6so7124082itd.4
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2018 01:17:28 -0800 (PST)
From: alexey.lyashkov@gmail.com
To: linux-ext4@vger.kernel.org
Cc: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: [PATCH 0/3] debugfs fixes
Date: Mon, 19 Nov 2018 12:16:47 +0300
Message-Id: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Alexey Lyashkov <alexey.lyashkov@gmail.com>

This patchset provide a various fixes for debugfs tool.
All fixes related to the logdump command which able to handle large FS
and journal checksums version 1. It fixes a panic with journal super block
flags print.


Alexey Lyashkov (3):
  block number output fix.
  Fix panic with journal superblock flags printing.
  add support to check a journal checksum v1 while journal dump.

 debugfs/logdump.c | 103 +++++++++++++++++++++++++++++++++++-----------
 e2fsck/jfs_user.h |   5 +++
 2 files changed, 84 insertions(+), 24 deletions(-)

-- 
2.18.0
