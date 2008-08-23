From: Andreas Dilger <adilger@sun.com>
Subject: Re: ENOSPC returned during writepages
Date: Sat, 23 Aug 2008 05:12:33 -0600
Message-ID: <20080823111233.GL3392@webber.adilger.int>
References: <20080820054339.GB6381@skywalker>
 <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu>
 <1219269325.7895.45.camel@mingming-laptop> <20080821151815.GD6509@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62607 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYHWLMj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Aug 2008 07:12:39 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7NBCcEj017746
	for <linux-ext4@vger.kernel.org>; Sat, 23 Aug 2008 04:12:39 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6100I01W6J4O00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 23 Aug 2008 04:12:37 -0700 (PDT)
In-reply-to: <20080821151815.GD6509@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 21, 2008  20:48 +0530, Aneesh Kumar wrote:
> On Wed, Aug 20, 2008 at 02:55:25PM -0700, Mingming Cao wrote:
> > I have a feeling that we did not try very hard before invalidate the
> > dirty page which fail to map to disks. Perhaps we should try a few more
> > times before give up. Also in that case, perhaps we should turn off
> > delalloc fs wide, so the new writers won't take the subsequently made
> > avaible free blocks away from this unlucky delalloc da writepages.
> 
> How do we try hard ? The mballoc already try had to allocate blocks. So I
> am not sure what do we achieve by requesting for block allocation again.

One reason is that if blocks are being released then they cannot be
reallocated until the transaction has committed.

Running something like iozone in a loop on a filesystem that has only
as much free space as the size of the output file can run out of space
after a few loops because of this, so definitely retrying the allocation
can help.

Also, keeping the pages in RAM may allow them to be written again if
the user detects the ENOSPC and deletes some files...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

