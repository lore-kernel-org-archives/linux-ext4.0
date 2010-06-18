From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: fio test triggering bad data on ext4
Date: Fri, 18 Jun 2010 19:36:09 +0200
Message-ID: <4C1BAE89.3050609@fusionio.com>
References: <4C1B292C.2080205@fusionio.com> <4C1B7C73.505@redhat.com> <4C1B89C1.6090408@redhat.com> <4C1B8D1F.3020002@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36367 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933739Ab0FRRgK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jun 2010 13:36:10 -0400
In-Reply-To: <4C1B8D1F.3020002@fusionio.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-06-18 17:13, Jens Axboe wrote:
> On 18/06/10 16.59, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> I was writing a small fio job file to do writes and read verifies on a
>>>> device. It forks 32 processes, each writing randomly to 4 files with a
>>>> block size between 4k and 16k. When it has written 1024 of those blocks,
>>>> it'll verify the oldest 512 of them. Each block is checksummed for every
>>>> 512b. It uses libaio and O_DIRECT.
>>>>
>>>> It works on ext2 and btrfs. I haven't run it to completion yet, but they
>>>> survive 15-20 minutes just fine. ext4 doesn't even go a full minutes
>>>> before this triggers:
>>>
>>> Jens, can you try XFS too?  Since ext3 can't do direct IO to a hole,
>>> (and I'm not sure about btrfs in that regard), ext4 may be most similar
>>> to xfs's behavior on the test ... wondering how it fares.
>>>
>>> Thanks,
>>> -Eric
>>
>> Actually mingming had a patch for direct-io.c which may be related, I'll
>> test that out.
> 
> OK, I'll try XFS tonight as well.

XFS fails too.

-- 
Jens Axboe

