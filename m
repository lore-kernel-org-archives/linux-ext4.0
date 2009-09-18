From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH][RFC] resize2fs and uninit_bg questions
Date: Fri, 18 Sep 2009 07:43:04 -0400
Message-ID: <4AB37248.4050309@redhat.com>
References: <20090916162457.GA84213@freezingfog.local>	<20090916190831.GH2537@webber.adilger.int>	<20090916204225.GB84213@freezingfog.local>	<20090916212250.GL2537@webber.adilger.int>	<20090916231131.GC84213@freezingfog.local> <4AB28DD5.30607@redhat.com> <yq1ocp8943k.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Will Drewry <redpig@dataspill.org>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757AbZIRLmw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 07:42:52 -0400
In-Reply-To: <yq1ocp8943k.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/18/2009 02:09 AM, Martin K. Petersen wrote:
>>>>>> "Ric" == Ric Wheeler<rwheeler@redhat.com>  writes:
>>>>>>              
> Ric>  One note - the WRITE_SAME command in SCSI has long been used by
> Ric>  array vendors to do relatively high performance zero fills.
>
> I've been working on WRITE SAME and UNMAP support recently (layering on
> top of Christoph's patch kit).  It might be worthwhile to expose the
> WRITE SAME functionality further up the stack.  It could also be helpful
> for initializing RAID disks, for instance...
>
>    

Using it to initialize RAID disks is exactly what it is there for - that 
sounds quite useful...

ric

