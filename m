From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Do we need dump for ext4?
Date: Fri, 29 Aug 2008 07:36:16 -0500
Message-ID: <48B7ED40.6020508@redhat.com>
References: <48B6BD02.3080307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50797 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYH2MhJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Aug 2008 08:37:09 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m7TCaXYV011215
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 08:36:53 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TCaLOj025315
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 08:36:22 -0400
In-Reply-To: <48B6BD02.3080307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> I was talking to Ric about dump benchmarks, and he was of the impression
> that dump may not be used that often anymore, at least in the
> enterprise.  (Ric, hope I'm paraphrasing correctly)
> 
> Undaunted :) I ran off and tested an artificial backup scenario:
> 
> * Untar a kernel tree into 128 different top level dirs
> * Make a level 0 backup
> * Untar a kernel tree into 128 MORE different top level dirs
> * Make a level 1 backup
> 
> 128 kernel trees uses about 6.5M inodes, and about 80G of space.
> 
> I tested ext3 with dump; ext4 with tar, and xfs with xfsdump.
> 
> for ext3:
> dump -1 -u -f $DUMPDIR/dump1 $DATADIR
> 
> for ext4:
> tar --atime-preserve --xattr --after-date=$DUMPDIR/dump0.tar -cf
> $DUMPDIR/dump1.tar $DATADIR
> 
> for xfs:
> xfsdump -F -l 1 -f $DUMPDIR/dump0 $DATADIR
> 
> DUMPDIR and DATADIR were 2 partitions on the same (fast hardware) lun.
> 
> Results:

at Ric & hch's  request here is tar on the other fs's as well, re-sorted
 by level 0 dump time.  I put acp into the mix as well.

Oh, and this time I remembered to set the elevator to something sane
(noop) for this storage, oops (was cfq last time)

Also, this time the dup/tar/acp was written to /dev/null rather than
another filesystem.  Interesting how routing to /dev/null alone changed
the ranking quite a bit.

		level0	level1
		======	======
ext4-acp	12m22s	------
ext3-acp	14m11s	------
ext4-tar	18m24s	34m56s
ext3-dump	19m30s	35m30s
xfs-dump        20m07s	40m24s
ext3-tar	21m16s	42m41s
xfs-tar		21m19s	46m13s
xfs-acp		29m38s	------

-Eric
