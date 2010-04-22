From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 benchmark questions
Date: Thu, 22 Apr 2010 16:52:10 -0500
Message-ID: <4BD0C50A.5050508@redhat.com>
References: <x2m1f4ef0971004221438n76bbc32bu6835dfe17dd702d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Steve Brown <sbrown25@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab0DVVwS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Apr 2010 17:52:18 -0400
In-Reply-To: <x2m1f4ef0971004221438n76bbc32bu6835dfe17dd702d8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Steve Brown wrote:
...

> I'll start with the craziest one: noatime.  Everything I have read
> says that the noatime option should increase both read and write
> performance.  My results are finding that write speeds are comparable
> with or without this option, but read speeds are significantly faster
> *without* the noatime option.  For example, a 16GB file reads about
> 210MB/s with noatime but reads closer to 250MB/s without the noatime
> option.

the kernel uses "relatime" now by default, which gives you most of the
benefit already.

> Next is the write barrier.  I'm an in a fully battery-backed
> environment, so I'm not worried about disabling it.  From my testing,
> setting barrier=0 will improve write performance on large files
> (>10GB), but hurts performance on smaller files (<10GB).  Read
> performance is effected similarly.  Is this to be expected with files
> of this size?

not expected by me; barriers == drive write cache flushes, which I
would never expect to speed things up...

> Next is the data option.  I am seeing a significant increase in read
> performance when using data=ordered vs data=writeback.  Reading is as
> much as 20% faster when using data=ordered.  The difference in write
> performance is almost none with this option.

data=writeback is not safe for data integrity; unless you can handle
scrambled files post-crash/powerloss, don't use it.

> Finally is the commit option.  I did my testing mounting with commit=5
> and commit=90.  While my read performance increased with commit=90, my
> write performance improved by as much as 30% or more with commit=5.

not sure offhand what to make of decreased write performance with a longer
commit time...

-Eric
