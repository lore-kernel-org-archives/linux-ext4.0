From: Christian Kujau <lists@nerdbynature.de>
Subject: e2fsck not fixing all corruptions on the first run?
Date: Thu, 13 Mar 2008 19:34:40 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803131923420.7433@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.g-housing.de ([81.169.133.75]:41997 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbYCMSep (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 14:34:45 -0400
Received: from [89.49.156.246] (helo=[192.168.178.25])
	by mail.g-house.de with esmtpa (Exim 4.63)
	(envelope-from <lists@nerdbynature.de>)
	id 1JZsGJ-0005DD-5M
	for linux-ext4@vger.kernel.org; Thu, 13 Mar 2008 19:34:43 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

after a few unclean shutdown, I noticed that my ext4 filesystem got 
mounted with:

   EXT4-fs warning: mounting fs with errors, running e2fsck is recommended

So I decided to unmount and check it with a fairly current version of 
e2fsck, git show tells me:

  # git show
  commit d6a525282f4b3ece90c271d470b27ef7b6853817
  Merge: 0ea8aa6... e91c9d4...
  Author: Theodore Ts'o <tytso@mit.edu>
  Date:   Fri Feb 29 09:21:29 2008 -0500

e2fsck indeed does find a few corruptions, fixes them. The next 
run, e2fsck says "clean" of course. But when I ran with -f, e2fsck did 
find more (small) corruptions, see the full log here:

http://nerdbynature.de/bits/e2fsprogs.pu/md4.log
http://nerdbynature.de/bits/e2fsprogs.pu/

Q: How comes e2fsck would skip a few things during the first run? If it
    (technically) has to, couldn't it NOT mark the fs clean so that one
    knows it has to run fsck again?

Thanks,
Christian.
-- 
BOFH excuse #274:

It was OK before you touched it.
