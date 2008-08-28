From: Eric Sandeen <sandeen@redhat.com>
Subject: Do we need dump for ext4?
Date: Thu, 28 Aug 2008 09:58:10 -0500
Message-ID: <48B6BD02.3080307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35316 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbYH1O7J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2008 10:59:09 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m7SEwSHk005522
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 10:58:48 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7SEwGiZ013052
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 10:58:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was talking to Ric about dump benchmarks, and he was of the impression
that dump may not be used that often anymore, at least in the
enterprise.  (Ric, hope I'm paraphrasing correctly)

Undaunted :) I ran off and tested an artificial backup scenario:

* Untar a kernel tree into 128 different top level dirs
* Make a level 0 backup
* Untar a kernel tree into 128 MORE different top level dirs
* Make a level 1 backup

128 kernel trees uses about 6.5M inodes, and about 80G of space.

I tested ext3 with dump; ext4 with tar, and xfs with xfsdump.

for ext3:
dump -1 -u -f $DUMPDIR/dump1 $DATADIR

for ext4:
tar --atime-preserve --xattr --after-date=$DUMPDIR/dump0.tar -cf
$DUMPDIR/dump1.tar $DATADIR

for xfs:
xfsdump -F -l 1 -f $DUMPDIR/dump0 $DATADIR

DUMPDIR and DATADIR were 2 partitions on the same (fast hardware) lun.

Results:

	level0	level1
        ------	------
ext3	38m52s	42m21s
ext4	57m55s	69m35s
xfs	25m18s	37m44s

Clearly tar on ext4, at least for my incantation, lags.  Is dump for
ext4 anywhere on the todo list, or should it be?  Or am I just running
tar wrong? :)

-Eric
