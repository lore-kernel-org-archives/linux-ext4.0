From: Christian Kujau <lists@nerdbynature.de>
Subject: ext4_ext_check_inode: bad header/extent in inode
Date: Thu, 23 Apr 2009 05:15:40 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbZDWMPn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Apr 2009 08:15:43 -0400
Received: from localhost ([127.0.0.1] helo=localhost.localdomain)
	by bogon.housecafe.de with esmtp (Exim 4.69)
	(envelope-from <lists@nerdbynature.de>)
	id 1Lwxq8-0004Xj-5d
	for linux-ext4@vger.kernel.org; Thu, 23 Apr 2009 14:15:40 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi there,

let's say "something" happened to this ext4 partition - OK, I created a 
ZFS pool on a freshly created (unmounted) ext4 partition (for testing 
purposes) and this might have wiped some ext4 information off the 
partition. But I was able to mount the partition again and it looked
like as if all data was in place. 

However, a fsck later on revealed and fixed quite a few errors. Now the 
filesystem can still be mounted, but some files cannot be read:

------------------
# mount -t ext4 /dev/md0 /mnt/md0
# ls -la /mnt/md0 /mnt/md0/lost+found
/mnt/md0:
total 28
drwxr-xr-x  4 root  root   4096 Apr 23 13:43 .
drwxr-xr-x  4 root  root   4096 Apr  2 13:39 ..
drwxr-xr-x 23 dummy users  4096 Apr 18 21:06 linux-2.6-git
drwx------  3 root  root  16384 Apr 23 13:43 lost+found
ls: cannot access /mnt/md0/lost+found/#12042: Input/output error
ls: cannot access /mnt/md0/lost+found/#12207: Input/output error
ls: cannot access /mnt/md0/lost+found/#12249: Input/output error
-------------------


I realize that "creating a filesystem on an ext4 partition" may indeed 
harm ext4 information and I don't expect fsck to get everything fixed - 
but then I think: in the real world this "destruction" could be caused 
by bad memory/cables or just a disk controller gone mad - so yes, some 
ext4 information may have been lost, but:

Shouldn't fsck (1.41.3) complain more, when there are errors left
on the filesystem? Even if the errors cannot be fixed, I'd have 
expected fsck to tell me about that. But fsck exits clean on the 2nd run, 
but there are still a few files unaccessible.

Details about the process (mkfs, fsck, etc.), a .config and kernel logs 
are here: http://nerdbynature.de/bits/2.6.30-rc2/

Thanks,
Christian.
-- 
Only Bruce Schneier is allowed to wear the "I read the NSA's e-mail" t-shirt.
