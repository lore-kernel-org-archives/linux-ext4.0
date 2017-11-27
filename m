From: Riccardo Schirone <sirmy15@gmail.com>
Subject: [PATCH 0/3] Improve kobject handling in fs/ext4
Date: Tue, 28 Nov 2017 00:17:58 +0100
Message-ID: <20171127231801.27652-1-sirmy15@gmail.com>
Cc: Riccardo Schirone <sirmy15@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35567 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdK0XSQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Nov 2017 18:18:16 -0500
Received: by mail-wm0-f65.google.com with SMTP id w73so9553632wmw.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2017 15:18:16 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch tries to correctly use kobjects in fs/ext4. In particular it
allocates kobjects/ksets dynamically, instead of statically, and improve
error handling in case kobject_* functions fail.

It is based on
https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
branch.

Riccardo Schirone (3):
  fs/ext4: release kobject/kset even when init/register fail
  fs/ext4: create ext4_feat kobject dynamically
  fs/ext4: create ext4_kset dynamically

 fs/ext4/sysfs.c | 63 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 18 deletions(-)

-- 
2.14.3
