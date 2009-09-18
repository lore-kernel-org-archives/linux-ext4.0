From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][RFC] resize2fs and uninit_bg questions
Date: Fri, 18 Sep 2009 07:56:53 -0600
Message-ID: <20090918135653.GR2537@webber.adilger.int>
References: <20090916162457.GA84213@freezingfog.local>
 <20090916190831.GH2537@webber.adilger.int>
 <20090916204225.GB84213@freezingfog.local>
 <20090916212250.GL2537@webber.adilger.int>
 <20090916231131.GC84213@freezingfog.local> <4AB28DD5.30607@redhat.com>
 <yq1ocp8943k.fsf@sermon.lab.mkp.net> <4AB37248.4050309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Will Drewry <redpig@dataspill.org>, linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:47508 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZIRN4u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 09:56:50 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8IDurwr000559
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 06:56:53 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQ6000006EV0X00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 18 Sep 2009 06:56:53 -0700 (PDT)
In-reply-to: <4AB37248.4050309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 18, 2009  07:43 -0400, Ric Wheeler wrote:
> On 09/18/2009 02:09 AM, Martin K. Petersen wrote:
>>>>>>> "Ric" == Ric Wheeler<rwheeler@redhat.com>  writes:
>>>>>>>              
>> Ric>  One note - the WRITE_SAME command in SCSI has long been used by
>> Ric>  array vendors to do relatively high performance zero fills.
>>
>> I've been working on WRITE SAME and UNMAP support recently (layering on
>> top of Christoph's patch kit).  It might be worthwhile to expose the
>> WRITE SAME functionality further up the stack.  It could also be helpful
>> for initializing RAID disks, for instance...
>
> Using it to initialize RAID disks is exactly what it is there for - that  
> sounds quite useful...

In ext4 we already have a routine ext4_ext_zeroout() that is used to zero
out chunks of disk in order to wipe uninitialized extents when they need
to be put into use.  It currently maps ZERO_PAGE() multiple times to avoid
causing cache pressure, but if we could wire it up to some block-level
routine that optimized this it would be even better.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

