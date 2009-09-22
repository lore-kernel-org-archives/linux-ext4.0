From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Tue, 22 Sep 2009 07:30:08 -0700
Message-ID: <4AB8DF70.8000406@redhat.com>
References: <4AB2B6B9.7010506@redhat.com> <yq1k4zw93vu.fsf@sermon.lab.mkp.net>	<4AB397F3.3090206@redhat.com> <yq1ab0s6ny7.fsf@sermon.lab.mkp.net>	<20090918202814.GC2537@webber.adilger.int> <yq1skeh5oqf.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605AbZIVOaR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Sep 2009 10:30:17 -0400
In-Reply-To: <yq1skeh5oqf.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/20/2009 01:46 PM, Martin K. Petersen wrote:
>>>>>> "Andreas" == Andreas Dilger<adilger@sun.com>  writes:
>>>>>>              
> Andreas>  Yes, there is more chance that writing sector 7 (due to 4k
> Andreas>  sector r-m-w) will cause collateral damage, but the truth even
> Andreas>  today is that disks are not going to fail a single 512-byte
> Andreas>  sector at one time, but more likely 64kB (or whatever the
> Andreas>  remapping unit size is), so this isn't really introducing a new
> Andreas>  failure mode.
>
> I keep hearing this disk drive "internal block size" of 32KB or 64KB
> being mentioned.  And yet none of the drive firmware engineers I talk to
> on a regular basis have ever heard of such a thing...
>    

I have not heard of drives with that kind of internal block size for 
single drives.

What is common is that reads (often) are often done in much larger 
chunks like this (basically, if you are reading, it normally makes sense 
to read a whole track from the platter :-)

Array vendors definitely do have larger internal block sizes.

ric


