From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH 0/2] ext4: fix overhead calculation for noloaded journals
Date: Wed, 21 Sep 2016 21:11:32 -0400
Message-ID: <20160922011132.GA27216@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33329 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754090AbcIVBH0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Sep 2016 21:07:26 -0400
Received: by mail-qk0-f196.google.com with SMTP id n66so4268612qkf.0
        for <linux-ext4@vger.kernel.org>; Wed, 21 Sep 2016 18:07:25 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When calculating file system overhead, ext4 does not account for the
size of a file system's internal journal when it is present on the
storage device but not loaded in memory (noload option used when the
file system is mounted).

This bug can be reproduced on a 4.8-rc7 kernel by running xfstest
shared/289 with the 5 Sep 2016 version of the xfstest-bld test
appliance in the nojournal test configuration.

Eric Whitney (2):
  ext4: create function to read journal inode
  ext4: use journal inode to determine journal overhead

 fs/ext4/super.c | 51 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 11 deletions(-)

-- 
2.1.4

