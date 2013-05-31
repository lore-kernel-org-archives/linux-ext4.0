From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: How to differentiate ext4 from ext2/3 in code?
Date: Fri, 31 May 2013 07:04:18 +0000 (UTC)
Message-ID: <loom.20130531T090136-835@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59052 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab3EaHKG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 03:10:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1UiJTO-0001gz-Ps
	for linux-ext4@vger.kernel.org; Fri, 31 May 2013 09:10:02 +0200
Received: from user-31-174-109-102.play-internet.pl ([31.174.109.102])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 31 May 2013 09:10:02 +0200
Received: from felipemonteiro.carvalho by user-31-174-109-102.play-internet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 31 May 2013 09:10:02 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I am working on a software which has its own code to mount file systems, but 
when working on adding ext4 support I just noticed something strange. The 
ext2/3 reader already works quite well for ext4!

Also: EXT2_SUPER_MAGIC == EXT3_SUPER_MAGIC == EXT4_SUPER_MAGIC

So does anyone know what is the best way to differentiate in a file system 
reader between ext3 and ext4?

The best I came up so far would be checking the size of the superblock ... for 
ext3 it seams to be smaller I think ... but I guess people here might have 
better ideas.

thanks,

Felipe Monteiro de Carvalho

