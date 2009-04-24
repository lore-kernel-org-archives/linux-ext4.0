From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Fri, 24 Apr 2009 01:09:43 -0600
Message-ID: <20090424070943.GR3209@webber.adilger.int>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de>
 <49F0642A.4000704@redhat.com>
 <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de>
 <20090423204059.GM2723@mit.edu>
 <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de>
 <20090424032028.GB7949@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Christian Kujau <lists@nerdbynature.de>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55372 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZDXHKA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Apr 2009 03:10:00 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3O79tDL023397
	for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2009 00:09:55 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIL00C00FTS3E00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 24 Apr 2009 00:09:55 -0700 (PDT)
In-reply-to: <20090424032028.GB7949@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 23, 2009  23:20 -0400, Theodore Ts'o wrote:
> On Thu, Apr 23, 2009 at 03:15:10PM -0700, Christian Kujau wrote:
> > On Thu, 23 Apr 2009, Theodore Tso wrote:
> > > Eventually I might need a raw e2image dump, i.e.:
> > > 
> > > 	   e2image -r /dev/md0 - | bzip2 > /var/tmp/md0.e2i.bz2
> > 
> > I've put the raw e2image dump on http://nerdbynature.de/bits/2.6.30-rc2/
> > Do you still need the dump without the "-r"?
> 
> Nope, the raw e2image file was perfect.  This was actually a problem I
> knew about, and wanted to get fixed before the e2fsprogs 1.41.5
> release.  The problem was that i_file_acl_high was set and the kernel
> unconditionally checks for it even though the INCOMPAT_64_BITS flag is
> not set.

Maybe I'm missing something, but how can i_file_acl_high being used
cause a problem with the file extent maps?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

