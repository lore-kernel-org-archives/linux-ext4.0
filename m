From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Thu, 23 Apr 2009 07:50:50 -0500
Message-ID: <49F0642A.4000704@redhat.com>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37187 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbZDWMuz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Apr 2009 08:50:55 -0400
In-Reply-To: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christian Kujau wrote:
> Hi there,
> 
> let's say "something" happened to this ext4 partition - OK, I created a 
> ZFS pool on a freshly created (unmounted) ext4 partition (for testing 
> purposes) and this might have wiped some ext4 information off the 
> partition. But I was able to mount the partition again and it looked
> like as if all data was in place. 
> 
> However, a fsck later on revealed and fixed quite a few errors. Now the 
> filesystem can still be mounted, but some files cannot be read:
> 
> ------------------
> # mount -t ext4 /dev/md0 /mnt/md0
> # ls -la /mnt/md0 /mnt/md0/lost+found
> /mnt/md0:
> total 28
> drwxr-xr-x  4 root  root   4096 Apr 23 13:43 .
> drwxr-xr-x  4 root  root   4096 Apr  2 13:39 ..
> drwxr-xr-x 23 dummy users  4096 Apr 18 21:06 linux-2.6-git
> drwx------  3 root  root  16384 Apr 23 13:43 lost+found
> ls: cannot access /mnt/md0/lost+found/#12042: Input/output error
> ls: cannot access /mnt/md0/lost+found/#12207: Input/output error
> ls: cannot access /mnt/md0/lost+found/#12249: Input/output error
> -------------------
> 
> 
> I realize that "creating a filesystem on an ext4 partition" may indeed 
> harm ext4 information and I don't expect fsck to get everything fixed - 
> but then I think: in the real world this "destruction" could be caused 
> by bad memory/cables or just a disk controller gone mad - so yes, some 
> ext4 information may have been lost, but:
> 
> Shouldn't fsck (1.41.3) complain more, when there are errors left
> on the filesystem? Even if the errors cannot be fixed, I'd have 
> expected fsck to tell me about that. But fsck exits clean on the 2nd run, 
> but there are still a few files unaccessible.

Yep, probably so; based on:

[400026.511081] EXT4-fs error (device md0): ext4_ext_check_inode: bad
header/extent in inode #12120: invalid magic - magic 702, entries 30990,
max 5120(0), depth 55352(55352)
[400026.519200] EXT4-fs error (device md0): ext4_ext_check_inode: bad
header/extent in inode #12272: invalid magic - magic 1c2b, entries 6928,
max 14(0), depth 4116(4116)

I'd have expected fsck to find that, I think.  I'd first suggest using
1.41.4 or 1.41.5 (probably released very soon) and see if that catches
it (I don't remember offhand if there is a relevant change since 1.41.3
but the check should be easy...)

-Eric
