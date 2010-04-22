From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 benchmark questions
Date: Thu, 22 Apr 2010 17:20:47 -0500
Message-ID: <4BD0CBBF.1060300@redhat.com>
References: <x2m1f4ef0971004221438n76bbc32bu6835dfe17dd702d8@mail.gmail.com>	 <4BD0C50A.5050508@redhat.com> <m2h1f4ef0971004221511wa0ea3d3fteb90ad1c38c9511d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Steve Brown <sbrown25@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab0DVWUy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Apr 2010 18:20:54 -0400
In-Reply-To: <m2h1f4ef0971004221511wa0ea3d3fteb90ad1c38c9511d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Steve Brown wrote:
>>> I'll start with the craziest one: noatime.  Everything I have read
>>> says that the noatime option should increase both read and write
>>> performance.  My results are finding that write speeds are comparable
>>> with or without this option, but read speeds are significantly faster
>>> *without* the noatime option.  For example, a 16GB file reads about
>>> 210MB/s with noatime but reads closer to 250MB/s without the noatime
>>> option.
>> the kernel uses "relatime" now by default, which gives you most of the
>> benefit already.
> 
> So should I see any performance change by using the noatime mount option at all?

they are not exactly the same thing, so noatime may be -slightly-
faster in some cases than relatime.

>>> Next is the write barrier.  I'm an in a fully battery-backed
>>> environment, so I'm not worried about disabling it.  From my testing,
>>> setting barrier=0 will improve write performance on large files
>>> (>10GB), but hurts performance on smaller files (<10GB).  Read
>>> performance is effected similarly.  Is this to be expected with files
>>> of this size?
>> not expected by me; barriers == drive write cache flushes, which I
>> would never expect to speed things up...
> 
> hmmm... this would seem to conflict with the docs in the kernel, especially:
> 
> "Write barriers enforce proper on-disk ordering
> of journal commits, making volatile disk write caches
> safe to use, at some performance penalty.  If
> your disks are battery-backed in one way or another,
> disabling barriers may safely improve performance."

what you saw is in conflict with what is expected, yes; I don't know
why barriers would ever increase performance.

(my description of barriers as drive write caches isn't in conflict
with the docs, I just said how they're implemented)

>>> Next is the data option.  I am seeing a significant increase in read
>>> performance when using data=ordered vs data=writeback.  Reading is as
>>> much as 20% faster when using data=ordered.  The difference in write
>>> performance is almost none with this option.
>> data=writeback is not safe for data integrity; unless you can handle
>> scrambled files post-crash/powerloss, don't use it.
> 
> I'm not worried about powerloss.  The kernel docs seem to imply that
> data=[journaled,ordered] come with a performance hit.  My results
> would indicate otherwise.  Should I be seeing this kinda of
> performance difference?

Sorry, I misread...  I also don't know why reading would be much affected
at all by the journalling mode, which journals -writes- (reading can
update metadata, but not much, esp. if you have noatime/relatime).

-Eric

>>> Finally is the commit option.  I did my testing mounting with commit=5
>>> and commit=90.  While my read performance increased with commit=90, my
>>> write performance improved by as much as 30% or more with commit=5.
>> not sure offhand what to make of decreased write performance with a longer
>> commit time...
> 
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

