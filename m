From: coly <colyli@gmail.com>
Subject: confused on different inode size
Date: Sun, 08 Apr 2007 14:39:03 +0800
Message-ID: <1176014343.20429.6.camel@colyT43.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.229]:65055 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbXDHGf1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Apr 2007 02:35:27 -0400
Received: by nz-out-0506.google.com with SMTP id s1so812450nze
        for <linux-ext4@vger.kernel.org>; Sat, 07 Apr 2007 23:35:26 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, list:

I find size of struct ext4_inode is 152 bytes, but from the dumpe2fs, it
tells me the inode size is 128 bytes.

I am confused that, the ext4_inode is the on-disk inode format, so how
can dumpe2fs tells the inode size is 128 bytes.

Further more, when I use sb_bread() to read inode from inode table (with
152 bytes inode size), I can not read proper data from the bh->b_data.
Once I use 128 bytes inode size, I can read what I want from the
bh->b_data.

I believe there is something I missed, can anybody give me some points ?

Thanks in advance.

Coly
