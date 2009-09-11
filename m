From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: flex_bg information initialization and question on resize/bad inodes
 with 48 bits filesystem
Date: Fri, 11 Sep 2009 19:57:00 +0200
Message-ID: <4AAA8F6C.6030206@partition-saving.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:47007 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbZIKRyi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Sep 2009 13:54:38 -0400
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 770094B013A
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2009 19:54:35 +0200 (CEST)
Received: from [192.168.103.118] (lan31-6-82-230-26-21.fbx.proxad.net [82.230.26.21])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 82BA04B0172
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2009 19:54:33 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I have looked at the new features provided by ext4 and have a question 
on flex_bg information initialization:
into ext4_fill_flex_info function of fs/ext4/super.c (lines 1698, 1700 
and 1702 for kernel 2.6.31) doesn't the atomic_set calls be atomic_add 
to sum statistics of each group composing a flex group, or do I 
misunderstand something ?

For the extension to manage 48 bits blocks number, I do not see anything 
to treat this for resize and bad inodes into kernel or e2fsprogs. For 
the resize inode, it is perhaps an incompatibility of this feature with 
48 bits blocks number, but for the bad inode ?

For information, I did not subscribe to the list, so could you please 
CC-me in your answer ?

Thanks,

Damien
