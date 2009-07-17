From: Andreas Dilger <adilger@sun.com>
Subject: Re: file allocation problem
Date: Fri, 17 Jul 2009 00:32:42 -0400
Message-ID: <20090717043241.GA4207@webber.adilger.int>
References: <200907161331.17623.coolo@suse.de> <20090716155832.GA6605@mit.edu>
 <200907161943.21575.coolo@suse.de> <20090717011219.GE8508@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Stephan Kulow <coolo@suse.de>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:43448 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZGQEdh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jul 2009 00:33:37 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6H4XWBQ005487
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2009 21:33:32 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KMW00A00S8N1I00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 16 Jul 2009 21:33:32 -0700 (PDT)
In-reply-to: <20090717011219.GE8508@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 16, 2009  21:12 -0400, Theodore Ts'o wrote:
> On Thu, Jul 16, 2009 at 07:43:21PM +0200, Stephan Kulow wrote:
> > My problem is not so much with what e4defrag does, but the fact that
> > a new file I create with cp(1) contains 34 extents.
> 
> The other problem is that an ext3 filesystem that has been converted
> to ext4 does not have the flex_bg feature.  This is a feature that,
> when set at when the file system is formatted, creates a higher order
> flex_bg which combines several block groups into a bigger allocation
> group, a flex_bg.  This helps avoid fragmentation, especially for
> directories like /usr/bin which typically have more than 128 megs (a
> single block group) worth of files in it.

It seems quite odd to me that mballoc didn't find enough contiguous
free space for this relatively small file.  It might be worthwhile
to look at (though not necessarily post) the output from the file
/sys/fs/ext4/{dev}/mb_groups (or "dumpe2fs" has equivalent data)
and see if there are groups with a lot of contiguous free space.
In the mb_groups file this would be numbers in the 2^{high} column. 

I don't agree that flex_bg is necessary to have good block allocation,
since we do get about 125MB per group.  Maybe mballoc is being
constrained to look at too few block groups in this case?  Looking at
/sys/fs/ext4/{dev}/mb_history under the "groups" column will tell how
many groups were scanned to find that allocation, and the "original"
and "result" will show group/grpblock/count@logblock for recent writes.

$ dd if=/dev/zero of=/myth/tmp/foo bs=1M count=1

pid   inode    original             goal                  result
4423  110359   3448/14336/256@0     1646/18944/256@0      1646/19456/256@0

You might also try to create a new temp directory elsewhere on the
filesystem, copy the file over to the temp directory, and then see
if it is less fragmented in the new directory.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

