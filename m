From: Andreas Dilger <adilger@sun.com>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Wed, 11 Mar 2009 00:18:39 -0600
Message-ID: <20090311061839.GC3199@webber.adilger.int>
References: <1236655451.30280.29.camel@kulgan.wumi.org.au>
 <49B5EDFE.8060405@redhat.com> <1236661371.30280.33.camel@kulgan.wumi.org.au>
 <20090310070915.GN3199@webber.adilger.int> <20090310144651.GC23075@mit.edu>
 <1236719691.16191.9.camel@kulgan.wumi.org.au> <20090310224810.GA15229@mit.edu>
 <20090311003845.GB3199@webber.adilger.int>
 <1236735808.16191.23.camel@kulgan.wumi.org.au>
 <1236736137.16191.25.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:63830 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZCKGSy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Mar 2009 02:18:54 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n2B6Ipjo016624
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2009 23:18:51 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KGB00A00W6XN100@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 10 Mar 2009 23:18:51 -0700 (PDT)
In-reply-to: <1236736137.16191.25.camel@kulgan.wumi.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 11, 2009  12:18 +1030, Kevin Shanahan wrote:
> On Wed, 2009-03-11 at 12:13 +1030, Kevin Shanahan wrote:
> > 
> >   getfattr: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/RptControllers.dll: Input/output error
> > 
> > And syslog shows:
> >   Mar 11 00:06:24 hermes kernel: attempt to access beyond end of device
> >   Mar 11 00:06:24 hermes kernel: dm-0: rw=0, want=946232834916360, limit=2147483648
> > 
> > hermes:~# debugfs /dev/dm-0
> > debugfs 1.41.3 (12-Oct-2008)
> > debugfs:  stat "local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll"
> > 
> > Inode: 875   Type: FIFO    Mode:  0611   Flags: 0xb3b9c185
> > Generation: 3690868    Version: 0x9d36b10d
> > User: 868313917   Group: -1340283792   Size: 0
> > File ACL: 0    Directory ACL: 0
> > Links: 1   Blockcount: 0
> > Fragment:  Address: 0    Number: 0    Size: 0
> > ctime: 0x0742afc4 -- Sun Nov 11 06:51:24 1973
> > atime: 0x472a2311 -- Fri Nov  2 05:33:45 2007
> > mtime: 0x80c59881 -- Fri Jun 18 09:51:21 2038
> > Size of extra inode fields: 4
> > BLOCKS:

There isn't anything obvious here that would imply reading a wacky block
beyond the end of the filesystem.  I even checked if e.g. you had quotas
enabled and the bogus UID/GID would result in the quota file becoming
astronomically large or something, but the numbers don't seem to match.

There are no blocks in the file, no xattr block ("File ACL" should be
renamed...).

> hermes:~# ls -l /srv/samba/local/apps/Gestalt.Net/SetupCD/program\ files/Business\ Objects/Common/3.5/bin/RptControllers.dll 
> prwS--x--t 1 868313917 2954683504 0 1902-05-13 03:23 /srv/samba/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll
> 
> I guess this is what Andreas meant by "turning a pile of manure into
> neatly organized fertilizer" :)

Yes, you should just delete the inodes reported corrupted in your
earlier postings in the 87x range - they contain nothing of value
anymore, and I suspect your troubles would be gone.  At least we
wouldn't be left wondering if you are seeing new corruption in
the same range of blocks, or just leftover badness.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

