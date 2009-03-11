From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Wed, 11 Mar 2009 12:18:57 +1030
Message-ID: <1236736137.16191.25.camel@kulgan.wumi.org.au>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au>
	 <49B5D71D.1030802@redhat.com>
	 <1236655451.30280.29.camel@kulgan.wumi.org.au>
	 <49B5EDFE.8060405@redhat.com>
	 <1236661371.30280.33.camel@kulgan.wumi.org.au>
	 <20090310070915.GN3199@webber.adilger.int> <20090310144651.GC23075@mit.edu>
	 <1236719691.16191.9.camel@kulgan.wumi.org.au>
	 <20090310224810.GA15229@mit.edu> <20090311003845.GB3199@webber.adilger.int>
	 <1236735808.16191.23.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:59564 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbZCKBtE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2009 21:49:04 -0400
In-Reply-To: <1236735808.16191.23.camel@kulgan.wumi.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-03-11 at 12:13 +1030, Kevin Shanahan wrote:
> It looks like there is still a problem there, even after fsck has done
> it's cleanup.
> 
> Last night I got:
> 
>   getfattr: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/RptControllers.dll: Input/output error
> 
> And syslog shows:
> 
>   Mar 11 00:06:01 hermes /USR/SBIN/CRON[26947]: (root) CMD (   /usr/local/bin/rsync-backup-all.sh)
>   Mar 11 00:06:24 hermes kernel: attempt to access beyond end of device
>   Mar 11 00:06:24 hermes kernel: dm-0: rw=0, want=946232834916360, limit=2147483648
>   Mar 11 00:06:24 hermes kernel: attempt to access beyond end of device
>   Mar 11 00:06:24 hermes kernel: dm-0: rw=0, want=946232834916360, limit=2147483648
> 
> hermes:~# getfattr /srv/samba/local/apps/Gestalt.Net/SetupCD/program\ files/Business\ Objects/Common/3.5/bin/RptControllers.dll 
> getfattr: /srv/samba/local/apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/RptControllers.dll: Input/output error
> 
> hermes:~# debugfs /dev/dm-0
> debugfs 1.41.3 (12-Oct-2008)
> debugfs:  stat "local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll"
> 
> Inode: 875   Type: FIFO    Mode:  0611   Flags: 0xb3b9c185
> Generation: 3690868    Version: 0x9d36b10d
> User: 868313917   Group: -1340283792   Size: 0
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x0742afc4 -- Sun Nov 11 06:51:24 1973
> atime: 0x472a2311 -- Fri Nov  2 05:33:45 2007
> mtime: 0x80c59881 -- Fri Jun 18 09:51:21 2038
> Size of extra inode fields: 4
> BLOCKS:
> 
> debugfs:  imap "local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll"
> Inode 875 is part of block group 0
> 	located at block 343, offset 0x0a00
> 
> hermes:~# dd if=/dev/dm-0 of=block-343.dump bs=4k skip=343 count=1
> 1+0 records in
> 1+0 records out
> 4096 bytes (4.1 kB) copied, 3.6316e-05 s, 113 MB/s
> 
> "strings block-343.dump" doesn't show anything obvious to me about where
> the data came from, but I guess the concern would be whether fsck didn't
> pick this up or maybe the corruption returned very quickly for some
> reason.

Oh, by the way:

hermes:~# ls -l /srv/samba/local/apps/Gestalt.Net/SetupCD/program\ files/Business\ Objects/Common/3.5/bin/RptControllers.dll 
prwS--x--t 1 868313917 2954683504 0 1902-05-13 03:23 /srv/samba/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll

I guess this is what Andreas meant by "turning a pile of manure into
neatly organized fertilizer" :)

Cheers,
Kevin.


