From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Filessystem corruptions while using rsnapshot
Date: Wed, 09 Sep 2009 16:35:45 -0500
Message-ID: <4AA81FB1.7000000@redhat.com>
References: <20090909133026.GA1965@phenom2.trippelsdorf.de> <4AA7BE69.7070406@redhat.com> <20090909172015.GA1980@phenom2.trippelsdorf.de> <4AA7E411.7070005@redhat.com> <20090909212925.GA2011@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435AbZIIVf7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Sep 2009 17:35:59 -0400
In-Reply-To: <20090909212925.GA2011@phenom2.trippelsdorf.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Markus Trippelsdorf wrote:
> On Wed, Sep 09, 2009 at 12:21:21PM -0500, Eric Sandeen wrote:
>> Markus Trippelsdorf wrote:
>>> On Wed, Sep 09, 2009 at 09:40:41AM -0500, Eric Sandeen wrote:
>>>> Markus Trippelsdorf wrote:
>> ...
>>
>>>>> The bug is very simple to reproduce here. Just run rsnapshot several
>>>>> times per day and you will eventually hit the problem.
>>>> Could you provide a bzip2'd e2image -r of a corrupted filesystem for 
>>>> analysis?
>>> OK I've uploaded the file (~80 MB):
>>> http://www.2shared.com/file/7681344/d19d7154/disc_e2image.html
>>>
>>> Hope it helps.
>> Thanks, can't guarantee that the post-mortem will lead to the anwer but 
>> it's worth a look.
> 
> I also took a look myself and it turned out that my maildir, which
> contains the LKML messages of the last three months, is the root of the
> problem. I can now reproduce the bug, by simply running (e.g.):
> 
> cp -al /var/backup/hourly.3/localhost/home/markus/.maildir/lkml/. /var/tmp/debug
> 
> where /var is mounted as: "/dev/sda1 on /var type ext4 (rw,noatime,commit=60)"
> and /var/backup/hourly.3/localhost/ is a previous backup produced by rsnapshot.

 From the original post it wasn't quite clear; do you hit runtime 
corruption, indicated by the kernel logs when the fs is mounted, and a 
subsequent fsck also finds errors?

Just for completeness, if there are errors in the system logs, can you 
post them here as well?

Thanks,
-Eric
