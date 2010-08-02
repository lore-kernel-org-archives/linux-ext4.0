From: horhe <skrzynka_na_spami@kolekcja.mejor.pl>
Subject: Re: [PATCH] fix strange values displayed by e2freefrag
Date: Mon, 02 Aug 2010 19:47:44 +0200
Message-ID: <i370c2$p8s$1@dough.gmane.org>
References: <i2fkse$lkr$1@dough.gmane.org> <32C2860D-6E4D-41CB-8C80-29BAF1C153D4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52423 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab0HBRsE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Aug 2010 13:48:04 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Ofz7F-00069A-Qo
	for linux-ext4@vger.kernel.org; Mon, 02 Aug 2010 19:47:57 +0200
Received: from ip-194.54.191.238.spray.net.pl ([194.54.191.238])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 02 Aug 2010 19:47:57 +0200
Received: from skrzynka_na_spami by ip-194.54.191.238.spray.net.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 02 Aug 2010 19:47:57 +0200
In-Reply-To: <32C2860D-6E4D-41CB-8C80-29BAF1C153D4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

W dniu 2010-07-30 02:03, Andreas Dilger pisze:

> That's because the kernel does not update the "free blocks" summary value in the superblock on disk.  It only updates the per-group free blocks counters in the group descriptor table.  That means the "free blocks" value read from the filesystem is totally incorrect (too low in your case) and caused the percentage to be incorrect.
> 
> For a while, when calling statfs() to get the free blocks information, it would also write out the superblock summary values.  However, this confused the journal checksum code because the modification wasn't being checksummed correctly.
> 
> It is possible to change the e2freefrag code to count the number of free blocks it finds, instead of depending on the value in the superblock (which may be slightly out of date no matter how often it is updated).  A patch to fix this, and to make e2freefrag work properly on filesystems with more than 2^32 free blocks, is attached.
> 
> I'd still like some way for userspace to update the superblock, or have the kernel do it periodically, so that "dumpe2fs -h" and other tools that look at the superblock are at least close instead of having values from the time of last mount.

Hello!
Thank you much for explanation! Now i know how to reproduce this problem
;) I couldn't try your patch (didn't apply clean on e2fsprogs-1.41.12 ,
gentoo :
patching file misc/e2freefrag.c
Hunk #8 FAILED at 142.
Hunk #9 FAILED at 170. ) but i suppose is working.
Sorry for delay, i was away from keys :)
Regards!
Marcin

