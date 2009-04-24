From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Fri, 24 Apr 2009 07:36:27 -0500
Message-ID: <49F1B24B.7080308@redhat.com>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com> <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de> <20090423204059.GM2723@mit.edu> <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de> <20090424032028.GB7949@mit.edu> <alpine.DEB.2.01.0904240153310.6162@bogon.housecafe.de> <alpine.DEB.2.01.0904240235020.6162@bogon.housecafe.de> <20090424120004.GD7949@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christian Kujau <christian@nerdbynature.de>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45357 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565AbZDXMge (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 08:36:34 -0400
In-Reply-To: <20090424120004.GD7949@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Apr 24, 2009 at 02:40:58AM -0700, Christian Kujau wrote:
>> Maybe the repair with 1.41.{3,4} before did something wrong and I should 
>> use 1.41.5 from the beginning? This issue is somewhat reproducible (given 
>> the fs holds enough files), so I could start over, corrupt the fs again 
>> and let e2fsprogs-1.41.5 do the whole job.
> 
> I doubt it; the problem was that the repair performed by e2fsck 1.41.3
> was simply imcomplete.  You can try to reproduce the corrupted
> filesystem again, but it should result in the same result.
> 
> Note that because there was garbage written into the inode table,
> there was going to be data loss; there's not much that can be done
> about that.  This just simple does a better job cleaning up after the
> mess, that's all.
> 
> 						- Ted
> 

But it's still got errors:

it fixed up inodes 12042, 12207, 12249 in lost+found plus "12090
(/t/#12090)" (?)

but post-mount:

sid:~# mount -t ext4 /dev/md0 /mnt/md0
sid:~# ls -la /mnt/md0/lost*
ls: cannot access /mnt/md0/lost+found/#12042: Input/output error
ls: cannot access /mnt/md0/lost+found/#12207: Input/output error
ls: cannot access /mnt/md0/lost+found/#12249: Input/output error
total 20
c????????? ? ?    ?        ?            ? #12042
s????????? ? ?    ?        ?            ? #12207
s????????? ? ?    ?        ?            ? #12249
drwx------ 2 root root 16384 Apr 23 21:16 .
drwxr-xr-x 5 root root  4096 Apr 23 21:15 ..

Christian, is there anything in dmesg along with it this time?

-Eric
