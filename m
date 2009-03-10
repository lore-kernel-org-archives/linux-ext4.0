From: Andreas Dilger <adilger@sun.com>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Tue, 10 Mar 2009 01:09:15 -0600
Message-ID: <20090310070915.GN3199@webber.adilger.int>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au>
 <49B5D71D.1030802@redhat.com> <1236655451.30280.29.camel@kulgan.wumi.org.au>
 <49B5EDFE.8060405@redhat.com> <1236661371.30280.33.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52780 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZCJHJn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2009 03:09:43 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n2A79TX4025740
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2009 00:09:42 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KGA00B003OHNS00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 10 Mar 2009 00:09:29 -0700 (PDT)
In-reply-to: <1236661371.30280.33.camel@kulgan.wumi.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 10, 2009  15:32 +1030, Kevin Shanahan wrote:
> On Mon, 2009-03-09 at 23:35 -0500, Eric Sandeen wrote:
> > Kevin Shanahan wrote:
> > > On Mon, 2009-03-09 at 21:57 -0500, Eric Sandeen wrote:
> > >> Kevin Shanahan wrote:
> > >>> kernel: init_special_inode: bogus i_mode (53253)

If anyone has a chance, fixing this error message to be not-useless would
be good...  Including the device name and the inode number would help
track down the source of the problem.

> hermes:~# debugfs /dev/dm-0 
> debugfs 1.41.3 (12-Oct-2008)
> debugfs:  stat "local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/Cdo32sv.dll"
> 
> Gives the following output:
> 
>   Inode: 867   Type: bad type    Mode:  0404   Flags: 0x802a61af
>   Generation: 2483046020    Version: 0xb9286359:17a7fdfd
>   User: 1455931783   Group: -798021131   Size: -1808719531
>   File ACL: 141934744    Directory ACL: 0
>   Links: 15681   Blockcount: 171984001880781
>   Fragment:  Address: 956780679    Number: 0    Size: 0
>    ctime: 0xdca60244:006c5b08 -- Wed Apr 23 01:54:36 2087
>    atime: 0x5c9e956c:777587a4 -- Sat Mar 30 08:30:12 2019
>    mtime: 0x2ce44e11:286138f8 -- Sat Nov 13 13:31:37 1993
>   crtime: 0x737781cb:5661f351 -- Thu May 22 19:54:11 2031
>   dtime: 0xf19c4882 -- Sat Jun 14 11:57:14 2098
>   Size of extra inode fields: 3625
>   BLOCKS:
> 
> And when I exit the pager and return to the prompt I also see:
> 
>   invalid inode->i_extra_isize (3625)

All garbage.  Running e2fsck should fix this, though it won't explain
why it got corrupted in the first place..

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

