From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: fio test triggering bad data on ext4
Date: Wed, 07 Jul 2010 21:39:33 +0200
Message-ID: <4C34D7F5.2060309@fusionio.com>
References: <4C1B292C.2080205@fusionio.com> <4C348EB1.4010101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57317 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab0GGTje (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jul 2010 15:39:34 -0400
In-Reply-To: <4C348EB1.4010101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/07/10 16.26, Eric Sandeen wrote:
> Jens Axboe wrote:
>> Hi,
>>
>> I was writing a small fio job file to do writes and read verifies on a
>> device. It forks 32 processes, each writing randomly to 4 files with a
>> block size between 4k and 16k. When it has written 1024 of those blocks,
>> it'll verify the oldest 512 of them. Each block is checksummed for every
>> 512b. It uses libaio and O_DIRECT.
>>
>> It works on ext2 and btrfs. I haven't run it to completion yet, but they
>> survive 15-20 minutes just fine. ext4 doesn't even go a full minutes
>> before this triggers:
>>
>> Bad verify header 0 at 10137600
>> fio: pid=9943, err=84/file:io_u.c:1212, func=io_u_queued_complete, error=Invalid or incomplete multibyte or wide character
>>
>> writers: (groupid=0, jobs=32): err=84 (file:io_u.c:1212, func=io_u_queued_complete, error=Invalid or incomplete multibyte or wide character): pid=9943
> 
> FYI:
> 
> I asked Jens to test hch's and Jiaying's aio completion patches with this,
> and apparently those fixed this problem for him.

At least for a shorter run, but long enough that all the holes should
have been filled at this point. So it at least fixes my test case.
I can try and expand the run a bit if there's any interest in that,
and see if that still verifies correctly.

-- 
Jens Axboe

