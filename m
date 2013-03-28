From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Failure of resize2fs past 4TB
Date: Wed, 27 Mar 2013 22:57:25 -0500
Message-ID: <5153BFA5.9090404@redhat.com>
References: <CAN=xW0bhw41-NNqWnDfqk0SbM6xymrhuL9WONQKefC=PsHg5GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: John Jolly <john.jolly@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab3C1D52 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 23:57:28 -0400
In-Reply-To: <CAN=xW0bhw41-NNqWnDfqk0SbM6xymrhuL9WONQKefC=PsHg5GQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/27/13 10:44 PM, John Jolly wrote:
> All,
> 
> I recently had a major data loss when expanding an LVM logical volume
> past 2TB in size. I have preserved the 2.25TB just in case I might be
> able to recover some data. But this backup is not my reason for
> writing.
> 
> I have done several tests and these are the results. First the error
> condition, where I create a 1GB file system, expand the volume to 2TB,
> resize the file system and have it become corrupted:

I checked the recent code in the master & pu branches of git, and the
same problem persists.

...


> I know it is unusual to start so small and expand like this, but I
> doubt I am the only one to have experienced this. How could I have
> prepared my small 1GB file system so that it would be able to handle
> an expansion past 2TB? Any help would be appreciated.

not sure; you haven't done anything wrong, this simply looks like
a resize bug, of which there have been a few lately I'm afraid.

-Eric
 
> Regards,
> --
> John Jolly - john.jolly@gmail.com - http://john.jolly.name
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

