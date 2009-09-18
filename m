From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][RFC] resize2fs and uninit_bg questions
Date: Fri, 18 Sep 2009 02:09:03 -0400
Message-ID: <yq1ocp8943k.fsf@sermon.lab.mkp.net>
References: <20090916162457.GA84213@freezingfog.local>
	<20090916190831.GH2537@webber.adilger.int>
	<20090916204225.GB84213@freezingfog.local>
	<20090916212250.GL2537@webber.adilger.int>
	<20090916231131.GC84213@freezingfog.local> <4AB28DD5.30607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Will Drewry <redpig@dataspill.org>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:31154 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZIRGJV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 02:09:21 -0400
In-Reply-To: <4AB28DD5.30607@redhat.com> (Ric Wheeler's message of "Thu, 17
	Sep 2009 15:28:21 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Ric" == Ric Wheeler <rwheeler@redhat.com> writes:

Ric> One note - the WRITE_SAME command in SCSI has long been used by
Ric> array vendors to do relatively high performance zero fills.

I've been working on WRITE SAME and UNMAP support recently (layering on
top of Christoph's patch kit).  It might be worthwhile to expose the
WRITE SAME functionality further up the stack.  It could also be helpful
for initializing RAID disks, for instance...

-- 
Martin K. Petersen	Oracle Linux Engineering
