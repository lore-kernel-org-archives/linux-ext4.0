From: Davide Italiano <dccitaliano@gmail.com>
Subject: [PATCH] Remove redundant check under lock scope in fallocate()
Date: Mon,  6 Apr 2015 22:35:00 -0700
Message-ID: <1428384901-2304-1-git-send-email-dccitaliano@gmail.com>
Cc: Davide Italiano <dccitaliano@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f195.google.com ([209.85.192.195]:35110 "EHLO
	mail-pd0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbbDGFfH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2015 01:35:07 -0400
Received: by pdjg10 with SMTP id g10so16374478pdj.2
        for <linux-ext4@vger.kernel.org>; Mon, 06 Apr 2015 22:35:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The check for indirect files is already done in ext4_fallocate()
and outside of the lock scope. I removed it entirely from ext4_zero_range
and ext4_collapse range.

Davide Italiano (1):
  ext4: Remove redundant check under lock scope

 fs/ext4/extents.c | 16 ----------------
 1 file changed, 16 deletions(-)

-- 
2.3.4

