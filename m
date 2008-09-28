From: "Rohit Sharma" <imreckless@gmail.com>
Subject: inode and blocks
Date: Sun, 28 Sep 2008 15:49:04 +0530
Message-ID: <2d08ef090809280319m64555696nfe1a446e010f921f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:63082 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYI1KTG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Sep 2008 06:19:06 -0400
Received: by yw-out-2324.google.com with SMTP id 9so256940ywe.1
        for <linux-ext4@vger.kernel.org>; Sun, 28 Sep 2008 03:19:04 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Suppose i have a file named abc.txt and i want to specify that
all the *.txt files must be allocated between block groups no. 100 -
200 in ext2 fs.

Is there a way to do this?

can we modify function ext2_new_inode and find_group_orlov for this?
