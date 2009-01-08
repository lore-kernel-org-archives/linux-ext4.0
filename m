From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Ext4 without a journal: some benchmark results
Date: Thu, 8 Jan 2009 09:20:53 -0800
Message-ID: <6601abe90901080920h2d2f4215tf8b886cefbb6e4b7@mail.gmail.com>
References: <6601abe90901071129v3de159d4jcf3b250aac40d0eb@mail.gmail.com>
	 <20090108130357.GW13721@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:10224 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbZAHRU6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Jan 2009 12:20:58 -0500
Received: from zps37.corp.google.com (zps37.corp.google.com [172.25.146.37])
	by smtp-out.google.com with ESMTP id n08HKvN7008921
	for <linux-ext4@vger.kernel.org>; Thu, 8 Jan 2009 09:20:57 -0800
Received: from bwz10 (bwz10.prod.google.com [10.188.26.10])
	by zps37.corp.google.com with ESMTP id n08HJL2I017486
	for <linux-ext4@vger.kernel.org>; Thu, 8 Jan 2009 09:20:54 -0800
Received: by bwz10 with SMTP id 10so1257291bwz.22
        for <linux-ext4@vger.kernel.org>; Thu, 08 Jan 2009 09:20:54 -0800 (PST)
In-Reply-To: <20090108130357.GW13721@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas:

On Thu, Jan 8, 2009 at 5:03 AM, Andreas Dilger <adilger@sun.com> wrote:
> On Jan 07, 2009  11:29 -0800, Curt Wohlgemuth wrote:
>> Iozone was run with the following command line:
>>
>>       iozone -t (# threads) -s 2g -r 256k -I -T -i0 -i1 -i2
>>
>> I.e., throughput mode; 2GiB file; 256KiB buffer; O_DIRECT.  Tests were
>> limited to
>
> How much RAM is on the test system?  If the file size is only 2GB then
> it will likely fit into RAM, which is possibly why the performance
> numbers of all the filesystems is so close together.  The other possibility
> is that a single disk is the performance bottleneck and all of the
> filesystems can feed a single disk at a reasonable rate.

Indeed, the system was not memory-limited at all.  I've done some
playing around with how limiting memory affects random reads in iozone
with O_DIRECT, and have found that, as expected, ext4 is much less
affected than ext2.  I'm assuming this is because the metadata isn't
in the page cache, and the far larger number of metadata blocks on
ext2 than ext4 in this case causes a bigger hit on ext2.

If I generate numbers on a low-memory system, I'll post them here too.

Thanks,
Curt
