From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/4 v3] ext3/4: enhance fsync performance when using CFQ
Date: Thu, 15 Apr 2010 09:13:51 -0400
Message-ID: <x494ojcj1tc.fsf@segfault.boston.devel.redhat.com>
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com>
	<20100415103345.GY27497@kernel.dk>
	<x498w8oj276.fsf@segfault.boston.devel.redhat.com>
	<20100415130854.GA27497@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	vgoyal@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab0DONN5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Apr 2010 09:13:57 -0400
In-Reply-To: <20100415130854.GA27497@kernel.dk> (Jens Axboe's message of "Thu,
	15 Apr 2010 15:08:55 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jens Axboe <jens.axboe@oracle.com> writes:

>> > This is starting to look better. Can you share what tests you did? I
>> > tried reproducing with fs_mark last time and could not.
>> 
>> Did you use the fs_mark command line I (think I) had posted?  What
>> storage were you using?
>
> No, I didn't see any references to example command lines. I tested on a
> few single disks, rotating and SSD. I expected the single spinning disk
> to show the problem to some extent at least, but there was no difference
> observed with 64kb blocks.

Boy, I'm really slipping.  Try this one:

./fs_mark -S 1 -D 100 -N 1000 -d /mnt/test/fs_mark -s 65536 -t 1 -w 4096

Cheers,
Jeff
