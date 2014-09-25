From: Christian Kujau <lists@nerdbynature.de>
Subject: birth time of a file
Date: Wed, 24 Sep 2014 23:23:24 -0700 (PDT)
Message-ID: <alpine.DEB.2.19.4.1409242257430.9897@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:33099 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaIYG3l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Sep 2014 02:29:41 -0400
Received: from trent.utfs.org (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id B2DDF3DAE7
	for <linux-ext4@vger.kernel.org>; Thu, 25 Sep 2014 08:23:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 8B0813DABF
	for <linux-ext4@vger.kernel.org>; Thu, 25 Sep 2014 08:23:24 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I want to find out the "creation time" or "birth time" of a file. I know, 
this comes up every now and then but I could not find any recent or 
reliable information, just random posting on the interwebs. Here[0] it is 
suggested that coreutils stat(1) cannot display "birth time", although a 
commit[1] from 2010 states that birthtime is now supported. But even if 
stat(1) cannot display it, debugfs should be able to, but not here:

# mkfs.ext4 /dev/loop0
# mount -t ext4 /dev/loop0 /mnt/disk/
# mount | tail -1
/dev/loop0 on /mnt/disk1 type ext4 (rw,relatime,data=ordered)
# touch /mnt/disk/foo
# debugfs -R 'stat foo' /dev/loop0
debugfs 1.42.12 (29-Aug-2014)
Inode: 12   Type: regular    Mode:  0600   Flags: 0x80000
Generation: 3547819027    Version: 0x00000001
User:     0   Group:     0   Size: 0
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x5423a873 -- Wed Sep 24 22:30:27 2014
atime: 0x5423a873 -- Wed Sep 24 22:30:27 2014
mtime: 0x5423a873 -- Wed Sep 24 22:30:27 2014
EXTENTS:


Now, fs/ext4/ext4.h defines i_crtime and it's referenced in ialloc.c and 
inode.c, so it seems to be used - but why can't debugfs display it? I 
tested this with 3.14, 3.17-rc6 and 3.16 kernels, debugfs just would 
not display "crtime".

Thanks,
Christian.

[0] https://unix.stackexchange.com/questions/50177/birth-is-empty-on-ext4 
[1] http://git.savannah.gnu.org/cgit/coreutils.git/commit/?id=abe5c1f9
-- 
BOFH excuse #408:

Computers under water due to SYN flooding.
