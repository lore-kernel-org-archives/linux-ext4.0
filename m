From: "=?EUC-KR?B?yKu9xSBzaGluIGhvbmc=?=" <hongshin@gmail.com>
Subject: a question for i_inode's i_size in ext2
Date: Fri, 19 Sep 2008 16:21:44 +0900
Message-ID: <2014bcab0809190021qbca7bect601c891c2db197cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:47017 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYISHVp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Sep 2008 03:21:45 -0400
Received: by rv-out-0506.google.com with SMTP id k40so308520rvb.1
        for <linux-ext4@vger.kernel.org>; Fri, 19 Sep 2008 00:21:44 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear ext2 maintainers

  I have a question of inode's i_size. I found that it is hard to find
any consistent synchronization mechanism that protects inode's i_size
field.
  Is there any lock or synchronization mechanism that consistently
protects i_size fields of inode objects to avoid data race?
  In inode's definition in /include/linux/fs.h, there is comment that
i_lock protects i_size but it is not clear.

Sincerely
Shin Hong
