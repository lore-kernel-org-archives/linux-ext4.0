From: Dan Carpenter <error27@gmail.com>
Subject: smatch stuff: a couple unused assignments in ext4
Date: Sat, 6 Mar 2010 18:21:36 +0300
Message-ID: <20100306152135.GT4958@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:64597 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0CFPVx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Mar 2010 10:21:53 -0500
Received: by fxm19 with SMTP id 19so5068758fxm.21
        for <linux-ext4@vger.kernel.org>; Sat, 06 Mar 2010 07:21:51 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Roel's fix got merged so now there are only two unused assignments
left in ext4.

fs/ext4/extents.c +3578 ext4_ext_truncate warn: assignment to 'err' was never used
fs/ext4/mballoc.c +2050 ext4_mb_regular_allocator warn: assignment to 'desc' was never used

I'm not sure what the fix should be.

BTW.  I'm always trying to figure out the best way to report 
smatch issues.  Let me know how I can improve the process.

regards,
dan carpenter
