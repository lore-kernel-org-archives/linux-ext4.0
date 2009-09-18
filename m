From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Fri, 18 Sep 2009 09:23:47 -0500
Message-ID: <4AB397F3.3090206@redhat.com>
References: <4AB2B6B9.7010506@redhat.com> <yq1k4zw93vu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZIROXw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 10:23:52 -0400
In-Reply-To: <yq1k4zw93vu.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Martin K. Petersen wrote:
>>>>>> "Eric" == Eric Sandeen <sandeen@redhat.com> writes:
> 
> Eric> This is just a rough cut, due to the blkid header selection issues
> Eric> I mentioned earlier on the list.  It'll also need some config-fu
> Eric> to be sure we've got a blkid which has these calls, but with it in
> Eric> place, we'll finally have automatic selection of stride/stripe:
> 
> What about alignment?
> 
> I know that in our friendly DM universe the volume will be aligned.  But
> what if the user does mkfs on /dev/sdX and the drive isn't naturally
> aligned?

heh, mkfs.ext* complains if you point it at a whole disk, though it will 
proceed...

> How flexible is the extN on-disk format?  Can you pad and shift things
> if need be?

shifting by 63 sectors would be tough I think; maybe a stern warning and 
a "proceed y/N?" would be better.

I had sort of assumed that -we- could assume the lower layers 
(partitions, volumes) got well-aligned before mkfs, but didn't think 
about making the fs on the whole device.

> Also, are you guys affected by the previously-acked-sectors-are-now-gone
> problems with 512-byte logical/4KB physical drives?

previously-acked-sectors-are-now-gone?  I guess I haven't been keeping 
up.  What do you mean by this?

-Eric
