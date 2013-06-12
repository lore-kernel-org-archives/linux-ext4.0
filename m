From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Too large value in =?utf-8?b?aW5vZGUuaV9ibG9ja3NbMV0=?=
Date: Wed, 12 Jun 2013 05:08:21 +0000 (UTC)
Message-ID: <loom.20130612T065900-326@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34197 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab3FLFIk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 01:08:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1UmdIT-0000pT-LR
	for linux-ext4@vger.kernel.org; Wed, 12 Jun 2013 07:08:37 +0200
Received: from user-46-113-129-43.play-internet.pl ([46.113.129.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jun 2013 07:08:37 +0200
Received: from felipemonteiro.carvalho by user-46-113-129-43.play-internet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jun 2013 07:08:37 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Continuing in my adventures with ext4, now I am having
a problem that when reading the root
inode everything is fine. 
When reading the inodes of directories placed on the file system root,
my reading fails, because inode.i_blocks has the following data 
(for 1 particular subdir for example):

127754,
4,
0,
0,
1,
1366,
0,...

The root works because in its inode i_blocks[1] has a smaller, 
in-bounds value, but this one has
the first value completely out of bounds of the filesystem =(

My ext4 filesystem has 3 incompat flags set: EXT4_FEATURE_INCOMPAT_FILETYPE,
EXT4_FEATURE_INCOMPAT_EXTENTS, EXT4_FEATURE_INCOMPAT_FLEX_BG

I suppose it must be related to either EXTENTS or FLEX_BG ...

any ideas?

Also, where can I read about the exact effect of ext4 new features?

thanks,

Felipe Monteiro de Carvalho

