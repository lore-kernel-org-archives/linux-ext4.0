From: Stone <stone@heisl.org>
Subject: fsck illegal bitmap block
Date: Mon, 06 May 2013 19:40:22 +0200
Message-ID: <5187EB06.7030409@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.heisl.org ([86.59.94.242]:38904 "EHLO donkey.heisl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab3EFRu0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 May 2013 13:50:26 -0400
Received: from localhost (localhost [127.0.0.1])
	by donkey.heisl.org (Postfix) with ESMTP id D95CC28024C
	for <linux-ext4@vger.kernel.org>; Mon,  6 May 2013 19:40:35 +0200 (CEST)
Received: from donkey.heisl.org ([127.0.0.1])
	by localhost (donkey.heisl.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tLDYzp5Q73Qk for <linux-ext4@vger.kernel.org>;
	Mon,  6 May 2013 19:40:35 +0200 (CEST)
Received: from [192.168.0.20] (chello213047090191.3.14.vie.surfer.at [213.47.90.191])
	(Authenticated sender: stone@heisl.org)
	by donkey.heisl.org (Postfix) with ESMTPSA id 9489828024A
	for <linux-ext4@vger.kernel.org>; Mon,  6 May 2013 19:40:35 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi.

i have a broken filesystem that i have checked with fsck.

here is my error output:
Inode 22161733 has an invalid extent node (blk 88789488, lblk 0)
Clear? yes
fsck.ext4: e2fsck_read_bitmaps: illegal bitmap block(s) for 
/dev/mapper/md2_nas
/dev/mapper/md2_nas: ***** FILE SYSTEM WAS MODIFIED *****
e2fsck: aborted
/dev/mapper/md2_nas: ***** FILE SYSTEM WAS MODIFIED *****
echo $?
9

the check cancel always at 88789488.
my os is a ubuntu 12.04 64bit system with the e2fsprogs verions 
1.42.5-1ubuntu4

i hope some guys have an idea ;-)

thx.


