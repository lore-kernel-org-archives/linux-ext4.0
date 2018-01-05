From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH 0/3] ext4: clean up inode flag definitions
Date: Fri,  5 Jan 2018 01:23:22 -0800
Message-ID: <cover.1515135646.git.tgnottingham@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        Tyson Nottingham <tgnottingham@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38220 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbeAEJYF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jan 2018 04:24:05 -0500
Received: by mail-pf0-f196.google.com with SMTP id u25so1980823pfg.5
        for <linux-ext4@vger.kernel.org>; Fri, 05 Jan 2018 01:24:05 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is my first patch to ext4 and the kernel. It's simple, but you
might give it extra scrutiny since I'm new and all.

I'm working off the dev branch of git://git.kernel.org/pub/scm/linux/
kernel/git/tytso/ext4.git. Let me know if that's the wrong place to be.

Thanks,
Tyson

Tyson Nottingham (3):
  ext4: move inode flags enum in preparation for cleanup
  ext4: define inode flags in terms of enum values
  ext4: define visible/modifiable flag masks in terms of inode flags

 fs/ext4/ext4.h  | 210 +++++++++++++++++++++++++++-----------------------------
 fs/ext4/super.c |   3 -
 2 files changed, 103 insertions(+), 110 deletions(-)

-- 
2.7.4
