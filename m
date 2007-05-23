From: coly <colyli@gmail.com>
Subject: [RFC 5/5] inode reservation v0.1 (next step working)
Date: Thu, 24 May 2007 02:08:52 +0800
Message-ID: <1179943732.4179.56.camel@coly-t43.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:45813 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761279AbXEWSI0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 May 2007 14:08:26 -0400
Received: by mu-out-0910.google.com with SMTP id i10so202185mue
        for <linux-ext4@vger.kernel.org>; Wed, 23 May 2007 11:08:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>From the benchmark and the experimental inores patch on ext4, it can be
found that inode reservation on ext4 is a good idea to be tried. 

One of the original idea of inode reservation is NOT modifying on-disk
format. Current magic inode can make it, but use a magic inodes list to
link each reserved inode block together is not a good idea. Indeed, this
is a performance killer.

1, Therefor, group descriptor has to be modified to add a new member ---
this new member records the lastest reserved inode in inode table of
each block group.

2, Use rest room in magic inode (sizeof(ext4_inode) -
sizeof(ext4_magic_inode)) to record other reserved inode blocks. This
method can reduce number of magic inodes, which can minimize I/O for
magic inodes.

3, Use magic inode cache. Most of the magic inode accessings are reading
(not writing), therefore, caching can help to reduce most of the read
I/O for magic inode.

4, Modify mke2fs to support new on-disk layout for inode reservation.


Coly
