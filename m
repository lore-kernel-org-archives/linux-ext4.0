From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Wed, 11 Mar 2009 12:13:28 +1030
Message-ID: <1236735808.16191.23.camel@kulgan.wumi.org.au>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au>
	 <49B5D71D.1030802@redhat.com>
	 <1236655451.30280.29.camel@kulgan.wumi.org.au>
	 <49B5EDFE.8060405@redhat.com>
	 <1236661371.30280.33.camel@kulgan.wumi.org.au>
	 <20090310070915.GN3199@webber.adilger.int> <20090310144651.GC23075@mit.edu>
	 <1236719691.16191.9.camel@kulgan.wumi.org.au>
	 <20090310224810.GA15229@mit.edu> <20090311003845.GB3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Gq4RI0E7rs2BbXALnVnM"
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:44327 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbZCKBnd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2009 21:43:33 -0400
In-Reply-To: <20090311003845.GB3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-Gq4RI0E7rs2BbXALnVnM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2009-03-10 at 18:38 -0600, Andreas Dilger wrote:
> On Mar 10, 2009  18:48 -0400, Theodore Ts'o wrote:
> > So now we know that the block containing inode 867 is 65+54 = 119
> 
> Or you can use imap (which Ted probably wrote in the first place. :-)
> 
> debugfs: imap some/problem/file
> Inode 867 is part of block group 0
> 	located at block 119, offset 0x0180
> 
> > Now to dump that block, we do:
> > 
> >     dd if=/dev/fs-device of=block-119.dump bs=4k skip=119 count=1
> 
> This part is the same.

Thanks guys.

It looks like there is still a problem there, even after fsck has done
it's cleanup.

Last night I got:

  getfattr: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/RptControllers.dll: Input/output error

And syslog shows:

  Mar 11 00:06:01 hermes /USR/SBIN/CRON[26947]: (root) CMD (   /usr/local/bin/rsync-backup-all.sh)
  Mar 11 00:06:24 hermes kernel: attempt to access beyond end of device
  Mar 11 00:06:24 hermes kernel: dm-0: rw=0, want=946232834916360, limit=2147483648
  Mar 11 00:06:24 hermes kernel: attempt to access beyond end of device
  Mar 11 00:06:24 hermes kernel: dm-0: rw=0, want=946232834916360, limit=2147483648

hermes:~# getfattr /srv/samba/local/apps/Gestalt.Net/SetupCD/program\ files/Business\ Objects/Common/3.5/bin/RptControllers.dll 
getfattr: /srv/samba/local/apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/RptControllers.dll: Input/output error

hermes:~# debugfs /dev/dm-0
debugfs 1.41.3 (12-Oct-2008)
debugfs:  stat "local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll"

Inode: 875   Type: FIFO    Mode:  0611   Flags: 0xb3b9c185
Generation: 3690868    Version: 0x9d36b10d
User: 868313917   Group: -1340283792   Size: 0
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x0742afc4 -- Sun Nov 11 06:51:24 1973
atime: 0x472a2311 -- Fri Nov  2 05:33:45 2007
mtime: 0x80c59881 -- Fri Jun 18 09:51:21 2038
Size of extra inode fields: 4
BLOCKS:

debugfs:  imap "local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll"
Inode 875 is part of block group 0
	located at block 343, offset 0x0a00

hermes:~# dd if=/dev/dm-0 of=block-343.dump bs=4k skip=343 count=1
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 3.6316e-05 s, 113 MB/s

"strings block-343.dump" doesn't show anything obvious to me about where
the data came from, but I guess the concern would be whether fsck didn't
pick this up or maybe the corruption returned very quickly for some
reason.

Cheers,
Kevin.


--=-Gq4RI0E7rs2BbXALnVnM
Content-Disposition: attachment; filename="block-343.dump"
Content-Type: application/octet-stream; name="block-343.dump"
Content-Transfer-Encoding: base64

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


--=-Gq4RI0E7rs2BbXALnVnM--

