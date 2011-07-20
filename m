From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: ext4: let ext4 get free blocks count of uninit groups from desc
Date: Wed, 20 Jul 2011 21:32:52 +0800
Message-ID: <1311168774-26378-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51641 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1GTNh0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jul 2011 09:37:26 -0400
Received: by iwn6 with SMTP id 6so190698iwn.19
        for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 06:37:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I do not know why ext4 does not get free blocks count of BLOCK_UNINIT groups
from group descriptors directly in the past.  But now, according to e2fsprogs
and code of kernel side we can get free blocks count from descriptors for
BLOCK_UNINIT groups, rather than compute it.  This can simplifies code a lot.

