From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync performance when using CFQ
Date: Wed, 23 Jun 2010 09:06:18 -0400
Message-ID: <x49iq59q4ol.fsf@segfault.boston.devel.redhat.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<4C21D442.8080703@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Tao Ma <tao.ma@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab0FWNGZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jun 2010 09:06:25 -0400
In-Reply-To: <4C21D442.8080703@oracle.com> (Tao Ma's message of "Wed, 23 Jun
	2010 17:30:42 +0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Tao Ma <tao.ma@oracle.com> writes:

> Hi Jeff,
>
> On 06/23/2010 05:34 AM, Jeff Moyer wrote:
>> Hi,
>>
>> Running iozone with the fsync flag, or fs_mark, the performance of CFQ is
>> far worse than that of deadline for enterprise class storage when dealing
>> with file sizes of 8MB or less.  I used the following command line as a
>> representative test case:
>>
>>    fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w 4096 -F
>>
>> When run using the deadline I/O scheduler, an average of the first 5 numbers
>> will give you 448.4 files / second.  CFQ will yield only 106.7.  With
>> this patch series applied (and the two patches I sent yesterday), CFQ now
>> achieves 462.5 files / second.
> which 2 patches? Could you paste the link or the subject? Just want to
> make my test env like yours. ;)
> As Joel mentioned in another mail, ocfs2 also use jbd/jbd2, so I'd
> like to give it a try and give you some feedback about the test.

http://lkml.org/lkml/2010/6/21/307:

[PATCH 1/2] cfq: always return false from should_idle if slice_idle is
set to zero
[PATCH 2/2] cfq: allow dispatching of both sync and async I/O together

Thanks in advance for the testing!

-Jeff
