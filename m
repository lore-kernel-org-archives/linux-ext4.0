From: HaiBo Liu <haiboliu6@gmail.com>
Subject: a question about the ext3fs reserve window
Date: Thu, 31 Dec 2009 02:29:22 +0000 (UTC)
Message-ID: <loom.20091231T032810-88@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44356 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZLaC3r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Dec 2009 21:29:47 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NQAnI-0007P9-Dp
	for linux-ext4@vger.kernel.org; Thu, 31 Dec 2009 03:29:44 +0100
Received: from 219.133.62.73 ([219.133.62.73])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 31 Dec 2009 03:29:44 +0100
Received: from haiboliu6 by 219.133.62.73 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 31 Dec 2009 03:29:44 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,All:
   I am a newer to linux kernel.I have read some code of the ext3fs.
I found a new word "reserve window".I have not known much about it.
All of I known is :

   1."reserve window" is used to help extfs to allocate the block(for
regular file only).
   2.One inode can have some reserve window,and it can store the allocate
info of some ranges.
   3.It used rb_tree to link thoses "reserve window",so if you want to find
a new "reserve window",
   it will be fast.
   4.The info of the "reserve window" store in memory only,not in disk.
   5.You can control the "reserve window" through the ioctl();

I not sure above and I have some questions:

   1.Before the "reserve window" ,extfs allocate the block through
searching the block bitmap.
   Between these two methods, who is better?
   2.When was "reserve window" been code to the extfs?

Thank you very much for your answer.

