From: Zlatko Calusic <zcalusic@bitsync.net>
Subject: e2fsck not fixing deleted inode referenced errors?
Date: Tue, 30 Sep 2014 19:56:36 +0200
Message-ID: <542AEED4.5050303@bitsync.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bitsync.net ([80.83.126.10]:53781 "EHLO bitsync.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbaI3SFt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Sep 2014 14:05:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hope this is the right list to ask this question.

I have an ext4 filesystem that has a few errors like this:

Sep 30 19:14:09 atlas kernel: EXT4-fs error (device md2): 
ext4_lookup:1448: inode #7913865: comm find: deleted inode referenced: 
7912058
Sep 30 19:14:09 atlas kernel: EXT4-fs error (device md2): 
ext4_lookup:1448: inode #7913865: comm find: deleted inode referenced: 
7912055

Yet, when I run e2fsck -fy on it, I have a clean run, no errors are 
found and/or fixed. Is this the expected behaviour? What am I supposed 
to do to get rid of errors like the above?

The filesystem is on a md mirror device, the kernel is 3.17.0-rc7, 
e2progs 1.42.12-1 (Debian sid). Could md device somehow interfere? I ran 
md check yesterday, but there were no errors.

BTW, this all started when I got ata2.00: failed command: FLUSH CACHE 
EXT error yesterday morning. I did several runs of e2fsck before the 
filesystem came up clean, yet errors like the above are popping constantly.

Thanks for any info. [and please Cc:, I'm not subscribed]

-- 
Zlatko

